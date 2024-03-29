//
//  StatesScene.swift
//  Kikisenki
//
//  Created by 田中 颯 on 2019/08/15.
//  Copyright © 2019 tanahaya. All rights reserved.
//

import UIKit
import SpriteKit

class StatesScene : SKScene, SKPhysicsContactDelegate{
    
    let StartLabel = SKLabelNode()//文字を表示する。
    
    override func didMove(to view: SKView) {
        
        //起動した時の処理
        self.size = CGSize(width: 414, height: 896)//414x896が最適。これはiphoneXRの画面サイズ
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        self.physicsWorld.contactDelegate = self //didBeginCOntactに必要
        
        self.backgroundColor = UIColor.white
        
        StartLabel.fontSize = 60// フォントサイズを設定.
        StartLabel.fontColor = UIColor.red// 色を指定(青).
        StartLabel.position = CGPoint(x: 207, y: 448)// 表示するポジションを指定.今回は中央
        StartLabel.text = "StatesScene"
        self.addChild(StartLabel)//シーンに追加
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //        if let touch = touches.first as UITouch? {
        //
        //            let location = touch.location(in: self)
        //        }//今のところ使わないけど一応用意
        
        let Scene = HomeScene()
        Scene.size = self.size
        let transition = SKTransition.crossFade(withDuration: 1.0)
        
        self.view?.presentScene(Scene, transition: transition)
        
    }
    
}
