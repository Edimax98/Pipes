//
//  GameViewController.swift
//  pipes
//
//  Created by Даниил Смирнов on 30.11.16.
//  Copyright © 2016 Даниил Смирнов. All rights reserved.
//

import UIKit
import SpriteKit
//import GameplayKit

class GameViewController: UIViewController {
    
    var scene: GameScene!
    var level: Level!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.landscape, .landscapeLeft]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the view.
        let skView = view as! SKView
        skView.isMultipleTouchEnabled = false
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        // Create and configure the scene.
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        
        //Render a level
        level = Level(filename: "Level_1")
        scene.level = level
        scene.addCells()
        
        // Present the scene.
        skView.presentScene(scene)
        
        beginGame()
    }
    
    func beginGame(){
        renderBoxes()
        renderPipes()
    }
    
    func renderBoxes() {
        let newBoxes = level.showBoxes()
        scene.addBoxes(boxes: newBoxes)
    }
    
    func renderPipes() {
        let newPipes = level.showPipes()
        scene.addSprites(for: newPipes)
    }
}
