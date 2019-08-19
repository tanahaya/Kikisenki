//
//  HomeScene.swift
//  Kikisenki
//
//  Created by 田中 颯 on 2019/08/06.
//  Copyright © 2019 tanahaya. All rights reserved.
//

import UIKit
import SpriteKit

class HomeScene : SKScene, SKPhysicsContactDelegate{
    
    var Map = SKSpriteNode(imageNamed: "map")
    
    var MapIcon1 = SKSpriteNode(imageNamed: "mapIcon")
    var MapIcon2 = SKSpriteNode(imageNamed: "mapIcon")
    var MapIcon3 = SKSpriteNode(imageNamed: "mapIcon")
    var MapIcon4 = SKSpriteNode(imageNamed: "mapIcon")
    var MapIcon5 = SKSpriteNode(imageNamed: "mapIcon")
    var MapIcon6 = SKSpriteNode(imageNamed: "mapIcon")
    var MapIcon7 = SKSpriteNode(imageNamed: "mapIcon")
    var MapIcon8 = SKSpriteNode(imageNamed: "mapIcon")
    var MapIcon9 = SKSpriteNode(imageNamed: "mapIcon")
    var MapIcon10 = SKSpriteNode(imageNamed: "mapIcon")
    var MapIcon11 = SKSpriteNode(imageNamed: "mapIcon")
    
