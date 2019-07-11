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
    
    //let Ball = SKSpriteNode(color: UIColor.red, size: CGSize(width: 30.0, height:  30.0))
    var Ball = SKSpriteNode(imageNamed: "Ball")
    var Back = SKSpriteNode(imageNamed: "Back")
    
    
    override func didMove(to view: SKView) {
        Back.position = CGPoint(x: 0,y: 0)
        Back.anchorPoint = CGPoint(x: 0,y: 0)//ノードの位置配置などの起点を設定。
        self.addChild(Back)
        
        self.size = CGSize(width: 414, height: 896)//414x896が最適。これはiphoneXRの画面サイズ
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        self.physicsWorld.contactDelegate = self //didBeginCOntactに必要
        self.MakeBall()
        
        WallLeft.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "WallLeft.png"), size: WallLeft.size)
        WallLeft.physicsBody?.restitution = 1.0//反発値
        WallLeft.physicsBody?.isDynamic = false//ぶつかったときに移動するかどうか =>しない
        WallLeft.physicsBody?.contactTestBitMask = 1//次元を1に設定(次元1の物体と反応)
        WallLeft.position = CGPoint(x:103.5,y:448)
        self.addChild(WallLeft)
        
        WallRight.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "WallRight.png"), size: WallRight.size)
        WallRight.physicsBody?.restitution = 1.0//反発値
        WallRight.physicsBody?.isDynamic = false//ぶつかったときに移動するかどうか =>しない
        WallRight.physicsBody?.contactTestBitMask = 1//次元を1に設定(次元1の物体と反応)
        WallRight.position = CGPoint(x:310.5,y:448)
        self.addChild(WallRight)
        
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    func MakeBall(){
        let BallSprite = SKSpriteNode(imageNamed: "Ball")
        Ball.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Ball.png"), size: Ball.size)
        //Ball.physicsBody = SKPhysicsBody(circleOfRadius: 15)
        Ball.physicsBody?.contactTestBitMask = 1//次元を1に設定(次元1の物体と反応)
        Ball.position = CGPoint(x:165,y:300)//初期いち
        self.addChild(Ball)//Ballを追加
    }
    
    
}



