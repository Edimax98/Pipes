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
