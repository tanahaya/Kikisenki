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
    var phaseFlag = true //trueならMovePhase.falseならAttackPhase
    
    var ally1  = SKSpriteNode(imageNamed: "monster1a")//allyの追加
    var MoveMarker1 = SKSpriteNode(imageNamed: "movemarker1")//ally1のmovemader
    let levelLabel1 = SKLabelNode()
    var level1:Int = 0
    
    var Ally1Flag = true
    var MoveMarker1Flag = true
    
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
        
        self.start() //始める時の処理
        
    }
    
    @objc func mainTimerupdate() {
        
        //phaseの切り替えの処理。
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
        
        //移動の処理
        
        var allyposition:CGPoint = CGPoint(x: 0.0,y: 0.0)
        var movemarkerposition:CGPoint = CGPoint(x: 0.0,y: 0.0)
        
        allyposition = ally1.position
        movemarkerposition = MoveMarker1.position
        
        if allyposition == movemarkerposition {//移動系の処理
            
            MoveMarker1.alpha = 0.0
            
        } else {
            
            var relativepostion:CGPoint = CGPoint(x: 0,y: 0)
            
            relativepostion.x = MoveMarker1.position.x - ally1.position.x
            relativepostion.y = MoveMarker1.position.y - ally1.position.y
            
            let direction :CGFloat = vector2radian(vector: relativepostion)
            
            if Ally1Flag || MoveMarker1Flag {} else {
                
                if length(v: relativepostion) <= 6 {//相対位置の距離が6以下の場合、位置を同じにする。
                        
                    ally1.position = MoveMarker1.position
                    MoveMarker1.alpha = 0.0
                            
                }else{//違う場合距離にして3づつ近づく
                        
                    let travelTime = SKAction.move( to: CGPoint(x: ally1.position.x - CGFloat( 3 * cos(Double(direction))),y: ally1.position.y
                            + CGFloat( 3 * sin(Double(direction)))), duration: 0.01)
                    ally1.run(travelTime)
                            
                }
                        
                levelLabel1.position = CGPoint(x: ally1.position.x, y: ally1.position.y - 45)// 表示するポジションを指定.
                
            }
        }
    }
    
    func start(){//ゲームを開始するときに呼ばれるメソッド。
        
        phaseFlag = true
        
        Ally1Flag = false
        MoveMarker1Flag = false
        
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
            
            if self.atPoint(location).name == "Ally1"{
                Ally1Flag = true
            }
            
            if self.atPoint(location).name == "MoveMarker1"{
                MoveMarker1Flag = true
            }
            
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first as UITouch? {
            let location = touch.location(in: self)
            
            if Ally1Flag || MoveMarker1Flag {
                MoveMarker1.alpha = 1.0
                MoveMarker1.position = location
            }
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //allyの挙動を全て書いてるため、長くなっております。あとで関数化するかも。多分そうしたほうが少なく書ける。
        
        if let touch = touches.first as UITouch? {
            let location = touch.location(in: self)
            
            //ally1
            if Ally1Flag {//味方を最初に触った時。
                
                Ally1Flag = false
                
                if self.rangeofField(minX: 10, maxX: 886, minY: 10, maxY: 344, location: location) {
                    
                    MoveMarker1.position = location
                    
                } else {
                    MoveMarker1.position = ally1.position
                    MoveMarker1.alpha = 0.0
                }
                
            }
            
            if MoveMarker1Flag {
                
                MoveMarker1Flag = false
                
                if self.rangeofField(minX: 10, maxX: 886, minY: 10, maxY:344, location: location) {
                    MoveMarker1.position = location
                } else {
                    MoveMarker1.position = ally1.position
                    MoveMarker1.alpha = 0.0
                }
            }
            
        }
    }
    
    func changeHp(change:Int,side:Int) {//渡された値が正なら回復。負ならダメージを与える。hpを変動させる。sideが0なら味方,1なら敵
        print("chageHp")
    }
    
    //便利系メソッド集
    func rangeofField(minX: CGFloat,maxX: CGFloat,minY: CGFloat,maxY: CGFloat,location: CGPoint) -> Bool {//触ったポイント内にあるかどうか判定するメソッド。
        
        if location.x >= minX  && location.x <= maxX && location.y >= minY && location.y <= maxY {
            
            return true
            
        }
        
        return false
        
    }
    
    func vector2radian(vector: CGPoint) -> CGFloat {//向いている方向をくれる。
        
        let len = length(v: vector)
        let t = -vector.y / vector.x
        let c = vector.x / len
        
        if vector.x == 0 {
            return acos(c)
        } else {
            let angle = CGFloat(atan(t))
            return angle + CGFloat(0 < vector.x ? Double.pi : 0.0)
        }
        
    }
    
    func length(v: CGPoint) -> CGFloat {//相対位置の長さを測る。
        return sqrt(v.x * v.x + v.y * v.y)//長さを測る。
    }
}
