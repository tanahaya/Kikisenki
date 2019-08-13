//
//  PhazeBattleScene.swift
//  Kikisenki
//
//  Created by 田中 颯 on 2019/08/13.
//  Copyright © 2019 tanahaya. All rights reserved.
//

import UIKit
import SpriteKit

class PhazeBattleScene : SKScene, SKPhysicsContactDelegate{//PhazeBattle実装用のScene
    
    
    let numberLabel = SKLabelNode()//文字を表示する。
    let phazeLabel = SKLabelNode()//文字を表示する。
    
    
    var MainTimer:Timer?
    var phazenumber:Int = 0
    var phazeFlag = true
    
    override func didMove(to view: SKView) {
        
        //起動した時の処理
        self.size = CGSize(width: 414, height: 896)//414x896が最適。これはiphoneXRの画面サイズ
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        self.physicsWorld.contactDelegate = self //didBeginCOntactに必要
        
        self.backgroundColor = UIColor.white
        
        numberLabel.fontSize = 60// フォントサイズを設定.
        numberLabel.fontColor = UIColor.red// 色を指定(青).
        numberLabel.position = CGPoint(x: 207, y: 548)// 表示するポジションを指定.今回は中央
        numberLabel.text = "0"
        self.addChild(numberLabel)//シーンに追加
        
        phazeLabel.fontSize = 60// フォントサイズを設定.
        phazeLabel.fontColor = UIColor.red// 色を指定(青).
        phazeLabel.position = CGPoint(x: 207, y: 348)// 表示するポジションを指定.今回は中央
        phazeLabel.text = "MovePhaze"
        self.addChild(phazeLabel)//シーンに追加
        
        self.MainTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.mainTimerupdate), userInfo: nil, repeats: true)
        
    }
    
    @objc func mainTimerupdate() {
        
        phazenumber = phazenumber + 1
        numberLabel.text = "\( Float(50 - phazenumber) / 10)"
        
        if phazenumber == 50 {
            
            phazenumber = 0
            
            if phazeFlag {
                phazeLabel.text = "AttackPhaze"
                phazeFlag = false
            }else {
                phazeLabel.text = "MovePhaze"
                phazeFlag = true
            }
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first as UITouch? {
            let location = touch.location(in: self)
            
            if self.atPoint(location).name == "" {
                let Scene = HomeScene()
                Scene.size = self.size
                let transition = SKTransition.crossFade(withDuration: 1.0)
                
                self.view?.presentScene(Scene, transition: transition)
            }
            
        }//今のところ使わないけど一応用意
        
    }
    
}
