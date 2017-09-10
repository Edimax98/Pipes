//
//  MainMenuViewController.swift
//  pipes
//
//  Created by Даниил Смирнов
//  Copyright © 2017 Даниил Смирнов. All rights reserved.
//

import UIKit
/// ViewController главного меню
class MainMenuViewController: UIViewController {
    
    @IBOutlet weak var startGameButton: UIButton!
    
    @IBOutlet weak var gameName: UILabel!

    @IBOutlet weak var backGroundImage: UIImageView!
    
    @IBAction func startGame(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        startGameButton.layer.cornerRadius = 7
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
