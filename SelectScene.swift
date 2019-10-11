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
    
    var Background = SKSpriteNode(imageNamed: "selectbackground")
    
    let userDefaults = UserDefaults.standard//管理用のuserdefaults
    
    var world:Int = 0
    
    override func didMove(to view: SKView) {
        
        //起動した時の処理
        self.size = CGSize(width: 896, height: 414)//414x896が最適。これはiphoneXRの画面サイズ
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        self.physicsWorld.contactDelegate = self //didBeginCOntactに必要
        
        world = userDefaults.integer(forKey: "world")
        
        Background.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "selectbackground"), size: Background.size)
        Background.name = "Background"
        Background.position = CGPoint(x: 448,y: 207)
        Background.physicsBody?.categoryBitMask = 0
        Background.physicsBody?.collisionBitMask = 0
        Background.physicsBody?.contactTestBitMask = 0
        self.addChild(Background)
        
        BackButton.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "BackButton.png"), size: BackButton.size)
        BackButton.name = "BackButton"
        BackButton.physicsBody?.categoryBitMask = 0
        BackButton.physicsBody?.collisionBitMask = 0
        BackButton.physicsBody?.contactTestBitMask = 0
        BackButton.position = CGPoint(x: 816,y: 80)
        self.addChild(BackButton)
        
        if world == 1 {
            
            Background.texture = SKTexture(imageNamed: "selectview1.png")
            
            let storyarrow1 = SKSpriteNode(imageNamed: "storyarrow1-1")
            
            storyarrow1.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "storyarrow1-1"), size: storyarrow1.size)
            storyarrow1.name = "storyarrow1"
            storyarrow1.position = CGPoint(x: 207,y: 230)
            storyarrow1.physicsBody?.categoryBitMask = 0
            storyarrow1.physicsBody?.collisionBitMask = 0
            storyarrow1.physicsBody?.contactTestBitMask = 0
            let rotateaction1 = SKAction.rotate(toAngle: -CGFloat(Double.pi / 36), duration: 0.01)
            storyarrow1.run(rotateaction1)
            self.addChild(storyarrow1)
            
            let storyarrow2 = SKSpriteNode(imageNamed: "storyarrow1-2")
            
            storyarrow2.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "storyarrow1-2"), size: storyarrow2.size)
            storyarrow2.name = "storyarrow2"
            storyarrow2.position = CGPoint(x: 207,y: 130)
            storyarrow2.physicsBody?.categoryBitMask = 0
            storyarrow2.physicsBody?.collisionBitMask = 0
            storyarrow2.physicsBody?.contactTestBitMask = 0
            let rotateaction2 = SKAction.rotate(toAngle: CGFloat(Double.pi / 36), duration: 0.01)
            storyarrow2.run(rotateaction2)
            self.addChild(storyarrow2)
            
            let battlearrow1 = SKSpriteNode(imageNamed: "battlearrow1-1")
            
            battlearrow1.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "battlearrow1-1"), size: battlearrow1.size)
            battlearrow1.name = "battlearrow1"
            battlearrow1.position = CGPoint(x: 657,y: 230)
            battlearrow1.physicsBody?.categoryBitMask = 0
            battlearrow1.physicsBody?.collisionBitMask = 0
            battlearrow1.physicsBody?.contactTestBitMask = 0
            let rotateaction3 = SKAction.rotate(toAngle: CGFloat(Double.pi / 36), duration: 0.01)
            battlearrow1.run(rotateaction3)
            self.addChild(battlearrow1)
            
            let battlearrow2 = SKSpriteNode(imageNamed: "battlearrow1-2")
            
            battlearrow2.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "battlearrow1-2"), size: battlearrow2.size)
            battlearrow2.name = "battlearrow2"
            battlearrow2.position = CGPoint(x: 657,y: 130)
            battlearrow2.physicsBody?.categoryBitMask = 0
            battlearrow2.physicsBody?.collisionBitMask = 0
            battlearrow2.physicsBody?.contactTestBitMask = 0
            let rotateaction4 = SKAction.rotate(toAngle: -CGFloat(Double.pi / 36), duration: 0.01)
            battlearrow2.run(rotateaction4)
            self.addChild(battlearrow2)
            
            
        } else if world == 2 {
            
            Background.texture = SKTexture(imageNamed: "selectview2.png")
            
            let battlearrow1 = SKSpriteNode(imageNamed: "battlearrow1-1")
            
            battlearrow1.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "battlearrow1-1"), size: battlearrow1.size)
            battlearrow1.name = "battlearrow1"
            battlearrow1.position = CGPoint(x: 657,y: 230)
            battlearrow1.physicsBody?.categoryBitMask = 0
            battlearrow1.physicsBody?.collisionBitMask = 0
            battlearrow1.physicsBody?.contactTestBitMask = 0
            let rotateaction3 = SKAction.rotate(toAngle: CGFloat(Double.pi / 36), duration: 0.01)
            battlearrow1.run(rotateaction3)
            self.addChild(battlearrow1)
            
            let battlearrow2 = SKSpriteNode(imageNamed: "battlearrow1-2")
            
            battlearrow2.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "battlearrow1-2"), size: battlearrow2.size)
            battlearrow2.name = "battlearrow2"
            battlearrow2.position = CGPoint(x: 657,y: 130)
            battlearrow2.physicsBody?.categoryBitMask = 0
            battlearrow2.physicsBody?.collisionBitMask = 0
            battlearrow2.physicsBody?.contactTestBitMask = 0
            let rotateaction4 = SKAction.rotate(toAngle: -CGFloat(Double.pi / 36), duration: 0.01)
            battlearrow2.run(rotateaction4)
            self.addChild(battlearrow2)
            
            
            
        } else if world == 3 {
            
            Background.texture = SKTexture(imageNamed: "selectview3.png")
            
            let battlearrow1 = SKSpriteNode(imageNamed: "battlearrow1-1")
            
            battlearrow1.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "battlearrow1-1"), size: battlearrow1.size)
            battlearrow1.name = "battlearrow1"
            battlearrow1.position = CGPoint(x: 657,y: 230)
            battlearrow1.physicsBody?.categoryBitMask = 0
            battlearrow1.physicsBody?.collisionBitMask = 0
            battlearrow1.physicsBody?.contactTestBitMask = 0
            let rotateaction3 = SKAction.rotate(toAngle: CGFloat(Double.pi / 36), duration: 0.01)
            battlearrow1.run(rotateaction3)
            self.addChild(battlearrow1)
            
            let battlearrow2 = SKSpriteNode(imageNamed: "battlearrow1-2")
            
            battlearrow2.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "battlearrow1-2"), size: battlearrow2.size)
            battlearrow2.name = "battlearrow2"
            battlearrow2.position = CGPoint(x: 657,y: 130)
            battlearrow2.physicsBody?.categoryBitMask = 0
            battlearrow2.physicsBody?.collisionBitMask = 0
            battlearrow2.physicsBody?.contactTestBitMask = 0
            let rotateaction4 = SKAction.rotate(toAngle: -CGFloat(Double.pi / 36), duration: 0.01)
            battlearrow2.run(rotateaction4)
            self.addChild(battlearrow2)
            
            
        } else if world == 4 {
            
            Background.texture = SKTexture(imageNamed: "selectview4.png")
            
            let battlearrow1 = SKSpriteNode(imageNamed: "battlearrow1-1")
            
            battlearrow1.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "battlearrow1-1"), size: battlearrow1.size)
            battlearrow1.name = "battlearrow1"
            battlearrow1.position = CGPoint(x: 657,y: 230)
            battlearrow1.physicsBody?.categoryBitMask = 0
            battlearrow1.physicsBody?.collisionBitMask = 0
            battlearrow1.physicsBody?.contactTestBitMask = 0
            let rotateaction3 = SKAction.rotate(toAngle: CGFloat(Double.pi / 36), duration: 0.01)
            battlearrow1.run(rotateaction3)
            self.addChild(battlearrow1)
            
            let battlearrow2 = SKSpriteNode(imageNamed: "battlearrow1-2")
            
            battlearrow2.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "battlearrow1-2"), size: battlearrow2.size)
            battlearrow2.name = "battlearrow2"
            battlearrow2.position = CGPoint(x: 657,y: 130)
            battlearrow2.physicsBody?.categoryBitMask = 0
            battlearrow2.physicsBody?.collisionBitMask = 0
            battlearrow2.physicsBody?.contactTestBitMask = 0
            let rotateaction4 = SKAction.rotate(toAngle: -CGFloat(Double.pi / 36), duration: 0.01)
            battlearrow2.run(rotateaction4)
            self.addChild(battlearrow2)
            
            
        } else {
            
            let arrowtoPhaze = SKSpriteNode(imageNamed: "PhazeBattle")
            
            arrowtoPhaze.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "PhazeBattle"), size: arrowtoPhaze.size)
            arrowtoPhaze.name = "arrowtoPhaze"
            arrowtoPhaze.position = CGPoint(x: 207,y: 170)
            arrowtoPhaze.physicsBody?.categoryBitMask = 0
            arrowtoPhaze.physicsBody?.collisionBitMask = 0
            arrowtoPhaze.physicsBody?.contactTestBitMask = 0
            let rotateaction1 = SKAction.rotate(toAngle: CGFloat(Double.pi / 36), duration: 0.01)
            arrowtoPhaze.run(rotateaction1)
            self.addChild(arrowtoPhaze)
            
            let arrowtoEnegy = SKSpriteNode(imageNamed: "EnegyBattle")
            
            arrowtoEnegy.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "EnegyBattle"), size: arrowtoEnegy.size)
            arrowtoEnegy.name = "arrowtoEnegy"
            arrowtoEnegy.position = CGPoint(x: 207,y: 60)
            arrowtoEnegy.physicsBody?.categoryBitMask = 0
            arrowtoEnegy.physicsBody?.collisionBitMask = 0
            arrowtoEnegy.physicsBody?.contactTestBitMask = 0
            let rotateaction2 = SKAction.rotate(toAngle: -CGFloat(Double.pi / 36), duration: 0.01)
            arrowtoEnegy.run(rotateaction2)
            self.addChild(arrowtoEnegy)
            
            let arrowtoSample = SKSpriteNode(imageNamed: "SampleStory")
            
            arrowtoSample.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "SampleStory"), size: arrowtoSample.size)
            arrowtoSample.name = "arrowtoSample"
            arrowtoSample.position = CGPoint(x: 207,y: 250)
            arrowtoSample.physicsBody?.categoryBitMask = 0
            arrowtoSample.physicsBody?.collisionBitMask = 0
            arrowtoSample.physicsBody?.contactTestBitMask = 0
            let rotateaction3 = SKAction.rotate(toAngle: CGFloat(Double.pi / 18), duration: 0.01)
            arrowtoSample.run(rotateaction3)
            self.addChild(arrowtoSample)
            
        }
        
        if world == 2 {
            
        } else if world == 3 {
            
        } else if world == 4 {
            
        } else if world == 5 {
            
        } else if world == 6 {
            
        } else if world == 7 {
            
        } else if world == 8 {
            
        } else if world == 9 {
            
        } else if world == 10 {
            
        } else if world == 11 {
            
        } else if world == 12 {
            
        }
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first as UITouch? {
            
            let location = touch.location(in: self)
            
            if world == 1 {
                
                if self.atPoint(location).name == "storyarrow1" {
                    userDefaults.set(1, forKey: "story")
                    self.gotoConversationScene()
                }
                
                if self.atPoint(location).name == "storyarrow2" {
                    userDefaults.set(2, forKey: "story")
                    self.gotoConversationScene()
                }
                
                if self.atPoint(location).name == "battlearrow1" {
                    userDefaults.set(1, forKey: "stage")
                    self.gotoPhazeBattleScene()
                }
                
                if self.atPoint(location).name == "battlearrow2" {
                    userDefaults.set(2, forKey: "stage")
                    self.gotoPhazeBattleScene()
                }
                
            } else if world == 2 {
                
                if self.atPoint(location).name == "battlearrow1" {
                    userDefaults.set(1, forKey: "stage")
                    self.gotoPhazeBattleScene()
                }
                
                if self.atPoint(location).name == "battlearrow2" {
                    userDefaults.set(2, forKey: "stage")
                    self.gotoPhazeBattleScene()
                }
                
            } else if world == 3 {
                
                if self.atPoint(location).name == "battlearrow1" {
                    userDefaults.set(1, forKey: "stage")
                    self.gotoPhazeBattleScene()
                }
                
                if self.atPoint(location).name == "battlearrow2" {
                    userDefaults.set(2, forKey: "stage")
                    self.gotoPhazeBattleScene()
                }
                
            } else if world == 4 {
                
                if self.atPoint(location).name == "battlearrow1" {
                    userDefaults.set(1, forKey: "stage")
                    self.gotoPhazeBattleScene()
                }
                
                if self.atPoint(location).name == "battlearrow2" {
                    userDefaults.set(2, forKey: "stage")
                    self.gotoPhazeBattleScene()
                }
                
            } else if world == 5 {
                
            } else if world == 6 {
                
            } else if world == 7 {
                
            } else if world == 8 {
                
            } else if world == 9 {
                
            } else if world == 10 {
                
            } else if world == 11 {
                
            } else if world == 12 {
                
            }
            
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
        
        let Scene = PhaseBattleScene()
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
