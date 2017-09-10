//
//  Level.swift
//  pipes
//
//  Created by Даниил Смирнов
//  Copyright © 2016 Даниил Смирнов. All rights reserved.
//

import Foundation
import SpriteKit

/// Количество строк с ячейками
let NumOfRows = 5
/// Количество столбцов с ячейками
let NumOfColumns = 10

/**
 Отвечает за парсинг json-файла и отображение элементов
 */

class Level {
    /// Двумерный массив ячеек
    private var cells = Array2D<Cell>(columns: NumOfColumns, rows: NumOfRows)
    /// Время в таймере
    private var timeLeft: Int?
    /// Экземпляр класса PipeMaker для осущствления генерации коробок и первоначальных труб
    let pipeMaker = PipeMaker()
    
    /// Возвращает ячеку по заданному столбцу и ячейке
    /// - Parameter column: столбец
    /// - Parameter row: строка
    /// - Returns: Cell?
    func cellAt(column: Int, row: Int) -> Cell? {
        return cells[column, row]
    }
    
    /// Инициализатор уровня
    /// - Parameter filename: Имя json-файла, содержащего структуру файла
    init(filename: String) {
        guard let dictionary = Dictionary<String, AnyObject>.loadJSONFromBundle(filename: filename) else { return }
        
        guard let cellsArray = dictionary["cells"] as? [[Int]] else { return }
        guard let time = dictionary["time"] as? Int else { return }
        
        timeLeft = time
        
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
    
    /// Получает количество секунд для таймера
    /// - Returns: Int
    func getTime() -> Int {
        return timeLeft!
    }
    
    /// Создает трубу, сгенерированную случайным образом
    /// - Returns: Pipes
    func createRandomPipe() -> Pipes {
        return Pipes(typeOfPipe: TypesOfPipe.random())
    }
    
    /// Отображает коробки
    /// - Returns: [SKSpriteNode]
    func showBoxes() -> Array<SKSpriteNode> {
        let array = pipeMaker.renderBoxes()
        return array
    }
    
    /// Отображает трубы
    /// - Returns: [Pipes]
    func showPipes() -> Array<Pipes>{
        let array =  pipeMaker.renderPipes()
        return array
    }
}
