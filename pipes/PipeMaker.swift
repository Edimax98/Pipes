//
//  PipeMaker.swift
//  pipes
//
//  Created by Даниил Смирнов on 16.12.16.
//  Copyright © 2016 Даниил Смирнов. All rights reserved.
//

import Foundation
import SpriteKit

let AmountOfInitialPipes = 5

class PipeMaker {
    
    let box = SKSpriteNode(imageNamed: "OpenedBox")
   
    func renderPipes() -> Array<Pipes> {
        let array = createInitialPipes()
        return array
    }
    
    fileprivate func createInitialPipes() -> Array<Pipes> {
        var array = Array<Pipes>()
        
        for _ in 0..<AmountOfInitialPipes {
            let pipeType = TypesOfPipe.random()
            let pipe = Pipes(typeOfPipe: pipeType)
            array.append(pipe)
        }
        return array
    }
    
    fileprivate func createBoxes() -> Array<SKSpriteNode> {
        var array = Array<SKSpriteNode>()
        
        for _ in 0..<AmountOfInitialPipes{
            array.append(box)
        }
        return array
    }
    
    func renderBoxes() -> Array<SKSpriteNode> {
        let array = createBoxes()
        return array
    }
}
