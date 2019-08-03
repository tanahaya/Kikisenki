//
//  GameScene.swift
//  Kikisenki
//
//  Created by 田中 颯 on 2019/07/08.
//  Copyright © 2019 tanahaya. All rights reserved.
//

import Foundation
import SpriteKit

class GameScene : SKScene, SKPhysicsContactDelegate{
    
    var LeftWall = SKSpriteNode(imageNamed: "LeftWall")
    var RightWall = SKSpriteNode(imageNamed: "RightWall")
    var UpperWall = SKSpriteNode(imageNamed: "UpperWall")
    var LowerWall = SKSpriteNode(imageNamed: "LowerWall")
    var Button = SKSpriteNode(imageNamed: "smallbutton")
    
    let ButtonPosition = CGPoint(x: 207,y: 200)
    var AimTimer:Timer?
    
    var Background = SKSpriteNode(imageNamed: "Background")
    
    var originalPoint:CGPoint = CGPoint(x: 0.0,y: 0.0)
    var aimPoint:CGPoint = CGPoint(x: 0.0,y: 0.0)
    var aimmingPoint:CGPoint = CGPoint(x: 0.0,y: 0.0)
    
    var ButtonFlag:Bool = false
    var Ally1Flag:Bool = false
    var Ally2Flag:Bool = false
    var Ally3Flag:Bool = false
    var MoveMaker1Flag:Bool = false
    var MoveMaker2Flag:Bool = false
    var MoveMaker3Flag:Bool = false
    
    var MainTimer:Timer?//enegyと移動と敵の攻撃に使用
    
    var enegy:Double = 10.0//enegyの値
    let enegyLabel = SKLabelNode()//enegyを表示
    var enegyBar = SKSpriteNode(color: SKColor.blue, size: CGSize(width: 7.0, height: 30.0))//エナジーの量を表示
    
    var ally1  = SKSpriteNode(imageNamed: "monster1a")//allyの追加
    var MoveMaker1 = SKSpriteNode(imageNamed: "movemaker1")//ally1のmovemader
    let levelLabel1 = SKLabelNode()
    var level1:Int = 0
    var exp1:Int = 0
    
    var ally2  = SKSpriteNode(imageNamed: "monster2a")//allyの追加
    var MoveMaker2 = SKSpriteNode(imageNamed: "movemaker2")//ally2のmovemader
    let levelLabel2 = SKLabelNode()
    var level2:Int = 0
    var exp2:Int = 0
    
    var ally3  = SKSpriteNode(imageNamed: "monster3a")//allyの追加
    var MoveMaker3 = SKSpriteNode(imageNamed: "movemaker3")//ally3のmovemader
    let levelLabel3 = SKLabelNode()
    var level3:Int = 0
    var exp3:Int = 0
    
    let allyHpLabel = SKLabelNode()//allyのhpを表示する。
    var allyHpBar = SKSpriteNode(color: SKColor.green, size: CGSize(width: 0.25, height: 25.0))//味方のhpの量を表示
    var allyHp:Int = 1000
    var allyMaxHp:Int = 1000
    
    
    var enemy1 = SKSpriteNode(imageNamed: "syatihoko")
    var enemy1AttackLabel = SKLabelNode()
    var enemy1AttackCount:Int = 50//mainTimerの感覚が0.1秒ごとのため10バイしております。そのため攻撃感覚は5秒です。
    
    let enemyHpLabel = SKLabelNode()//
    var enemyHpBar = SKSpriteNode(color: SKColor.red, size: CGSize(width: 0.5, height: 25.0))//敵のhpの量を表示
    var enemyHp:Int = 500
    var enemyMaxHp:Int = 500
    
    var lifeTimerCount:Int = 0
    var HeartCount:Int = 1
    
    var endFlag = false
    
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
        
        self.start()
        
        self.size = CGSize(width: 414, height: 896)//414x896が最適。これはiphoneXRの画面サイズ
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        self.physicsWorld.contactDelegate = self //didBeginCOntactに必要
        
