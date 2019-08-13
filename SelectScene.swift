//
//  SelectScene.swift
//  Kikisenki
//
//  Created by 田中 颯 on 2019/08/06.
//  Copyright © 2019 tanahaya. All rights reserved.
//

import UIKit
import SpriteKit

class SelectScene : SKScene, SKPhysicsContactDelegate {
    
    
    var BackButton = SKSpriteNode(imageNamed: "BackButton")
    
    var Background = SKSpriteNode(imageNamed: "chapter0")
    
    var arrowtoPhaze = SKSpriteNode(imageNamed: "EnegyBattle")
    var arrowtoEnegy = SKSpriteNode(imageNamed: "PhazeBattle")
    var arrowtoSample = SKSpriteNode(imageNamed: "SampleStory")
    
    
    override func didMove(to view: SKView) {
        
        //起動した時の処理
        self.size = CGSize(width: 414, height: 896)//414x896が最適。これはiphoneXRの画面サイズ
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        self.physicsWorld.contactDelegate = self //didBeginCOntactに必要
       
        
        
        Background.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "chapter0"), size: Background.size)
        Background.name = "Background"
        Background.position = CGPoint(x: 207,y: 448)
        Background.physicsBody?.categoryBitMask = 0
        Background.physicsBody?.contactTestBitMask = 0
        Background.physicsBody?.collisionBitMask = 0
        self.addChild(Background)
        
        
        arrowtoPhaze.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "PhazeBattle"), size: arrowtoPhaze.size)
        arrowtoPhaze.name = "arrowtoPhaze"
        arrowtoPhaze.position = CGPoint(x: 207,y: 598)
        arrowtoPhaze.physicsBody?.categoryBitMask = 0
        arrowtoPhaze.physicsBody?.contactTestBitMask = 0
        arrowtoPhaze.physicsBody?.collisionBitMask = 0
        let rotateaction1 = SKAction.rotate(toAngle: CGFloat(Double.pi / 18), duration: 0.01)
        arrowtoPhaze.run(rotateaction1)
        self.addChild(arrowtoPhaze)
        
        
        arrowtoEnegy.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "EnegyBattle"), size: arrowtoEnegy.size)
        arrowtoEnegy.name = "arrowtoEnegy"
        arrowtoEnegy.position = CGPoint(x: 207,y: 448)
        arrowtoEnegy.physicsBody?.categoryBitMask = 0
        arrowtoEnegy.physicsBody?.contactTestBitMask = 0
        arrowtoEnegy.physicsBody?.collisionBitMask = 0
        let rotateaction2 = SKAction.rotate(toAngle: -CGFloat(Double.pi / 18), duration: 0.01)
        arrowtoEnegy.run(rotateaction2)
        self.addChild(arrowtoEnegy)
        
        
        arrowtoSample.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "SampleStory"), size: arrowtoSample.size)
        arrowtoSample.name = "arrowtoSample"
        arrowtoSample.position = CGPoint(x: 207,y: 298)
        arrowtoSample.physicsBody?.categoryBitMask = 0
        arrowtoSample.physicsBody?.contactTestBitMask = 0
        arrowtoSample.physicsBody?.collisionBitMask = 0
        let rotateaction3 = SKAction.rotate(toAngle: CGFloat(Double.pi / 18), duration: 0.01)
        arrowtoSample.run(rotateaction3)
        self.addChild(arrowtoSample)
        
        
        BackButton.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "BackButton.png"), size: BackButton.size)
        BackButton.name = "BackButton"
        BackButton.position = CGPoint(x: 80,y: 80)
        BackButton.physicsBody?.categoryBitMask = 0
        BackButton.physicsBody?.contactTestBitMask = 0
        BackButton.physicsBody?.collisionBitMask = 0
        self.addChild(BackButton)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first as UITouch? {
            
            let location = touch.location(in: self)
            
            if self.atPoint(location).name == "arrowtoPhaze" {
                self.gotoGameScene()
            }
            
            if self.atPoint(location).name == "arrowtoEnegy" {
                self.gotoPhazeBattleScene()
            }
            
            if self.atPoint(location).name == "arrowtoSample" {
                self.gotoConversationScene()
            }
            
            if self.atPoint(location).name == "BackButton" {
                self.gotoHomeScene()
            }
            
        }
        
    }
    
    func gotoHomeScene() {
        
        let Scene = HomeScene()
        Scene.size = self.size
        let transition = SKTransition.crossFade(withDuration: 1.0)
        
        self.view?.presentScene(Scene, transition: transition)
        
    }
    
    func gotoGameScene() {
        
        let Scene = GameScene()
        Scene.size = self.size
        let transition = SKTransition.crossFade(withDuration: 0.5)
        
        self.view?.presentScene(Scene, transition: transition)
        
    }
    
    func gotoPhazeBattleScene() {
        
        let Scene = PhazeBattleScene()
        Scene.size = self.size
        let transition = SKTransition.crossFade(withDuration: 0.5)
        
        self.view?.presentScene(Scene, transition: transition)
        
    }
    
    func gotoConversationScene() {
        
        let Scene = ConversationScene()
        Scene.size = self.size
        let transition = SKTransition.crossFade(withDuration: 1.0)
        
        self.view?.presentScene(Scene, transition: transition)
        
    }
    
    
}
