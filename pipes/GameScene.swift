//
//  GameScene.swift
//  pipes
//
//  Created by Даниил Смирнов
//  Copyright © 2016 Даниил Смирнов. All rights reserved.
//

import SpriteKit
import GameplayKit
private let pipeNodeName = "movable"

class GameScene: SKScene {
    
    var level: Level!
    var viewController: UIViewController?
    
    private let background = SKSpriteNode(imageNamed: "Background")
    private var levelTimerLabel = SKLabelNode(fontNamed: "ArialMT")
    private var victoryLabel = SKLabelNode(fontNamed: "Chalkboard SE")
    private var defeatLabel = SKLabelNode(fontNamed: "Chalkboard SE")
    private var selectedPipe = SKNode()
    private var boxesPositionsArray = Array<CGPoint>()
    private var reservedCells = Array<(Int)>()
    
    private var startPipeConnected = false
    private var endPipeConnected = false
    
    private var pipesArray = Array<Pipes>()
    private var pipesOnGameField = [Int : Pipes]()
    private var plumbingArray = [(index: Int, pipe: Pipes)]()
    private var plumbingDict = [Int: Pipes]()
    
    private var selectedPipeInitialPosition = CGPoint()
    private let cellsHeight: CGFloat = 50.0
    private let cellsWidth: CGFloat = 50.0
    private let boxHeight: CGFloat = 50.0
    private let boxWidth: CGFloat = 50.0
    private let gameLayer = SKNode()
    private let cellLayer = SKNode()
    private let pipeMakerLayer = SKNode()
    private var startPipePosition = CGPoint()
    private var endPipePosition = CGPoint()
    private var countOfSeconds = 0
    
    private var sequenceActionArray = [SKAction]()
    let button = SKSpriteNode(color: SKColor.red, size: CGSize(width: 100, height: 44))
    
    //File names
    private let anglePipeLeftWaterLeftFileName = "anglePipeLeft_WaterLeft"
    private let anglePipeLeftWaterRightFileName = "anglePipeLeft_WaterRight"
    private let anglePipeRightWaterLeftFileName = "anglePipeRight_WaterLeft"
    private let anglePipeRightWaterRightFileName = "anglePipeRight_WaterRight"
    private let verticalStraightPipeWaterDownFileName = "verticalStraightPipe_WaterDown"
    private let verticalStraightPipeWaterUpFileName = "verticalStraightPipe_WaterUp"
    private let horizontalStraightPipeWaterLeftFileName = "horizontalStraightPipe_WaterLeft"
    private let horizontalStraightPipeWaterRightFileName = "horizontalStraightPipe_WaterRight"
    private let rightAnglePipeDownWaterDownFileName = "rightAnglePipeDown_WaterDown"
    private let rightAnglePipeDownWaterUpFileName = "rightAnglePipeDown_WaterUp"
    private let leftAnglePipeDownWaterDownFileName = "leftAnglePipeDown_WaterDown"
    private let leftAnglePipeDownWaterUpFileName = "leftAnglePipeDown_WaterUp"
    
    // Texture atlases
    private var anglePipeLeftWaterLeftTextureAtlas = SKTextureAtlas(named: "anglePipeLeft_WaterLeft")
    private var anglePipeLeftWaterRightTextureAtlas = SKTextureAtlas(named: "anglePipeLeft_WaterRight")
    private var anglePipeRightWaterLeftTextureAtlas = SKTextureAtlas(named: "anglePipeRight_WaterLeft")
    private var anglePipeRightWaterRightTextureAtlas = SKTextureAtlas(named: "anglePipeRight_WaterLeft")
    private var verticalStraightPipeWaterDownTextureAtlas = SKTextureAtlas(named: "verticalStraightPipe_WaterDown")
    private var verticalStraightPipeWaterUpTextureAtlas = SKTextureAtlas(named: "verticalStraightPipe_WaterUp")
    private var horizontalStraightPipeWaterLeftTextureAtlas = SKTextureAtlas(named: "horizontalStraightPipe_WaterLeft")
    private var horizontalStraightPipeWaterRightTextureAtlas = SKTextureAtlas(named: "horizontalStraightPipe_WaterRight")
    private var rightAnglePipeDownWaterDownTextureAtlas = SKTextureAtlas(named: "rightAnglePipeDown_WaterDown")
    private var rightAnglePipeDownWaterUpTextureAtlas = SKTextureAtlas(named: "rightAnglePipeDown_WaterUp")
    private var leftAnglePipeDownWaterDownTextureAtlas = SKTextureAtlas(named: "leftAnglePipeDown_WaterDown")
    private var leftAnglePipeDownWaterUpTextureAtlas = SKTextureAtlas(named: "leftAnglePipeDown_WaterUp")
    
