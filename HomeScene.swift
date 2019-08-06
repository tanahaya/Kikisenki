//
//  HomeScene.swift
//  Kikisenki
//
//  Created by 田中 颯 on 2019/08/06.
//  Copyright © 2019 tanahaya. All rights reserved.
//

import Foundation
import SpriteKit

class HomeScene : SKScene, SKPhysicsContactDelegate{
    
    var Map = SKSpriteNode(imageNamed: "map")
    var MapIcon1 = SKSpriteNode(imageNamed: "mapIcon")
    
    override func didMove(to view: SKView) {
        
        //起動した時の処理
        self.size = CGSize(width: 414, height: 896)//414x896が最適。これはiphoneXRの画面サイズ
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        self.physicsWorld.contactDelegate = self //didBeginCOntactに必要
        
        self.backgroundColor = UIColor.white
        
        
        Map.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "map.png"), size: Map.size)
        Map.name = "map"
        Map.position = CGPoint(x: 207,y: 448)
        Map.physicsBody?.categoryBitMask = 0
        Map.physicsBody?.contactTestBitMask = 0
        Map.physicsBody?.collisionBitMask = 0
        self.addChild(Map)
        
        
        MapIcon1.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "mapIcon.png"), size: MapIcon1.size)
        MapIcon1.name = "mapIcon1"
        MapIcon1.position = CGPoint(x: 296,y: 259)
        MapIcon1.xScale = 0.25
        MapIcon1.yScale = 0.25
        MapIcon1.physicsBody?.categoryBitMask = 0
        MapIcon1.physicsBody?.contactTestBitMask = 0
        MapIcon1.physicsBody?.collisionBitMask = 0
        MapIcon1.alpha = 1.0//0.0なら反応しない
        self.addChild(MapIcon1)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first as UITouch? {
            
            let location = touch.location(in: self)
            
            if self.atPoint(location).name == "mapIcon1" {
                self.gotoGameScene()
            }
        }
    }
    
    
    
    func gotoGameScene() {
        
        let Scene = GameScene()
        Scene.size = self.size
        let transition = SKTransition.crossFade(withDuration: 1.0)
        
        self.view?.presentScene(Scene, transition: transition)
        
    }
    
    
    
    
}

