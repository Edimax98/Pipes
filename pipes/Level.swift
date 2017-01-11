//
//  Level.swift
//  pipes
//
//  Created by Даниил Смирнов on 07.12.16.
//  Copyright © 2016 Даниил Смирнов. All rights reserved.
//

import Foundation
import SpriteKit

let NumOfRows = 5
let NumOfColumns = 10

class Level {
    
    private var cells = Array2D<Cell>(columns: NumOfColumns, rows: NumOfRows)
    
    let pipeMaker = PipeMaker()
    
    func cellAt(column: Int, row: Int) -> Cell? {
        return cells[column, row]
    }
    
    init(filename: String) {
        guard let dictionary = Dictionary<String, AnyObject>.loadJSONFromBundle(filename: filename) else { return }
        
        guard let cellsArray = dictionary["cells"] as? [[Int]] else { return }
        
        for (row, rowArray) in cellsArray.enumerated() {
            let cellRow = NumOfRows - row - 1
            
            for (column, value) in rowArray.enumerated() {
                
                switch value {
                case 1:
                    cells[column, cellRow] = Cell()
                    
                case 2:
                    self.cells[column, cellRow] = Cell()
                    self.cells[column, cellRow]?.sprite = SKSpriteNode(imageNamed: "startPipe")
                    self.cells[column, cellRow]?.sprite?.name = "start"
                    
                case 3:
                    self.cells[column, cellRow] = Cell()
                    self.cells[column, cellRow]?.sprite = SKSpriteNode(imageNamed: "endPipe")
                    self.cells[column, cellRow]?.sprite?.name = "end"
                    
                default:
                    cells[column, cellRow] = nil
                }
            }
        }
    }
    
    func createRandomPipe() -> Pipes {
        return Pipes(typeOfPipe: TypesOfPipe.random())
    }
    
    func showBoxes() -> Array<SKSpriteNode> {
        let array = pipeMaker.renderBoxes()
        return array
    }
    
    func showPipes() -> Array<Pipes>{
        let array =  pipeMaker.renderPipes()
        return array
    }
}
