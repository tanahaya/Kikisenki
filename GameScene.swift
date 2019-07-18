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
    
    var count:Int = 0
    
    var enemyLifeGuage = SKSpriteNode()
    var enemyLifeGuageBase = SKSpriteNode()
    
    var originalPoint:CGPoint = CGPoint(x: 0.0,y: 0.0)
    var aimPoint:CGPoint = CGPoint(x: 0.0,y: 0.0)
    
    var ButtonFlag:Bool = false
    
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
        self.addChild(WallLeft)
        
        WallRight.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "WallRight.png"), size: WallRight.size)
        WallRight.name = "WallRight"
        WallRight.physicsBody?.restitution = 1.0//反発値
        WallRight.physicsBody?.isDynamic = false//ぶつかったときに移動するかどうか =>しない
        WallRight.physicsBody?.contactTestBitMask = 1//次元を1に設定(次元1の物体と反応)
        WallRight.position = CGPoint(x:310.5,y:448)
        self.addChild(WallRight)
        
        
        Button.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Button.png"), size: Button.size)
        Button.name = "Button"
        Button.physicsBody?.restitution = 1.0//反発値
        Button.physicsBody?.isDynamic = false//ぶつかったときに移動するかどうか =>しない
        Button.physicsBody?.contactTestBitMask = 1//次元を1に設定(次元1の物体と反応)
        Button.position = CGPoint(x: 207,y: 240)//207,140が中心に相当近い
        self.addChild(Button)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first as UITouch? {
            let location = touch.location(in: self)
            
            originalPoint.x = location.x
            originalPoint.x = location.y
            
            if self.atPoint(location).name == "Button" {
                //print("button tapped")
                ButtonFlag = true
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first as UITouch? {
            
            if ButtonFlag{
                
                let location = touch.location(in: self)
                aimPoint.x = location.x
                aimPoint.y = location.y
                self.MakeBall()
                
                ButtonFlag = false
                
            }
        }
    }
    
    func MakeBall(){
        
        let Ball = SKSpriteNode(imageNamed: "tama2")
        
        Ball.physicsBody?.usesPreciseCollisionDetection = true//精度の高い衝突判定を行う。
        Ball.physicsBody?.friction = 0//摩擦係数を0にする
        Ball.name = "Ball"
        Ball.physicsBody?.isDynamic = true
        Ball.physicsBody?.restitution = 0.1 // 1.0にしたい。
        
        Ball.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "tama2.png"), size: Ball.size)//Ball.size CGSize(width: 0,height: 30)
        Ball.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        Ball.color = UIColor.red
        Ball.physicsBody?.contactTestBitMask = 1//次元を1に設定(次元1の物体と反応)
        Ball.position = CGPoint(x:165,y:500)//初期位置
        Ball.userData = NSMutableDictionary()
        Ball.userData = ["count":0] as NSMutableDictionary
        
        self.addChild(Ball)//Ballを追加
        let pi:CGFloat = vector2radian(vector: CGPoint(x: originalPoint.x - aimPoint.x, y: originalPoint.y - aimPoint.y))
        
        Ball.physicsBody?.velocity = CGVector(dx: -500 * cos(Double(pi)),dy: -500 * sin(Double(pi)))//500の速さで球を飛ばす。
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {//衝突の処理
        
        if let nodeA = contact.bodyA.node {
            if let nodeB = contact.bodyB.node{
                if nodeA.name == "WallRight" || nodeA.name == "WallLeft" || nodeB.name == "WallRight" || nodeB.name == "WallLeft" {
                    count += 1
                    if nodeA.name == "Ball"{
                        var plusone:Int = nodeA.userData?["count"] as! Int
                        plusone = plusone + 1
                        nodeA.userData?.setValue( plusone, forKey: "count")
                        print((nodeA.userData?["count"])!)
                        if nodeA.userData?["count"] as! Int == 4 {
                            nodeA.removeFromParent()
                        }
                    }else if nodeB.name == "Ball"{
                        var plusone:Int = nodeB.userData?["count"] as! Int
                        plusone = plusone + 1
                        nodeB.userData?.setValue( plusone, forKey: "count")
                        print((nodeB.userData?["count"])!)
                        if nodeB.userData?["count"] as! Int == 4 {
                            nodeB.removeFromParent()
                        }
                    }
                    
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
    
    
}