    var levelup = SKSpriteNode(imageNamed: "levelup")
    
    
    override func didMove(to view: SKView) {
        
        //起動した時の処理
        self.size = CGSize(width: 414, height: 896)//414x896が最適。これはiphoneXRの画面サイズ
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        self.physicsWorld.contactDelegate = self //didBeginCOntactに必要
        
        self.backgroundColor = UIColor.white
        
        //背景の地図
        Map.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "map.png"), size: Map.size)
        Map.name = "map"
        Map.position = CGPoint(x: 208,y: 448)
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
        self.addChild(MapIcon1)
        
        MapIcon2.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "mapIcon.png"), size: MapIcon2.size)
        MapIcon2.name = "mapIcon2"
        MapIcon2.position = CGPoint(x: 290,y: 408)
        MapIcon2.xScale = 0.25
        MapIcon2.yScale = 0.25
        MapIcon2.physicsBody?.categoryBitMask = 0
        MapIcon2.physicsBody?.contactTestBitMask = 0
        MapIcon2.physicsBody?.collisionBitMask = 0
        self.addChild(MapIcon2)
        
        MapIcon3.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "mapIcon.png"), size: MapIcon3.size)
        MapIcon3.name = "mapIcon3"
        MapIcon3.position = CGPoint(x: 292,y: 568)
        MapIcon3.xScale = 0.25
        MapIcon3.yScale = 0.25
        MapIcon3.physicsBody?.categoryBitMask = 0
        MapIcon3.physicsBody?.contactTestBitMask = 0
        MapIcon3.physicsBody?.collisionBitMask = 0
        self.addChild(MapIcon3)
        
        MapIcon4.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "mapIcon.png"), size: MapIcon4.size)
        MapIcon4.name = "mapIcon4"
        MapIcon4.position = CGPoint(x: 240,y: 478)
        MapIcon4.xScale = 0.25
        MapIcon4.yScale = 0.25
        MapIcon4.physicsBody?.categoryBitMask = 0
        MapIcon4.physicsBody?.contactTestBitMask = 0
        MapIcon4.physicsBody?.collisionBitMask = 0
        self.addChild(MapIcon4)
        
        MapIcon5.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "mapIcon.png"), size: MapIcon5.size)
        MapIcon5.name = "mapIcon5"
        MapIcon5.position = CGPoint(x: 194,y: 548)
        MapIcon5.xScale = 0.25
        MapIcon5.yScale = 0.25
        MapIcon5.physicsBody?.categoryBitMask = 0
        MapIcon5.physicsBody?.contactTestBitMask = 0
        MapIcon5.physicsBody?.collisionBitMask = 0
        self.addChild(MapIcon5)
        
        MapIcon6.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "mapIcon.png"), size: MapIcon6.size)
        MapIcon6.name = "mapIcon6"
        MapIcon6.position = CGPoint(x: 166,y: 458)
        MapIcon6.xScale = 0.25
        MapIcon6.yScale = 0.25
        MapIcon6.physicsBody?.categoryBitMask = 0
        MapIcon6.physicsBody?.contactTestBitMask = 0
        MapIcon6.physicsBody?.collisionBitMask = 0
        self.addChild(MapIcon6)
        
        MapIcon7.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "mapIcon.png"), size: MapIcon7.size)
        MapIcon7.name = "mapIcon7"
        MapIcon7.position = CGPoint(x: 137,y: 372)
        MapIcon7.xScale = 0.25
        MapIcon7.yScale = 0.25
        MapIcon7.physicsBody?.categoryBitMask = 0
        MapIcon7.physicsBody?.contactTestBitMask = 0
        MapIcon7.physicsBody?.collisionBitMask = 0
        self.addChild(MapIcon7)
        
        MapIcon8.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "mapIcon.png"), size: MapIcon8.size)
        MapIcon8.name = "mapIcon8"
        MapIcon8.position = CGPoint(x: 137,y: 287)
        MapIcon8.xScale = 0.25
        MapIcon8.yScale = 0.25
        MapIcon8.physicsBody?.categoryBitMask = 0
        MapIcon8.physicsBody?.contactTestBitMask = 0
        MapIcon8.physicsBody?.collisionBitMask = 0
        self.addChild(MapIcon8)
        
        MapIcon9.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "mapIcon.png"), size: MapIcon9.size)
        MapIcon9.name = "mapIcon9"
        MapIcon9.position = CGPoint(x: 250,y: 213)
        MapIcon9.xScale = 0.25
        MapIcon9.yScale = 0.25
        MapIcon9.physicsBody?.categoryBitMask = 0
        MapIcon9.physicsBody?.contactTestBitMask = 0
        MapIcon9.physicsBody?.collisionBitMask = 0
        self.addChild(MapIcon9)
        
        MapIcon10.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "mapIcon.png"), size: MapIcon10.size)
        MapIcon10.name = "mapIco10"
        MapIcon10.position = CGPoint(x: 245,y: 278)
        MapIcon10.xScale = 0.25
        MapIcon10.yScale = 0.25
        MapIcon10.physicsBody?.categoryBitMask = 0
        MapIcon10.physicsBody?.contactTestBitMask = 0
        MapIcon10.physicsBody?.collisionBitMask = 0
        self.addChild(MapIcon10)
        
        MapIcon11.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "mapIcon.png"), size: MapIcon11.size)
        MapIcon11.name = "mapIcon11"
        MapIcon11.position = CGPoint(x: 214,y: 352)
        MapIcon11.xScale = 0.25
        MapIcon11.yScale = 0.25
        MapIcon11.physicsBody?.categoryBitMask = 0
        MapIcon11.physicsBody?.contactTestBitMask = 0
        MapIcon11.physicsBody?.collisionBitMask = 0
        self.addChild(MapIcon11)
        
        levelup.name = "levelup"
        levelup.anchorPoint = CGPoint(x: 0,y: 0)
        levelup.position = CGPoint(x: 274,y: 712)
        levelup.xScale = 0.7
        levelup.yScale = 0.7
        levelup.physicsBody?.categoryBitMask = 0
        levelup.physicsBody?.contactTestBitMask = 0
        levelup.physicsBody?.collisionBitMask = 0
        self.addChild(levelup)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first as UITouch? {
            
            let location = touch.location(in: self)
            
            switch self.atPoint(location).name  {//可変レベル
                
            case "mapIcon1":
                self.gotoSelectScene()
            case "mapIcon2":
                self.gotoSelectScene()
            case "mapIcon3":
                self.gotoSelectScene()
            case "mapIcon4":
                self.gotoSelectScene()
            case "mapIcon5":
                self.gotoSelectScene()
            case "mapIcon6":
                self.gotoSelectScene()
            case "mapIcon7":
                self.gotoSelectScene()
            case "mapIcon8":
                self.gotoSelectScene()
            case "mapIcon9":
                self.gotoSelectScene()
            case "mapIcon10":
                self.gotoSelectScene()
            case "mapIcon11":
                self.gotoSelectScene()
            case "levelup":
                self.gotoStatesScene()
            default:
                print("nomalarea")
            }
            
            
        }
        
    }
    
    func stageFlag(){
        
        //0.0なら反応しない
        MapIcon1.alpha = 1.0
        MapIcon2.alpha = 1.0
        MapIcon3.alpha = 1.0
        MapIcon4.alpha = 1.0
        MapIcon5.alpha = 1.0
        MapIcon6.alpha = 1.0
        MapIcon7.alpha = 1.0
        MapIcon8.alpha = 1.0
        MapIcon9.alpha = 1.0
        MapIcon10.alpha = 1.0
        MapIcon11.alpha = 1.0
        
        
    }
    
    func gotoSelectScene() {
        
        let Scene = SelectScene()
        Scene.size = self.size
        let transition = SKTransition.crossFade(withDuration: 0.5)
        
        self.view?.presentScene(Scene, transition: transition)
        
    }
    
    func gotoStatesScene() {
        
        let Scene = StatesScene()
        Scene.size = self.size
        let transition = SKTransition.crossFade(withDuration: 0.5)
        
        self.view?.presentScene(Scene, transition: transition)
        
    }
    
    
    
}

