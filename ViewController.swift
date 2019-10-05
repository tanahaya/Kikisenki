//
//  ViewController.swift
//  Kikisenki
//
//  Created by 田中 颯 on 2019/07/08.
//  Copyright © 2019 tanahaya. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    let startScene = StartScene()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let View = self.view as! SKView
        
        View.showsFPS = true
        View.showsNodeCount = true
        View.isMultipleTouchEnabled = false
        //View.showsPhysics = true
        View.showsPhysics = false
        
        View.presentScene(startScene)
        
        
    }
    
    
}