    //Texture arrays
    private var anglePipeLeftWaterLeftTextureArray = Array<SKTexture>()
    private var anglePipeLeftWaterRightTextureArray = Array<SKTexture>()
    private var anglePipeRightWaterLeftTextureArray = Array<SKTexture>()
    private var anglePipeRightWaterRightTextureArray = Array<SKTexture>()
    private var verticalStraightPipeWaterDownTextureArray = Array<SKTexture>()
    private var verticalStraightPipeWaterUpTextureArray = Array<SKTexture>()
    private var horizontalStraightPipeWaterLeftTextureArray = Array<SKTexture>()
    private var horizontalStraightPipeWaterRightTextureArray = Array<SKTexture>()
    private var rightAnglePipeDownWaterDownTextureArray = Array<SKTexture>()
    private var rightAnglePipeDownWaterUpTextureArray = Array<SKTexture>()
    private var leftAnglePipeDownWaterDownTextureArray = Array<SKTexture>()
    private var leftAnglePipeDownWaterUpTextureArray = Array<SKTexture>()
    var vc = UIViewController()

    var levelTimerValue: Int = 150{
        didSet {
            levelTimerLabel.text = "\(levelTimerValue)"
        }
    }
    
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
        background.addChild(pipeMakerLayer)
        
        let layerPosition = CGPoint(
            x: -cellsWidth * CGFloat(NumOfColumns) / 2,
            y: -cellsHeight * CGFloat(NumOfRows) / 2)
        
        cellLayer.position = layerPosition
        cellLayer.name = "cellLayer"
        gameLayer.addChild(cellLayer)
        
        levelTimerLabel.fontColor = SKColor.black
        levelTimerLabel.fontSize = 40
        levelTimerLabel.position = CGPoint(x: self.frame.midX - self.size.width / 2 + 40,
                                           y: self.frame.maxY - self.size.height + 20)
        levelTimerLabel.text = "\(levelTimerValue)"
        self.addChild(levelTimerLabel)
        
        victoryLabel.fontColor = SKColor.white
        victoryLabel.fontSize = 50
        victoryLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        victoryLabel.text = "Победа!"
        victoryLabel.color = UIColor(colorLiteralRed: 219, green: 142, blue: 27, alpha: 0)
        
        defeatLabel.fontColor = SKColor.white
        defeatLabel.fontSize = 50
        defeatLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        defeatLabel.text = "Поражение!"
        defeatLabel.color = UIColor(colorLiteralRed: 219, green: 142, blue: 27, alpha: 0)
        
        //gameLayer.addChild(victoryLabel)
        
        print("HEIGHT OF SCENE \(self.size.height)")
        print("WIDTH OF SCENE \(self.size.width)")
        
        let wait = SKAction.wait(forDuration: 1) //скорость
        let block = SKAction.run({
            
            if (self.levelTimerValue > 0) {
                self.levelTimerValue -= 1
            }else{
                self.removeAction(forKey: "countdown")
            }
        })
        let sequence = SKAction.sequence([wait,block])
        
