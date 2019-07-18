//
//  GameScene.swift
//  Kikisenki
//
//  Created by 田中 颯 on 2019/07/08.
//  Copyright © 2019 tanahaya. All rights reserved.
//

import Foundation
import SpriteKit

class GameScene : SKScene, SKPhysicsContactDelegate{
    
    var WallLeft = SKSpriteNode(imageNamed: "WallLeft")
    var WallRight = SKSpriteNode(imageNamed: "WallRight")
    var Button = SKSpriteNode(imageNamed: "Button")
    var Ball = SKSpriteNode(imageNamed: "Ball")
    var Back = SKSpriteNode(imageNamed: "Back")
    
    
    override func didMove(to view: SKView) {
        Back.position = CGPoint(x: 0,y: 0)
        Back.anchorPoint = CGPoint(x: 0,y: 0)//ノードの位置配置などの起点を設定。
        self.addChild(Back)
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        <#code#>
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        <#code#>
    }
    
}



