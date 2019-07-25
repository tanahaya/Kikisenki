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
    
    var WallLeft = SKSpriteNode(imageNamed: "WallLeft")
    var WallRight = SKSpriteNode(imageNamed: "WallRight")
    var Button = SKSpriteNode(imageNamed: "Button")
    var Arrow = SKSpriteNode(imageNamed: "Arrow")
    
    var Back = SKSpriteNode(imageNamed: "Back")
    
    var originalPoint:CGPoint = CGPoint(x: 0.0,y: 0.0)
    var aimPoint:CGPoint = CGPoint(x: 0.0,y: 0.0)
    
    var ButtonFlag:Bool = false
    var AllyFlag:Bool = false
    
    var timer:Timer?//enegy
    var enegy:Double = 10.0//enegy
    let enegyLabel = SKLabelNode()//enegy
    var enegyBar = SKSpriteNode(color: SKColor.blue, size: CGSize(width: 5.0, height: 50.0))//エナジーの量を表示
    
    let levelLabel = SKLabelNode()
    var level:Int = 0
    var exp:Int = 0
    
    var ally1  = SKSpriteNode(imageNamed: "monster3a")//allyの追加
    
    var enemy1 = SKSpriteNode(imageNamed: "monster2a")
    
    let enemyHpLabel = SKLabelNode()//enegy
    var enemyHpBar = SKSpriteNode(color: SKColor.red, size: CGSize(width: 0.5, height: 25.0))//エナジーの量を表示
    var enemyHp:Int = 500
    var enemyMaxHp:Int = 500
    
    //衝突判定のためのビットマスク作成
    struct PhysicsCategory {
        static let Emeny: UInt32 = 1
        static let Ball: UInt32 = 2
        static let Ally: UInt32 = 3
        static let Wall: UInt32 = 4
        static let Button: UInt32 = 5
    }
    
    override func didMove(to view: SKView) {
        
        self.size = CGSize(width: 414, height: 896)//414x896が最適。これはiphoneXRの画面サイズ
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        self.physicsWorld.contactDelegate = self //didBeginCOntactに必要
        
        Back.position = CGPoint(x: 0,y: 0)
        Back.anchorPoint = CGPoint(x: 0,y: 0)//ノードの位置配置などの起点を設定。
        Back.name = "Back"
        self.addChild(Back)
        
        WallLeft.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "WallLeft.png"), size: WallLeft.size)
        WallLeft.name = "WallLeft"
        WallLeft.physicsBody?.restitution = 1.0//反発値
        WallLeft.physicsBody?.isDynamic = false//ぶつかったときに移動するかどうか =>しない
        WallLeft.physicsBody?.categoryBitMask = PhysicsCategory.Wall //物体のカテゴリ次元をwall(4)
        WallLeft.physicsBody?.contactTestBitMask = PhysicsCategory.Ball //衝突を検知するカテゴリBall
        WallLeft.physicsBody?.collisionBitMask = PhysicsCategory.Ball //衝突させたい物体Ball
        WallLeft.position = CGPoint(x:103.5,y:448)
        WallLeft.userData = NSMutableDictionary()
        WallLeft.userData?.setValue( 0, forKey: "count")
        WallLeft.userData?.setValue( PhysicsCategory.Wall, forKey: "category")
        self.addChild(WallLeft)
        
        WallRight.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "WallRight.png"), size: WallRight.size)
        WallRight.name = "WallRight"
        WallRight.physicsBody?.restitution = 1.0//反発値
        WallRight.physicsBody?.isDynamic = false//ぶつかったときに移動するかどうか =>しない
        WallRight.physicsBody?.categoryBitMask = PhysicsCategory.Wall //物体のカテゴリ次元をwall(4)
        WallRight.physicsBody?.contactTestBitMask = PhysicsCategory.Ball //衝突を検知するカテゴリBall
        WallRight.physicsBody?.collisionBitMask = PhysicsCategory.Ball //衝突させたい物体Ball
        WallRight.position = CGPoint(x:310.5,y:448)
        WallRight.userData = NSMutableDictionary()
        WallRight.userData?.setValue( PhysicsCategory.Wall, forKey: "category")
        self.addChild(WallRight)
        
        Button.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Button.png"), size: Button.size)
        Button.name = "Button"
        Button.physicsBody?.restitution = 1.0//反発値
        Button.physicsBody?.isDynamic = false//ぶつかったときに移動するかどうか =>しない
        Button.physicsBody?.contactTestBitMask = 1//次元を1に設定(次元1の物体と反応)
        Button.position = CGPoint(x: 207,y: 240)//207,140が中心に相当近い
        Button.userData = NSMutableDictionary()
        Button.userData?.setValue( PhysicsCategory.Button, forKey: "category")
        self.addChild(Button)
        
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.timerupdate), userInfo: nil, repeats: true)
        
        enegyLabel.text = "0.0"// Labelに文字列を設定.
        enegyLabel.fontSize = 45// フォントサイズを設定.
        enegyLabel.fontColor = UIColor.blue// 色を指定(赤).
        enegyLabel.position = CGPoint(x: 100, y: 100)// 表示するポジションを指定.
        enegyLabel.text = "\(enegy)"
        self.addChild(enegyLabel)//シーンに追加
        
        enegyBar.anchorPoint = CGPoint(x: 0, y: 0)
        enegyBar.position = CGPoint(x: 150, y: 100)
        enegyBar.zPosition = 1
        enegyBar.xScale = CGFloat(enegy)//x方向の倍率
        self.addChild(enegyBar)
        
        ally1.name = "Ally1"
        ally1.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "monster3a"), size: ally1.size)
        ally1.physicsBody?.isDynamic = false
        ally1.physicsBody?.restitution = 1.0//反発値
        ally1.position = CGPoint(x: 207,y: 500)
        ally1.userData = NSMutableDictionary()
        ally1.userData?.setValue( PhysicsCategory.Ally, forKey: "category")
        ally1.userData?.setValue( 0, forKey: "level")//levelを追加
        ally1.physicsBody?.categoryBitMask = PhysicsCategory.Ally //物体のカテゴリ次元をally
        ally1.physicsBody?.contactTestBitMask = PhysicsCategory.Ball //衝突を検知するカテゴリBall
        ally1.physicsBody?.collisionBitMask = 0 //PhysicsCategory.Ball //衝突させたい物体＝＞なし
        self.addChild(ally1)
        
        levelLabel.text = "0.0"// Labelに文字列を設定.
        levelLabel.fontSize = 20// フォントサイズを設定.
        levelLabel.fontColor = UIColor.red// 色を指定(赤).
        levelLabel.position = CGPoint(x: ally1.position.x, y: ally1.position.y - 40)// 表示するポジションを指定.
        levelLabel.text = "level: \(level)"
        self.addChild(levelLabel)//シーンに追加
        
        enemy1.name = "Enemy1"
        enemy1.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "monster2a"), size: enemy1.size)
        enemy1.physicsBody?.isDynamic = false
        enemy1.physicsBody?.restitution = 1.0//反発値
        enemy1.position = CGPoint(x: 207,y: 750)
        enemy1.userData = NSMutableDictionary()
        enemy1.userData?.setValue( PhysicsCategory.Emeny, forKey: "category")
        enemy1.userData?.setValue( 0, forKey: "level")//levelを追加
        enemy1.physicsBody?.categoryBitMask = PhysicsCategory.Emeny //物体のカテゴリ次元をally
        enemy1.physicsBody?.contactTestBitMask = PhysicsCategory.Ball //衝突を検知するカテゴリBall
        enemy1.physicsBody?.collisionBitMask = 0 //PhysicsCategory.Ball //衝突させたい物体＝＞なし
        self.addChild(enemy1)
        
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
            }
            if self.atPoint(location).name == "Ally1"{
                AllyFlag = true
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first as UITouch? {
            let location = touch.location(in: self)
            if ButtonFlag {
                aimPoint.x = location.x
                aimPoint.y = location.y
                if enegy >= 3.0 {//エネルギー減らす分を確保。
                    enegy = enegy - 3.0//エネルギーを減らす。
                    self.enegyLabel.text = "\(enegy)"
                    self.enegyBar.xScale = CGFloat(enegy)//x方向の倍率
                    self.MakeBall()
                }
                ButtonFlag = false
            }
            if AllyFlag {
                AllyFlag = false
                if self.atPoint(location).name == "WallRight" || self.atPoint(location).name == "WallLeft" {
                    ally1.position = location
                    levelLabel.position = CGPoint(x: ally1.position.x, y: ally1.position.y - 40)// 表示するポジションを指定.
                    
                }else if self.self.atPoint(location).name == "Enemy1" {
                    enemyHp = enemyHp - 10 * level * level
                    if enemyHp <= 0 {
                        enemyHp = 0
                    }
                    enemyHpBar.xScale = CGFloat(enemyHp)//x方向の倍率hpゲージ
                    enemyHpLabel.text = "\(enemyHp) / \(enemyMaxHp)"
                    
                    switch level  {//可変レベル
                    case 0:
                        level = 0
                    case 1://123(3)
                        exp = exp - 1
                    case 2://4567(4)
                        exp = exp - 4
                    case 3://89101112(5)
                        exp = exp - 8
                    case 4://121314151617(6)
                        exp = exp - 12
                    case 5://18192021222324(7)
                        exp = exp - 18
                    case 6://2526272829303132(8)
                        exp = exp - 25
                    case 7://~max
                        exp = exp - 33
                    default:
                        print("default")
                    }
                    level = 0//レベルを０に戻す
                    levelLabel.text = "level: \(level)"
                    
                }
            }
            
        }
    }
    
    func MakeBall(){
        
        let Ball = SKSpriteNode(imageNamed: "tama2")
        
        Ball.physicsBody?.usesPreciseCollisionDetection = true//精度の高い衝突判定を行う。
        Ball.physicsBody?.friction = 0//摩擦係数を0にする
        Ball.name = "Ball"
        Ball.physicsBody?.isDynamic = true
        Ball.physicsBody?.restitution = 0.8 // 1.0にしたい。
        Ball.physicsBody?.allowsRotation = false
        Ball.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "tama2.png"), size: Ball.size)//Ball.size CGSize(width: 0,height: 30)
        Ball.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        Ball.color = UIColor.red
        Ball.physicsBody?.categoryBitMask = PhysicsCategory.Ball //物体のカテゴリ次元をBall
        Ball.physicsBody?.contactTestBitMask = PhysicsCategory.Wall //衝突を検知するカテゴリWall
        Ball.physicsBody?.collisionBitMask = PhysicsCategory.Wall //PhysicsCategory.Ball //衝突させたい物体＝＞なし
        Ball.position = CGPoint(x: 207,y: 320)//初期位置
        Ball.userData = NSMutableDictionary()
        Ball.userData?.setValue( 1, forKey: "count")
        Ball.userData?.setValue( PhysicsCategory.Ball, forKey: "category")
        
        self.addChild(Ball)//Ballを追加
        
        let pi:CGFloat = vector2radian(vector: CGPoint(x: originalPoint.x - aimPoint.x, y: originalPoint.y - aimPoint.y))
        
        let speed:Double = 2000.0 // 速さを設定
        Ball.physicsBody?.velocity = CGVector(dx: -speed * cos(Double(pi)),dy: -speed * sin(Double(pi)))//800の速さで球を飛ばす。
        
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
                        exp = exp + plusexp//可変経験値
                        nodeA.removeFromParent()
                    }else if nodeB.userData?.value(forKey: "category") as! UInt32 == PhysicsCategory.Ball {
                        let plusexp:Int = nodeB.userData?["count"] as! Int
                        exp = exp + plusexp//可変経験値
                        nodeB.removeFromParent()
                    }
                    
                    switch exp {//可変レベル制
                    case 0:
                        level = 0
                    case 1 ..< 4://123(3)
                        level = 1
                    case 4 ..< 8://4567(4)
                        level = 2
                    case 8 ..< 12://89101112(5)
                        level = 3
                    case 12 ..< 18://121314151617(6)
                        level = 4
                    case 18 ..< 25://18192021222324(7)
                        level = 5
                    case 21 ..< 28://2526272829303132(8)
                        level = 6
                    case 28 ..< 1000://~max
                        level = 7
                    default:
                        print("default")
                    }
                    
                    levelLabel.text = "level: \(level)"
                    levelLabel.position = CGPoint(x: ally1.position.x, y: ally1.position.y - 40)// 表示するポジションを指定.
                }
                
            }
        }
        
    }
    
    func length(v: CGPoint) -> CGFloat {
        return sqrt(v.x * v.x + v.y * v.y)//長さを測る。
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
    
    @objc func timerupdate(){
        
        if self.enegy < 30.0 {
            self.enegy = self.enegy + 2.0
            if enegy > 30.0 {
                enegy = 30.0
            }
        }
        enegyLabel.text = "\(self.enegy)"//enegyをラベルに表示
        enegyBar.xScale = CGFloat(enegy)//x方向の倍率
        
    }
    
    
}



