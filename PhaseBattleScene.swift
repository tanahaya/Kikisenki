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
    
    var Background = SKSpriteNode(color: UIColor.white, size: CGSize(width:  876.0, height: 334.0))//skill1の四角
    
    //ally1ここから
    var ally1  = SKSpriteNode(imageNamed: "monster1a")//allyの追加
    var MoveMarker1 = SKSpriteNode(imageNamed: "movemarker1")//ally1のmovemader
    var ally1GradeIcon = SKSpriteNode(imageNamed: "gradeicon")
    let ally1GradeLabel1 = SKLabelNode()
    var ally1Grade1:Int = 0
    
    var ally1HpBar = SKSpriteNode(color: UIColor.green, size: CGSize(width: 40.0, height: 10.0))//味方のhpの量を表示
    var ally1HpBarBack = SKSpriteNode(color: UIColor.black, size: CGSize(width: 45.0, height: 14.0))//味方のhpの量を表示
    var ally1Hp:Int = 1000
    var ally1MaxHp:Int = 1000//味方の最大のHp
    
    var ally1Skill1 = SKSpriteNode(color: UIColor.green, size: CGSize(width: 50.0, height: 50.0))//skill1の四角
    var ally1Skill2 = SKSpriteNode(color: UIColor.green, size: CGSize(width: 50.0, height: 50.0))//skill2の四角
    var ally1Skill3 = SKSpriteNode(color: UIColor.green, size: CGSize(width: 50.0, height: 50.0))//skill3の四角
    var ally1Skill4 = SKSpriteNode(color: UIColor.green, size: CGSize(width: 50.0, height: 50.0))//skill4の四角
    var ally1SkilledFlag = true //スキルを使ったかどうかを判定するflag
    
    var Ally1Flag = true
    var MoveMarker1Flag = true
    //ally1ここまで
    
    //enemy1ここから
    var Enemy1 = SKSpriteNode(imageNamed: "syatihoko")
    
    var Enemy1GradeIcon = SKSpriteNode(imageNamed: "gradeicon")
    let Enemy1GradeLabel1 = SKLabelNode()
    var Enemy1Grade1:Int = 0
    
    var Enemy1HpBar = SKSpriteNode(color: UIColor.green, size: CGSize(width: 40.0, height: 10.0))//敵1のhpの量を表示
    var Enemy1HpBarBack = SKSpriteNode(color: UIColor.black, size: CGSize(width: 45.0, height: 14.0))//味方のhpの量を表示
    var Enemy1Hp:Int = 1000
    var Enemy1MaxHp:Int = 1000//敵1の最大のHp
    //enemy1ここまで
    
    var LeftWall = SKSpriteNode(color: UIColor.black, size: CGSize(width: 10, height: 334))
    var RightWall = SKSpriteNode(color: UIColor.black, size: CGSize(width: 10, height: 334))
    var UpperWall = SKSpriteNode(color: UIColor.black, size: CGSize(width: 896, height: 10))
    var LowerWall = SKSpriteNode(color: UIColor.black, size: CGSize(width: 896, height: 10))
    
    var HeartCount:Int = 1
    //衝突判定のためのビットマスク作成
    struct PhysicsCategory {
        static let Enemy: UInt32 = 1
        static let Ally: UInt32 = 2
        static let Bullet: UInt32 = 3
        static let Wall: UInt32 = 4
        static let Heart: UInt32 = 5
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
        LeftWall.physicsBody?.contactTestBitMask = PhysicsCategory.Bullet //衝突を検知するカテゴリBall
        LeftWall.physicsBody?.collisionBitMask = PhysicsCategory.Bullet //衝突させたい物体Ball
        LeftWall.position = CGPoint(x: 5,y: 177)
        LeftWall.userData = NSMutableDictionary()
        LeftWall.userData?.setValue( PhysicsCategory.Wall, forKey: "category")
        self.addChild(LeftWall)
        
        RightWall.name = "WallRight"
        RightWall.physicsBody?.restitution = 1.0//反発値
        RightWall.physicsBody?.isDynamic = false//ぶつかったときに移動するかどうか =>しない
        RightWall.physicsBody?.categoryBitMask = PhysicsCategory.Wall //物体のカテゴリ次元をwall(4)
        RightWall.physicsBody?.contactTestBitMask = PhysicsCategory.Bullet //衝突を検知するカテゴリBall
        RightWall.physicsBody?.collisionBitMask = PhysicsCategory.Bullet //衝突させたい物体Ball
        RightWall.position = CGPoint(x: 891,y: 177)
        RightWall.userData = NSMutableDictionary()
        RightWall.userData?.setValue( PhysicsCategory.Wall, forKey: "category")
        self.addChild(RightWall)
        
        UpperWall.name = "UpperWall"
        UpperWall.physicsBody?.restitution = 1.0//反発値
        UpperWall.physicsBody?.isDynamic = false//ぶつかったときに移動するかどうか =>しない
        UpperWall.physicsBody?.categoryBitMask = PhysicsCategory.Wall //物体のカテゴリ次元をwall(4)
        UpperWall.physicsBody?.contactTestBitMask = PhysicsCategory.Bullet //衝突を検知するカテゴリBall
        UpperWall.physicsBody?.collisionBitMask = PhysicsCategory.Bullet //衝突させたい物体Ball
        UpperWall.position = CGPoint(x: 448,y: 349)
        UpperWall.userData = NSMutableDictionary()
        UpperWall.userData?.setValue( PhysicsCategory.Wall, forKey: "category")
        self.addChild(UpperWall)
        
        LowerWall.name = "LowerWall"
        LowerWall.physicsBody?.restitution = 1.0//反発値
        LowerWall.physicsBody?.isDynamic = false//ぶつかったときに移動するかどうか =>しない
        LowerWall.physicsBody?.categoryBitMask = PhysicsCategory.Wall //物体のカテゴリ次元をwall(4)
        LowerWall.physicsBody?.contactTestBitMask = PhysicsCategory.Bullet //衝突を検知するカテゴリBall
        LowerWall.physicsBody?.collisionBitMask = PhysicsCategory.Bullet //衝突させたい物体Ball
        LowerWall.position = CGPoint(x: 448,y: 5)
        LowerWall.userData = NSMutableDictionary()
        LowerWall.userData?.setValue( PhysicsCategory.Wall, forKey: "category")
        self.addChild(LowerWall)
        
        Background.anchorPoint = CGPoint(x: 0,y: 0)//ノードの位置配置などの起点を設定。
        Background.position = CGPoint(x: 10,y: 10)
        Background.name = "Background"
        self.addChild(Background)
        
        //ally1の処理
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
        ally1.physicsBody?.contactTestBitMask = PhysicsCategory.Bullet //衝突を検知するカテゴリBall
        ally1.physicsBody?.collisionBitMask = 0 //PhysicsCategory.Ball //衝突させたい物体＝＞なし
        ally1.xScale = 0.7
        ally1.yScale = 0.7
        self.addChild(ally1)
        
        ally1HpBarBack.anchorPoint = CGPoint(x: 0, y: 0)
        ally1HpBarBack.position = CGPoint(x: ally1.position.x - 18,y:ally1.position.y - 37)
        self.addChild(ally1HpBarBack)
        
        ally1HpBar.anchorPoint = CGPoint(x: 0, y: 0)
        ally1HpBar.position = CGPoint(x: ally1.position.x - 18,y:ally1.position.y - 35)
        ally1HpBar.xScale = CGFloat(Double(ally1Hp) / Double(ally1MaxHp))//x方向の倍率
        self.addChild(ally1HpBar)
        
        ally1GradeIcon.name = "ally1Gradeicon"
        ally1GradeIcon.position = CGPoint(x: ally1.position.x - 28, y: ally1.position.y - 30)
        ally1GradeIcon.userData = NSMutableDictionary()
        ally1GradeIcon.userData?.setValue( PhysicsCategory.Ally, forKey: "category")
        ally1GradeIcon.userData?.setValue( 0, forKey: "level")//levelを追加
        ally1GradeIcon.xScale = 0.3
        ally1GradeIcon.yScale = 0.3
        self.addChild(ally1GradeIcon)
        
        ally1GradeLabel1.text = "0"// Labelに文字列を設定.
        ally1GradeLabel1.name = "ally1GradeLabel1"
        ally1GradeLabel1.fontSize = 20// フォントサイズを設定.
        ally1GradeLabel1.fontColor = UIColor.black// 色を指定(赤).
        ally1GradeLabel1.position = CGPoint(x: ally1.position.x - 28, y: ally1.position.y - 37)// 表示するポジションを指定.
        ally1GradeLabel1.text = " \(ally1Grade1)"
        self.addChild(ally1GradeLabel1)
        
        MoveMarker1.position = ally1.position
        MoveMarker1.alpha = 0.0
        MoveMarker1.name = "MoveMarker1"
        self.addChild(MoveMarker1)
        
        ally1Skill1.anchorPoint = CGPoint(x: 0, y: 0)
        ally1Skill1.position = CGPoint(x: ally1.position.x + 50, y: ally1.position.y + 50)//右上
        ally1Skill1.name = "Skill1"
        ally1Skill1.alpha = 0.0
        self.addChild(ally1Skill1)
        
        ally1Skill2.anchorPoint = CGPoint(x: 0, y: 0)
        ally1Skill2.position = CGPoint(x: ally1.position.x + 50, y: ally1.position.y - 50)//右下
        ally1Skill2.name = "Skill2"
        ally1Skill2.alpha = 0.0
        self.addChild(ally1Skill2)
        
        ally1Skill3.anchorPoint = CGPoint(x: 0, y: 0)
        ally1Skill3.position = CGPoint(x: ally1.position.x - 50, y: ally1.position.y + 50)//左上
        ally1Skill3.name = "Skill3"
        ally1Skill3.alpha = 0.0
        self.addChild(ally1Skill3)
        
        ally1Skill4.anchorPoint = CGPoint(x: 0, y: 0)
        ally1Skill4.position = CGPoint(x: ally1.position.x - 50, y: ally1.position.y - 50)//左下
        ally1Skill4.name = "Skill4"
        ally1Skill4.alpha = 0.0
        self.addChild(ally1Skill4)
        
        //enemy1の処理
        Enemy1.name = "Enemy1"
        Enemy1.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "syatihoko"), size: Enemy1.size)
        Enemy1.physicsBody?.isDynamic = false
        Enemy1.physicsBody?.restitution = 1.0//反発値
        Enemy1.position = CGPoint(x: 600,y: 200)
        Enemy1.userData = NSMutableDictionary()
        Enemy1.userData?.setValue( PhysicsCategory.Enemy, forKey: "category")
        Enemy1.physicsBody?.categoryBitMask = PhysicsCategory.Enemy //衝突判定に使用する値の設定
        Enemy1.physicsBody?.contactTestBitMask = PhysicsCategory.Bullet
        Enemy1.physicsBody?.collisionBitMask = PhysicsCategory.Enemy //衝突させたい物体Enemy
        Enemy1.xScale = 0.6
        Enemy1.yScale = 0.6
        self.addChild(Enemy1)
        
        Enemy1HpBarBack.anchorPoint = CGPoint(x: 0, y: 0)
        Enemy1HpBarBack.position = CGPoint(x: Enemy1.position.x - 18,y:Enemy1.position.y - 77)
        self.addChild(Enemy1HpBarBack)
        
        Enemy1HpBar.anchorPoint = CGPoint(x: 0, y: 0)
        Enemy1HpBar.position = CGPoint(x: Enemy1.position.x - 20,y: Enemy1.position.y - 75)
        Enemy1HpBar.zPosition = 1
        Enemy1HpBar.xScale = CGFloat( Double(Enemy1Hp) / Double(Enemy1MaxHp) )//x方向の倍率
        self.addChild(Enemy1HpBar)
        
        Enemy1GradeIcon.name = "Enemy1Gradeicon"
        Enemy1GradeIcon.position = CGPoint(x: Enemy1.position.x - 28, y: Enemy1.position.y - 70)
        Enemy1GradeIcon.userData = NSMutableDictionary()
        Enemy1GradeIcon.userData?.setValue( PhysicsCategory.Ally, forKey: "category")
        Enemy1GradeIcon.userData?.setValue( 0, forKey: "level")//levelを追加
        Enemy1GradeIcon.xScale = 0.3
        Enemy1GradeIcon.yScale = 0.3
        self.addChild(Enemy1GradeIcon)
        
        Enemy1GradeLabel1.text = "0"// Labelに文字列を設定.
        Enemy1GradeLabel1.name = "Enemy1GradeLabel1"
        Enemy1GradeLabel1.fontSize = 20// フォントサイズを設定.
        Enemy1GradeLabel1.fontColor = UIColor.black// 色を指定(赤).
        Enemy1GradeLabel1.position = CGPoint(x: Enemy1.position.x - 28, y: Enemy1.position.y - 77)// 表示するポジションを指定.
        Enemy1GradeLabel1.text = " \(ally1Grade1)"
        self.addChild(Enemy1GradeLabel1)
        
        self.start() //始める時の処理
        
    }
    
    @objc func mainTimerupdate() {
        
        //phaseの切り替えの処理。
        phasenumber = phasenumber + 1
        numberLabel.text = "\( Float(50 - phasenumber) / 10)"
        
        if phasenumber == 50 {
            
            phasenumber = 0
            
            if phaseFlag { //Attackphaseに切り替わる時。
                
                phaseFlag = false
                phaseLabel.text = "AttackPhase"
                
                MoveMarker1.position = ally1.position
                MoveMarker1.alpha = 0.0
                
                ally1SkilledFlag = true
                
            }else { //Movephaseに切り替わる時。
                
                phaseFlag = true
                phaseLabel.text = "MovePhase"
                
                ally1Skill1.alpha = 0.0
                ally1Skill2.alpha = 0.0
                ally1Skill3.alpha = 0.0
                ally1Skill4.alpha = 0.0
                
                if Int.random(in: 0 ..< 2) == 0 { //毎ターン回復アイテムかgradeupアイテムがフィールドに現れる。
                    
                    //makeheart
                    let heartX = Int.random(in: 0 ..< 254)
                    let heartY = Int.random(in: 0 ..< 816)
                    
                    if self.atPoint(CGPoint(x: heartX,y: heartY)).name == "Background" { //ハートと他のオブジェクトが被らないようにできる場所に他のオブジェクトがなかったらハートができるように変更。
                        
                        self.makeHeart(x: heartX, y: heartY)
                        
                    }
                    
                } else {
                    //ここにgradeupItemを用意する予定
                    
                }
                
            }
            
        }
        
        //移動の処理
        if phaseFlag {
            
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
                    
                    ally1GradeLabel1.position = CGPoint(x: ally1.position.x - 28, y: ally1.position.y - 37)// 表示するポジションを指定.
                    ally1GradeIcon.position = CGPoint(x: ally1.position.x - 28, y: ally1.position.y - 30)
                    ally1HpBar.position = CGPoint(x: ally1.position.x - 18,y:ally1.position.y - 35)
                    ally1HpBarBack.position = CGPoint(x: ally1.position.x - 18,y:ally1.position.y - 37)
                    
                }
            }
            
        } else {
            
        }//phaseflag
        
        
    }
    
    func start(){//ゲームを開始するときに呼ばれるメソッド。
        
        phaseFlag = true
        
        Ally1Flag = false
        MoveMarker1Flag = false
        ally1SkilledFlag = true
        
        
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
            
            if Ally1Flag {
                
                if phaseFlag {//movephaseの時
                    
                    MoveMarker1.alpha = 1.0
                    MoveMarker1.position = location
                    
                } else {//Attackphaseの時
                    if ally1SkilledFlag {
                        
                        ally1Skill1.position = CGPoint(x: ally1.position.x + 50, y: ally1.position.y + 50)//右上
                        ally1Skill1.alpha = 1.0
                        
                        ally1Skill2.position = CGPoint(x: ally1.position.x + 50, y: ally1.position.y - 50)//右下
                        ally1Skill2.alpha = 1.0
                        
                        ally1Skill3.position = CGPoint(x: ally1.position.x - 50, y: ally1.position.y + 50)//左上
                        ally1Skill3.alpha = 1.0
                        
                        ally1Skill4.position = CGPoint(x: ally1.position.x - 50, y: ally1.position.y - 50)//左下
                        ally1Skill4.alpha = 1.0
                        
                    } else {
                        
                    }
                }
                
            }
            
            if MoveMarker1Flag {
                
                MoveMarker1.alpha = 1.0
                MoveMarker1.position = location
                    
            }
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first as UITouch? {
            let location = touch.location(in: self)
            
            //ally1
            if Ally1Flag {//味方を最初に触った時。
                
                Ally1Flag = false
                
                
                if phaseFlag {//movephase
                    
                    if self.rangeofField(minX: 10, maxX: 886, minY: 10, maxY: 344, location: location) {
                        
                        MoveMarker1.position = location
                        
                    } else {
                        MoveMarker1.position = ally1.position
                        MoveMarker1.alpha = 0.0
                    }
                    
                } else {//Attackphase
                    
                    if ally1SkilledFlag {
                        
                        if self.atPoint(location).name == "Skill1" {//skill1の発動
                            
                            print("Skill1")
                            
                            //Bullet作成
                            
                            let bullet = SKSpriteNode(imageNamed: "Back")
                            
                            bullet.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Back"), size: bullet.size)
                            bullet.xScale = 0.03
                            bullet.yScale = 0.01
                            bullet.position = CGPoint(x: ally1.position.x,y: ally1.position.y) //生成位置の設定
                            bullet.name  = "bullet"
                            bullet.userData = NSMutableDictionary()
                            bullet.userData?.setValue( PhysicsCategory.Bullet, forKey: "category")
                            
                            //bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
                            bullet.physicsBody?.categoryBitMask = PhysicsCategory.Bullet //衝突判定に使用する値の設定
                            bullet.physicsBody?.collisionBitMask = PhysicsCategory.Enemy
                            bullet.physicsBody?.contactTestBitMask = PhysicsCategory.Bullet
                            
                            self.addChild(bullet)//Bullet表示
                            
                            let action = SKAction.moveTo(x: self.size.width, duration: 1.0)//アクション作成(移動方向:Y,移動時間:1.0秒)
                            let actionDone = SKAction.removeFromParent()
                            bullet.run(SKAction.sequence([action,actionDone]))
                            
                            ally1SkilledFlag = false//Skillを使ったこと判定
                            
                        }
                        
                        if self.atPoint(location).name == "Skill2" {//skill2の発動
                            
                            print("Skill2")
                            ally1SkilledFlag = false
                            
                        }
                        
                        if self.atPoint(location).name == "Skill3" {//skill3の発動
                            
                            print("Skill3")
                            ally1SkilledFlag = false
                            
                        }
                        
                        if self.atPoint(location).name == "Skill4" {//skill4の発動
                            
                            print("Skill4")
                            ally1SkilledFlag = false
                            
                        }
                        
                    } else {
                        
                    }
                }
                
                ally1Skill1.alpha = 0.0//name判定より後にしないと判定がされなくなる。
                ally1Skill2.alpha = 0.0
                ally1Skill3.alpha = 0.0
                ally1Skill4.alpha = 0.0
                
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
    
    func didBegin(_ contact: SKPhysicsContact) {//衝突の処理
        
        if let nodeA = contact.bodyA.node {
            if let nodeB = contact.bodyB.node{
                
                if nodeA.userData?.value(forKey: "category") as! UInt32 == PhysicsCategory.Enemy && nodeB.userData?.value(forKey: "category") as! UInt32 == PhysicsCategory.Bullet || nodeA.userData?.value(forKey: "category") as! UInt32 == PhysicsCategory.Bullet && nodeB.userData?.value(forKey: "category") as! UInt32 == PhysicsCategory.Enemy {
                    //ダメージ処理
                    print("damage")
                    self.changeHp(change: -400, side: 0)
                    
                    if nodeA.userData?.value(forKey: "category") as! UInt32 == PhysicsCategory.Bullet {
                        nodeA.removeFromParent()
                    } else if nodeB.userData?.value(forKey: "category") as! UInt32 == PhysicsCategory.Bullet {
                        nodeB.removeFromParent()
                    }
                    
                    
                }
                
            }
        }
        
    }
    
    func changeHp(change:Int,side:Int) {//渡された値が正なら回復。負ならダメージを与える。hpを変動させる。sideが0なら敵,1なら味方
        
        if side == 0 {
            
            Enemy1Hp = Enemy1Hp + change//hpの増減処理
            
            if Enemy1Hp <= 0 {
                //gameover処理
                
            }
            
            Enemy1HpBar.position = CGPoint(x: Enemy1.position.x - 20,y: Enemy1.position.y - 75)
            Enemy1HpBar.zPosition = 1
            Enemy1HpBar.xScale = CGFloat( Double(Enemy1Hp) / Double(Enemy1MaxHp) )//x方向の倍率
            
            if Double(Enemy1Hp) / Double(Enemy1MaxHp) >= 0.7 {
                //hpbarGreen
                Enemy1HpBar.color = UIColor.green
                
            } else if Double(Enemy1Hp) / Double(Enemy1MaxHp) >= 0.3 {
                //hpbarYellow
                Enemy1HpBar.color = UIColor.yellow
                
            } else {
                //hpbarRed
                Enemy1HpBar.color = UIColor.red
                
            }
            
            
        } else if side == 1 {
            
            ally1Hp = ally1Hp + change//hpの増減処理
            
            if ally1Hp <= 0 {
                //gameclear処理]
                
            }
            
            ally1HpBar.position = CGPoint(x: ally1.position.x - 20,y:ally1.position.y - 35)
            ally1HpBar.zPosition = 1
            ally1HpBar.xScale = CGFloat( Double(ally1Hp) / Double(ally1MaxHp) )//x方向の倍率
            
            if Double(ally1Hp) / Double(ally1MaxHp) >= 0.7 {
                //hpbarGreen
                Enemy1HpBar.color = UIColor.green
                
            } else if Double(ally1Hp) / Double(ally1MaxHp) >= 0.3 {
                //hpbarYellow
                Enemy1HpBar.color = UIColor.yellow
                
            } else {
                //hpbarRed
                Enemy1HpBar.color = UIColor.red
                
            }
        }
        
    }
    
    func makeHeart(x: Int,y: Int) {//ハートを作る関数
        
        let Heart = SKSpriteNode(imageNamed: "heart")
        
        Heart.physicsBody?.usesPreciseCollisionDetection = true//精度の高い衝突判定を行う。
        Heart.physicsBody?.friction = 0//摩擦係数を0にする
        Heart.name = "haert"
        Heart.physicsBody?.isDynamic = false
        Heart.physicsBody?.restitution = 1.0 // 1.0にしたい。
        Heart.physicsBody?.allowsRotation = false
        Heart.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "heart.png"), size: Heart.size)
        Heart.physicsBody?.categoryBitMask = 0//物体のカテゴリ次元をHeart
        Heart.physicsBody?.contactTestBitMask = PhysicsCategory.Ally //衝突を検知するカテゴリ
        Heart.physicsBody?.collisionBitMask = 0 //衝突させたい物体＝＞なし
        Heart.position = CGPoint(x: 50 + x,y: 50 + y)
        Heart.userData = NSMutableDictionary()
        Heart.userData?.setValue( PhysicsCategory.Heart, forKey: "category")
        Heart.xScale = 0.7
        Heart.yScale = 0.7
        self.addChild(Heart)//Ballを追加
        
        HeartCount = HeartCount + 1
        
    }
    
    //////////////////////////便利系メソッド集/////////////////////////////////
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