        //壁
        LeftWall.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "LeftWall.png"), size: LeftWall.size)
        LeftWall.name = "LeftWall"
        LeftWall.physicsBody?.restitution = 1.0//反発値
        LeftWall.physicsBody?.isDynamic = false//ぶつかったときに移動するかどうか =>しない
        LeftWall.physicsBody?.categoryBitMask = PhysicsCategory.Wall //物体のカテゴリ次元をwall(4)
        LeftWall.physicsBody?.contactTestBitMask = PhysicsCategory.Ball //衝突を検知するカテゴリBall
        LeftWall.physicsBody?.collisionBitMask = PhysicsCategory.Ball //衝突させたい物体Ball
        LeftWall.position = CGPoint(x: 5,y: 533)
        LeftWall.userData = NSMutableDictionary()
        LeftWall.userData?.setValue( 0, forKey: "count")
        LeftWall.userData?.setValue( PhysicsCategory.Wall, forKey: "category")
        self.addChild(LeftWall)
        
        RightWall.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "RightWall.png"), size: RightWall.size)
        RightWall.name = "WallRight"
        RightWall.physicsBody?.restitution = 1.0//反発値
        RightWall.physicsBody?.isDynamic = false//ぶつかったときに移動するかどうか =>しない
        RightWall.physicsBody?.categoryBitMask = PhysicsCategory.Wall //物体のカテゴリ次元をwall(4)
        RightWall.physicsBody?.contactTestBitMask = PhysicsCategory.Ball //衝突を検知するカテゴリBall
        RightWall.physicsBody?.collisionBitMask = PhysicsCategory.Ball //衝突させたい物体Ball
        RightWall.position = CGPoint(x: 409,y: 533)
        RightWall.userData = NSMutableDictionary()
        RightWall.userData?.setValue( PhysicsCategory.Wall, forKey: "category")
        self.addChild(RightWall)
        
        UpperWall.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "UpperWall.png"), size: UpperWall.size)
        UpperWall.name = "UpperWall"
        UpperWall.physicsBody?.restitution = 1.0//反発値
        UpperWall.physicsBody?.isDynamic = false//ぶつかったときに移動するかどうか =>しない
        UpperWall.physicsBody?.categoryBitMask = PhysicsCategory.Wall //物体のカテゴリ次元をwall(4)
        UpperWall.physicsBody?.contactTestBitMask = PhysicsCategory.Ball //衝突を検知するカテゴリBall
        UpperWall.physicsBody?.collisionBitMask = PhysicsCategory.Ball //衝突させたい物体Ball
        UpperWall.position = CGPoint(x: 207,y: 856)
        UpperWall.userData = NSMutableDictionary()
        UpperWall.userData?.setValue( PhysicsCategory.Wall, forKey: "category")
        self.addChild(UpperWall)
        
        LowerWall.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "LowerWall.png"), size: LowerWall.size)
        LowerWall.name = "LowerWall"
        LowerWall.physicsBody?.restitution = 1.0//反発値
        LowerWall.physicsBody?.isDynamic = false//ぶつかったときに移動するかどうか =>しない
        LowerWall.physicsBody?.categoryBitMask = PhysicsCategory.Wall //物体のカテゴリ次元をwall(4)
        LowerWall.physicsBody?.contactTestBitMask = PhysicsCategory.Ball //衝突を検知するカテゴリBall
        LowerWall.physicsBody?.collisionBitMask = PhysicsCategory.Ball //衝突させたい物体Ball
        LowerWall.position = CGPoint(x: 207,y: 125)
        LowerWall.userData = NSMutableDictionary()
        LowerWall.userData?.setValue( PhysicsCategory.Wall, forKey: "category")
        self.addChild(LowerWall)
        
        //壁紙
        Background.anchorPoint = CGPoint(x: 0,y: 0)//ノードの位置配置などの起点を設定。
        Background.position = CGPoint(x: 10,y: 250)
        Background.name = "Background"
        self.addChild(Background)
        
        //ボタン＝＞後々放題にしてフィールドに配置する予定。
        Button.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "smallbutton.png"), size: Button.size)
        Button.name = "Button"
        Button.physicsBody?.restitution = 1.0//反発値
        Button.physicsBody?.isDynamic = false//ぶつかったときに移動するかどうか =>しない
        Button.position = CGPoint(x: 207,y: 200)//207,が中心に相当近い
        Button.userData = NSMutableDictionary()
        Button.userData?.setValue( PhysicsCategory.Button, forKey: "category")
        self.addChild(Button)
        
        //メインタイマー
        self.MainTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.mainTimerupdate), userInfo: nil, repeats: true)
        
        //エネルギー管理系
        enegyLabel.fontSize = 30// フォントサイズを設定.
        enegyLabel.fontColor = UIColor.blue// 色を指定(赤).
        enegyLabel.position = CGPoint(x: 50, y: 120)// 表示するポジションを指定.
        enegyLabel.text = "\(enegy)"
        self.addChild(enegyLabel)//シーンに追加
        
        enegyBar.anchorPoint = CGPoint(x: 0, y: 0)
        enegyBar.position = CGPoint(x: 100, y: 120)
        enegyBar.zPosition = 1
        enegyBar.xScale = CGFloat(enegy)//x方向の倍率
        self.addChild(enegyBar)
        
        
        //ally1
        ally1.name = "Ally1"
        ally1.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "monster1a"), size: ally1.size)
        ally1.physicsBody?.isDynamic = false
        ally1.physicsBody?.restitution = 1.0//反発値
        ally1.position = CGPoint(x: 207,y: 500)
        ally1.zPosition = 1 //movermakerより上に来るようにz=1
        ally1.userData = NSMutableDictionary()
        ally1.userData?.setValue( PhysicsCategory.Ally, forKey: "category")
        ally1.userData?.setValue( 0, forKey: "level")//levelを追加
        ally1.physicsBody?.categoryBitMask = PhysicsCategory.Ally //物体のカテゴリ次元をally
        ally1.physicsBody?.contactTestBitMask = PhysicsCategory.Ball //衝突を検知するカテゴリBall
        ally1.physicsBody?.collisionBitMask = 0 //PhysicsCategory.Ball //衝突させたい物体＝＞なし
        self.addChild(ally1)
        
        levelLabel1.text = "level: 0"// Labelに文字列を設定.
        levelLabel1.fontSize = 20// フォントサイズを設定.
        levelLabel1.fontColor = UIColor.green// 色を指定(赤).
        levelLabel1.position = CGPoint(x: ally1.position.x, y: ally1.position.y - 55)// 表示するポジションを指定.
        levelLabel1.text = "level: \(level1)"
        self.addChild(levelLabel1)//シーンに追加
        
        MoveMaker1.position = ally1.position
        MoveMaker1.alpha = 0.0
        MoveMaker1.name = "MoveMaker1"
        self.addChild(MoveMaker1)
        
        
        //ally2
        ally2.name = "Ally2"
        ally2.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "monster2a"), size: ally2.size)
        ally2.physicsBody?.isDynamic = false
        ally2.physicsBody?.restitution = 1.0//反発値
        ally2.position = CGPoint(x: 100,y: 400)
        ally2.zPosition = 1 //movermakerより上に来るようにz=1
        ally2.userData = NSMutableDictionary()
        ally2.userData?.setValue( PhysicsCategory.Ally, forKey: "category")
        ally2.userData?.setValue( 0, forKey: "level")//levelを追加
        ally2.physicsBody?.categoryBitMask = PhysicsCategory.Ally //物体のカテゴリ次元をally
        ally2.physicsBody?.contactTestBitMask = PhysicsCategory.Ball //衝突を検知するカテゴリBall
        ally2.physicsBody?.collisionBitMask = 0 //PhysicsCategory.Ball //衝突させたい物体＝＞なし
        self.addChild(ally2)
        
        levelLabel2.text = "level: 0"// Labelに文字列を設定.
        levelLabel2.fontSize = 20// フォントサイズを設定.
        levelLabel2.fontColor = UIColor.red// 色を指定(赤).
        levelLabel2.position = CGPoint(x: ally2.position.x, y: ally2.position.y - 65)// 表示するポジションを指定.
        levelLabel2.text = "level: \(level2)"
        self.addChild(levelLabel2)//シーンに追加
        
        MoveMaker2.position = ally2.position
        MoveMaker2.alpha = 0.0
        MoveMaker2.name = "MoveMaker2"
        self.addChild(MoveMaker2)
        
        //ally3
        ally3.name = "Ally3"
        ally3.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "monster3a"), size: ally3.size)
        ally3.physicsBody?.isDynamic = false
        ally3.physicsBody?.restitution = 1.0//反発値
        ally3.position = CGPoint(x: 300,y: 400)
        ally3.zPosition = 1 //movermakerより上に来るようにz=1
        ally3.userData = NSMutableDictionary()
        ally3.userData?.setValue( PhysicsCategory.Ally, forKey: "category")
        ally3.userData?.setValue( 0, forKey: "level")//levelを追加
        ally3.physicsBody?.categoryBitMask = PhysicsCategory.Ally //物体のカテゴリ次元をally
        ally3.physicsBody?.contactTestBitMask = PhysicsCategory.Ball //衝突を検知するカテゴリBall
        ally3.physicsBody?.collisionBitMask = 0 //PhysicsCategory.Ball //衝突させたい物体＝＞なし
        self.addChild(ally3)
        
        levelLabel3.text = "level: 0"// Labelに文字列を設定.
        levelLabel3.fontSize = 20// フォントサイズを設定.
        levelLabel3.fontColor = UIColor.blue// 色を指定(赤).
        levelLabel3.position = CGPoint(x: ally3.position.x, y: ally3.position.y - 40)// 表示するポジションを指定.
        levelLabel3.text = "level: \(level3)"
        self.addChild(levelLabel3)//シーンに追加
        
        MoveMaker3.position = ally3.position
        MoveMaker3.alpha = 0.0
        MoveMaker3.name = "MoveMaker3"
        self.addChild(MoveMaker3)
        
        
        //味方のhp
        allyHpLabel.text = "0.0"// Labelに文字列を設定.
        allyHpLabel.fontSize = 25// フォントサイズを設定.
        allyHpLabel.fontColor = UIColor.green// 色を指定(赤).
        allyHpLabel.position = CGPoint(x: 75, y: 70)// 表示するポジションを指定.
        allyHpLabel.text = "\(allyHp) / \(allyMaxHp)"
        self.addChild(allyHpLabel)//シーンに追加
        
        
        allyHpBar.anchorPoint = CGPoint(x: 0, y: 0)
        allyHpBar.position = CGPoint(x: 145, y: 70)
        allyHpBar.zPosition = 1
        allyHpBar.xScale = CGFloat(allyHp)//x方向の倍率
        self.addChild(allyHpBar)
        
        //enemy1
        enemy1.name = "Enemy1"
        enemy1.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "syatihoko"), size: enemy1.size)
        enemy1.physicsBody?.isDynamic = false
        enemy1.physicsBody?.restitution = 1.0//反発値
        enemy1.position = CGPoint(x: 207,y: 700)
        enemy1.userData = NSMutableDictionary()
        enemy1.userData?.setValue( PhysicsCategory.Emeny, forKey: "category")
        enemy1.userData?.setValue( 0, forKey: "level")//levelを追加
        enemy1.physicsBody?.categoryBitMask = PhysicsCategory.Emeny //物体のカテゴリ次元をEnemy
        enemy1.physicsBody?.contactTestBitMask = PhysicsCategory.Ball //衝突を検知するカテゴリBall
        enemy1.physicsBody?.collisionBitMask = 0 //PhysicsCategory.Ball //衝突させたい物体＝＞なし
        self.addChild(enemy1)
        
        enemy1AttackLabel.fontSize = 30// フォントサイズを設定.
        enemy1AttackLabel.fontColor = UIColor.yellow// 色を指定(赤).
        enemy1AttackLabel.position = CGPoint(x: enemy1.position.x, y: enemy1.position.y - 130)// 表示するポジションを指定.
        enemy1AttackLabel.text = "\(enemy1AttackCount / 10)"//mainTimerの感覚が0.1秒ごとのため10バイしております。
        self.addChild(enemy1AttackLabel)//シーンに追加
        
        //敵のhp
        enemyHpLabel.text = "0.0"// Labelに文字列を設定.
        enemyHpLabel.fontSize = 25// フォントサイズを設定.
        enemyHpLabel.fontColor = UIColor.red// 色を指定(赤).
        enemyHpLabel.position = CGPoint(x: 75, y: 830)// 表示するポジションを指定.
        enemyHpLabel.text = "\(enemyHp) / \(enemyMaxHp)"
        self.addChild(enemyHpLabel)//シーンに追加
        
        enemyHpBar.anchorPoint = CGPoint(x: 0, y: 0)
        enemyHpBar.position = CGPoint(x: 145, y: 830)
        enemyHpBar.zPosition = 1
        enemyHpBar.xScale = CGFloat(enemyHp)//x方向の倍率
        self.addChild(enemyHpBar)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first as UITouch? {
            let location = touch.location(in: self)
            
            originalPoint.x = location.x
            originalPoint.x = location.y
            
            if self.atPoint(location).name == "Button" {
                ButtonFlag = true
                
                self.AimTimer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(self.aimupdate), userInfo: nil, repeats: true)
                //タイマーをここで開始して話した時に終了にして、movedで常に位置の新しい情報を入れ続けてもらえばいんじゃね
                
            }
            if self.atPoint(location).name == "Ally1"{
                Ally1Flag = true
            }
            if self.atPoint(location).name == "Ally2"{
                Ally2Flag = true
            }
            if self.atPoint(location).name == "Ally3"{
                Ally3Flag = true
            }
            
            if self.atPoint(location).name == "MoveMaker1"{
                MoveMaker1Flag = true
            }
            if self.atPoint(location).name == "MoveMaker2"{
                MoveMaker2Flag = true
            }
            if self.atPoint(location).name == "MoveMaker3"{
                MoveMaker3Flag = true
            }
            
        }
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first as UITouch? {
            let location = touch.location(in: self)
            
            if ButtonFlag {
                aimmingPoint = location
            }
            
            if Ally1Flag || MoveMaker1Flag {
                MoveMaker1.alpha = 1.0
                MoveMaker1.position = location
            }
            
            if Ally2Flag || MoveMaker2Flag {
                MoveMaker2.alpha = 1.0
                MoveMaker2.position = location
            }
            
            if Ally3Flag || MoveMaker3Flag {
                MoveMaker3.alpha = 1.0
                MoveMaker3.position = location
            }
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //allyの挙動を全て書いてるため、長くなっております。あとで関数化するかも。多分、多分そうしたほうが少なく書ける。
        
        if let touch = touches.first as UITouch? {
            let location = touch.location(in: self)
            if ButtonFlag { //発射ボタンを最初に触った時。
                aimPoint.x = location.x
                aimPoint.y = location.y
                
                if AimTimer!.isValid == true {
                    AimTimer?.invalidate()//AimTimerを破棄する.
                }
                
                if enegy >= 3.0 {//エネルギー減らす分を確保。
                    enegy = enegy - 3.0//エネルギーを減らす。
                    self.MakeBall(origin: ButtonPosition, aim: location)
                }
                ButtonFlag = false
            }
            //ally1
            if Ally1Flag {//味方を最初に触った時。
                Ally1Flag = false
                print(self.atPoint(location).name!)
                if self.atPoint(location).name == "Background"{
                    
                    MoveMaker1.position = location
                    
                }
                if self.self.atPoint(location).name == "Enemy1" {
                    
                    MoveMaker1.alpha = 0.0
                    MoveMaker1.position = ally1.position
                    
                    self.changeEnemyHp(change: -10 * level1 * level1)
                    
                    switch level1  {//可変レベル
                    case 0:
                        level1 = 0
                    case 1://123(3)
                        exp1 = exp1 - 1
                    case 2://4567(4)
                        exp1 = exp1 - 4
                    case 3://89101112(5)
                        exp1 = exp1 - 8
                    case 4://121314151617(6)
                        exp1 = exp1 - 12
                    case 5://18192021222324(7)
                        exp1 = exp1 - 18
                    case 6://2526272829303132(8)
                        exp1 = exp1 - 25
                    case 7://~max
                        exp1 = exp1 - 33
                    default:
                        print("default")
                    }
                    level1 = 0//レベルを０に戻す
                    levelLabel1.text = "level: \(level1)"
                    
                }
            }
            
            if MoveMaker1Flag {
                MoveMaker1Flag = false
                MoveMaker1.position = location
            }
            //ally2
            if Ally2Flag {//味方を最初に触った時。
                Ally2Flag = false
                print(self.atPoint(location).name!)
                if self.atPoint(location).name == "Background"{
                    
                    MoveMaker2.position = location
                    
                }
                if self.self.atPoint(location).name == "Enemy1" {
                    
                    MoveMaker2.alpha = 0.0
                    MoveMaker2.position = ally2.position
                    
                    self.changeEnemyHp(change: -10 * level2 * level2)
                    
                    switch level2  {//可変レベル
                    case 0:
                        level2 = 0
                    case 1://123(3)
                        exp2 = exp2 - 1
                    case 2://4567(4)
                        exp2 = exp2 - 4
                    case 3://89101112(5)
                        exp2 = exp2 - 8
                    case 4://121314151617(6)
                        exp2 = exp2 - 12
                    case 5://18192021222324(7)
                        exp2 = exp2 - 18
                    case 6://2526272829303132(8)
                        exp2 = exp2 - 25
                    case 7://~max
                        exp2 = exp2 - 33
                    default:
                        print("default")
                    }
                    level2 = 0//レベルを０に戻す
                    levelLabel2.text = "level: \(level2)"
                    
                }
            }
            
            if MoveMaker2Flag {
                MoveMaker2Flag = false
                MoveMaker2.position = location
            }
            //ally3
            if Ally3Flag {//味方を最初に触った時。
                Ally3Flag = false
                print(self.atPoint(location).name!)
                if self.atPoint(location).name == "Background"{
                    
                    MoveMaker3.position = location
                    
                }
                if self.self.atPoint(location).name == "Enemy1" {
                    
                    MoveMaker3.alpha = 0.0
                    MoveMaker3.position = ally3.position
                    
                    self.changeEnemyHp(change: -10 * level3 * level3)
                    
                    switch level3  {//可変レベル
                    case 0:
                        level3 = 0
                    case 1://123(3)
                        exp3 = exp3 - 1
                    case 2://4567(4)
                        exp3 = exp3 - 4
                    case 3://89101112(5)
                        exp3 = exp3 - 8
                    case 4://121314151617(6)
                        exp3 = exp3 - 12
                    case 5://18192021222324(7)
                        exp3 = exp3 - 18
                    case 6://2526272829303132(8)
                        exp3 = exp3 - 25
                    case 7://~max
                        exp3 = exp3 - 33
                    default:
                        print("default")
                    }
                    level3 = 0//レベルを０に戻す
                    levelLabel3.text = "level: \(level3)"
                    
                }
            }
            
            if MoveMaker3Flag {
                MoveMaker3Flag = false
                MoveMaker3.position = location
            }
            
        }
    }
    
    
    func MakeBall(origin: CGPoint,aim: CGPoint){
        
        let Ball = SKSpriteNode(imageNamed: "tama2")
        
        Ball.physicsBody?.usesPreciseCollisionDetection = true//精度の高い衝突判定を行う。
        Ball.physicsBody?.friction = 0//摩擦係数を0にする
        Ball.name = "Ball"
        Ball.physicsBody?.isDynamic = true
        Ball.physicsBody?.restitution = 1.0 // 1.0にしたい。
        Ball.physicsBody?.allowsRotation = false
        Ball.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "tama2.png"), size: Ball.size)//Ball.size CGSize(width: 0,height: 30)
        Ball.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        Ball.color = UIColor.red
        Ball.physicsBody?.categoryBitMask = PhysicsCategory.Ball //物体のカテゴリ次元をBall
        Ball.physicsBody?.contactTestBitMask = PhysicsCategory.Wall //衝突を検知するカテゴリWall
        Ball.physicsBody?.collisionBitMask = PhysicsCategory.Wall //PhysicsCategory.Ball //衝突させたい物体＝＞なし
        Ball.position = CGPoint(x: 207,y: 275)//初期位置
        Ball.userData = NSMutableDictionary()
        Ball.userData?.setValue( 1, forKey: "count")
        Ball.userData?.setValue( PhysicsCategory.Ball, forKey: "category")
        
        self.addChild(Ball)//Ballを追加
        
        let pi:CGFloat = vector2radian(vector: CGPoint(x: origin.x - aim.x, y: origin.y - aim.y))
        
        let speed:Double = 1500.0 // 速さを設定
        Ball.physicsBody?.velocity = CGVector(dx: -speed * cos(Double(pi)),dy: speed * sin(Double(pi)))//800の速さで球を飛ばす。
        
    }
    
    @objc func aimupdate() {//ボタンから触った時のタイマーの挙動
        MakeSmallBall(origin: ButtonPosition, aim: aimmingPoint)//経路予想のためのボールを作る。
    }
    
    func MakeSmallBall(origin: CGPoint,aim: CGPoint) {
        
        let SmallBall = SKSpriteNode(imageNamed: "smallball")
        
        SmallBall.physicsBody?.usesPreciseCollisionDetection = true//精度の高い衝突判定を行う。
        SmallBall.physicsBody?.friction = 0//摩擦係数を0にする
        SmallBall.name = "SmallBall"
        SmallBall.physicsBody?.isDynamic = true
        SmallBall.physicsBody?.restitution = 1.0 // 1.0にしたい。
        SmallBall.physicsBody?.allowsRotation = false
        SmallBall.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "smallball.png"), size: SmallBall.size)//Ball.size CGSize(width: 0,height: 30)
        SmallBall.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        SmallBall.color = UIColor.red
        SmallBall.physicsBody?.categoryBitMask = 0//PhysicsCategory.SmallBall //物体のカテゴリ次元をBall
        SmallBall.physicsBody?.contactTestBitMask = 0//PhysicsCategory.Wall //衝突を検知するカテゴリWall
        SmallBall.physicsBody?.collisionBitMask = PhysicsCategory.Wall //PhysicsCategory.Ball //衝突させたい物体＝＞なし
        SmallBall.position = CGPoint(x: 207,y: 275)//初期位置
        SmallBall.userData = NSMutableDictionary()
        SmallBall.userData?.setValue( 0, forKey: "count")
        SmallBall.userData?.setValue( PhysicsCategory.SmallBall, forKey: "category")
        
        self.addChild(SmallBall)//Ballを追加
        
        let pi:CGFloat = vector2radian(vector: CGPoint(x: origin.x - aim.x, y: origin.y - aim.y))
        let speed:Double = 1200.0 // 速さを設定
        SmallBall.physicsBody?.velocity = CGVector(dx: -speed * cos(Double(pi)),dy: speed * sin(Double(pi)))//800の速さで球を飛ばす。
        
        let wait = SKAction.wait(forDuration: 0.5)
        let remove = SKAction.removeFromParent()
        SmallBall.run(SKAction.sequence([wait,remove]))
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {//衝突の処理
        
        if let nodeA = contact.bodyA.node {
            if let nodeB = contact.bodyB.node{
                
                if nodeA.userData?.value(forKey: "category") as! UInt32 == PhysicsCategory.Wall && nodeB.userData?.value(forKey: "category") as! UInt32 == PhysicsCategory.Ball || nodeA.userData?.value(forKey: "category") as! UInt32 == PhysicsCategory.Ball && nodeB.userData?.value(forKey: "category") as! UInt32 == PhysicsCategory.Wall {
                    
                    if nodeA.userData?.value(forKey: "category") as! UInt32 == PhysicsCategory.Ball {
                        var plusone:Int = nodeA.userData?["count"] as! Int
                        plusone = plusone + 1
                        nodeA.userData?.setValue( plusone, forKey: "count")
                        //print((nodeA.userData?["count"])!)
                        if nodeA.userData?["count"] as! Int == 10 {
                            nodeA.removeFromParent()
                        }
                    }else if nodeB.userData?.value(forKey: "category") as! UInt32 == PhysicsCategory.Ball{
                        var plusone:Int = nodeB.userData?["count"] as! Int
                        plusone = plusone + 1
                        nodeB.userData?.setValue( plusone, forKey: "count")
                        //print((nodeB.userData?["count"])!)
                        if nodeB.userData?["count"] as! Int == 10 {
                            nodeB.removeFromParent()
                        }
                    }
                }
                
                if nodeA.userData?.value(forKey: "category") as! UInt32 == PhysicsCategory.Ally && nodeB.userData?.value(forKey: "category") as! UInt32 == PhysicsCategory.Ball || nodeA.userData?.value(forKey: "category") as! UInt32 == PhysicsCategory.Ball && nodeB.userData?.value(forKey: "category") as! UInt32 == PhysicsCategory.Ally {
                    //ボールと味方が衝突した時の処理。本当は衝突処理だけして、すり抜けさせたい。=>できた。
                    if nodeA.userData?.value(forKey: "category") as! UInt32 == PhysicsCategory.Ball  {
                        let plusexp:Int = nodeB.userData?["count"] as! Int
                        exp1 = exp1 + plusexp//可変経験値
                        nodeA.removeFromParent()
                    }else if nodeB.userData?.value(forKey: "category") as! UInt32 == PhysicsCategory.Ball {
                        let plusexp:Int = nodeB.userData?["count"] as! Int
                        exp1 = exp1 + plusexp//可変経験値
                        nodeB.removeFromParent()
                    }
                    
                    switch exp1 {//可変レベル制
                    case 0:
                        level1 = 0
                    case 1 ..< 4://123(3)
                        level1 = 1
                    case 4 ..< 8://4567(4)
                        level1 = 2
                    case 8 ..< 12://89101112(5)
                        level1 = 3
                    case 12 ..< 18://121314151617(6)
                        level1 = 4
                    case 18 ..< 25://18192021222324(7)
                        level1 = 5
                    case 21 ..< 28://2526272829303132(8)
                        level1 = 6
                    case 28 ..< 1000://~max
                        level1 = 7
                    default:
                        print("default")
                    }
                    
                    levelLabel1.text = "level: \(level1)"
                    levelLabel1.position = CGPoint(x: ally1.position.x, y: ally1.position.y - 55)// 表示するポジションを指定.
                    
                }
                
                if nodeA.userData?.value(forKey: "category") as! UInt32 == PhysicsCategory.Heart && nodeB.userData?.value(forKey: "category") as! UInt32 == PhysicsCategory.Ally || nodeA.userData?.value(forKey: "category") as! UInt32 == PhysicsCategory.Heart && nodeB.userData?.value(forKey: "category") as! UInt32 == PhysicsCategory.Ally {
                    
                    if nodeA.userData?.value(forKey: "category") as! UInt32 == PhysicsCategory.Heart {
                        print("hello")
                        nodeA.removeFromParent()
                        
                    }else if nodeB.userData?.value(forKey: "category") as! UInt32 == PhysicsCategory.Heart {
                        print("hello")
                        nodeB.removeFromParent()
                        
                    }
                    
                }
            }
        }
        
    }
    
    func vector2radian(vector: CGPoint) -> CGFloat {
        
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
    
    @objc func mainTimerupdate(){
        
        if self.enegy < 30.0 {//エナジー系の処理
            self.enegy = self.enegy + 0.2
            if enegy > 30.0 {
                enegy = 30.0
            }
            
        }
        
        //ally1.position.y = ally1.position.y + 1はできる
        if ally1.position == MoveMaker1.position {//移動系の処理
            
            MoveMaker1.alpha = 0.0
            
        } else {
            
            let relativepostion:CGPoint = CGPoint(x: MoveMaker1.position.x - ally1.position.x, y:  MoveMaker1.position.y - ally1.position.y)
            let direction :CGFloat = vector2radian(vector: relativepostion)
            if Ally1Flag || MoveMaker1Flag {
                
            }else{
                if enegy >= 0.2 {
                    if length(v: relativepostion) <= 6 {//相対位置の距離が6以下の場合、位置を同じにする。
                        
                        ally1.position = MoveMaker1.position
                        MoveMaker1.alpha = 0.0
                        
                    }else{//違う場合距離にして3づつ近づく
                        
                        
                        let travelTime = SKAction.move( to: CGPoint(x: ally1.position.x - CGFloat( 3 * cos(Double(direction))),y: ally1.position.y + CGFloat( 3 * sin(Double(direction)))), duration: 0.01)
                        ally1.run(travelTime)
                        
                        enegy = enegy - 0.2
                        
                    }
                    
                    levelLabel1.position = CGPoint(x: ally1.position.x, y: ally1.position.y - 55)// 表示するポジションを指定.
                    
                    }
            
            }
            
            let enegy1f = floor(enegy*10) / 10//少数第一位まで
            
            self.enegyLabel.text = "\(enegy1f)"
            self.enegyBar.xScale = CGFloat(enegy1f)//x方向の倍率
            
        }
        
        enemy1AttackCount = enemy1AttackCount - 1//敵の攻撃に関する処理
        if enemy1AttackCount == -10 {
            
            enemy1AttackCount = 50//攻撃間隔 ＊ 10
            self.changeAllyHp(change: -100)
            
        }
        
        if enemy1AttackCount % 10 == 0 {
            enemy1AttackLabel.text = "\(enemy1AttackCount / 10)"//mainTimerの感覚が0.1秒ごとのため10バイしております。
        }
        
        lifeTimerCount = lifeTimerCount + 1
        
        if lifeTimerCount % 50 == 0 && HeartCount <= 2 { //ハートの数は2コまで
            
            
            
            let Heart = SKSpriteNode(imageNamed: "heart")
            
            Heart.physicsBody?.usesPreciseCollisionDetection = true//精度の高い衝突判定を行う。
            Heart.physicsBody?.friction = 0//摩擦係数を0にする
            Heart.name = "haert"
            Heart.physicsBody?.isDynamic = false
            Heart.physicsBody?.restitution = 1.0 // 1.0にしたい。
            Heart.physicsBody?.allowsRotation = false
            Heart.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "heart.png"), size: Heart.size)
            Heart.physicsBody?.categoryBitMask = 0//物体のカテゴリ次元をHeart
            Heart.physicsBody?.contactTestBitMask = 0 //衝突を検知するカテゴリWall
            Heart.physicsBody?.collisionBitMask = 0 //衝突させたい物体＝＞なし
            Heart.position = CGPoint(x: 50 + Int.random(in: 0 ..< 294) ,y: 300 + Int.random(in: 0 ..< 416))
            //初期位置、414*896 100 + 20 + 294 300 + 80 + 100 + 416
            Heart.userData = NSMutableDictionary()
            Heart.userData?.setValue( PhysicsCategory.Heart, forKey: "category")
            
            if self.atPoint(Heart.position).name == "Background" { //ハートと他のオブジェクトが被らないようにできる場所に他のオブジェクトがなかったらハートができるように変更。
                
                self.addChild(Heart)//Ballを追加
                HeartCount = HeartCount + 1
                
            }
            
        }
        
    }
    
    func changeEnemyHp(change:Int) {//渡された値が正なら回復。負ならダメージを与える。敵のhpを変動させる。
        
        enemyHp = enemyHp + change
        
        if enemyHp <= 0 {
            enemyHp = 0
            
            if endFlag {
                
            }else {
                let alertController0 = UIAlertController(title: "GameClear", message: "貴方の勝利", preferredStyle: .alert)
                let gotoStartAction = UIAlertAction(title: "了解", style: .default) {
                    action in
                    print("勝利")
                    
                    let Scene = StartScene()
                    Scene.size = self.size
                    let transition = SKTransition.crossFade(withDuration: 1.0)
                    
                    self.view?.presentScene(Scene, transition: transition)
                    
                }
                
                alertController0.addAction(gotoStartAction)
                
                let currentViewController : UIViewController? = UIApplication.shared.keyWindow?.rootViewController!
                //SKSceneと言えど、Viewの最も最前面にはUIViewContollerが存在しており、それを取得してきて、そこから使用するというもの。
                currentViewController?.present(alertController0, animated: true, completion: nil)

                endFlag = true
            }
            
        }
        
        enemyHpBar.xScale = CGFloat(enemyHp)
        enemyHpLabel.text = "\(enemyHp) / \(enemyMaxHp)"
        
    }
    
    func changeAllyHp(change:Int) {//渡された値が正なら回復。負ならダメージを与える。味方のhpを変動させる。
        
        allyHp = allyHp + change
        
        if allyHp <= 0 {
            allyHp = 0
            
            if endFlag {
                
            } else {
                let alertController0 = UIAlertController(title: "GameOver", message: "貴方の敗北", preferredStyle: .alert)
                let gotoStartAction = UIAlertAction(title: "了解", style: .default) {
                    action in
                    print("敗北")
                    
                    let Scene = StartScene()
                    Scene.size = self.size
                    let transition = SKTransition.crossFade(withDuration: 1.0)
                    
                    self.view?.presentScene(Scene, transition: transition)
                    
            }
                alertController0.addAction(gotoStartAction)
                
                let currentViewController : UIViewController? = UIApplication.shared.keyWindow?.rootViewController!
                //SKSceneと言えど、Viewの最も最前面にはUIViewContollerが存在しており、それを取得してきて、そこから使用するというもの。
                currentViewController?.present(alertController0, animated: true, completion: nil)
                endFlag = true
            }
            
        }
        
        allyHpBar.xScale = CGFloat(allyHp)
        allyHpLabel.text = "\(allyHp) / \(allyMaxHp)"
        
    }
    func start(){
        
        endFlag = false
        allyHp = allyMaxHp
        enemyHp = enemyMaxHp
        ButtonFlag = false
        Ally1Flag = false
        Ally2Flag = false
        Ally3Flag = false
        MoveMaker1Flag = false
        MoveMaker2Flag = false
        MoveMaker3Flag = false
        
    }
    
}


