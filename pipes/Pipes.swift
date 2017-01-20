//
//  Pipes.swift
//  pipes
//
//  Created by Даниил Смирнов on 05.12.16.
//  Copyright © 2016 Даниил Смирнов. All rights reserved.
//

import Foundation
import SpriteKit

enum TypesOfPipe: Int{
    case unknown = 0, anglePipeRight, anglePipeLeft,horizontalStraightPipe, verticalStraightPipe, rightAnglePipeDown, leftAnglePipeDown
    
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
    
   static func random() -> TypesOfPipe{
        return TypesOfPipe(rawValue: Int(arc4random_uniform(6)) + 1)!
    }
}

class Pipes {
    let typeOfPipe: TypesOfPipe
    var sprite: SKSpriteNode?
    var pipeConnected = (firstSide: false,secondSide: false)
    
    init(typeOfPipe: TypesOfPipe){
        self.typeOfPipe = typeOfPipe
    }
}
