//
//  GameScene.swift
//  pipes
//
//  Created by Даниил Смирнов on 30.11.16.
//  Copyright © 2016 Даниил Смирнов. All rights reserved.
//

import SpriteKit
import GameplayKit
private let pipeNodeName = "movable"

class GameScene: SKScene {
    
    var level: Level!
    
    private let background = SKSpriteNode(imageNamed: "Background")
    private var selectedPipe = SKNode()
    private var boxesPositionsArray = Array<CGPoint>()
    private var reservedCells = Array<(Int)>()
    private var movingSelectedPipe = Pipes(typeOfPipe: .unknown)
    
    private var pipesArray = Array<Pipes>()
    private var pipesOnGameField = [Int : Pipes]()
    private var cellsArray = [[SKSpriteNode]]()
    
    private var selectedPipeInitialPosition = CGPoint()
    private let cellsHeight: CGFloat = 50.0
    private let cellsWidth: CGFloat = 50.0
    private let boxHeight: CGFloat = 50.0
    private let boxWidth: CGFloat = 50.0
    private let gameLayer = SKNode()
    private let cellLayer = SKNode()
    private let pipeMakerLayer = SKNode()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.size = size
        background.name = "background"
        addChild(background)
        
        gameLayer.name = "gameLayer"
        background.addChild(gameLayer) // для всего нашего игрового поля
        
        pipeMakerLayer.name = "pipeMakerLayer"
        // pipeMakerLayer.frame.size.height = boxHeight * AmountOfInitialPipes
        // pipeMakerLayer.frame.size.width = boxWidth
        background.addChild(pipeMakerLayer)
        
        
        let layerPosition = CGPoint(
            x: -cellsWidth * CGFloat(NumOfColumns) / 2,
            y: -cellsHeight * CGFloat(NumOfRows) / 2)
        
