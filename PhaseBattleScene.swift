//
//  PhazeBattleScene.swift
//  Kikisenki
//
//  Created by 田中 颯 on 2019/08/13.
//  Copyright © 2019 tanahaya. All rights reserved.
//

import UIKit
import SpriteKit

class PhaseBattleScene : SKScene, SKPhysicsContactDelegate{//PhazeBattle実装用のScene
    
    
    let numberLabel = SKLabelNode()//文字を表示する。
    let phaseLabel = SKLabelNode()//文字を表示する。
    
    
    var MainTimer:Timer?
    var phasenumber:Int = 0
    var phaseFlag = true
    
    var ally1  = SKSpriteNode(imageNamed: "monster1a")//allyの追加
    var MoveMarker1 = SKSpriteNode(imageNamed: "movemarker1")//ally1のmovemader
    let levelLabel1 = SKLabelNode()
    var level1:Int = 0
    
    var LeftWall = SKSpriteNode(color: UIColor.black, size: CGSize(width: 10, height: 334))
    var RightWall = SKSpriteNode(color: UIColor.black, size: CGSize(width: 10, height: 334))
    var UpperWall = SKSpriteNode(color: UIColor.black, size: CGSize(width: 896, height: 10))
    var LowerWall = SKSpriteNode(color: UIColor.black, size: CGSize(width: 896, height: 10))
    
    //衝突判定のためのビットマスク作成
    struct PhysicsCategory {
        static let Emeny: UInt32 = 1
        static let Ball: UInt32 = 2
        static let Ally: UInt32 = 3
        static let Wall: UInt32 = 4
        static let Button: UInt32 = 5
        static let SmallBall: UInt32 = 6
        static let Heart: UInt32 = 7
    }
    
