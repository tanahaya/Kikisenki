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
    
    let enemyHPLabel = SKLabelNode()//enegy
    var enemyHPBar = SKSpriteNode(color: SKColor.red, size: CGSize(width: 1.0, height: 25.0))//エナジーの量を表示
    var enemyHP:Int = 250
    
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
        WallLeft.physicsBody?.contactTestBitMask = 1//次元を1に設定(次元1の物体と反応)
        WallLeft.position = CGPoint(x:103.5,y:448)
        WallLeft.userData = NSMutableDictionary()
        WallLeft.userData?.setValue( 0, forKey: "count")
        WallLeft.userData?.setValue( PhysicsCategory.Wall, forKey: "category")
        self.addChild(WallLeft)
        
        WallRight.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "WallRight.png"), size: WallRight.size)
        WallRight.name = "WallRight"
        WallRight.physicsBody?.restitution = 1.0//反発値
        WallRight.physicsBody?.isDynamic = false//ぶつかったときに移動するかどうか =>しない
        WallRight.physicsBody?.contactTestBitMask = 1//次元を1に設定(次元1の物体と反応)
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
        enegyLabel.text = "\(CGFloat(enegy))"
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
        ally1.physicsBody?.contactTestBitMask = 2
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
        enemy1.physicsBody?.contactTestBitMask = 2
        self.addChild(enemy1)
        
        enemyHPLabel.text = "0.0"// Labelに文字列を設定.
        enemyHPLabel.fontSize = 25// フォントサイズを設定.
        enemyHPLabel.fontColor = UIColor.red// 色を指定(赤).
        enemyHPLabel.position = CGPoint(x: 75, y: 830)// 表示するポジションを指定.
        enemyHPLabel.text = "\(enemyHP) / 250"
        self.addChild(enemyHPLabel)//シーンに追加
        
        enemyHPBar.anchorPoint = CGPoint(x: 0, y: 0)
        enemyHPBar.position = CGPoint(x: 145, y: 830)
        enemyHPBar.zPosition = 1
        enemyHPBar.xScale = CGFloat(enemyHP)//x方向の倍率
        self.addChild(enemyHPBar)
        
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
                if self.atPoint(location).name == "Back" {
                    ally1.position = location
                    levelLabel.position = CGPoint(x: ally1.position.x, y: ally1.position.y - 40)// 表示するポジションを指定.
                    print("position:\(ally1.position)")
                    print("locaton:\(location)")
                }else if self.self.atPoint(location).name == "Enemy1" {
                    enemyHP = enemyHP - 10 * level * level
                    if enemyHP <= 0 {
                        enemyHP = 0
                    }
                    enemyHPBar.xScale = CGFloat(enemyHP)//x方向の倍率
                    enemyHPLabel.text = "\(enemyHP) / 250"
                    print("helloenemy")
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
        
        Ball.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "tama2.png"), size: Ball.size)//Ball.size CGSize(width: 0,height: 30)
        Ball.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        Ball.color = UIColor.red
        Ball.physicsBody?.contactTestBitMask = 1//次元を1に設定(次元1の物体と反応)
        Ball.position = CGPoint(x: 207,y: 320)//初期位置
        Ball.userData = NSMutableDictionary()
        Ball.userData?.setValue( 0, forKey: "count")
        Ball.userData?.setValue( PhysicsCategory.Ball, forKey: "category")
        
        self.addChild(Ball)//Ballを追加
        
        let pi:CGFloat = vector2radian(vector: CGPoint(x: originalPoint.x - aimPoint.x, y: originalPoint.y - aimPoint.y))
        
        let speed:Double = 1500.0 // 速さを設定
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
                        if nodeA.userData?["count"] as! Int == 4 {
                            nodeA.removeFromParent()
                        }
                    }else if nodeB.userData?.value(forKey: "category") as! UInt32 == PhysicsCategory.Ball{
                        var plusone:Int = nodeB.userData?["count"] as! Int
                        plusone = plusone + 1
                        nodeB.userData?.setValue( plusone, forKey: "count")
                        //print((nodeB.userData?["count"])!)
                        if nodeB.userData?["count"] as! Int == 4 {
                            nodeB.removeFromParent()
                        }
                    }
                }
                if nodeA.userData?.value(forKey: "category") as! UInt32 == PhysicsCategory.Ally && nodeB.userData?.value(forKey: "category") as! UInt32 == PhysicsCategory.Ball || nodeA.userData?.value(forKey: "category") as! UInt32 == PhysicsCategory.Ball && nodeB.userData?.value(forKey: "category") as! UInt32 == PhysicsCategory.Ally {
                    //ボールと味方が衝突した時の処理。本当は衝突処理だけして、すり抜けさせたい。
                    exp = exp + 1//可変経験値レベル
                    if level == 0 {
                        if exp == 1 {
                            level = level + 1
                        }
                    }else if level == 1{
                        if exp == 3 {
                            level = level + 1
                        }
                    }else if level == 2{
                        if exp == 6 {
                            level = level + 1
                        }
                    }else if level == 3{
                        if exp == 10 {
                            level = level + 1
                        }
                    }else if level == 4{
                        if exp == 15 {
                            level = level + 1
                        }
                    }else if level == 5{
                        if exp == 21 {
                            level = level + 1
                        }
                    }else if level == 6{
                        if exp == 28 {
                            level = level + 1
                        }
                    }else if level == 7{
                        //最大レベル
                    }
                    
                    levelLabel.text = "level: \(CGFloat(level))"
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
            self.enegy = self.enegy + 1.0
            if enegy > 30.0 {
                enegy = 30.0
            }
        }
        enegyLabel.text = "\(self.enegy)"//enegyをラベルに表示
        enegyBar.xScale = CGFloat(enegy)//x方向の倍率
        
    }
    
    
}