        run(SKAction.repeatForever(sequence), withKey: "countdown")

        
        // Заполнить массивы с текстурами
        anglePipeLeftWaterLeftTextureArray   =   fillSkTextureArray(atlas: anglePipeLeftWaterLeftTextureAtlas,pictureName: anglePipeLeftWaterLeftFileName)
        anglePipeLeftWaterRightTextureArray  =   fillSkTextureArray(atlas: anglePipeLeftWaterRightTextureAtlas,pictureName: anglePipeLeftWaterRightFileName)
        anglePipeRightWaterLeftTextureArray  =   fillSkTextureArray(atlas: anglePipeRightWaterLeftTextureAtlas,pictureName: anglePipeRightWaterLeftFileName)
        anglePipeRightWaterRightTextureArray =   fillSkTextureArray(atlas: anglePipeRightWaterRightTextureAtlas,pictureName: anglePipeRightWaterRightFileName)
        verticalStraightPipeWaterDownTextureArray = fillSkTextureArray(atlas: verticalStraightPipeWaterDownTextureAtlas,pictureName: verticalStraightPipeWaterDownFileName)
        verticalStraightPipeWaterUpTextureArray = fillSkTextureArray(atlas: verticalStraightPipeWaterUpTextureAtlas, pictureName: verticalStraightPipeWaterUpFileName)
        horizontalStraightPipeWaterLeftTextureArray = fillSkTextureArray(atlas: horizontalStraightPipeWaterLeftTextureAtlas, pictureName: horizontalStraightPipeWaterLeftFileName)
        horizontalStraightPipeWaterRightTextureArray = fillSkTextureArray(atlas: horizontalStraightPipeWaterRightTextureAtlas, pictureName: horizontalStraightPipeWaterRightFileName)
        rightAnglePipeDownWaterDownTextureArray = fillSkTextureArray(atlas: rightAnglePipeDownWaterDownTextureAtlas, pictureName: rightAnglePipeDownWaterDownFileName)
        rightAnglePipeDownWaterUpTextureArray  = fillSkTextureArray(atlas: rightAnglePipeDownWaterUpTextureAtlas,pictureName: rightAnglePipeDownWaterUpFileName)
        leftAnglePipeDownWaterDownTextureArray = fillSkTextureArray(atlas: leftAnglePipeDownWaterDownTextureAtlas,pictureName: leftAnglePipeDownWaterDownFileName)
        leftAnglePipeDownWaterUpTextureArray   = fillSkTextureArray(atlas: leftAnglePipeDownWaterUpTextureAtlas, pictureName: leftAnglePipeDownWaterUpFileName)
        
