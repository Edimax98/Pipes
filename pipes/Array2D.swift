//
//  Array2D.swift
//  pipes
//
//  Created by Даниил Смирнов on 04.12.16.
//  Copyright © 2016 Даниил Смирнов. All rights reserved.
//

import Foundation

struct Array2D<T> {
    
    let columns: Int
    let rows: Int
    fileprivate var array: Array<T?>
    
    init(columns: Int, rows: Int) {
        self.columns = columns
        self.rows = rows
        array = Array<T?>(repeating: nil, count: rows*columns)
    }
    
    func indexIsValid(row: Int, column: Int) -> Bool {
        return row >= 0 && row <= rows && column >= 0 && column <= columns
    }
    
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
