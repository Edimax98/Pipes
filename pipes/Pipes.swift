//
//  Pipes.swift
//  pipes
//
//  Created by Даниил Смирнов
//  Copyright © 2016 Даниил Смирнов. All rights reserved.
//

import Foundation
import SpriteKit

/**
    Позиции труб по отношению друг к другу в водопроводе
    - **unknown**: Местоположение не известно
    - **upper**: Выше
    - **lower**: Ниже
    - **righter**: Правее
    - **lefter**: Левее
*/
enum locationOfPipeForWater: Int {
    case unknown = 0, upper, lower, righter, lefter
}
/**
    Виды труб
 - **unknown**: Тип трубы не известен
 - **anglePipeRight**: |-
 - **anglePipeLeft**: -|
 - **horizontalStraightPipe**: |
 - **verticalStraightPipe**: --
 - **rightAnglePipeDown**: _|
 - **verticalStraightPipe**: |_
 */
enum TypesOfPipe: Int{
    case unknown = 0, anglePipeRight, anglePipeLeft,horizontalStraightPipe, verticalStraightPipe, rightAnglePipeDown, leftAnglePipeDown
    
    /// Названия спрайтов труб
    var spritesName: String {
        let spritesName = [
            "anglePipeRight",
            "anglePipeLeft",
            "horizontalStraightPipe",
            "verticalStraightPipe",
            "rightAnglePipeDown",
            "leftAnglePipeDown",
        ]
        return spritesName[rawValue - 1]
    }
    
    /// Возвращает уникальный двумерный массив для каждого вида труб. 
    /// - Returns: [[Bool]]
    func getBitMap() -> [[Bool]] {
        switch self {
        case .horizontalStraightPipe:           // --
            return [[false, false, false],
                    [true, false, true],
                    [false, false, false],]
            
        case .verticalStraightPipe:             // |
            return [[false, true, false],
                    [false, false, false],
                    [false, true, false],]
            
        case .anglePipeLeft:                    // -| up
            return [[false, false, false],
                    [true, false, false],
                    [false, true, false],]
            
        case .anglePipeRight:                    // |- up
            return [[false, false, false],
                    [false, false, true],
                    [false, true, false],]
            
        case .rightAnglePipeDown:                // _|
            return [[false, true, false],
                    [true, false, false],
                    [false, false, false],]
        
        case .leftAnglePipeDown:                // |_
            return [[false, true, false],
                    [false, false, true],
                    [false, false, false],]
        
        default:
            return [[false, false, false],
                    [false, false, false],
                    [false, false, false],]
        }
    }
    
    /// Создает определенное количество типов труб, сгенерированных случайным образом
    /// - Returns: TypeOfPipe
   static func random() -> TypesOfPipe{
        return TypesOfPipe(rawValue: Int(arc4random_uniform(6)) + 1)!
    }
}

/**
    Основополагающий класс, отображающий свойства трубы
*/
class Pipes {
    /// Местоположение трубы относительно других труб в водопроводе. По умолчанию: `.unknown`
    var locationInPlumbing = locationOfPipeForWater.unknown
    /// Тип трубы. Задается при инициализации объекта
    let typeOfPipe: TypesOfPipe
    /// Спрайт трубы
    var sprite: SKSpriteNode?
    /// Есть ли соединение с основной трубой. По умолчанию: `false`
    var connectedToMainPipe = false
    /// Кортеж из двух переменных типа `Bool`. Показывает соединена ли труба с одной из сторон
    var pipeConnected = (firstSide: false,secondSide: false)
    /// - Parameter typeOfPipe: Тип трубы
    init(typeOfPipe: TypesOfPipe){
        self.typeOfPipe = typeOfPipe
    }
}
