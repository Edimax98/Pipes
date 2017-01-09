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
    case unknown = 0, anglePipeRight, anglePipeLeft,horizontalStraightPipe, verticalStraightPipe
    
    var spritesName: String {
        let spritesName = [
            "anglePipeRight",
            "anglePipeLeft",
            "horizontalStraightPipe",
            "verticalStraightPipe"
        ]
        return spritesName[rawValue - 1]
    }
    
    func getBitMap() -> [[Bool]] {
        switch self {
        case .horizontalStraightPipe:           // |
            return [[false , true , false],
                    [false , false , false],
                    [false , true , false],]
            
        case .verticalStraightPipe:             // --
            return [[false , false , false],
                    [true , false , true],
                    [false , false, false],]
            
        case .anglePipeLeft:                    // _|
            return [[false , true, false],
                    [true , false , false],
                    [false , false, false],]
            
        case .anglePipeRight:                    // |_
            return [[false , true , false],
                    [false , false , true],
                    [false , false, false],]
        default:
            return [[false , false , false],
                    [false , false , false],
                    [false , false, false],]
        }
    }
    
   static func random() -> TypesOfPipe{
        return TypesOfPipe(rawValue: Int(arc4random_uniform(4)) + 1)!
    }
}

class Pipes {
    let typeOfPipe: TypesOfPipe
    var sprite: SKSpriteNode?
    
    init(typeOfPipe: TypesOfPipe){
        self.typeOfPipe = typeOfPipe
    }
}
