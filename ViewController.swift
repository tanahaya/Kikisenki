//
//  ViewController.swift
//  Kikisenki
//
//  Created by 田中 颯 on 2019/07/08.
//  Copyright © 2019 tanahaya. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController, UIGestureRecognizerDelegate  {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let Scene = GameScene()
        
        let View = self.view as! SKView
        
        View.showsFPS = true
        
        View.showsNodeCount = true
        
        Scene.size = View.frame.size
        
        View.presentScene(Scene)
        
        view.isMultipleTouchEnabled = false
        
        
        // Do any additional setup after loading the view.
    }
    @IBAction func didPan(sender: UIPanGestureRecognizer) {
        
    }


}

