//
//  StartScene.swift
//  Kikisenki
//
//  Created by 田中 颯 on 2019/07/30.
//  Copyright © 2019 tanahaya. All rights reserved.
//

import UIKit
import SpriteKit

class StartScene : SKScene, SKPhysicsContactDelegate{
    
    let StartLabel = SKLabelNode()//文字を表示する。
    
    var BackgroundImage = SKSpriteNode(imageNamed: "logo")
    
    override func didMove(to view: SKView) {
        
        //起動した時の処理
        self.size = CGSize(width: 896, height: 414)//414x896が最適。これはiphoneXRの画面サイズ
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        self.physicsWorld.contactDelegate = self //didBeginCOntactに必要
        
        BackgroundImage.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "logo.png"), size: BackgroundImage.size)
        BackgroundImage.name = "BackgroundImage"
        BackgroundImage.position = CGPoint(x: 448,y: 207)
        BackgroundImage.physicsBody?.categoryBitMask = 0
        BackgroundImage.physicsBody?.contactTestBitMask = 0
        BackgroundImage.physicsBody?.collisionBitMask = 0
        self.addChild(BackgroundImage)
        
        StartLabel.fontSize = 60// フォントサイズを設定.
        StartLabel.fontColor = UIColor.black// 色を指定(青).
        StartLabel.position = CGPoint(x: 448, y: 70)// 表示するポジションを指定.今回は中央
        StartLabel.text = "Tap to Start"
        self.addChild(StartLabel)//シーンに追加
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let Scene = HomeScene()
        Scene.size = self.size
        let transition = SKTransition.crossFade(withDuration: 1.0)
        
        self.view?.presentScene(Scene, transition: transition)
        
    }
    
}
