//
//  PipeMaker.swift
//  pipes
//
//  Created by Даниил Смирнов 
//  Copyright © 2016 Даниил Смирнов. All rights reserved.
//

import Foundation
import SpriteKit

/// Количество первоначальных труб
let AmountOfInitialPipes = 5

/**
    Отвечает за создание первоначальных труб, которые сгенерированы случайным образом. Создание коробок
 */

class PipeMaker {
   
    ///Коробка
    let box = SKSpriteNode(imageNamed: "OpenedBox")
   
    /// Отобразить первоначальные трубы
    /// - Returns: [Pipes]
    func renderPipes() -> Array<Pipes> {
        let array = createInitialPipes()
        return array
    }
    
    /// Генерируются первоначальные трубы
    /// - Returns: [Pipes]
    fileprivate func createInitialPipes() -> Array<Pipes> {
        var array = Array<Pipes>()
        
        for _ in 0..<AmountOfInitialPipes {
            let pipeType = TypesOfPipe.random()
            let pipe = Pipes(typeOfPipe: pipeType)
            array.append(pipe)
        }
        return array
    }
    
    /// Генерируются коробки
    /// - Returns: [SKSpriteNode]
    fileprivate func createBoxes() -> Array<SKSpriteNode> {
        var array = Array<SKSpriteNode>()
        
        for _ in 0..<AmountOfInitialPipes{
            array.append(box)
        }
        return array
    }
    /// Отображает коробки
    /// - Returns: [SKSpriteNode]
    func renderBoxes() -> Array<SKSpriteNode> {
        let array = createBoxes()
        return array
    }
}
