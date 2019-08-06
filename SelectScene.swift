//
//  SelectScene.swift
//  Kikisenki
//
//  Created by 田中 颯 on 2019/08/06.
//  Copyright © 2019 tanahaya. All rights reserved.
//

import Foundation
import SpriteKit

class SelectScene : SKScene, SKPhysicsContactDelegate{
    
    
    let Label = SKLabelNode()//文字を表示する。
    var WhiteBack = SKSpriteNode(color: SKColor.white, size: CGSize(width: 200, height: 50))
    
    
    var BackButton = SKSpriteNode(imageNamed: "BackButton")
    
    override func didMove(to view: SKView) {
        
        //起動した時の処理
        self.size = CGSize(width: 414, height: 896)//414x896が最適。これはiphoneXRの画面サイズ
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        self.physicsWorld.contactDelegate = self //didBeginCOntactに必要
        
        self.backgroundColor = UIColor.black
        
        WhiteBack.position = CGPoint(x: 207, y: 463)
        WhiteBack.name = "WhiteBack"
        self.addChild(WhiteBack)
        
        Label.fontSize = 40// フォントサイズを設定.
        Label.fontColor = UIColor.black// 色を指定(青).
        Label.position = CGPoint(x: 207, y: 448)// 表示するポジションを指定.今回は中央
        Label.text = "Tap to Start"
        Label.name = "Label"
        self.addChild(Label)//シーンに追加
        
        
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
            
            if self.atPoint(location).name == "Label" {
                self.gotoGameScene()
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
    
    
}
