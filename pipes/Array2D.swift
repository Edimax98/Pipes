//
//  Array2D.swift
//  pipes
//
//  Created by Даниил Смирнов
//  Copyright © 2016 Даниил Смирнов. All rights reserved.
//

import Foundation

/// Структура реализующая двумерный массив
struct Array2D<T> {
    
    let columns: Int
    let rows: Int
    fileprivate var array: Array<T?>
    
    init(columns: Int, rows: Int) {
        self.columns = columns
        self.rows = rows
        array = Array<T?>(repeating: nil, count: rows*columns)
    }
    /// Проверка на корректность вводимых данных. Если строка или столбец не существуют возникнет ошибка
    /// - Parameter column: Столбец
    /// - Parameter row: Строка
    /// - Returns: Bool
    func indexIsValid(row: Int, column: Int) -> Bool {
        return row >= 0 && row <= rows && column >= 0 && column <= columns
    }
    
    /// Субскрипт для получения элемента массива по номеру столбца и строки
    /// - Parameter column: Столбец
    /// - Parameter row: Строка
    subscript(column: Int, row: Int) -> T? {
        get {
            assert(indexIsValid(row: row, column: column), "index out of range")
            return array[row*columns + column]
        }
        set {
            assert(indexIsValid(row: row, column: column), "index out of range")
            array[row*columns + column] = newValue
        }
    }
}