    override func didMove(to view: SKView) {
        
        //起動した時の処理
        self.size = CGSize(width: 896, height: 414)//896x414が最適。これはiphoneXRの画面サイズを横にしたもの。
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        self.physicsWorld.contactDelegate = self //didBeginCOntactに必要
        
        self.backgroundColor = UIColor.white
        
        phaseLabel.fontSize = 25// フォントサイズを設定.
        phaseLabel.fontColor = UIColor.red// 色を指定(青).
        phaseLabel.position = CGPoint(x: 448, y: 390)// 表示するポジションを指定.今回は中央
        phaseLabel.text = "MovePhase"
        self.addChild(phaseLabel)//シーンに追加
        
        numberLabel.fontSize = 25// フォントサイズを設定.
        numberLabel.fontColor = UIColor.red// 色を指定(青).
        numberLabel.position = CGPoint(x: 448, y: 364)// 表示するポジションを指定.今回は中央
        numberLabel.text = "0"
        self.addChild(numberLabel)//シーンに追加
        
        
        self.MainTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.mainTimerupdate), userInfo: nil, repeats: true)
        
        //四つの壁
        LeftWall.name = "LeftWall"
        LeftWall.physicsBody?.restitution = 1.0//反発値
        LeftWall.physicsBody?.isDynamic = false//ぶつかったときに移動するかどうか =>しない
        LeftWall.physicsBody?.categoryBitMask = PhysicsCategory.Wall //物体のカテゴリ次元をwall(4)
        LeftWall.physicsBody?.contactTestBitMask = PhysicsCategory.Ball //衝突を検知するカテゴリBall
        LeftWall.physicsBody?.collisionBitMask = PhysicsCategory.Ball //衝突させたい物体Ball
        LeftWall.position = CGPoint(x: 5,y: 177)
        LeftWall.userData = NSMutableDictionary()
        LeftWall.userData?.setValue( 0, forKey: "count")
        LeftWall.userData?.setValue( PhysicsCategory.Wall, forKey: "category")
        self.addChild(LeftWall)
        
        RightWall.name = "WallRight"
        RightWall.physicsBody?.restitution = 1.0//反発値
        RightWall.physicsBody?.isDynamic = false//ぶつかったときに移動するかどうか =>しない
        RightWall.physicsBody?.categoryBitMask = PhysicsCategory.Wall //物体のカテゴリ次元をwall(4)
        RightWall.physicsBody?.contactTestBitMask = PhysicsCategory.Ball //衝突を検知するカテゴリBall
        RightWall.physicsBody?.collisionBitMask = PhysicsCategory.Ball //衝突させたい物体Ball
        RightWall.position = CGPoint(x: 891,y: 177)
        RightWall.userData = NSMutableDictionary()
        RightWall.userData?.setValue( PhysicsCategory.Wall, forKey: "category")
        self.addChild(RightWall)
        
        UpperWall.name = "UpperWall"
        UpperWall.physicsBody?.restitution = 1.0//反発値
        UpperWall.physicsBody?.isDynamic = false//ぶつかったときに移動するかどうか =>しない
        UpperWall.physicsBody?.categoryBitMask = PhysicsCategory.Wall //物体のカテゴリ次元をwall(4)
        UpperWall.physicsBody?.contactTestBitMask = PhysicsCategory.Ball //衝突を検知するカテゴリBall
        UpperWall.physicsBody?.collisionBitMask = PhysicsCategory.Ball //衝突させたい物体Ball
        UpperWall.position = CGPoint(x: 448,y: 349)
        UpperWall.userData = NSMutableDictionary()
        UpperWall.userData?.setValue( PhysicsCategory.Wall, forKey: "category")
        self.addChild(UpperWall)
        
        LowerWall.name = "LowerWall"
        LowerWall.physicsBody?.restitution = 1.0//反発値
        LowerWall.physicsBody?.isDynamic = false//ぶつかったときに移動するかどうか =>しない
        LowerWall.physicsBody?.categoryBitMask = PhysicsCategory.Wall //物体のカテゴリ次元をwall(4)
        LowerWall.physicsBody?.contactTestBitMask = PhysicsCategory.Ball //衝突を検知するカテゴリBall
        LowerWall.physicsBody?.collisionBitMask = PhysicsCategory.Ball //衝突させたい物体Ball
        LowerWall.position = CGPoint(x: 448,y: 5)
        LowerWall.userData = NSMutableDictionary()
        LowerWall.userData?.setValue( PhysicsCategory.Wall, forKey: "category")
        self.addChild(LowerWall)
        
        
        ally1.name = "Ally1"
        ally1.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "monster1a"), size: ally1.size)
        ally1.physicsBody?.isDynamic = false
        ally1.physicsBody?.restitution = 1.0//反発値
        ally1.position = CGPoint(x: 448,y: 150)
        ally1.zPosition = 1 //movermarkerより上に来るようにz=1
        ally1.userData = NSMutableDictionary()
        ally1.userData?.setValue( PhysicsCategory.Ally, forKey: "category")
        ally1.userData?.setValue( 0, forKey: "level")//levelを追加
        ally1.physicsBody?.categoryBitMask = PhysicsCategory.Ally //物体のカテゴリ次元をally
        ally1.physicsBody?.contactTestBitMask = PhysicsCategory.Ball //衝突を検知するカテゴリBall
        ally1.physicsBody?.collisionBitMask = 0 //PhysicsCategory.Ball //衝突させたい物体＝＞なし
        ally1.xScale = 0.7
        ally1.yScale = 0.7
        self.addChild(ally1)
        
        levelLabel1.text = "level: 0"// Labelに文字列を設定.
        levelLabel1.name = "levelLabel1"
        levelLabel1.fontSize = 20// フォントサイズを設定.
        levelLabel1.fontColor = UIColor.green// 色を指定(赤).
        levelLabel1.position = CGPoint(x: ally1.position.x, y: ally1.position.y - 45)// 表示するポジションを指定.
        levelLabel1.text = "level: \(level1)"
        self.addChild(levelLabel1)//シーンに追加
        
        MoveMarker1.position = ally1.position
        MoveMarker1.alpha = 0.0
        MoveMarker1.name = "MoveMarker1"
        self.addChild(MoveMarker1)
        
    }
    
    @objc func mainTimerupdate() {
        
        phasenumber = phasenumber + 1
        numberLabel.text = "\( Float(50 - phasenumber) / 10)"
        
        if phasenumber == 50 {
            
            phasenumber = 0
            
            if phaseFlag {
                phaseLabel.text = "AttackPhase"
                phaseFlag = false
            }else {
                phaseLabel.text = "MovePhase"
                phaseFlag = true
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
            
        }
        
    }
    
}