        cellLayer.position = layerPosition
        cellLayer.name = "cellLayer"
        gameLayer.addChild(cellLayer)
        
    }
    
    func boundLayerPos(aNewPosition: CGPoint) -> CGPoint { //???
        let winSize = self.size
        var retval = aNewPosition
        retval.x = CGFloat(min(retval.x, 0))
        retval.x = CGFloat(max(retval.x, -(background.size.width) + winSize.width))
        retval.y = self.position.y
        
        return retval
    }
    
    func panForTranslation(translation: CGPoint) {
        let position = selectedPipe.position
        
        if selectedPipe.name == nil || selectedPipe.name != pipeNodeName {
            return
        }
        
        if selectedPipe.name! == pipeNodeName {
            selectedPipe.position = CGPoint(x: position.x + translation.x, y: position.y + translation.y)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let positionInScene = touch.location(in:self)
            selectNodeForTouch(touchLocation: positionInScene)
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Не дает пользователю сместить уже поставленную трубу
        if selectedPipe.inParentHierarchy(cellLayer) && selectedPipe.name == "movable"{
            return
        }
        
        for touch in touches {
            let positionInScene = touch.location(in: self)
            let previousPosition = touch.previousLocation(in: self)
            let translation = CGPoint(x: positionInScene.x - previousPosition.x,
                                      y: positionInScene.y - previousPosition.y)
            
            panForTranslation(translation: translation)
        }
    }
    
    // Через субскрипт нахожу все спрайты с именем pipesNodename и делаю из них массив
    // Ищу индекс перетаскиваемой трубы и по нему возвращаю на первоначальную позицию
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let array = pipeMakerLayer[pipeNodeName]
        let arrayOfCells = cellLayer.children
        var i = 0
        
//        while (i < cellLayer.children.count) {
//            print(" cell layer #\(i) name --> \(cellLayer.children[i].name) position --> \(cellLayer.children[i].position)")
//            i += 1
//        }
        
        if let index = array.index(of: selectedPipe) {
            if (!replaceSelectedPipeInAvailablePlace(sprites: arrayOfCells, name: "cell")) {
                selectedPipe.position = boxesPositionsArray[index]
            } else {
                
                fillInPipesOnGameFieldDictionary()
                addPipeIntoEmptyBox()
                print("index = \(index)")
                
                for (key,value) in pipesOnGameField {
                    print("INFO PIPES ON GAME FIELD: key -> \(key) value -> \(value.typeOfPipe)" )
                }
                
                for i in pipesArray {
                    print("PIPES ARR INFO: name - \(i.sprite?.name); type - \(i.typeOfPipe)")
                }
                
                print("count of reserved cells \(cellLayer["reserved"].count)")
                print("count of children cellLayer \(cellLayer.children.count)")
                return
            }
        }
    }
    
    // Определяет трубу по прикосновению
    
    func selectNodeForTouch(touchLocation: CGPoint) {
        
        let touchedNode = self.scene?.nodes(at:touchLocation)
        
        // Выводит позицию спрайта при первом прикосновении
        print("position of node  X -> \(touchedNode![0].position.x) | Y -> \(touchedNode![0].position.x)")
        selectedPipe = touchedNode?[0] as! SKSpriteNode
        selectedPipeInitialPosition = selectedPipe.position
    }
    
    // Adding level cells
    func addCells() {
        for row in 0..<NumOfRows {
            for column in 0..<NumOfColumns {
                
                if level.cellAt(column: column, row: row)?.sprite?.name == "start" ||
                    level.cellAt(column: column, row: row)?.sprite?.name == "end" {
                    
                    let cellNode = SKSpriteNode(imageNamed: "Cell")
                    cellNode.name = "reserved"
                    cellNode.size = CGSize(width: cellsWidth, height: cellsHeight)
                    cellNode.position = pointFor(column: column, row: row)
                    print("\(cellNode.name) ---> \(cellNode.position)")
                    cellNode.alpha = 0.65
                    cellLayer.addChild(cellNode)
                    
                    if let mainNode = level.cellAt(column: column, row: row)?.sprite {
                        mainNode.size = CGSize(width: cellsWidth, height: cellsHeight)
                        mainNode.position = pointFor(column: column, row: row)
                        print("\(mainNode.name) ---> \(mainNode.position)")
                        cellLayer.addChild(mainNode)
                    }
                    
                } else {
                    
                    if level.cellAt(column: column, row: row) != nil {
                        let cellNode = SKSpriteNode(imageNamed: "Cell")
                        cellNode.name = "cell" + String(row) + "-" + String(column)
                        cellNode.size = CGSize(width: cellsWidth, height: cellsHeight)
                        cellNode.position = pointFor(column: column, row: row)
                       // print("\(cellNode.name) ---> \(cellNode.position)")
                        cellNode.alpha = 0.65
                        cellLayer.addChild(cellNode)
                    }
                }
            }
        }
    }
    
    func addSprites(for pipes: Array<Pipes>) {
        var i = 0
        pipesArray = pipes
        for pipe in pipes {
            // Create a new sprite for the pipe and add it to the pipeMakerLayer.
            let sprite = SKSpriteNode(imageNamed: pipe.typeOfPipe.spritesName)
            sprite.name = pipeNodeName
            sprite.position.y = boxesPositionsArray[i].y
            sprite.position.x = boxesPositionsArray[i].x
            sprite.zPosition = 1
            print("position x \(sprite.position.x) and pos y \(sprite.position.y)")
            pipeMakerLayer.addChild(sprite)
            pipe.sprite = sprite
            print("Z pos for pipes \(sprite.zPosition)")
            print("Pipe height \(sprite.size.height) : width \(sprite.size.width)")
            i += 1
        }
    }
    
    func addBoxes(boxes: Array<SKSpriteNode>) {
        var i: CGFloat = 0.0
        for _ in boxes {
            let sprite = SKSpriteNode(imageNamed: "OpenedBox")
            sprite.name = "box" //+ String(describing: i)
            sprite.size = CGSize(width: boxWidth, height: boxHeight)
            sprite.position.y = i * boxHeight - boxWidth/2 - 20
            sprite.position.x = (scene?.anchorPoint.x)! - (scene?.size.width)!/2 + boxWidth/2 + 5
            boxesPositionsArray.append(sprite.position)
            pipeMakerLayer.addChild(sprite)
            i += 1.0
        }
    }
    
    // Расположение ячеек на экране
    
    fileprivate func pointFor(column: Int, row: Int) -> CGPoint {
        return CGPoint(
            x: CGFloat(column) * cellsHeight + cellsWidth/2 + 20, // 20 offset for cells (!)
            y: CGFloat(row) * cellsHeight + cellsWidth/2 + 20)
    }
    
    // Функция перемещает трубу в доступное место
    // В массив передается слой в который нужно поставить трубу
    // Перемещает выбранную трубу в другой слой (в данном случае в слой с ячейками), чтоб был доступ к сиситеме координат родителя
    
    fileprivate func replaceSelectedPipeInAvailablePlace(sprites: Array<SKNode>, name: String) -> Bool {
        for sprite in sprites {
            
            if (sprite.intersects(selectedPipe) && sprite.name!.contains(name)) {
                selectedPipe.move(toParent: sprite.parent!)
                print("\(selectedPipe.name) and its parent  \(selectedPipe.parent?.name)")
                // print("\(sprite.name) position in loop \(sprite.position)")
                selectedPipe.position = sprite.position
                sprite.name = "reserved"
                return true
            }
        }
        return false
    }
    
    //    func findPipeNearBy(cellName: String) -> Pipes {
    //        let pipeNearBy = Pipes(typeOfPipe: .unknown)
    //
    //        for pipe in pipesOnGameFieldArray {
    //            if (pipe.sprite?.position)! == cellLayer[cellName][0].position {
    //
    //            }
    //        }
    //
    //        return pipeNearBy
    //    }
    //

    
    // Заполняет словарь труб на игровом поле
    // Ключ - индекс в массиве CellLayer.children
    // Value - сама труба
    fileprivate func fillInPipesOnGameFieldDictionary() {
        
        for j in 0..<cellLayer.children.count {
            if (cellLayer.children[j].name == "reserved") {
                print("index has found \(j)")
                
                for i in 0..<pipesArray.count {
                    print("i = \(i)")
                    if (pipesArray[i].sprite?.inParentHierarchy(cellLayer))! &&
                        pipesArray[i].sprite?.position == cellLayer.children[j].position {
                        
                        pipesOnGameField[j] = pipesArray[i]
                        pipesArray.remove(at: i)
                    }
                }
            }
        }
    }
    
    fileprivate func cellIndexReserved(cell index: Int) -> Bool {
        if(cellLayer.children[index].name == "reserved") {
            return true
        }
        return false
    }
    
    // Добавляет новую трубу в свободную коробку
    fileprivate func addPipeIntoEmptyBox() {
        
        let newPipe = level.createRandomPipe()
        if (selectedPipe.position != selectedPipeInitialPosition) {
            let sprite = SKSpriteNode(imageNamed: newPipe.typeOfPipe.spritesName)
            sprite.position = selectedPipeInitialPosition
            sprite.name = pipeNodeName
            sprite.zPosition = 1
            pipeMakerLayer.addChild(sprite)
            newPipe.sprite = sprite
        
            popAnimation(sprite: sprite)
            pipesArray.append(newPipe)
        } else {
            return
        }
    }
    
    // Проверка на наличие свободной ячейки
    fileprivate func availablePlace() -> Bool{
        
        if (cellLayer["reserved"].count == NumOfRows * NumOfColumns) {
            return false
        }
        return true
    }
    
    
    // Происходит увеличение размера спрайта и возврат к первоначальному
    fileprivate func popAnimation(sprite: SKSpriteNode) {
        let initialSize = sprite.size
        let scaledUpSize = CGSize(width: initialSize.width + 5,height: initialSize.height + 5)
        let scaleDownSize = CGSize(width: initialSize.width - 3,height: initialSize.height - 3)
        
        
        let scaleUp = SKAction.scale(to: scaledUpSize, duration: 0.2)
        let scaleToInitial = SKAction.scale(to: initialSize, duration: 0.1)
        let scaleDown = SKAction.scale(to: scaleDownSize, duration: 0.1)
        
        sprite.run(SKAction.sequence([scaleUp,scaleDown,scaleToInitial]))
    }
    
    
    //    func movablePipesOnGameField() -> Array<Pipes> {
    //        var pipesOnGameField = Array<Pipes>()
    //
    //        for pipe in pipesArray {
    //
    //            print("parent name of pipe in loop\(pipe.sprite?.parent?.name)")
    //
    //            if pipe.sprite!.inParentHierarchy(cellLayer) {
    //                pipesOnGameField.append(pipe)
    //            }
    //        }
    //
    //        return pipesOnGameField
    //    }
}