       // button.position = CGPoint(x:self.frame.midX + 50, y: self.frame.midY - 140);
       // self.addChild(button)
}

    
    
    
    
    ///  Функция предназначена для заполнения массивов текстур
    /// - Parameter atlas: папка-атлас, содержащая определенный набор текстур
    /// - Parameter pictureName: для удобства использвания атласов, рекомендуется именовать текстуры одинаково, меняя лишь порядковый номер
    /// - Returns: [SKTexture]
    fileprivate func fillSkTextureArray(atlas: SKTextureAtlas, pictureName: String) -> Array<SKTexture> {
        var array = Array<SKTexture>()
        var i = 1
        while(i <= atlas.textureNames.count / 3) {
            let name = pictureName + "\(i).png"
            array.append(SKTexture(imageNamed: name))
            i += 1
        }
        return array
    }
    
    ///   Организует перемещение спрайта по координатам
    /// - Parameter translation: координаты спрайта
    /// - Returns: Void
    fileprivate func panForTranslation(translation: CGPoint) {
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
        //deleteCell()
        let arrayOfCells = cellLayer.children
        var i = 0
        
        while (i < cellLayer.children.count) {
            print(" cell layer #\(i) name --> \(cellLayer.children[i].name) position --> \(cellLayer.children[i].position)")
            i += 1
        }
        
        if (!replaceSelectedPipeInAvailablePlace(sprites: arrayOfCells, name: "cell")) {
            selectedPipe.position = selectedPipeInitialPosition
            print("index of box - > \(index)")
        } else {
            
            
            fillInPipesOnGameFieldDictionary()
            addPipeIntoEmptyBox()
            connectPipe()
            plumbingArray = createPlumping()
            fillSequenceActionArray()
            
            if !backToMainMenu() {
               victoryHappend()
            }
            
            print("timeLeft \(level.getTime())")
        
            print("count of pipe IN PLUMBING - \(plumbingArray.count)")
            for (index,pipe) in plumbingArray {
                print("INFO about PLUMBING: index -> \(index), type - \(pipe.typeOfPipe) location - \(pipe.locationInPlumbing)")
            }
            
            for (key,value) in pipesOnGameField {
                print("INFO PIPES ON GAME FIELD: key -> \(key) value -> \(value.typeOfPipe) connected? - > \(value.pipeConnected)")
            }
            
            for i in pipesArray {
                print("PIPES ARR INFO: name - \(i.sprite?.name); type - \(i.typeOfPipe)")
            }
            return
        }
    }
    
    ///  Определяет спрайт по прикосновению
    /// - Parameter touchLocation: Координаты касания
    /// - Returns: Void
    fileprivate func selectNodeForTouch(touchLocation: CGPoint) {
        
        let touchedNode = self.scene?.nodes(at:touchLocation)
        
        // Выводит позицию спрайта при первом прикосновении
        print("position of node  X -> \(touchedNode![0].position.x) | Y -> \(touchedNode![0].position.x)")
        selectedPipe = touchedNode?[0] as! SKSpriteNode
        selectedPipeInitialPosition = selectedPipe.position
    }
    
    ///  Добавляет ячейки и главные трубы: конец и начало водопровода. Ячейки добавляются в CellLayer
    ///- Returns: Void
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
                        cellNode.name = "cell" //+ String(row) + "-" + String(column)
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
    ///  Добавляет первоначальные трубы в коробки. Первоначальные трубы добавляются в PipeMakerLayer
    /// - Parameter pipes: Массив труб
    /// - Returns: Void
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
    
    /// Добавляет коробки, в которых будут появлятся трубы. Коробки добавляются в PipeMakerLayer
    /// - Parameter boxes: Массив текстур коробок
    /// - Returns: Void
    func addBoxes(boxes: Array<SKSpriteNode>) {
        var i: CGFloat = 0.0
        for _ in boxes {
            let sprite = SKSpriteNode(imageNamed: "OpenedBox")
            sprite.name = "box"
            sprite.size = CGSize(width: boxWidth, height: boxHeight)
            sprite.position.y = i * boxHeight - self.size.height / 4 //- boxWidth/2 - 20
            sprite.position.x = (scene?.anchorPoint.x)! - (scene?.size.width)!/2 + boxWidth/2 + 5
            boxesPositionsArray.append(sprite.position)
            pipeMakerLayer.addChild(sprite)
            i += 1.0
        }
    }
    
    /// Расположение ячеек на экране в зависимости от столбца и строки массива, в котором они находятся
    /// -Parameter column: Столбец
    /// -Parameter row: Строка
    /// - Returns: CGPoint
    fileprivate func pointFor(column: Int, row: Int) -> CGPoint {
        return CGPoint(
            x: CGFloat(column) * cellsHeight + cellsWidth/2 + 20,
            y: CGFloat(row) * cellsHeight + cellsWidth/2 + 20)
    }
    
    /// Функция перемещает трубу в доступное место
    /// В массив передается слой в который нужно поставить трубу
    /// Перемещает выбранную трубу в другой слой (в данном случае в слой с ячейками), чтоб был доступ к сиситеме координат родителя
    /// - Parameter sprites: Массив спрайтов, на которые можно перемещать трубу
    /// - Parameter name: Имя спрайта, на который можно перемещать
    /// - Returns: Bool
    /// ```Swift
    ///   test(){
    ///    replaceSelectedPipeInAvailablePlace(sprites: cellLayer.children, name: "cell")
    /// }

    fileprivate func replaceSelectedPipeInAvailablePlace(sprites: Array<SKNode>, name: String) -> Bool {
        
        if(selectedPipe.name != pipeNodeName) {
            return false
        }
        
        for sprite in sprites {
            
            if (sprite.intersects(selectedPipe) &&
                sprite.name!.contains(name) &&
                !selectedPipe.inParentHierarchy(cellLayer)) {
                
                selectedPipe.move(toParent: sprite.parent!)
                print("\(selectedPipe.name) and its parent  \(selectedPipe.parent?.name)")
                selectedPipe.position = sprite.position
                sprite.name = "reserved"
                return true
            }
        }
        return false
    }
    
    /// Заполняет словарь труб, которые находятся в ячейках
    ///  Структура словаря:
    ///  - Key: индекс в массиве CellLayer.children
    ///  - Value: сама труба
    /// - Returns: Void
    fileprivate func fillInPipesOnGameFieldDictionary() {
        
        for j in 0..<cellLayer.children.count {
            if (cellLayer.children[j].name == "reserved") {
                for i in 0..<pipesArray.count {
                    if (pipesArray[i].sprite?.inParentHierarchy(cellLayer))! &&
                        pipesArray[i].sprite?.position == cellLayer.children[j].position {
                        pipesOnGameField[j] = pipesArray[i]
                    }
                }
            }
        }
    }
    
    /// Проверяет занята ли ячейка с передаваемым индексом
    /// - Parameter index: Индекс ячейки, котору нужно проверить
    /// - Returns: Bool
    fileprivate func cellIndexReserved(cell index: Int) -> Bool {
        if (index > NumOfColumns*NumOfRows || index < 0) {
            return false
        } else {
            if(cellLayer.children[index].name == "reserved" &&
                (cellLayer.children[index+1].name != "start" &&
                    cellLayer.children[index+1].name != "end")) {
                return true
            }
        }
        return false
    }
    
    /// Добавляет новую трубу в свободную коробку, после того как предыдущая была успешно перемещена в ячейку.
    /// - Returns: Void
    fileprivate func addPipeIntoEmptyBox() {
        
        let newPipe = level.createRandomPipe()
        if (selectedPipe.position != selectedPipeInitialPosition && selectedPipe.inParentHierarchy(cellLayer)) {
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
    
    /// Проверка на наличие свободной ячейки на всем игровом поле
    /// - Returns: Bool
    fileprivate func availablePlace() -> Bool{
        
        if (cellLayer["reserved"].count == NumOfRows * NumOfColumns) {
            return false
        }
        return true
    }
    
    /// Проверка на соединение труб между собой на игровом поле. Проверка осуществляется при помщи свойства bitMap, которое имеет каждая труба. 
    /// Определяет положение следующей трубы, по отношению к передыдущей(левее, правее, выше, ниже).
    /// - Returns: Void
    
    fileprivate func connectPipe() {
        let startPipeIndex = findIndexOfMainPipe(name: "start")
        let endPipeIndex = findIndexOfMainPipe(name: "end")
        
        if(!startPipeConnected) {
            
            if(cellLayer.children[startPipeIndex + 2].name == "reserved") {
                let bitMap = pipesOnGameField[startPipeIndex + 2]!.typeOfPipe.getBitMap()
                
                if(bitMap[1][0]) {
                    startPipeConnected = true
                    pipesOnGameField[startPipeIndex + 2]?.pipeConnected.firstSide = true
                    pipesOnGameField[startPipeIndex + 2]?.locationInPlumbing = .righter
                    pipesOnGameField[startPipeIndex + 2]?.connectedToMainPipe = true
                }
            }
        } else {
            
            for (index,pipe) in pipesOnGameField {
                
                print("index in dict \(index)")
                print("end connected ? -> \(endPipeConnected); ")
                checkConnectWithEnd(index: endPipeIndex, pipe: pipe)
                
                if(cellIndexReserved(cell: index)) {
                    //На клетку правее
                    if (cellIndexReserved(cell: index+1)){
                        
                        let bitMapNext = pipesOnGameField[index+1]!.typeOfPipe.getBitMap()
                        let bitMapPrev = pipe.typeOfPipe.getBitMap()
                        
                        if(bitMapNext[1][0] && bitMapPrev[1][2]) {
                            pipesOnGameField[index + 1]?.pipeConnected.firstSide = true
                            pipe.pipeConnected.secondSide = true
                            pipesOnGameField[index + 1]?.locationInPlumbing = .righter
                            pipe.locationInPlumbing = .righter
                            
                            if(pipe.connectedToMainPipe){
                                pipesOnGameField[index + 1]?.connectedToMainPipe = true
                            }
                        }
                    }
                    // Если на клетку выше
                    if(cellIndexReserved(cell: index+NumOfColumns)) {
                        
                        let bitMapNext = pipesOnGameField[index+NumOfColumns]!.typeOfPipe.getBitMap()
                        let bitMapPrev = pipe.typeOfPipe.getBitMap()
                        
                        
                        if(bitMapPrev[0][1] && bitMapNext[2][1]) {
                                pipesOnGameField[index+NumOfColumns]!.pipeConnected.firstSide = true
                                pipe.pipeConnected.secondSide = true
                                pipesOnGameField[index+NumOfColumns]!.locationInPlumbing = .upper
                                if(pipe.connectedToMainPipe){
                                    pipesOnGameField[index+NumOfColumns]!.connectedToMainPipe = true
                            }
                        }
                    }
                    // Если труба слева
                    if(cellIndexReserved(cell: index-1)) {
                        let bitMapNext = pipesOnGameField[index-1]!.typeOfPipe.getBitMap()
                        let bitMapPrev = pipe.typeOfPipe.getBitMap()
                        
                        if(bitMapNext[1][2] && bitMapPrev[1][0]) {
                            pipesOnGameField[index-1]!.pipeConnected.secondSide = true
                            pipe.pipeConnected.firstSide = true
                            pipesOnGameField[index-1]!.locationInPlumbing = .lefter
                            pipe.locationInPlumbing = .righter
                            
                            if(pipesOnGameField[index-1]!.connectedToMainPipe){
                                pipe.connectedToMainPipe = true
                            }
                        }
                    }
                    // Если труба внизу
                    if(cellIndexReserved(cell: index - NumOfColumns)) {
                        
                        let bitMapPrev = pipe.typeOfPipe.getBitMap()
                        let bitMapNext = pipesOnGameField[index-NumOfColumns]!.typeOfPipe.getBitMap()
                        
                        if(bitMapNext[0][1] && bitMapPrev[2][1]) {
                            
                            if(pipe.typeOfPipe == .anglePipeLeft || pipe.typeOfPipe == .leftAnglePipeDown) {
                                pipesOnGameField[index-NumOfColumns]!.pipeConnected.firstSide = true
                                pipe.pipeConnected.secondSide = true
                                pipe.locationInPlumbing = .upper
                                if(pipe.connectedToMainPipe){
                                    pipesOnGameField[index-NumOfColumns]!.connectedToMainPipe = true
                                }
                                
                            } else {
                                pipesOnGameField[index-NumOfColumns]!.pipeConnected.secondSide = true
                                pipe.pipeConnected.firstSide = true
                                pipe.locationInPlumbing = .upper
                                if(pipesOnGameField[index-NumOfColumns]!.connectedToMainPipe){
                                    pipe.connectedToMainPipe = true
                                }
                           }
                        }
                    }
                }
            }
        }
    }
    
    ///Формирует водопровод
    ///Возвращает массив кортежей(отсортированный словарь водопровода)
    ///Труба добавляется в водопровод если она соединена с обеих сторон и подсоединена к началу водопровода
    /// - Returns: [(Int,Pipes)]
    fileprivate func createPlumping() -> Array<(Int,Pipes)> {
        
        var plumbing = Array<(Int,Pipes)>()
        
        for (index, pipe) in pipesOnGameField {
            if(pipe.pipeConnected.firstSide &&
                pipe.pipeConnected.secondSide &&
                pipe.connectedToMainPipe){
                plumbingDict[index] = pipe
            }
        }
        plumbing = plumbingDict.sorted(by: {$0.0 < $1.0})
        return plumbing
    }
    
    
    /// Проверка на подсоединение трубы к сливу
    /// - Parameter index: Индекс трубы, для которой осуществляется проверка
    /// - Parameter pipe: Труба, для которой осуществляется проверка
    /// - Returns: Void
    fileprivate func checkConnectWithEnd(index: Int,pipe: Pipes) {
        
        if(!endPipeConnected) {
            
            if(cellIndexReserved(cell: index+2) && pipesOnGameField[index+2]!.pipeConnected.firstSide) {
                pipesOnGameField[index+2]!.pipeConnected.secondSide = true
                endPipeConnected = true
            }
            
            if(cellIndexReserved(cell: index-1) && pipesOnGameField[index-1]!.pipeConnected.firstSide) {
                pipesOnGameField[index-1]!.pipeConnected.secondSide = true
                endPipeConnected = true
            }
            
            if(cellIndexReserved(cell: index-NumOfColumns) && pipesOnGameField[index-NumOfColumns]!.pipeConnected.firstSide) {
                pipesOnGameField[index-NumOfColumns]!.pipeConnected.secondSide = true
                endPipeConnected = true
            }
            
            if(cellIndexReserved(cell: index+NumOfColumns) && pipesOnGameField[index+NumOfColumns]!.pipeConnected.firstSide) {
                pipesOnGameField[index+NumOfColumns]!.pipeConnected.secondSide = true
                endPipeConnected = true
            }
        }
    }
    
    ///Создает анимацию для массива текстур
    /// - Parameter pipeActionArray: Массив текстур
    /// - Returns: SKAction
    fileprivate func createActionsForPipe(pipeActionArray: [SKTexture]) -> SKAction{
        let action = SKAction.animate(with: pipeActionArray, timePerFrame: 0.1)
        return action
    }
    
    ///Заполняет массив анимаций для потока воды. Заполнение происходит с учетом расположения труб по отошению друг к другу в водопроводе
    /// - Returns: Void
    fileprivate func fillSequenceActionArray(){
        var firstPipe = false
        
        for (index,pipe) in plumbingArray {
            if(index == findIndexOfMainPipe(name: "start") + 1) {
                firstPipe = true
            }
            
            switch pipe.typeOfPipe {
            case .anglePipeLeft:
                if(firstPipe){
                    sequenceActionArray.append(createActionsForPipe(pipeActionArray: anglePipeLeftWaterRightTextureArray))
                } else {
                    if(pipe.locationInPlumbing == .righter) {
                        sequenceActionArray.append(createActionsForPipe(pipeActionArray: anglePipeLeftWaterRightTextureArray))
                    }
                    if(pipe.locationInPlumbing == .lefter) {
                        sequenceActionArray.append(createActionsForPipe(pipeActionArray: anglePipeLeftWaterLeftTextureArray))
                    }
                }
                
            case .anglePipeRight:
                if(pipe.locationInPlumbing == .righter) {
                    sequenceActionArray.append(createActionsForPipe(pipeActionArray: anglePipeRightWaterLeftTextureArray))
                }
                if(pipe.locationInPlumbing == .upper) {
                    sequenceActionArray.append(createActionsForPipe(pipeActionArray: anglePipeRightWaterRightTextureArray))
                }
                
            case .horizontalStraightPipe:
                if(firstPipe) {
                    sequenceActionArray.append(createActionsForPipe(pipeActionArray: horizontalStraightPipeWaterRightTextureArray))
                } else {
                    
                    if(pipe.locationInPlumbing == .righter) {
                        sequenceActionArray.append(createActionsForPipe(pipeActionArray: horizontalStraightPipeWaterRightTextureArray))
                    }
                    
                    if(pipe.locationInPlumbing == .lefter) {
                        sequenceActionArray.append(createActionsForPipe(pipeActionArray: horizontalStraightPipeWaterLeftTextureArray))
                    }
                }
                
            case .verticalStraightPipe:
                if(pipe.locationInPlumbing == .upper) {
                    sequenceActionArray.append(createActionsForPipe(pipeActionArray: verticalStraightPipeWaterUpTextureArray))
                }
                if(pipe.locationInPlumbing == .lower){
                    sequenceActionArray.append(createActionsForPipe(pipeActionArray: verticalStraightPipeWaterDownTextureArray))
                }
                
            case .leftAnglePipeDown:
                if(pipe.locationInPlumbing == .lefter) {
                    sequenceActionArray.append(createActionsForPipe(pipeActionArray: leftAnglePipeDownWaterUpTextureArray))
                }
                
                if(pipe.locationInPlumbing == .lower) {
                    sequenceActionArray.append(createActionsForPipe(pipeActionArray: leftAnglePipeDownWaterDownTextureArray))
                }
                
            case .rightAnglePipeDown:
                if(firstPipe) {
                    sequenceActionArray.append(createActionsForPipe(pipeActionArray: rightAnglePipeDownWaterUpTextureArray))
                } else {
                    if(pipe.locationInPlumbing == .righter) {
                        sequenceActionArray.append(createActionsForPipe(pipeActionArray: rightAnglePipeDownWaterUpTextureArray))
                    }
                    
                    if(pipe.locationInPlumbing == .lower) {
                        sequenceActionArray.append(createActionsForPipe(pipeActionArray: rightAnglePipeDownWaterDownTextureArray))
                    }
                }
                
            default:
                return
            }
        }
    }

    ///Запускает анимацию воды в водопроводе при помощи массива анимаций. Первый элемент в этом массиве - задержка
    /// - Returns: Void
    fileprivate func pushWater(){
        var i = 0
        for (_,pipe) in plumbingArray {
            i += 1
            let waitAction = SKAction.wait(forDuration: TimeInterval(i))
            
            switch pipe.typeOfPipe {
            case .anglePipeLeft:
                if(pipe.locationInPlumbing == .upper) {
                    pipe.sprite!.run(SKAction.sequence([waitAction,createActionsForPipe(pipeActionArray: anglePipeLeftWaterLeftTextureArray)]))
                } else {
                    pipe.sprite!.run(SKAction.sequence([waitAction,createActionsForPipe(pipeActionArray: anglePipeLeftWaterRightTextureArray)]))
                }
            case .anglePipeRight:
                if(pipe.locationInPlumbing == .upper) {
                    pipe.sprite?.run(SKAction.sequence([waitAction, createActionsForPipe(pipeActionArray: anglePipeRightWaterRightTextureArray)]))
                } else {
                    pipe.sprite?.run(SKAction.sequence([waitAction, createActionsForPipe(pipeActionArray:  anglePipeRightWaterLeftTextureArray)]))
                }
            case .horizontalStraightPipe:
                if(pipe.locationInPlumbing == .righter) {
                    pipe.sprite?.run(SKAction.sequence([waitAction, createActionsForPipe(pipeActionArray: horizontalStraightPipeWaterRightTextureArray)]))
                } else if (pipe.locationInPlumbing == .lefter){
                    pipe.sprite?.run(SKAction.sequence([waitAction, createActionsForPipe(pipeActionArray: horizontalStraightPipeWaterLeftTextureArray)]))
                }
                
            case .leftAnglePipeDown:
                if(pipe.locationInPlumbing == .lower) {
                    pipe.sprite?.run(SKAction.sequence([waitAction, createActionsForPipe(pipeActionArray: leftAnglePipeDownWaterDownTextureArray)]))
                } else {
                    pipe.sprite?.run(SKAction.sequence([waitAction, createActionsForPipe(pipeActionArray: leftAnglePipeDownWaterUpTextureArray)]))
                }
            case .rightAnglePipeDown:
                if(pipe.locationInPlumbing == .lower) {
                    pipe.sprite?.run(SKAction.sequence([waitAction, createActionsForPipe(pipeActionArray: rightAnglePipeDownWaterDownTextureArray)]))
                } else {
                    pipe.sprite?.run(SKAction.sequence([waitAction, createActionsForPipe(pipeActionArray: rightAnglePipeDownWaterUpTextureArray)]))
                }
            case .verticalStraightPipe:
                if(pipe.locationInPlumbing == .upper) {
                    pipe.sprite?.run(SKAction.sequence([waitAction, createActionsForPipe(pipeActionArray: verticalStraightPipeWaterUpTextureArray)]))
                } else if (pipe.locationInPlumbing == .lower) {
                    pipe.sprite?.run(SKAction.sequence([waitAction, createActionsForPipe(pipeActionArray: verticalStraightPipeWaterDownTextureArray)]))
                }
            default:
                return
            }
        }
    }
    
    /// Проверка оставшегося времени на таймере
    /// - Returns: Bool
    fileprivate func checkTimeLeft() -> Bool {
        if(levelTimerLabel.text == "0") {
            return false
        }
        return true
    }
    
    /// Обработка событий при победе. Победа происходит при собранном водопроводе подключенном к началу и концу
    /// - Returns: Void
    fileprivate func victoryHappend() {
        if(plumbingArray.isEmpty) { return }

        if(cellLayer.children[plumbingArray.last!.index+2].name == "end") {
            pushWater()
            gameLayer.addChild(victoryLabel)
            victoryLabel.zPosition = 2
        }
        
        if(cellIndexReserved(cell: plumbingArray.last!.index+NumOfColumns) &&
            cellLayer.children[plumbingArray.last!.index+NumOfColumns].name == "end") {
            if(plumbingArray.last!.pipe.connectedToMainPipe){
                pushWater()
            }
        }
        
        if(cellIndexReserved(cell: plumbingArray.last!.index-2) &&
            cellLayer.children[plumbingArray.last!.index-2].name == "end") {
            if(plumbingArray.last!.pipe.connectedToMainPipe){
                pushWater()
            }
        }
        
        if(cellIndexReserved(cell: plumbingArray.last!.index-NumOfColumns) &&
            cellLayer.children[plumbingArray.last!.index-NumOfColumns].name == "end") {
            if(plumbingArray.last!.pipe.connectedToMainPipe){
                pushWater()
            }
        }
    }
    
    /// Происходит переход в главное меню  после поражения(но на самом деле нер переходит). Перед переходм выводится надписи "Поражение". Поражение происходит из-за истечения времени на таймере или когда места на игровом поле закончились
    /// - Returns: Bool
    fileprivate func backToMainMenu() -> Bool{
        if(!checkTimeLeft() || !availablePlace()){
            self.addChild(defeatLabel)
            defeatLabel.zPosition = 3
            let pauseAction = SKAction.run{
                self.view?.isPaused = true
            }
            self.run(pauseAction)
           // print(vc)
           // vc = self.view!.window!.rootViewController!
           // self.viewController!.performSegue(withIdentifier: "menu", sender: self)
            return true
        }
        return false
    }

    
    /// Анимация появления новой трубы в коробке. Происходит увеличение размера спрайта и возврат к первоначальному
    /// - Parameter sprite: Спрайт, который нужно анимировать
    /// - Returns: Void
    fileprivate func popAnimation(sprite: SKSpriteNode) {
        let initialSize = sprite.size
        let scaledUpSize = CGSize(width: initialSize.width + 5,height: initialSize.height + 5)
        let scaleDownSize = CGSize(width: initialSize.width - 3,height: initialSize.height - 3)
        
        let scaleUp = SKAction.scale(to: scaledUpSize, duration: 0.2)
        let scaleToInitial = SKAction.scale(to: initialSize, duration: 0.1)
        let scaleDown = SKAction.scale(to: scaleDownSize, duration: 0.1)
        
        sprite.run(SKAction.sequence([scaleUp,scaleDown,scaleToInitial]))
    }
    
    /// Осуществляет поиск инекса главной трубы по ее названию
    /// - Parameter name: Название искомой трубы
    /// - Returns: Int
    fileprivate func findIndexOfMainPipe(name: String) -> Int{
        var index = 0
        
        for i in 0..<cellLayer.children.count {
            
            if (cellLayer.children[i].name == name) {
                index = i - 1
            }
        }
        return index
    }
}
