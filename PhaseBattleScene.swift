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
    
    
    let numberLabel = SKLabelNode()//フェイズの時間を表示する。
    let phaseLabel = SKLabelNode()//フェイズを表示する。
    let waveLabel = SKLabelNode()//waveを表示する。
    
    var waveNumber:Int = 0
    var maxWaveNumber:Int = 0
    
    var Stage:[[Enemy]] = []
    
    var MainTimer:Timer?
    var phasenumber:Int = 0
    var phaseFlag = true //trueならMovePhase.falseならAttackPhase
    
    var Background = SKSpriteNode(color: UIColor.white, size: CGSize(width:  876.0, height: 334.0))//skill1の四角
    
    //ally1ここから
    var ally1  = Ally(imageNamed: "monster1a")//allyの追加
    var MoveMarker1 = SKSpriteNode(imageNamed: "movemarker1")//ally1のmovemader
    var ally1GradeIcon = SKSpriteNode(imageNamed: "gradeicon")
    let ally1GradeLabel = SKLabelNode()
    
    var ally1HpBar = SKSpriteNode(color: UIColor.green, size: CGSize(width: 40.0, height: 10.0))//味方のhpの量を表示
    var ally1HpBarBack = SKSpriteNode(color: UIColor.black, size: CGSize(width: 45.0, height: 14.0))//味方のhpの量を表示
    
    var ally1Skill1 = SKSpriteNode(imageNamed: "ally1skill1")//skill1の四角
    var ally1Skill2 = SKSpriteNode(imageNamed: "ally1skill2")//skill2の四角
    var ally1Skill3 = SKSpriteNode(imageNamed: "ally1skill3")//skill3の四角
    var ally1Skill4 = SKSpriteNode(imageNamed: "ally1skill4")//skill4の四角
    var ally1Skill5 = SKSpriteNode(color: UIColor.green, size: CGSize(width: 50.0, height: 50.0))//skill4の四角
    var ally1SkilledFlag = true //スキルを使ったかどうかを判定するflag
    
    var Ally1Flag = true
    var MoveMarker1Flag = true
    //ally1ここまで
    
    //ally2ここから
    var ally2  = Ally(imageNamed: "monster2a")//allyの追加
    var MoveMarker2 = SKSpriteNode(imageNamed: "movemarker2")//ally2のmovemader
    var ally2GradeIcon = SKSpriteNode(imageNamed: "gradeicon")
    let ally2GradeLabel = SKLabelNode()
    
    var ally2HpBar = SKSpriteNode(color: UIColor.green, size: CGSize(width: 40.0, height: 10.0))//味方のhpの量を表示
    var ally2HpBarBack = SKSpriteNode(color: UIColor.black, size: CGSize(width: 45.0, height: 14.0))//味方のhpの量を表示
    
    var ally2Skill1 = SKSpriteNode(imageNamed: "ally2skill1")//skill1の四角
    var ally2Skill2 = SKSpriteNode(imageNamed: "ally2skill2")//skill2の四角
    var ally2Skill3 = SKSpriteNode(imageNamed: "ally2skill3")//skill3の四角
    var ally2Skill4 = SKSpriteNode(imageNamed: "ally2skill4")//skill4の四角
    var ally2Skill5 = SKSpriteNode(color: UIColor.green, size: CGSize(width: 50.0, height: 50.0))//skill4の四角
    var ally2SkilledFlag = true //スキルを使ったかどうかを判定するflag
    
    var Ally2Flag = true
    var MoveMarker2Flag = true
    //ally2ここまで
    
    //ally3ここから
    var ally3  = Ally(imageNamed: "monster3a")//allyの追加
    var MoveMarker3 = SKSpriteNode(imageNamed: "movemarker3")//ally3のmovemader
    var ally3GradeIcon = SKSpriteNode(imageNamed: "gradeicon")
    let ally3GradeLabel = SKLabelNode()
    
    var ally3HpBar = SKSpriteNode(color: UIColor.green, size: CGSize(width: 40.0, height: 10.0))//味方のhpの量を表示
    var ally3HpBarBack = SKSpriteNode(color: UIColor.black, size: CGSize(width: 45.0, height: 14.0))
    
    var ally3Skill1 = SKSpriteNode(imageNamed: "ally3skill1")//skill1の四角
    var ally3Skill2 = SKSpriteNode(imageNamed: "ally3skill2")//skill2の四角
    var ally3Skill3 = SKSpriteNode(imageNamed: "ally3skill3")//skill3の四角
    var ally3Skill4 = SKSpriteNode(imageNamed: "ally3skill4")//skill4の四角
    var ally3Skill5 = SKSpriteNode(color: UIColor.green, size: CGSize(width: 50.0, height: 50.0))//skill4の四角
    var ally3SkilledFlag = true //スキルを使ったかどうかを判定するflag
    
    var Ally3Flag = true
    var MoveMarker3Flag = true
    //ally3ここまで
    
    var AllyArray:[Ally] = []
    
    var EnemyArray:[Enemy] = []
    
    var LeftWall = SKSpriteNode(color: UIColor.black, size: CGSize(width: 10, height: 334))
    var RightWall = SKSpriteNode(color: UIColor.black, size: CGSize(width: 10, height: 334))
    var UpperWall = SKSpriteNode(color: UIColor.black, size: CGSize(width: 896, height: 10))
    var LowerWall = SKSpriteNode(color: UIColor.black, size: CGSize(width: 896, height: 10))
    
    //Itemの数を管理する。
    var ItemCount:Int = 1
    
    var stopActionFlag:Bool = false
    var stopActionNumber = 0
    var aimPosition:CGPoint = CGPoint(x:0,y:0)
    
    let userDefaults = UserDefaults.standard//ダメージ管理用のuserdefaults
    
    //衝突判定のためのビットマスク作成
    struct PhysicsCategory {
        
        static let Enemy: UInt32 = 1
        static let Ally: UInt32 = 2
        static let Bullet: UInt32 = 3//ally用の弾
        static let Wall: UInt32 = 4
        static let Item: UInt32 = 5
        static let Charge: UInt32 = 6
        static let eBullet: UInt32 = 7//enemy用の弾
        
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
        
        waveLabel.fontSize = 35// フォントサイズを設定.
        waveLabel.fontColor = UIColor.black// 色を指定(青).
        waveLabel.position = CGPoint(x: 748, y: 364)// 表示するポジションを指定.今回は中央
        waveLabel.text = "wave: \(waveNumber) / \(maxWaveNumber) "
        self.addChild(waveLabel)//シーンに追加
        
        
        self.MainTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.mainTimerupdate), userInfo: nil, repeats: true)
        
        //四つの壁
        self.makeWall()

        //ally1の処理
        self.makeAlly1()
        AllyArray.append(ally1)
        
        //ally2の処理
        self.makeAlly2()
        AllyArray.append(ally2)
        
        //ally3の処理
        self.makeAlly3()
        AllyArray.append(ally3)
        
        
        Stage = self.makeStage(stage: 1)
        
        self.addEnemy()
        
        self.start() //始める時の処理

        
    }
    
    @objc func mainTimerupdate() {
        
        //phaseの切り替えの処理。
        phasenumber = phasenumber + 1
        numberLabel.text = "\( Float(30 - phasenumber) / 10)"
        
        if phasenumber == 30 {
            
            phasenumber = 0
            
            if phaseFlag { //Attackphaseに切り替わる時。
                
                phaseFlag = false
                phaseLabel.text = "AttackPhase"
                
                MoveMarker1.position = ally1.position
                MoveMarker1.alpha = 0.0
                
                MoveMarker2.position = ally2.position
                MoveMarker2.alpha = 0.0
                
                MoveMarker3.position = ally3.position
                MoveMarker3.alpha = 0.0
                
                ally1SkilledFlag = true
                ally2SkilledFlag = true
                ally3SkilledFlag = true
                
                
            }else { //Movephaseに切り替わる時。
                
                phaseFlag = true
                phaseLabel.text = "MovePhase"
                
                ally1Skill1.alpha = 0.0
                ally1Skill2.alpha = 0.0
                ally1Skill3.alpha = 0.0
                ally1Skill4.alpha = 0.0
                ally1Skill5.alpha = 0.0
                
                ally2Skill1.alpha = 0.0
                ally2Skill2.alpha = 0.0
                ally2Skill3.alpha = 0.0
                ally2Skill4.alpha = 0.0
                ally2Skill5.alpha = 0.0
                
                ally3Skill1.alpha = 0.0
                ally3Skill2.alpha = 0.0
                ally3Skill3.alpha = 0.0
                ally3Skill4.alpha = 0.0
                ally3Skill5.alpha = 0.0
                
                if ItemCount <= 3 {
                    
                    ItemCount = ItemCount + 1
                    
                    if Int.random(in: 0 ..< 2) == 0 { //毎ターン回復アイテムかgradeupアイテムがフィールドに現れる。
                        
                        print("makeheart")
                        //makeheart
                        var heartX = 0
                        var heartY = 0
                        
                        repeat { // repeat-while文のため、この処理は最低1回実行される
                            
                            heartX = Int.random(in: 0 ..< 816)
                            heartY = Int.random(in: 0 ..< 254)
                            
                        } while(overlap(location: CGPoint(x: heartX,y: heartY)))
                        
                        self.makeHeart(x: heartX, y: heartY)
                        
                    } else {
                        
                        print("makegrade")
                        
                        //gradeupItem
                        var gradeupX = 0
                        var gradeupY = 0
                        
                        repeat { // repeat-while文のため、この処理は最低1回実行される
                            
                            gradeupX = Int.random(in: 0 ..< 816)
                            gradeupY = Int.random(in: 0 ..< 254)
                            
                        } while(overlap(location: CGPoint(x: gradeupX,y: gradeupY)))
                        
                        self.makeGradeupItem(x: gradeupX, y: gradeupY)
                        
                    }
                    
                }
                
            }//movephaze
        }
        
        //移動の処理
        if phaseFlag {
            
            if ally1.moveEnable {
                
                if ally1.position == MoveMarker1.position {//ally1の移動系の処理
                    
                    MoveMarker1.alpha = 0.0
                    
                } else {
                    
                    var relativepostion:CGPoint = CGPoint(x: 0,y: 0)
                    
                    relativepostion.x = MoveMarker1.position.x - ally1.position.x
                    relativepostion.y = MoveMarker1.position.y - ally1.position.y
                    
                    let direction :CGFloat = vector2radian(vector: relativepostion)
                    
                    if Ally1Flag || MoveMarker1Flag {
                        
                    } else {
                        
                        if length(v: relativepostion) <= 30 {//相対位置の距離が6以下の場合、位置を同じにする。
                            
                            ally1.position = MoveMarker1.position
                            MoveMarker1.alpha = 0.0
                            
                        }else{//違う場合距離にして3づつ近づく。
                            
                            let speed:Double = 15.0 //移動速度を決定する。一時的の移動速度を上昇させております。
                            let travelTime = SKAction.move( to: CGPoint(x: ally1.position.x - CGFloat( speed * cos(Double(direction))),y: ally1.position.y
                                + CGFloat( speed * sin(Double(direction)))), duration: 0.01)
                            ally1.run(travelTime)
                            
                        }
                        
                    }
                }
                
            } else {
                
            }
            
            if ally2.moveEnable {
                
                if ally2.position == MoveMarker2.position {//ally2の移動系の処理
                    
                    MoveMarker2.alpha = 0.0
                    
                } else {
                    
                    var relativepostion:CGPoint = CGPoint(x: 0,y: 0)
                    
                    relativepostion.x = MoveMarker2.position.x - ally2.position.x
                    relativepostion.y = MoveMarker2.position.y - ally2.position.y
                    
                    let direction :CGFloat = vector2radian(vector: relativepostion)
                    
                    if Ally2Flag || MoveMarker2Flag {
                        
                    } else {
                        
                        if length(v: relativepostion) <= 30 {//相対位置の距離が6以下の場合、位置を同じにする。
                            
                            ally2.position = MoveMarker2.position
                            MoveMarker2.alpha = 0.0
                            
                        }else{//違う場合距離にして3づつ近づく
                            
                            let travelTime = SKAction.move( to: CGPoint(x: ally2.position.x - CGFloat( 15 * cos(Double(direction))),y: ally2.position.y
                                + CGFloat( 15 * sin(Double(direction)))), duration: 0.01)
                            ally2.run(travelTime)
                            
                        }
                        
                    }
                }
                
            } else {
                
            }
            
            if ally3.moveEnable {
                
                if ally3.position == MoveMarker3.position {//ally3の移動系の処理
                    
                    MoveMarker3.alpha = 0.0
                    
                } else {
                    
                    var relativepostion:CGPoint = CGPoint(x: 0,y: 0)
                    
                    relativepostion.x = MoveMarker3.position.x - ally3.position.x
                    relativepostion.y = MoveMarker3.position.y - ally3.position.y
                    
                    let direction :CGFloat = vector2radian(vector: relativepostion)
                    
                    if Ally3Flag || MoveMarker3Flag {
                        
                    } else {
                        
                        if length(v: relativepostion) <= 6 {//相対位置の距離が6以下の場合、位置を同じにする。
                            
                            ally3.position = MoveMarker3.position
                            MoveMarker3.alpha = 0.0
                            
                        }else{//違う場合距離にして3づつ近づく
                            
                            let travelTime = SKAction.move( to: CGPoint(x: ally3.position.x - CGFloat( 3 * cos(Double(direction))),y: ally3.position.y
                                + CGFloat( 3 * sin(Double(direction)))), duration: 0.01)
                            ally3.run(travelTime)
                            
                        }
                        
                    }
                }
                
            } else {
                
            }
            
            if phasenumber == 20 {
                
                self.EnemyAttack()
                
            }
            
        } else {//Attackphaseの時のタイマー
            
            //敵の移動の処理を行う。
            self.EnemyMove()
            
        }
        
        
    }
    
    func start(){//ゲームを開始するときに呼ばれるメソッド。
        
        phaseFlag = true
        stopActionFlag = false
        
        Ally1Flag = false
        MoveMarker1Flag = false
        ally1SkilledFlag = true
        
        Ally2Flag = false
        MoveMarker2Flag = false
        ally2SkilledFlag = true
        
        Ally3Flag = false
        MoveMarker3Flag = false
        ally3SkilledFlag = true
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first as UITouch? {
            let location = touch.location(in: self)
            
            if stopActionFlag {//途中動作
                
                aimPosition = location
                self.StopAction(actionNumber: 0)
                
            } else {
                if self.atPoint(location).name == "Ally1"{
                    Ally1Flag = true
                }
                if self.atPoint(location).name == "MoveMarker1"{
                    MoveMarker1Flag = true
                }
                
                if self.atPoint(location).name == "Ally2"{
                    Ally2Flag = true
                }
                if self.atPoint(location).name == "MoveMarker2"{
                    MoveMarker2Flag = true
                }
                
                if self.atPoint(location).name == "Ally3"{
                    Ally3Flag = true
                }
                if self.atPoint(location).name == "MoveMarker3"{
                    MoveMarker3Flag = true
                }
                
                if self.atPoint(location).name == "gameclear"{
                    self.gotoSelectScene()
                }
                if self.atPoint(location).name == "gameover"{
                    self.gotoSelectScene()
                }
                
            }
            
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first as UITouch? {
            let location = touch.location(in: self)
            
            //ally1の処理
            if Ally1Flag {
                
                if phaseFlag {//movephaseの時
                    
                    MoveMarker1.alpha = 1.0
                    MoveMarker1.position = location
                    
                } else {//Attackphaseの時
                    
                    if ally1SkilledFlag {
                        
                        ally1Skill1.alpha = 1.0
                        
                        ally1Skill2.alpha = 1.0
                        
                        if ally1.grade! <= 2 {//グレードを上昇させる技のため、グレードが上限の時は表示しない。(grade==3で上限)
                            
                            ally1Skill3.alpha = 1.0
                            
                        }
                        
                        ally1Skill4.alpha = 1.0
                        
                        if ally1.grade! == 5 {//必殺技のため、グレード最大の時のみ使用できる。
                            
                            ally1Skill5.alpha = 1.0
                        }
                        
                    } else {
                        
                    }
                }
                
            }
            
            if MoveMarker1Flag {
                
                MoveMarker1.alpha = 1.0
                MoveMarker1.position = location
                    
            }
            
            //ally2の処理
            if Ally2Flag {
                
                if phaseFlag {//movephaseの時
                    
                    MoveMarker2.alpha = 1.0
                    MoveMarker2.position = location
                    
                } else {//Attackphaseの時
                    if ally2SkilledFlag {
                        
                        ally2Skill1.alpha = 1.0
                        
                        ally2Skill2.alpha = 1.0
                        
                        ally2Skill3.alpha = 1.0
                        
                        ally2Skill4.alpha = 1.0
                        
                        if ally2.grade! == 5 {//必殺技のため、グレード最大の時のみ使用できる。
                            
                            ally2Skill5.alpha = 1.0
                            
                        }
                        
                    } else {
                        
                    }
                }
                
            }
            
            if MoveMarker2Flag {
                
                MoveMarker2.alpha = 1.0
                MoveMarker2.position = location
                
            }
            
            //ally3の処理
            if Ally3Flag {
                
                if phaseFlag {//movephaseの時
                    
                    MoveMarker3.alpha = 1.0
                    MoveMarker3.position = location
                    
                } else {//Attackphaseの時
                    if ally3SkilledFlag {
                        
                        ally3Skill1.alpha = 1.0
                        
                        ally3Skill2.alpha = 1.0
                        
                        ally3Skill3.alpha = 1.0
                        
                        ally3Skill4.alpha = 1.0
                        
                        if ally3.grade! == 5 {//必殺技のため、グレード最大の時のみ使用できる。
                            
                            ally3Skill5.alpha = 1.0
                            
                        }
                        
                    } else {
                        
                    }
                }
                
            }
            
            if MoveMarker3Flag {
                
                MoveMarker3.alpha = 1.0
                MoveMarker3.position = location
                
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
                        
                        if self.atPoint(location).name == "ally1Skill1" {//skill1の発動。弾の発射。
                            
                            //Bullet作成
                            
                            let bullet = Bullet(imageNamed: "Back")
                            
                            bullet.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Back"), size: bullet.size)
                            bullet.xScale = 0.03
                            bullet.yScale = 0.01
                            bullet.position = CGPoint(x: ally1.position.x,y: ally1.position.y) //生成位置の設定
                            bullet.name  = "bullet"
                            bullet.userData = NSMutableDictionary()
                            bullet.userData?.setValue( PhysicsCategory.Bullet, forKey: "category")
                            
                            if ally1.grade! == 1 {
                                print("ally1Skill1")
                                bullet.damage = 60
                            } else if ally1.grade! == 2 {
                                print("ally1Skill1G2")
                                bullet.damage = 300
                                
                            } else if ally1.grade! == 3 {
                                print("ally1Skill1G3")
                                bullet.damage = 600
                            }
                            
                            ally1.grade! = 1//gradeをリセットする。
                            ally1GradeLabel.text = "\(ally1.grade!)"
                            
                            bullet.damage = 1000  //400
                            
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
                        
                        if self.atPoint(location).name == "ally1Skill2" {//skill2の発動。一番近い的に攻撃
                            
                            var shortestDistance:CGFloat = 50000.0 //大きい数字をとりあえず、代入します。
                            var savei:Int = 0
                            
                            for i in 0 ..< EnemyArray.count {
                                if shortestDistance >= length(v: CGPoint(x: ally1.position.x - EnemyArray[i].position.x,y: ally1.position.y - EnemyArray[i].position.y)) {
                                    shortestDistance = length(v: CGPoint(x: ally1.position.x - EnemyArray[i].position.x,y: ally1.position.y - EnemyArray[i].position.y))
                                    savei = i
                                }
                            }
                            
                            print("targetenemy: \(EnemyArray[savei].id!)")
                            
                            if ally1.grade! == 1 {
                                print("ally2Skill1")
                                self.changeEnemyHp(change: -( 50 + Int( 0.25 * shortestDistance )), id: EnemyArray[savei].id!)
                                self.damageEffect(damageposition: EnemyArray[savei].position, damage: -( 50 + Int( 0.25 * shortestDistance )))
                            } else if ally1.grade! == 2 {
                                print("ally2Skill1G1")
                                self.changeEnemyHp(change: -( 200 + Int( shortestDistance )), id: EnemyArray[savei].id!)
                                self.damageEffect(damageposition: EnemyArray[savei].position, damage: -( 200 + Int(shortestDistance )))
                            } else if ally1.grade! == 3 {
                                print("ally2Skill1G2")
                                self.changeEnemyHp(change: -3000, id: EnemyArray[savei].id!)
                                self.damageEffect(damageposition: EnemyArray[savei].position, damage: -3000)
                            }
                            
                            ally1.grade! = 1//gradeをリセットする。
                            ally1GradeLabel.text = "\(ally1.grade!)"
                            
                            ally1SkilledFlag = false
                            
                        }
                        
                        if self.atPoint(location).name == "ally1Skill3" {//skill3の発動。グレードの上昇。
                            
                            print("ally1Skill3")
                            
                            if ally1.grade! <= 2 {
                                ally1.grade! = ally1.grade! + 1
                            }
                            ally1GradeLabel.text = "\(ally1.grade!)"
                            
                            ally1SkilledFlag = false
                            
                        }
                        
                        if self.atPoint(location).name == "ally1Skill4" {//skill4の発動
                            
                            if MainTimer?.isValid == true {
                                MainTimer?.invalidate()
                            }
                            
                            stopActionFlag = true
                            stopActionNumber = 0
                            
                            ally1SkilledFlag = false
                            
                        }
                        
                        if self.atPoint(location).name == "ally1Skill5" {//skill5の発動。必殺技
                            
                            print("ally1Skill5")
                            ally1SkilledFlag = false
                            
                        }
                        
                    } else {
                        
                    }
                }
                
                ally1Skill1.alpha = 0.0//name判定より後にしないと判定がされなくなる。
                ally1Skill2.alpha = 0.0
                ally1Skill3.alpha = 0.0
                ally1Skill4.alpha = 0.0
                ally1Skill5.alpha = 0.0
                
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
            
            //ally2
            if Ally2Flag {//味方を最初に触った時。
                
                Ally2Flag = false
                
                
                if phaseFlag {//movephase
                    
                    if self.rangeofField(minX: 10, maxX: 886, minY: 10, maxY: 344, location: location) {
                        
                        MoveMarker2.position = location
                        
                    } else {
                        MoveMarker2.position = ally2.position
                        MoveMarker2.alpha = 0.0
                    }
                    
                } else {//Attackphase
                    
                    if ally2SkilledFlag {
                        
                        if self.atPoint(location).name == "ally2Skill1" {//skill1の発動。手裏剣を四方に放つ。
                            
                            //Bullet作成
                            
                            let syuriken1 = Bullet(imageNamed: "Back")
                            
                            syuriken1.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Back"), size: syuriken1.size)
                            syuriken1.xScale = 0.03
                            syuriken1.yScale = 0.01
                            syuriken1.position = CGPoint(x: ally2.position.x,y: ally2.position.y) //生成位置の設定
                            syuriken1.name  = "syuriken"
                            syuriken1.userData = NSMutableDictionary()
                            syuriken1.userData?.setValue( PhysicsCategory.Bullet, forKey: "category")
                            syuriken1.damage = 60
                            syuriken1.physicsBody?.categoryBitMask = PhysicsCategory.Bullet //衝突判定に使用する値の設定
                            syuriken1.physicsBody?.collisionBitMask = PhysicsCategory.Enemy
                            syuriken1.physicsBody?.contactTestBitMask = PhysicsCategory.Bullet
                            
                            self.addChild(syuriken1)//Bullet表示
                            
                            let action1 = SKAction.move(to: CGPoint(x: ally2.position.x + 200, y: ally2.position.y + 200), duration: 0.5)//右上
                            let backaction = SKAction.move(to: CGPoint(x: ally2.position.x, y: ally2.position.y), duration: 0.5)
                            let actionDone = SKAction.removeFromParent()
                            syuriken1.run(SKAction.sequence([action1,backaction,actionDone]))
                            
                            let syuriken2 = Bullet(imageNamed: "Back")
                            
                            syuriken2.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Back"), size: syuriken1.size)
                            syuriken2.xScale = 0.03
                            syuriken2.yScale = 0.01
                            syuriken2.position = CGPoint(x: ally2.position.x,y: ally2.position.y) //生成位置の設定
                            syuriken2.name  = "syuriken"
                            syuriken2.userData = NSMutableDictionary()
                            syuriken2.userData?.setValue( PhysicsCategory.Bullet, forKey: "category")
                            syuriken2.damage = 60
                            syuriken2.physicsBody?.categoryBitMask = PhysicsCategory.Bullet //衝突判定に使用する値の設定
                            syuriken2.physicsBody?.collisionBitMask = PhysicsCategory.Enemy
                            syuriken2.physicsBody?.contactTestBitMask = PhysicsCategory.Bullet
                            
                            self.addChild(syuriken2)//Bullet表示
                            
                            let action2 = SKAction.move(to: CGPoint(x: ally2.position.x + 200, y: ally2.position.y - 200), duration: 0.5)//右下
                            syuriken2.run(SKAction.sequence([action2,backaction,actionDone]))
                            
                            let syuriken3 = Bullet(imageNamed: "Back")
                            
                            syuriken3.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Back"), size: syuriken1.size)
                            syuriken3.xScale = 0.03
                            syuriken3.yScale = 0.01
                            syuriken3.position = CGPoint(x: ally2.position.x,y: ally2.position.y) //生成位置の設定
                            syuriken3.name  = "syuriken"
                            syuriken3.userData = NSMutableDictionary()
                            syuriken3.userData?.setValue( PhysicsCategory.Bullet, forKey: "category")
                            syuriken3.damage = 60
                            syuriken3.physicsBody?.categoryBitMask = PhysicsCategory.Bullet //衝突判定に使用する値の設定
                            syuriken3.physicsBody?.collisionBitMask = PhysicsCategory.Enemy
                            syuriken3.physicsBody?.contactTestBitMask = PhysicsCategory.Bullet
                            
                            self.addChild(syuriken3)//Bullet表示
                            
                            let action3 = SKAction.move(to: CGPoint(x: ally2.position.x - 200, y: ally2.position.y + 200), duration: 0.5)//左上
                            syuriken3.run(SKAction.sequence([action3,backaction,actionDone]))
                            
                            let syuriken4 = Bullet(imageNamed: "Back")
                            
                            syuriken4.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Back"), size: syuriken1.size)
                            syuriken4.xScale = 0.03
                            syuriken4.yScale = 0.01
                            syuriken4.position = CGPoint(x: ally2.position.x,y: ally2.position.y) //生成位置の設定
                            syuriken4.name  = "syuriken"
                            syuriken4.userData = NSMutableDictionary()
                            syuriken4.userData?.setValue( PhysicsCategory.Bullet, forKey: "category")
                            syuriken4.damage = 60
                            syuriken4.physicsBody?.categoryBitMask = PhysicsCategory.Bullet //衝突判定に使用する値の設定
                            syuriken4.physicsBody?.collisionBitMask = PhysicsCategory.Enemy
                            syuriken4.physicsBody?.contactTestBitMask = PhysicsCategory.Bullet
                            
                            self.addChild(syuriken4)//Bullet表示
                            
                            let action4 = SKAction.move(to: CGPoint(x: ally2.position.x - 200, y: ally2.position.y - 200), duration: 0.5)//左下
                            syuriken4.run(SKAction.sequence([action4,backaction,actionDone]))
                            
                            if ally2.grade! == 1 {
                                print("ally2Skill1")
                                syuriken1.damage = 60
                                syuriken2.damage = 60
                                syuriken3.damage = 60
                                syuriken4.damage = 60
                            } else if ally2.grade! == 2 {
                                print("ally2Skill1G2")
                                syuriken1.damage = 200
                                syuriken2.damage = 200
                                syuriken3.damage = 200
                                syuriken4.damage = 200
                            } else if ally2.grade! == 3 {
                                print("ally2Skill1G3")
                                syuriken1.damage = 500
                                syuriken2.damage = 500
                                syuriken3.damage = 500
                                syuriken4.damage = 500
                            }
                            
                            ally2.grade! = 1 //gradeをリセットする。
                            ally2GradeLabel.text = "\(ally2.grade!)"
                            
                            ally2SkilledFlag = false//Skillを使ったこと判定
                            
                        }
                        
                        if self.atPoint(location).name == "ally2Skill2" {//skill2の発動。範囲内の敵を全員攻撃する。
                            
                            
                            for i in 0 ..< EnemyArray.count {
                                if 300 >= length(v: CGPoint(x: ally2.position.x - EnemyArray[i].position.x,y: ally2.position.y - EnemyArray[i].position.y)) {
                                    
                                    if ally2.grade! == 1 {
                                        print("ally2Skill2")
                                        self.changeEnemyHp(change: -80, id: EnemyArray[i].id!)
                                        self.damageEffect(damageposition: EnemyArray[i].position, damage: -80 )
                                    } else if ally2.grade! == 2 {
                                        print("ally2Skill2G2")
                                        self.changeEnemyHp(change: -250, id: EnemyArray[i].id!)
                                        self.damageEffect(damageposition: EnemyArray[i].position, damage: -250 )
                                    } else if ally2.grade! == 3 {
                                        print("ally2Skill2G3")
                                        self.changeEnemyHp(change: -1400, id: EnemyArray[i].id!)
                                        self.damageEffect(damageposition: EnemyArray[i].position, damage: -1400 )
                                    }
                                    
                                    ally2.grade! = 1 //gradeをリセットする。
                                    ally2GradeLabel.text = "\(ally2.grade!)"
                                    
                                    
                                }
                            }
                            
                            ally2SkilledFlag = false
                            
                        }
                        
                        if self.atPoint(location).name == "ally2Skill3" {//skill3の発動。毒霧で攻撃する。敵のグレードを下げる。実装途中。
                            
                            
                            let poison = Bullet(imageNamed: "Back")
                            
                            poison.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Back"), size: poison.size)
                            poison.xScale = 0.03
                            poison.yScale = 0.01
                            poison.position = CGPoint(x: ally2.position.x,y: ally2.position.y) //生成位置の設定
                            poison.name  = "poison"
                            poison.userData = NSMutableDictionary()
                            poison.userData?.setValue( PhysicsCategory.Bullet, forKey: "category")
                            poison.damage = 30
                            poison.physicsBody?.categoryBitMask = PhysicsCategory.Bullet //衝突判定に使用する値の設定
                            poison.physicsBody?.collisionBitMask = PhysicsCategory.Enemy
                            poison.physicsBody?.contactTestBitMask = PhysicsCategory.Bullet
                            
                            self.addChild(poison)//Bullet表示
                            
                            let action = SKAction.moveTo(x: self.size.width, duration: 1.0)//アクション作成(移動方向:Y,移動時間:1.0秒)
                            let actionDone = SKAction.removeFromParent()
                            poison.run(SKAction.sequence([action,actionDone]))
                            
                            ally2SkilledFlag = false
                            
                        }
                        
                        if self.atPoint(location).name == "ally2Skill4" {//skill4の発動
                            
                            print("ally2Skill4")
                            
                            //makeheart
                            var heartX = 0
                            var heartY = 0
                            
                            repeat { // repeat-while文のため、この処理は最低1回実行される
                                
                                heartX = Int.random(in: 0 ..< 816)
                                heartY = Int.random(in: 0 ..< 254)
                                
                            } while(overlap(location: CGPoint(x: heartX,y: heartY)))
                            
                            self.makeHeart(x: heartX, y: heartY)
                            
                            ally2SkilledFlag = false
                            
                        }
                        
                        if self.atPoint(location).name == "ally2Skill5" {//skill5の発動。必殺技
                            
                            print("ally2Skill5")
                            ally2SkilledFlag = false
                            
                        }
                        
                    } else {
                        
                    }
                }
                
                ally2Skill1.alpha = 0.0//name判定より後にしないと判定がされなくなる。
                ally2Skill2.alpha = 0.0
                ally2Skill3.alpha = 0.0
                ally2Skill4.alpha = 0.0
                ally2Skill5.alpha = 0.0
                
            }
            
            if MoveMarker2Flag {
                
                MoveMarker2Flag = false
                
                if self.rangeofField(minX: 10, maxX: 886, minY: 10, maxY:344, location: location) {
                    MoveMarker2.position = location
                } else {
                    MoveMarker2.position = ally2.position
                    MoveMarker2.alpha = 0.0
                }
                
            }
            
            //ally1
            if Ally3Flag {//味方を最初に触った時。
                
                Ally3Flag = false
                
                
                if phaseFlag {//movephase
                    
                    if self.rangeofField(minX: 10, maxX: 886, minY: 10, maxY: 344, location: location) {
                        
                        MoveMarker3.position = location
                        
                    } else {
                        MoveMarker3.position = ally3.position
                        MoveMarker3.alpha = 0.0
                    }
                    
                } else {//Attackphase
                    
                    if ally3SkilledFlag {
                        
                        if self.atPoint(location).name == "ally3Skill1" {//skill1の発動。斧をやりたい。まだできてません。
                            
                            //Bullet作成
                            
                            let bullet = Bullet(imageNamed: "Back")
                            
                            bullet.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Back"), size: bullet.size)
                            bullet.xScale = 0.05
                            bullet.yScale = 0.01
                            bullet.position = CGPoint(x: ally3.position.x + 40,y: ally3.position.y + 30) //生成位置の設定
                            bullet.name  = "bullet"
                            bullet.userData = NSMutableDictionary()
                            bullet.userData?.setValue( PhysicsCategory.Bullet, forKey: "category")
                            
                            if ally3.grade! == 1 {
                                print("ally3Skill1")
                                bullet.damage = 100
                            } else if ally3.grade! == 2 {
                                print("ally3Skill1G1")
                                bullet.damage = 220
                            } else if ally3.grade! == 3 {
                                print("ally3Skill1G2")
                                bullet.damage = 700
                            }
                            
                            ally3.grade! = 1//gradeをリセットする。
                            ally3GradeLabel.text = "\(ally3.grade!)"
                            
                            bullet.physicsBody?.categoryBitMask = PhysicsCategory.Bullet //衝突判定に使用する値の設定
                            bullet.physicsBody?.collisionBitMask = PhysicsCategory.Enemy
                            bullet.physicsBody?.contactTestBitMask = PhysicsCategory.Bullet
                            
                            self.addChild(bullet)//Bullet表示
                            
                            let action = SKAction.moveTo(y: -100, duration: 0.2)//アクション作成(移動方向:Y,移動時間:1.0秒)
                            let actionDone = SKAction.removeFromParent()
                            bullet.run(SKAction.sequence([action,actionDone]))
                            
                            ally3SkilledFlag = false//Skillを使ったこと判定
                            
                        }
                        
                        if self.atPoint(location).name == "ally3Skill2" {//skill2の発動
                            
                            if ally3.grade! == 1 {
                                print("ally3Skill2")
                                //bullet.damage = 200
                            } else if ally3.grade! == 2 {
                                print("ally3Skill2G2")
                                //bullet.damage = 500
                            } else if ally3.grade! == 3 {
                                print("ally3Skill2G3")
                                //bullet.damage = 1300
                            }
                            
                            ally3.grade! = 1//gradeをリセットする。
                            ally3GradeLabel.text = "\(ally3.grade!)"
                            
                            ally3SkilledFlag = false
                            
                        }
                        
                        if self.atPoint(location).name == "ally3Skill3" {//skill3の発動。移動しながら攻撃する。まだ実装できてません。
                            
                            print("ally3Skill1")
                            //bullet.damage = 50
                            
                            let action1 = SKAction.move(to: CGPoint(x: ally3.position.x + 200, y: ally3.position.y), duration: 0.5)
                            
                            ally3.run(action1)
                            
                            ally3.moveEnable = false
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                // 0.5秒後に実行したい処理
                                self.MoveMarker3.position = self.ally3.position
                                self.ally3.moveEnable = true
                                
                            }
                            
                            ally3SkilledFlag = false
                            
                        }
                        
                        if self.atPoint(location).name == "ally3Skill4" {//skill4の発動。範囲内にいる敵に攻撃する。攻撃したを移動しなくする。
                            
                            for i in 0 ..< EnemyArray.count {
                                if 200 >= length(v: CGPoint(x: ally3.position.x - EnemyArray[i].position.x,y: ally3.position.y - EnemyArray[i].position.y)) {
                                    
                                    if ally3.grade! == 1 {
                                        print("ally3Skill4")
                                        self.changeEnemyHp(change: -60, id: EnemyArray[i].id!)
                                        self.damageEffect(damageposition: EnemyArray[i].position, damage: -60 )
                                    } else if ally3.grade! == 2 {
                                        print("ally3Skill4G1")
                                        self.changeEnemyHp(change: -160, id: EnemyArray[i].id!)
                                        self.damageEffect(damageposition: EnemyArray[i].position, damage: -160 )
                                    } else if ally3.grade! == 3 {
                                        print("ally3Skill4G2")
                                        self.changeEnemyHp(change: -1000, id: EnemyArray[i].id!)
                                        self.damageEffect(damageposition: EnemyArray[i].position, damage: -1000 )
                                    }
                                    
                                    ally3.grade! = 1//gradeをリセットする。
                                    ally3GradeLabel.text = "\(ally3.grade!)"
                                    
                                    EnemyArray[i].moveEnable = false
                                    
                                }
                            }
                            
                            ally3SkilledFlag = false
                            
                        }
                        
                        if self.atPoint(location).name == "ally3Skill5" {//skill5の発動。必殺技
                            
                            print("ally3Skill5")
                            ally3SkilledFlag = false
                            
                        }
                        
                    } else {
                        
                    }
                }
                
                ally3Skill1.alpha = 0.0//name判定より後にしないと判定がされなくなる。
                ally3Skill2.alpha = 0.0
                ally3Skill3.alpha = 0.0
                ally3Skill4.alpha = 0.0
                ally3Skill5.alpha = 0.0
                
            }
            
            if MoveMarker3Flag {
                
                MoveMarker3Flag = false
                
                if self.rangeofField(minX: 10, maxX: 886, minY: 10, maxY:344, location: location) {
                    MoveMarker3.position = location
                } else {
                    MoveMarker3.position = ally3.position
                    MoveMarker3.alpha = 0.0
                }
            }
            
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {//衝突の処理
        
        if let nodeA = contact.bodyA.node {
            if let nodeB = contact.bodyB.node{
                
                //味方の弾と敵が当たる時の判定メソッド
                if nodeA.userData?.value(forKey: "category") as! UInt32 == PhysicsCategory.Enemy && nodeB.userData?.value(forKey: "category") as! UInt32 == PhysicsCategory.Bullet || nodeA.userData?.value(forKey: "category") as! UInt32 == PhysicsCategory.Bullet && nodeB.userData?.value(forKey: "category") as! UInt32 == PhysicsCategory.Enemy {
                    //ダメージ処理
                    print("EnemyDamaged")
                    
                    if nodeA.userData?.value(forKey: "category") as! UInt32 == PhysicsCategory.Bullet {
                        
                        self.changeEnemyHp(change: -(nodeA as! Bullet).damage!, id: (nodeB as! Enemy).id!)
                        
                        self.damageEffect(damageposition: nodeA.position,damage: (nodeA as! Bullet).damage!)
                        
                        if nodeA.name == "poison" {
                            
                            if (nodeB as! Enemy).grade! >= 1 {
                                self.changeEnemyGrade(change: -1, id: (nodeB as! Enemy).id!)
                            }
                            
                        }
                        
                        nodeA.removeFromParent()
                        
                    } else if nodeB.userData?.value(forKey: "category") as! UInt32 == PhysicsCategory.Bullet {
                        
                        print((nodeB as! Bullet).damage!)
                        print((nodeA as! Enemy).id!)
                        self.changeEnemyHp(change: -(nodeB as! Bullet).damage!, id: (nodeA as! Enemy).id!)
                        
                        self.damageEffect(damageposition: nodeB.position,damage: (nodeB as! Bullet).damage!)
                        
                        if nodeB.name == "poison" {
                            
                            if (nodeA as! Enemy).grade! >= 1 {
                                
                                self.changeEnemyGrade(change: -1, id: (nodeA as! Enemy).id!)
                                
                            }
                            
                        }
                        
                        nodeB.removeFromParent()
                        
                    }
                    
                }
                
                //敵の弾と味方が当たる時の判定メソッド
                if nodeA.userData?.value(forKey: "category") as! UInt32 == PhysicsCategory.Ally && nodeB.userData?.value(forKey: "category") as! UInt32 == PhysicsCategory.eBullet || nodeA.userData?.value(forKey: "category") as! UInt32 == PhysicsCategory.eBullet && nodeB.userData?.value(forKey: "category") as! UInt32 == PhysicsCategory.Ally {
                    //ダメージ処理
                    print("AllyDamaged")
                    
                    if nodeA.userData?.value(forKey: "category") as! UInt32 == PhysicsCategory.eBullet {
                        
                        print((nodeA as! Bullet).damage!)
                        print((nodeB as! Ally).id!)
                        
                        self.changeAllyHp(change: -(nodeA as! Bullet).damage!, id: (nodeB as! Ally).id!)
                        
                        self.damageEffect(damageposition: nodeA.position,damage: (nodeA as! Bullet).damage!)
                        
                        if nodeA.name == "poison" {
                            if (nodeB as! Ally).grade! >= 1 {
                                (nodeB as! Ally).grade! = (nodeB as! Ally).grade! - 1
                            }
                            
                            if (nodeB as! Ally).id! == 1 {
                                ally1GradeLabel.text = "\(ally1.grade!)"
                            }else if (nodeB as! Ally).id! == 2 {
                                ally2GradeLabel.text = "\(ally2.grade!)"
                            }else if (nodeB as! Ally).id! == 3 {
                                ally3GradeLabel.text = "\(ally3.grade!)"
                            }
                            
                        }
                        
                        nodeA.removeFromParent()
                        
                    } else if nodeB.userData?.value(forKey: "category") as! UInt32 == PhysicsCategory.eBullet {
                        
                        print((nodeB as! Bullet).damage!)
                        print((nodeA as! Ally).id!)
                        
                        self.changeAllyHp(change: -(nodeB as! Bullet).damage!, id: (nodeA as! Ally).id!)
                        self.damageEffect(damageposition: nodeB.position,damage: (nodeB as! Bullet).damage!)
                        
                        if nodeB.name == "poison" {
                            if (nodeA as! Ally).grade! >= 1 {
                                (nodeA as! Ally).grade! = (nodeA as! Ally).grade! - 1
                            }
                            
                            if (nodeA as! Ally).id! == 1 {
                                ally1GradeLabel.text = "\(ally1.grade!)"
                            }else if (nodeA as! Ally).id! == 2 {
                                ally2GradeLabel.text = "\(ally2.grade!)"
                            }else if (nodeA as! Ally).id! == 3 {
                                ally3GradeLabel.text = "\(ally3.grade!)"
                            }
                            
                        }
                        
                        nodeB.removeFromParent()
                        
                    }
                    
                }
                
                //Itemを撮るときに呼ばれるコード。Itemcountを-1して、効果を発揮する。
                if nodeA.userData?.value(forKey: "category") as! UInt32 == PhysicsCategory.Item && nodeB.userData?.value(forKey: "category") as! UInt32 == PhysicsCategory.Ally || nodeA.userData?.value(forKey: "category") as! UInt32 == PhysicsCategory.Ally && nodeB.userData?.value(forKey: "category") as! UInt32 == PhysicsCategory.Item {
                    
                    if nodeA.name == "heart" || nodeB.name == "heart" {
                        
                        print("getheart")
                        ItemCount = ItemCount - 1
                        
                        if nodeA.name == "Ally1" || nodeB.name == "Ally1" {
                            self.changeAllyHp(change: 100, id: 1)
                        } else if nodeA.name == "Ally2" || nodeB.name == "Ally2" {
                            self.changeAllyHp(change: 100, id: 2)
                        } else if nodeA.name == "Ally3" || nodeB.name == "Ally3" {
                            self.changeAllyHp(change: 100, id: 3)
                        }
                        
                    }
                    
                    if nodeA.name == "gradeup" || nodeB.name == "gradeup" {
                        //Itemを取った時の処理
                        print("getgradeupItem")
                        ItemCount = ItemCount - 1
                        
                        if nodeA.name == "Ally1" || nodeB.name == "Ally1" {
                            
                            if ally1.grade! <= 1 {
                                ally1.grade! = ally1.grade! + 1
                            }
                            ally1GradeLabel.text =  "\(ally1.grade!)"
                            
                        } else if nodeA.name == "Ally2" || nodeB.name == "Ally2" {
                            
                            if ally2.grade! <= 1 {
                                ally2.grade! = ally2.grade! + 1
                            }
                            ally2GradeLabel.text =  "\(ally2.grade!)"
                            
                        } else if nodeA.name == "Ally3" || nodeB.name == "Ally3" {
                            
                            if ally3.grade! <= 1 {
                                ally3.grade! = ally3.grade! + 1
                            }
                            ally3GradeLabel.text =  "\(ally3.grade!)"
                        }
                        
                    }
                    
                    if nodeA.userData?.value(forKey: "category") as! UInt32 == PhysicsCategory.Item {
                        nodeA.removeFromParent()
                    }else if nodeB.userData?.value(forKey: "category") as! UInt32 == PhysicsCategory.Item {
                        nodeB.removeFromParent()
                    }
                    
                }
                
            }
        }
        
    }
    
    func changeAllyHp(change:Int,id:Int) {//渡された値が正なら回復。負ならダメージを与える。
        
        if id == 1 {
            
            ally1.hp! = ally1.hp! + change//hpの増減処理
            
            if ally1.hp! > ally1.maxHp! {
                ally1.hp! = ally1.maxHp!
            }
            
            ally1HpBar.zPosition = 2
            ally1HpBar.xScale = CGFloat( Double(ally1.hp!) / Double(ally1.maxHp!) )//x方向の倍率
            ally1HpBar.position = CGPoint(x: -5,y: -25)
            
            if Double(ally1.hp!) / Double(ally1.maxHp!) >= 0.7 {
                //hpbarGreen
                ally1HpBar.color = UIColor.green
                
            } else if Double(ally1.hp!) / Double(ally1.maxHp!) >= 0.3 {
                //hpbarYellow
                ally1HpBar.color = UIColor.yellow
                
            } else {
                //hpbarRed
                ally1HpBar.color = UIColor.red
                
            }
            
            if ally1.hp! <= 0 {
                
                //味方の消去処理
                if let Index = AllyArray.firstIndex(of: ally1) {
                    
                    AllyArray.remove(at: Index)
                    
                    ally1.removeFromParent()
                    MoveMarker1.removeFromParent()
                    
                }
                if AllyArray.count == 0 {
                    self.gameover(side: "ally")
                }
                
            }
            
        } else if id == 2 {
            
            ally2.hp! = ally2.hp! + change//hpの増減処理
            
            if ally2.hp! > ally2.maxHp! {
                ally2.hp! = ally2.maxHp!
            }
            
            ally2HpBar.zPosition = 2
            ally2HpBar.xScale = CGFloat( Double(ally2.hp!) / Double(ally2.maxHp!) )//x方向の倍率
            ally2HpBar.position = CGPoint(x: -5,y: -25)
            
            if Double(ally2.hp!) / Double(ally2.maxHp!) >= 0.7 {
                //hpbarGreen
                ally2HpBar.color = UIColor.green
                
            } else if Double(ally2.hp!) / Double(ally2.maxHp!) >= 0.3 {
                //hpbarYellow
                ally2HpBar.color = UIColor.yellow
                
            } else {
                //hpbarRed
                ally2.color = UIColor.red
                
            }
            
            if ally2.hp! <= 0 {
                
                //味方の消去処理
                if let Index = AllyArray.firstIndex(of: ally2) {
                    
                    AllyArray.remove(at: Index)
                    
                    ally2.removeFromParent()
                    MoveMarker2.removeFromParent()
                    
                }
                
                if AllyArray.count == 0 {
                    self.gameover(side: "ally")
                }
                
            }
            
        } else if id == 3 {
            
            ally3.hp! = ally3.hp! + change//hpの増減処理
            
            if ally3.hp! > ally3.maxHp! {
                ally3.hp! = ally3.maxHp!
            }
            
            ally3HpBar.zPosition = 2
            ally3HpBar.xScale = CGFloat( Double(ally3.hp!) / Double(ally3.maxHp!) )//x方向の倍率
            ally3HpBar.position = CGPoint(x: -5,y: -25)
            
            
            if Double(ally3.hp!) / Double(ally3.maxHp!) >= 0.7 {
                //hpbarGreen
                ally3HpBar.color = UIColor.green
                
            } else if Double(ally3.hp!) / Double(ally3.maxHp!) >= 0.3 {
                //hpbarYellow
                ally3HpBar.color = UIColor.yellow
                
            } else {
                //hpbarRed
                ally3HpBar.color = UIColor.red
                
            }
            
            if ally3.hp! <= 0 {
                
                //味方の消去処理
                if let Index = AllyArray.firstIndex(of: ally3) {
                    
                    AllyArray.remove(at: Index)
                    
                    ally3.removeFromParent()
                    MoveMarker3.removeFromParent()
                    
                }
                
                if AllyArray.count == 0 {
                    self.gameover(side: "ally")
                }
                
            }
            
        }
        
    }
    
    func changeEnemyHp(change:Int,id:Int) {//渡された値が正なら回復。負ならダメージを与える。
        
        var EnemyidArray:[Int] = []
        
        for i in EnemyArray {
            
            EnemyidArray.append(i.id!)
            
        }
        
        if let Index = EnemyidArray.firstIndex(of: id) {
            
            print("hp変化する敵: \(Index)")
            
            let enemy:Enemy = EnemyArray[Index]
            
            enemy.hp! = enemy.hp! + change
            
            for i in enemy.children {
                
                if i.name == "HpBar" {
                    
                    i.xScale = CGFloat( Double(enemy.hp!) / Double(enemy.maxHp!) )
                    i.position = CGPoint(x: -5,y: -25)
                    
                    if Double(enemy.hp!) / Double(enemy.maxHp!) >= 0.7 {
                        //hpbarGreen
                        (i as! SKSpriteNode).color = UIColor.green
                        
                    } else if Double(enemy.hp!) / Double(enemy.maxHp!) >= 0.3 {
                        //hpbarYellow
                        (i as! SKSpriteNode).color = UIColor.yellow
                        
                    } else {
                        //hpbarRed
                        (i as! SKSpriteNode).color = UIColor.red
                        
                    }
                    
                    
                }
                
            }
            
            if enemy.hp! <= 0 {
                //敵の消去処理
                if let Index = EnemyArray.firstIndex(of: enemy) {
                    
                    EnemyArray[Index].removeFromParent()
                    EnemyArray.remove(at: Index)
                    
                }
                
                if EnemyArray.count == 0 {
                    
                    waveNumber = waveNumber + 1
                    
                    if waveNumber < maxWaveNumber {
                        
                        self.addEnemy()
                        waveLabel.text = "wave: \(waveNumber + 1) / \(maxWaveNumber) "
                        
                        phaseFlag = true
                        
                        if MainTimer?.isValid == true {
                            MainTimer?.invalidate()
                        }
                        
                        phasenumber = 0
                        
                        MainTimer?.fire()
                        
                        
                    } else {
                        
                        self.gameover(side: "enemy")
                        
                    }
                    
                }
                
            }
            
            if enemy.type == "Queen" {//女王は一発で倒さないと失敗。
                if enemy.hp! > 0 {
                    self.gameover(side: "ally")
                }
            }
            
            
        }
        
        
    }
    
    func changeEnemyGrade(change:Int,id:Int) {
        
        var EnemyidArray:[Int] = []
        
        for i in EnemyArray {
            
            EnemyidArray.append(i.id!)
            
        }
        
        if let Index = EnemyidArray.firstIndex(of: id) {
            
            EnemyArray[Index].grade! = EnemyArray[Index].grade! + change
            
            for i in EnemyArray[Index].children {
            
                if i.name == "GradeLabel" {
                    (i as! SKLabelNode).text = "\(EnemyArray[Index].grade!)"
                }
                
            }
        }
        
    }
    
    func getSkillDamege() {//技の威力を変更するときに必要になるのでとりあえず、作っとく。
        
        userDefaults.set( 100, forKey: "ally1Skill1G1")
        userDefaults.set( 100, forKey: "ally1Skill1G2")
        userDefaults.set( 100, forKey: "ally1Skill1G3")
        userDefaults.set( 100, forKey: "ally1Skill2G1")
        userDefaults.set( 100, forKey: "ally1Skill2G2")
        userDefaults.set( 100, forKey: "ally1Skill2G3")
        userDefaults.set( 100, forKey: "ally1Skill3G1")
        userDefaults.set( 100, forKey: "ally1Skill3G2")
        userDefaults.set( 100, forKey: "ally1Skill3G3")
        userDefaults.set( 100, forKey: "ally1Skill4G1")
        userDefaults.set( 100, forKey: "ally1Skill4G2")
        userDefaults.set( 100, forKey: "ally1Skill4G3")
        
        userDefaults.set( 100, forKey: "ally2Skill1G1")
        userDefaults.set( 100, forKey: "ally2Skill1G2")
        userDefaults.set( 100, forKey: "ally2Skill1G3")
        userDefaults.set( 100, forKey: "ally2Skill2G1")
        userDefaults.set( 100, forKey: "ally2Skill2G2")
        userDefaults.set( 100, forKey: "ally2Skill2G3")
        userDefaults.set( 100, forKey: "ally2Skill3G1")
        userDefaults.set( 100, forKey: "ally2Skill3G2")
        userDefaults.set( 100, forKey: "ally2Skill3G3")
        userDefaults.set( 100, forKey: "ally2Skill4G1")
        userDefaults.set( 100, forKey: "ally2Skill4G2")
        userDefaults.set( 100, forKey: "ally2Skill4G3")
        
        userDefaults.set( 100, forKey: "ally3Skill1G1")
        userDefaults.set( 100, forKey: "ally3Skill1G2")
        userDefaults.set( 100, forKey: "ally3Skill1G3")
        userDefaults.set( 100, forKey: "ally3Skill2G1")
        userDefaults.set( 100, forKey: "ally3Skill2G2")
        userDefaults.set( 100, forKey: "ally3Skill2G3")
        userDefaults.set( 100, forKey: "ally3Skill3G1")
        userDefaults.set( 100, forKey: "ally3Skill3G2")
        userDefaults.set( 100, forKey: "ally3Skill3G3")
        userDefaults.set( 100, forKey: "ally3Skill4G1")
        userDefaults.set( 100, forKey: "ally3Skill4G2")
        userDefaults.set( 100, forKey: "ally3Skill4G3")
        
        
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
        Heart.userData?.setValue( PhysicsCategory.Item, forKey: "category")
        Heart.xScale = 0.7
        Heart.yScale = 0.7
        self.addChild(Heart)
        
    }
    
    func makeGradeupItem(x: Int,y: Int) {//gradeupItemを作る関数、まだ
        
        let GradeItem = SKSpriteNode(imageNamed: "gradeup")
        
        GradeItem.physicsBody?.usesPreciseCollisionDetection = true//精度の高い衝突判定を行う。
        GradeItem.physicsBody?.friction = 0//摩擦係数を0にする
        GradeItem.name = "gradeup"
        GradeItem.physicsBody?.isDynamic = false
        GradeItem.physicsBody?.restitution = 1.0 // 1.0にしたい。
        GradeItem.physicsBody?.allowsRotation = false
        GradeItem.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "gradeup.png"), size: GradeItem.size)
        GradeItem.physicsBody?.categoryBitMask = 0//物体のカテゴリ次元をHeart
        GradeItem.physicsBody?.contactTestBitMask = PhysicsCategory.Ally //衝突を検知するカテゴリ
        GradeItem.physicsBody?.collisionBitMask = 0 //衝突させたい物体＝＞なし
        GradeItem.position = CGPoint(x: 50 + x,y: 50 + y)
        GradeItem.userData = NSMutableDictionary()
        GradeItem.userData?.setValue( PhysicsCategory.Item, forKey: "category")
        GradeItem.xScale = 0.7
        GradeItem.yScale = 0.7
        self.addChild(GradeItem)
        
    }
    
    func gameover(side:String) {
        
        if side == "ally" {//味方の全滅
            print("gameover")
            
            let gameoverBack = SKSpriteNode(imageNamed: "gameover")
            
            gameoverBack.name = "gameover"
            gameoverBack.position = CGPoint(x: 448, y: 207)
            gameoverBack.zPosition = 6
            self.addChild(gameoverBack)
            
            if MainTimer?.isValid == true {
                MainTimer?.invalidate()
            }
            
        } else if side == "enemy" {//敵の全滅
            print("gameclear")
            
            let gameclearBack = SKSpriteNode(imageNamed: "gameclear")
            
            gameclearBack.name = " gameclear"
            gameclearBack.position = CGPoint(x: 448, y: 207)
            gameclearBack.zPosition = 6
            self.addChild(gameclearBack)
            
            if MainTimer?.isValid == true {
                MainTimer?.invalidate()
            }
            
        }
        
    }
    
    func damageEffect(damageposition:CGPoint,damage:Int) { //ダメージを表示するためのエフェクトを作る。
        
        let damageEffectBack = SKSpriteNode(imageNamed: "damageEffect")
        damageEffectBack.name = "damageEffectBack"
        damageEffectBack.position = damageposition
        damageEffectBack.xScale = 0.5
        damageEffectBack.yScale = 0.5
        self.addChild(damageEffectBack)
        
        
        let damageLabel = SKLabelNode()
        damageLabel.name = "damageLabel"
        damageLabel.fontSize = 25 // フォントサイズを設定.
        damageLabel.fontColor = UIColor.black// 色を指定
        damageLabel.position = CGPoint(x: damageposition.x,y:damageposition.y - 8)// 表示するポジションを指定.
        if damage < 0 {
            var minusDamage = 0
            minusDamage = -damage
            damageLabel.text = " \(minusDamage)"
        } else {
            damageLabel.text = " \(damage)"
        }
        self.addChild(damageLabel)
        
        let wait = SKAction.wait(forDuration: 0.5)
        let fadeout = SKAction.fadeOut(withDuration: 0.5)
        let remove = SKAction.removeFromParent()
        
        damageLabel.run(SKAction.sequence([wait,fadeout,remove]))
        damageEffectBack.run(SKAction.sequence([wait,fadeout,remove]))
        
    }
    
    func addEnemy() {
        
        for enemy in Stage[waveNumber] {
            
            enemy.alpha = 0.0
            self.addChild(enemy)
            
            let fadeIn = SKAction.fadeIn(withDuration: 0.8)
            enemy.run(fadeIn)
            
        }
        
        EnemyArray = Stage[waveNumber]
        
    }
    
    func makeStage(stage:Int) -> [[Enemy]] {
        
        var stagearray:[[Enemy]] = []
        
        if stage == 1 {
            
            var firstArray:[Enemy] = []
            
            let Soilder1 = self.makeSoiler(position: CGPoint(x: 450,y: 250))
            Soilder1.id = firstArray.count
            firstArray.append(Soilder1)
            
            stagearray.append(firstArray)
            
            var secondArray:[Enemy] = []
            
            let Soilder2 = self.makeSoiler(position: CGPoint(x: 700,y: 150))
            Soilder2.id = secondArray.count
            secondArray.append(Soilder2)
            
            let Bom1 = self.makeBom(position: CGPoint(x: 450,y: 250))
            Bom1.id = secondArray.count
            secondArray.append(Bom1)
            
            stagearray.append(secondArray)
            
            var thirdArray:[Enemy] = []
            
            let Queen1 = self.makeQueen(position: CGPoint(x: 600,y: 250))
            Queen1.id = thirdArray.count
            thirdArray.append(Queen1)
            
            stagearray.append(thirdArray)
            
            maxWaveNumber = stagearray.count
            
            waveLabel.text = "wave: \(waveNumber + 1) / \(maxWaveNumber) "
            
            return stagearray
            
        }
        
        return stagearray
    }
    
    //////////////////////////敵作成系メソッド集/////////////////////////////////
    
    func makeSoiler(position:CGPoint) -> Enemy {
        
        let Soldier = Enemy(imageNamed: "Soldier")
        
        Soldier.name = "Soldier"
        Soldier.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Soldier"), size: Soldier.size)
        Soldier.physicsBody?.isDynamic = false
        Soldier.physicsBody?.restitution = 1.0//反発値
        Soldier.position = position
        Soldier.userData = NSMutableDictionary()
        Soldier.userData?.setValue( PhysicsCategory.Enemy, forKey: "category")
        Soldier.physicsBody?.categoryBitMask = PhysicsCategory.Enemy //衝突判定に使用する値の設定
        Soldier.physicsBody?.contactTestBitMask = PhysicsCategory.Bullet
        Soldier.physicsBody?.collisionBitMask = PhysicsCategory.Enemy //衝突させたい物体Enemy
        Soldier.xScale = 1.0
        Soldier.yScale = 1.0
        Soldier.grade = 2
        Soldier.hp = 500
        Soldier.type = "Soldier"
        Soldier.maxHp = 1000//敵1の最大のHp
        
        let HpBarBack = SKSpriteNode(color: UIColor.black, size: CGSize(width: 45.0, height: 14.0))
        
        HpBarBack.name = "HpBarBack"
        HpBarBack.position = CGPoint(x: -5,y: -25)
        Soldier.addChild(HpBarBack)
        
        let HpBar = SKSpriteNode(color: UIColor.green, size: CGSize(width: 40.0, height: 10.0))//敵2のhpの量を表示
        
        HpBar.name = "HpBar"
        HpBar.position = CGPoint(x: -5,y: -25)
        HpBar.zPosition = 1
        HpBar.xScale = CGFloat( Double(Soldier.hp!) / Double(Soldier.maxHp!) )//x方向の倍率
        Soldier.addChild(HpBar)
        
        let GradeIcon = SKSpriteNode(imageNamed: "gradeicon")
        
        GradeIcon.name = "Gradeicon"
        GradeIcon.position = CGPoint(x: -37, y: -25)
        GradeIcon.xScale = 0.3
        GradeIcon.yScale = 0.3
        Soldier.addChild(GradeIcon)
        
        let GradeLabel = SKLabelNode()
        
        GradeLabel.name = "GradeLabel"
        GradeLabel.fontSize = 20// フォントサイズを設定.
        GradeLabel.fontColor = UIColor.black// 色を指定(赤).
        GradeLabel.position = CGPoint(x: -37, y: -30)// 表示するポジションを指定.
        GradeLabel.text = " \(Soldier.grade!)"
        Soldier.addChild(GradeLabel)
        
        
        return Soldier
        
    }
    
    func makeQueen(position:CGPoint) -> Enemy  {
        
        let Queen = Enemy(imageNamed: "Queen")
        
        Queen.name = "Queen"
        Queen.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Queen"), size: Queen.size)
        Queen.physicsBody?.isDynamic = false
        Queen.physicsBody?.restitution = 1.0//反発値
        Queen.position = position
        Queen.userData = NSMutableDictionary()
        Queen.userData?.setValue( PhysicsCategory.Enemy, forKey: "category")
        Queen.physicsBody?.categoryBitMask = PhysicsCategory.Enemy //衝突判定に使用する値の設定
        Queen.physicsBody?.contactTestBitMask = PhysicsCategory.Bullet
        Queen.physicsBody?.collisionBitMask = PhysicsCategory.Enemy //衝突させたい物体Enemy
        Queen.xScale = 1.0
        Queen.yScale = 1.0
        Queen.grade = 2
        Queen.hp = 1000
        Queen.type = "Queen"
        Queen.maxHp = 1000//敵1の最大のHp
        
        let HpBarBack = SKSpriteNode(color: UIColor.black, size: CGSize(width: 45.0, height: 14.0))
        
        HpBarBack.name = "HpBarBack"
        HpBarBack.position = CGPoint(x: -5,y: -25)
        Queen.addChild(HpBarBack)
        
        let HpBar = SKSpriteNode(color: UIColor.green, size: CGSize(width: 40.0, height: 10.0))//敵2のhpの量を表示
        
        HpBar.name = "HpBar"
        HpBar.position = CGPoint(x: -5,y: -25)
        HpBar.zPosition = 1
        HpBar.xScale = CGFloat( Double(Queen.hp!) / Double(Queen.maxHp!) )//x方向の倍率
        Queen.addChild(HpBar)
        
        let GradeIcon = SKSpriteNode(imageNamed: "gradeicon")
        
        GradeIcon.name = "Gradeicon"
        GradeIcon.position = CGPoint(x: -37, y: -25)
        GradeIcon.xScale = 0.3
        GradeIcon.yScale = 0.3
        Queen.addChild(GradeIcon)
        
        let GradeLabel = SKLabelNode()
        
        GradeLabel.name = "GradeLabel"
        GradeLabel.fontSize = 20// フォントサイズを設定.
        GradeLabel.fontColor = UIColor.black// 色を指定(赤).
        GradeLabel.position = CGPoint(x: -37, y: -30)// 表示するポジションを指定.
        GradeLabel.text = " \(Queen.grade!)"
        Queen.addChild(GradeLabel)
        
        
        return Queen
        
    }
    
    func makeBom(position:CGPoint) -> Enemy  {
        
        let Bom = Enemy(imageNamed: "Bom")
        
        Bom.name = "Bom"
        Bom.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Bom"), size: Bom.size)
        Bom.physicsBody?.isDynamic = false
        Bom.physicsBody?.restitution = 1.0//反発値
        Bom.position = position
        Bom.userData = NSMutableDictionary()
        Bom.userData?.setValue( PhysicsCategory.Enemy, forKey: "category")
        Bom.physicsBody?.categoryBitMask = PhysicsCategory.Enemy //衝突判定に使用する値の設定
        Bom.physicsBody?.contactTestBitMask = PhysicsCategory.Bullet
        Bom.physicsBody?.collisionBitMask = PhysicsCategory.Enemy //衝突させたい物体Enemy
        Bom.xScale = 1.0
        Bom.yScale = 1.0
        Bom.grade = 2
        Bom.hp = 100
        Bom.type = "Bom"
        Bom.maxHp = 100//敵1の最大のHp
        
        let HpBarBack = SKSpriteNode(color: UIColor.black, size: CGSize(width: 45.0, height: 14.0))
        
        HpBarBack.name = "HpBarBack"
        HpBarBack.position = CGPoint(x: -5,y: -25)
        Bom.addChild(HpBarBack)
        
        let HpBar = SKSpriteNode(color: UIColor.green, size: CGSize(width: 40.0, height: 10.0))//敵2のhpの量を表示
        
        HpBar.name = "HpBar"
        HpBar.position = CGPoint(x: -5,y: -25)
        HpBar.zPosition = 1
        HpBar.xScale = CGFloat( Double(Bom.hp!) / Double(Bom.maxHp!) )//x方向の倍率
        Bom.addChild(HpBar)
        
        let GradeIcon = SKSpriteNode(imageNamed: "gradeicon")
        
        GradeIcon.name = "Gradeicon"
        GradeIcon.position = CGPoint(x: -37, y: -25)
        GradeIcon.xScale = 0.3
        GradeIcon.yScale = 0.3
        Bom.addChild(GradeIcon)
        
        let GradeLabel = SKLabelNode()
        
        GradeLabel.name = "GradeLabel"
        GradeLabel.fontSize = 20// フォントサイズを設定.
        GradeLabel.fontColor = UIColor.black// 色を指定(赤).
        GradeLabel.position = CGPoint(x: -37, y: -30)// 表示するポジションを指定.
        GradeLabel.text = " \(Bom.grade!)"
        Bom.addChild(GradeLabel)
        
        
        return Bom
        
    }
    
    func EnemyMove() {
        
        for enemy in EnemyArray {
            
            if enemy.moveEnable {
                
                if enemy.type == "Soldier" {
                    
                    var shortestDistance:CGFloat = 50000.0 //大きい数字をとりあえず、代入します。
                    var savei:Int = 0
                    
                    for i in 0 ..< AllyArray.count {
                        if shortestDistance >= length(v: CGPoint(x: enemy.position.x - AllyArray[i].position.x,y: enemy.position.y - AllyArray[i].position.y)) {
                            shortestDistance = length(v: CGPoint(x: enemy.position.x - AllyArray[i].position.x,y: enemy.position.y - AllyArray[i].position.y))
                            savei = i
                        }
                    }
                    
                    if shortestDistance >= 150 { //距離が遠い時は近づく
                        
                        var relativepostion:CGPoint = CGPoint(x: 0,y: 0)
                        
                        relativepostion.x = AllyArray[savei].position.x - enemy.position.x
                        relativepostion.y = AllyArray[savei].position.y - enemy.position.y
                        
                        let direction :CGFloat = vector2radian(vector: relativepostion)
                        
                        let travelTime = SKAction.move( to: CGPoint(x: enemy.position.x - CGFloat( 4 * cos(Double(direction))),y: enemy.position.y), duration: 0.01)
                        enemy.run(travelTime)
                        
                    } else { //距離が近い時は近づかない。
                        
                    }
                    
                    
                }
                
                if enemy.type == "Bom" {
                    
                    var shortestDistance:CGFloat = 50000.0 //大きい数字をとりあえず、代入します。
                    var savei:Int = 0
                    
                    for i in 0 ..< AllyArray.count {
                        if shortestDistance >= length(v: CGPoint(x: enemy.position.x - AllyArray[i].position.x,y: enemy.position.y - AllyArray[i].position.y)) {
                            shortestDistance = length(v: CGPoint(x: enemy.position.x - AllyArray[i].position.x,y: enemy.position.y - AllyArray[i].position.y))
                            savei = i
                        }
                    }
                    
                    if shortestDistance >= 50 { //距離が遠い時は近づく
                        
                        var relativepostion:CGPoint = CGPoint(x: 0,y: 0)
                        
                        relativepostion.x = AllyArray[savei].position.x - enemy.position.x
                        relativepostion.y = AllyArray[savei].position.y - enemy.position.y
                        
                        let direction :CGFloat = vector2radian(vector: relativepostion)
                        
                        let travelTime = SKAction.move( to: CGPoint(x: enemy.position.x - CGFloat( 3 * cos(Double(direction))),y: enemy.position.y
                            + CGFloat( 3 * sin(Double(direction)))), duration: 0.01)
                        enemy.run(travelTime)
                        
                    } else { //距離が近い時は近づかない
                        
                    }
                    
                }
                
                if enemy.type == "Queen" {
                    //移動しない。
                }
                
            }
            
        }
        
    }
    
    func EnemyAttack() {
        
        //敵の攻撃
        for enemy in EnemyArray {
            
            if enemy.type == "Soldier" {
                
                //Soldierの挙動。最も近い敵に向かって弾を発射する。また、角度30の所にも弾を撃つ。
                
                var shortestDistance:CGFloat = 5000.0
                var savei = 0
                
                for i in 0 ..< AllyArray.count {
                    if shortestDistance >= length(v: CGPoint(x: enemy.position.x - AllyArray[i].position.x,y: enemy.position.y - AllyArray[i].position.y)) {
                        shortestDistance = length(v: CGPoint(x: enemy.position.x - AllyArray[i].position.x,y: enemy.position.y - AllyArray[i].position.y))
                        savei = i
                    }
                }
                
                var relativepostion:CGPoint = CGPoint(x: 0,y: 0)
                
                relativepostion.x = AllyArray[savei].position.x - enemy.position.x
                relativepostion.y = AllyArray[savei].position.y - enemy.position.y
                
                let direction :CGFloat = vector2radian(vector: relativepostion)
                
                //Bullet作成
                
                let bullet1 = Bullet(imageNamed: "Back")
                bullet1.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Back"), size: bullet1.size)
                bullet1.xScale = 0.03
                bullet1.yScale = 0.01
                bullet1.position = CGPoint(x: enemy.position.x,y: enemy.position.y) //生成位置の設定
                bullet1.name  = "bullet"
                bullet1.userData = NSMutableDictionary()
                bullet1.userData?.setValue( PhysicsCategory.eBullet, forKey: "category")
                bullet1.damage = 100
                bullet1.physicsBody?.categoryBitMask = PhysicsCategory.eBullet //衝突判定に使用する値の設定
                bullet1.physicsBody?.collisionBitMask = PhysicsCategory.Enemy
                bullet1.physicsBody?.contactTestBitMask = PhysicsCategory.eBullet
                self.addChild(bullet1)//Bullet表示
                
                let travelTime1 = SKAction.move( to: CGPoint(x: enemy.position.x - CGFloat( 300 * cos(Double(direction))),y: enemy.position.y
                    + CGFloat( 300 * sin(Double(direction)))), duration: 0.8)
                let actionDone = SKAction.removeFromParent()
                bullet1.run(SKAction.sequence([travelTime1,actionDone]))
                
                let bullet2 = Bullet(imageNamed: "Back")
                bullet2.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Back"), size: bullet2.size)
                bullet2.xScale = 0.03
                bullet2.yScale = 0.01
                bullet2.position = CGPoint(x: enemy.position.x,y: enemy.position.y) //生成位置の設定
                bullet2.name  = "bullet"
                bullet2.userData = NSMutableDictionary()
                bullet2.userData?.setValue( PhysicsCategory.eBullet, forKey: "category")
                bullet2.damage = 100
                bullet2.physicsBody?.categoryBitMask = PhysicsCategory.eBullet //衝突判定に使用する値の設定
                bullet2.physicsBody?.collisionBitMask = PhysicsCategory.Enemy
                bullet2.physicsBody?.contactTestBitMask = PhysicsCategory.eBullet
                self.addChild(bullet2)//Bullet表示
                
                let travelTime2 = SKAction.move( to: CGPoint(x: enemy.position.x - CGFloat( 300 * cos(Double(direction + 0.2))),y: enemy.position.y
                    + CGFloat( 300 * sin(Double(direction + 0.2)))), duration: 0.8)
                bullet2.run(SKAction.sequence([travelTime2,actionDone]))
                
                let bullet3 = Bullet(imageNamed: "Back")
                bullet3.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Back"), size: bullet3.size)
                bullet3.xScale = 0.03
                bullet3.yScale = 0.01
                bullet3.position = CGPoint(x: enemy.position.x,y: enemy.position.y) //生成位置の設定
                bullet3.name  = "bullet"
                bullet3.userData = NSMutableDictionary()
                bullet3.userData?.setValue( PhysicsCategory.eBullet, forKey: "category")
                bullet3.damage = 100
                bullet3.physicsBody?.categoryBitMask = PhysicsCategory.eBullet //衝突判定に使用する値の設定
                bullet3.physicsBody?.collisionBitMask = PhysicsCategory.Enemy
                bullet3.physicsBody?.contactTestBitMask = PhysicsCategory.eBullet
                self.addChild(bullet3)//Bullet表示
                
                let travelTime3 = SKAction.move( to: CGPoint(x: enemy.position.x - CGFloat( 300 * cos(Double(direction - 0.2))),y: enemy.position.y
                    + CGFloat( 300 * sin(Double(direction - 0.2)))), duration: 0.8)
                bullet3.run(SKAction.sequence([travelTime3,actionDone]))
                
            }
            
            if enemy.type == "Bom" {
                
                enemy.grade! = enemy.grade! - 1
                
                for i in enemy.children {
                
                    if i.name == "GradeLabel" {
                        (i as! SKLabelNode).text = "\(enemy.grade!)"
                    }
                    
                }
                //gradeの表示を変更
                
                if enemy.grade! <= 0 {//グレードが0になると自爆する。死んでも発動する問題を確認。
                    
                    let BomPosition:CGPoint = enemy.position
                    
                    self.changeEnemyHp(change: -10000, id: enemy.id!)
                    
                    print("bom")
                    
                    let bom1 = Bullet(imageNamed: "Back")
                    bom1.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Back"), size: bom1.size)
                    bom1.xScale = 0.03
                    bom1.yScale = 0.01
                    bom1.position = CGPoint(x: BomPosition.x,y: BomPosition.y) //生成位置の設定
                    bom1.name  = "Bom"
                    bom1.userData = NSMutableDictionary()
                    bom1.userData?.setValue( PhysicsCategory.eBullet, forKey: "category")
                    bom1.damage = 500
                    bom1.physicsBody?.categoryBitMask = PhysicsCategory.eBullet //衝突判定に使用する値の設定
                    bom1.physicsBody?.collisionBitMask = PhysicsCategory.Ally
                    bom1.physicsBody?.contactTestBitMask = PhysicsCategory.eBullet
                    self.addChild(bom1)//Bullet表示
                    
                    let action1 = SKAction.move(to: CGPoint(x: BomPosition.x, y: BomPosition.y + 100), duration: 1.0)//上
                    let actionDone = SKAction.removeFromParent()
                    bom1.run(SKAction.sequence([action1,actionDone]))
                    
                    
                    let bom2 = Bullet(imageNamed: "Back")
                    bom2.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Back"), size: bom2.size)
                    bom2.xScale = 0.03
                    bom2.yScale = 0.01
                    bom2.position = CGPoint(x: BomPosition.x,y: BomPosition.y) //生成位置の設定
                    bom2.name  = "Bom"
                    bom2.userData = NSMutableDictionary()
                    bom2.userData?.setValue( PhysicsCategory.eBullet, forKey: "category")
                    bom2.damage = 500
                    bom2.physicsBody?.categoryBitMask = PhysicsCategory.eBullet //衝突判定に使用する値の設定
                    bom2.physicsBody?.collisionBitMask = PhysicsCategory.Ally
                    bom2.physicsBody?.contactTestBitMask = PhysicsCategory.eBullet
                    self.addChild(bom2)//Bullet表示
                    
                    let action2 = SKAction.move(to: CGPoint(x: BomPosition.x + 100, y: BomPosition.y + 100), duration: 1.0)//右上
                    bom2.run(SKAction.sequence([action2,actionDone]))
                    
                    
                    let bom3 = Bullet(imageNamed: "Back")
                    bom3.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Back"), size: bom3.size)
                    bom3.xScale = 0.03
                    bom3.yScale = 0.01
                    bom3.position = CGPoint(x: BomPosition.x,y: BomPosition.y) //生成位置の設定
                    bom3.name  = "Bom"
                    bom3.userData = NSMutableDictionary()
                    bom3.userData?.setValue( PhysicsCategory.eBullet, forKey: "category")
                    bom3.damage = 500
                    bom3.physicsBody?.categoryBitMask = PhysicsCategory.eBullet //衝突判定に使用する値の設定
                    bom3.physicsBody?.collisionBitMask = PhysicsCategory.Ally
                    bom3.physicsBody?.contactTestBitMask = PhysicsCategory.eBullet
                    self.addChild(bom3)//Bullet表示
                    
                    let action3 = SKAction.move(to: CGPoint(x: BomPosition.x + 100, y: BomPosition.y), duration: 1.0)//右
                    bom3.run(SKAction.sequence([action3,actionDone]))
                                            
                    
                    let bom4 = Bullet(imageNamed: "Back")
                    bom4.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Back"), size: bom4.size)
                    bom4.xScale = 0.03
                    bom4.yScale = 0.01
                    bom4.position = CGPoint(x: BomPosition.x,y: BomPosition.y) //生成位置の設定
                    bom4.name  = "Bom"
                    bom4.userData = NSMutableDictionary()
                    bom4.userData?.setValue( PhysicsCategory.eBullet, forKey: "category")
                    bom4.damage = 500
                    bom4.physicsBody?.categoryBitMask = PhysicsCategory.eBullet //衝突判定に使用する値の設定
                    bom4.physicsBody?.collisionBitMask = PhysicsCategory.Ally
                    bom4.physicsBody?.contactTestBitMask = PhysicsCategory.eBullet
                    self.addChild(bom4)//Bullet表示
                    
                    let action4 = SKAction.move(to: CGPoint(x: BomPosition.x + 100, y: BomPosition.y - 100), duration: 1.0)//右下
                    bom4.run(SKAction.sequence([action4,actionDone]))
                    
                    
                    let bom5 = Bullet(imageNamed: "Back")
                    
                    bom5.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Back"), size: bom5.size)
                    bom5.xScale = 0.03
                    bom5.yScale = 0.01
                    bom5.position = CGPoint(x: BomPosition.x,y: BomPosition.y) //生成位置の設定
                    bom5.name  = "Bom"
                    bom5.userData = NSMutableDictionary()
                    bom5.userData?.setValue( PhysicsCategory.eBullet, forKey: "category")
                    bom5.damage = 500
                    bom5.physicsBody?.categoryBitMask = PhysicsCategory.eBullet //衝突判定に使用する値の設定
                    bom5.physicsBody?.collisionBitMask = PhysicsCategory.Ally
                    bom5.physicsBody?.contactTestBitMask = PhysicsCategory.eBullet
                    self.addChild(bom5)//Bullet表示
                    
                    let action5 = SKAction.move(to: CGPoint(x: BomPosition.x, y: BomPosition.y - 100), duration: 1.0)//した
                    bom5.run(SKAction.sequence([action5,actionDone]))
                    
                    
                    let bom6 = Bullet(imageNamed: "Back")
                    
                    bom6.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Back"), size: bom6.size)
                    bom6.xScale = 0.03
                    bom6.yScale = 0.01
                    bom6.position = CGPoint(x: BomPosition.x,y: BomPosition.y) //生成位置の設定
                    bom6.name  = "Bom"
                    bom6.userData = NSMutableDictionary()
                    bom6.userData?.setValue( PhysicsCategory.eBullet, forKey: "category")
                    bom6.damage = 500
                    bom6.physicsBody?.categoryBitMask = PhysicsCategory.eBullet //衝突判定に使用する値の設定
                    bom6.physicsBody?.collisionBitMask = PhysicsCategory.Ally
                    bom6.physicsBody?.contactTestBitMask = PhysicsCategory.eBullet
                    self.addChild(bom6)//Bullet表示
                    
                    let action6 = SKAction.move(to: CGPoint(x: BomPosition.x - 100, y: BomPosition.y - 100), duration: 1.0)//左した
                    bom6.run(SKAction.sequence([action6,actionDone]))
                    
                    
                    let bom7 = Bullet(imageNamed: "Back")
                    
                    bom7.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Back"), size: bom7.size)
                    bom7.xScale = 0.03
                    bom7.yScale = 0.01
                    bom7.position = CGPoint(x: BomPosition.x,y: BomPosition.y) //生成位置の設定
                    bom7.name  = "Bom"
                    bom7.userData = NSMutableDictionary()
                    bom7.userData?.setValue( PhysicsCategory.eBullet, forKey: "category")
                    bom7.damage = 500
                    bom7.physicsBody?.categoryBitMask = PhysicsCategory.eBullet //衝突判定に使用する値の設定
                    bom7.physicsBody?.collisionBitMask = PhysicsCategory.Ally
                    bom7.physicsBody?.contactTestBitMask = PhysicsCategory.eBullet
                    self.addChild(bom7)//Bullet表示
                    
                    let action7 = SKAction.move(to: CGPoint(x: BomPosition.x - 100, y: BomPosition.y), duration: 1.0)//左
                    bom7.run(SKAction.sequence([action7,actionDone]))
                    
                    
                    let bom8 = Bullet(imageNamed: "Back")
                    bom8.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Back"), size: bom8.size)
                    bom8.xScale = 0.03
                    bom8.yScale = 0.01
                    bom8.position = CGPoint(x: BomPosition.x,y: BomPosition.y) //生成位置の設定
                    bom8.name  = "Bom"
                    bom8.userData = NSMutableDictionary()
                    bom8.userData?.setValue( PhysicsCategory.eBullet, forKey: "category")
                    bom8.damage = 500
                    bom8.physicsBody?.categoryBitMask = PhysicsCategory.eBullet //衝突判定に使用する値の設定
                    bom8.physicsBody?.collisionBitMask = PhysicsCategory.Ally
                    bom8.physicsBody?.contactTestBitMask = PhysicsCategory.eBullet
                    self.addChild(bom8)//Bullet表示
                    
                    let action8 = SKAction.move(to: CGPoint(x: BomPosition.x - 100, y: BomPosition.y + 100), duration: 1.0)//左うえ
                    bom8.run(SKAction.sequence([action8,actionDone]))
                    
                }
                
            }
            
            if enemy.type == "Queen" {
                
            }
            
        }
        
    }
    
    func StopAction(actionNumber: Int) {
        
        if actionNumber == 0 {
            
            //let bullet = Bullet(imageNamed: "Back")
            
            let bullet = Bullet(color: UIColor.black, size: CGSize(width:  100.0, height: 100.0))//skill1の四角
            bullet.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Back"), size: bullet.size)
            bullet.position = CGPoint(x: 200,y: 1000) //生成位置の設定
            bullet.name  = "bullet"
            bullet.userData = NSMutableDictionary()
            bullet.userData?.setValue( PhysicsCategory.Bullet, forKey: "category")
            
            if ally1.grade! == 1 {
                print("ally1Skill4")
                bullet.damage = 200

            } else if ally1.grade! == 2 {
                print("ally1Skill4G2")
                bullet.damage = 600

            } else if ally1.grade! == 3 {
                print("ally1Skill4G3")
                bullet.damage = 2000
            }

            ally1.grade! = 1
            ally1GradeLabel.text = "\(ally1.grade!)"

            //bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
            bullet.physicsBody?.categoryBitMask = PhysicsCategory.Bullet //衝突判定に使用する値の設定
            bullet.physicsBody?.collisionBitMask = PhysicsCategory.Enemy
            bullet.physicsBody?.contactTestBitMask = PhysicsCategory.Bullet

            self.addChild(bullet)//Bullet表示

            let wait = SKAction.wait(forDuration: 5.0)
            let action = SKAction.move(to: aimPosition, duration: 1.0)//アクション作成(移動方向:Y,移動時間:1.0秒)
            let actionDone = SKAction.removeFromParent()
            bullet.run(SKAction.sequence([wait,action,actionDone]))

            stopActionFlag = false
            
            self.MainTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.mainTimerupdate), userInfo: nil, repeats: true)
            
        }
        
    }
    //////////////////////////味方系メソッド集/////////////////////////////////
    
    func makeAlly1() {
        
        ally1.name = "Ally1"
        ally1.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "monster1a"), size: ally1.size)
        ally1.physicsBody?.isDynamic = false
        ally1.physicsBody?.restitution = 1.0//反発値
        ally1.position = CGPoint(x: 150,y: 150)
        ally1.zPosition = 1 //movermarkerより上に来るようにz=1
        ally1.userData = NSMutableDictionary()
        ally1.userData?.setValue( PhysicsCategory.Ally, forKey: "category")
        ally1.physicsBody?.categoryBitMask = PhysicsCategory.Ally
        ally1.physicsBody?.contactTestBitMask = PhysicsCategory.eBullet
        ally1.physicsBody?.collisionBitMask = PhysicsCategory.Ally
        ally1.id = 1
        ally1.grade = 1
        ally1.hp = 1000
        ally1.maxHp = 1000//敵1の最大のHp
        self.addChild(ally1)
        
        ally1HpBarBack.position = CGPoint(x: -5,y: -25)
        ally1HpBarBack.zPosition = 2
        ally1.addChild(ally1HpBarBack)
        
        ally1HpBar.position = CGPoint(x: -5,y: -25)
        ally1HpBar.zPosition = 2
        ally1HpBar.xScale = CGFloat(Double(ally1.hp!) / Double(ally1.maxHp!))//x方向の倍率
        ally1.addChild(ally1HpBar)
        
        ally1GradeIcon.name = "ally1Gradeicon"
        ally1GradeIcon.position = CGPoint(x: -37, y: -25)
        ally1GradeIcon.zPosition = 2
        ally1GradeIcon.xScale = 0.3
        ally1GradeIcon.yScale = 0.3
        ally1.addChild(ally1GradeIcon)
        
        ally1GradeLabel.text = "0"// Labelに文字列を設定.
        ally1GradeLabel.name = "ally1GradeLabel"
        ally1GradeLabel.fontSize = 20// フォントサイズを設定.
        ally1GradeLabel.fontColor = UIColor.black// 色を指定(赤).
        ally1GradeLabel.position = CGPoint(x: -37, y: -30)// 表示するポジションを指定.
        ally1GradeLabel.zPosition = 2
        ally1GradeLabel.text = " \(ally1.grade!)"
        ally1.addChild(ally1GradeLabel)
        
        MoveMarker1.position = ally1.position
        MoveMarker1.alpha = 0.0
        MoveMarker1.name = "MoveMarker1"
        self.addChild(MoveMarker1)
        
        //右上
        ally1Skill1.anchorPoint = CGPoint(x: 0, y: 0)
        ally1Skill1.xScale = 2 / 3
        ally1Skill1.yScale = 2 / 3
        ally1Skill1.name = "ally1Skill1"
        ally1Skill1.alpha = 0.0
        ally1Skill1.zPosition = 2
        ally1Skill1.position = CGPoint(x: 0,y: 0)
        ally1.addChild(ally1Skill1)
        
        //右下
        ally1Skill2.anchorPoint = CGPoint(x: 0, y: 0)
        ally1Skill2.xScale = 2 / 3
        ally1Skill2.yScale = 2 / 3
        ally1Skill2.name = "ally1Skill2"
        ally1Skill2.alpha = 0.0
        ally1Skill2.zPosition = 2
        ally1Skill2.position = CGPoint(x:0,y: -100)
        ally1.addChild(ally1Skill2)
        
        //左上
        ally1Skill3.anchorPoint = CGPoint(x: 0, y: 0)
        ally1Skill3.xScale = 2 / 3
        ally1Skill3.yScale = 2 / 3
        ally1Skill3.name = "ally1Skill3"
        ally1Skill3.alpha = 0.0
        ally1Skill3.position = CGPoint(x: -100,y: 0)
        ally1Skill3.zPosition = 2
        ally1.addChild(ally1Skill3)
        
        //左下
        ally1Skill4.anchorPoint = CGPoint(x: 0, y: 0)
        ally1Skill4.xScale = 2 / 3
        ally1Skill4.yScale = 2 / 3
        ally1Skill4.name = "ally1Skill4"
        ally1Skill4.alpha = 0.0
        ally1Skill4.position = CGPoint(x: -100,y: -100)
        ally1Skill4.zPosition = 2
        ally1.addChild(ally1Skill4)
        
        //右
        ally1Skill5.anchorPoint = CGPoint(x: 0, y: 0)
        ally1Skill5.name = "ally1Skill5"
        ally1Skill5.alpha = 0.0
        ally1Skill5.zPosition = 2
        ally1.addChild(ally1Skill5)
        
    }
    
    func makeAlly2() {
        
        ally2.name = "Ally2"
        ally2.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "monster2a"), size: ally2.size)
        ally2.physicsBody?.isDynamic = false
        ally2.physicsBody?.restitution = 1.0//反発値
        ally2.position = CGPoint(x: 100,y: 75)
        ally2.zPosition = 1 //movermarkerより上に来るようにz=1
        ally2.userData = NSMutableDictionary()
        ally2.userData?.setValue( PhysicsCategory.Ally, forKey: "category")
        ally2.physicsBody?.categoryBitMask = PhysicsCategory.Ally //物体のカテゴリ次元をally
        ally2.physicsBody?.contactTestBitMask = PhysicsCategory.eBullet //衝突を検知するカテゴリBall
        ally2.physicsBody?.collisionBitMask = PhysicsCategory.Ally
        ally2.id = 2
        ally2.grade = 1
        ally2.hp = 1000
        ally2.maxHp = 1000//敵1の最大のHp
        self.addChild(ally2)
        
        ally2HpBarBack.position = CGPoint(x: -5,y: -25)
        ally2HpBarBack.zPosition = 2
        ally2.addChild(ally2HpBarBack)
        
        ally2HpBar.position = CGPoint(x: -5,y: -25)
        ally2HpBar.zPosition = 2
        ally2HpBar.xScale = CGFloat(Double(ally2.hp!) / Double(ally2.maxHp!))//x方向の倍率
        ally2.addChild(ally2HpBar)
        
        ally2GradeIcon.name = "ally2Gradeicon"
        ally2GradeIcon.position = CGPoint(x: -37, y: -25)
        ally2GradeIcon.zPosition = 2
        ally2GradeIcon.xScale = 0.3
        ally2GradeIcon.yScale = 0.3
        ally2.addChild(ally2GradeIcon)
        
        ally2GradeLabel.text = "0"// Labelに文字列を設定.
        ally2GradeLabel.name = "ally2GradeLabel"
        ally2GradeLabel.fontSize = 20// フォントサイズを設定.
        ally2GradeLabel.fontColor = UIColor.black// 色を指定(赤).
        ally2GradeLabel.position = CGPoint(x: -37, y: -30)// 表示するポジションを指定.
        ally2GradeLabel.zPosition = 2
        ally2GradeLabel.text = " \(ally2.grade!)"
        ally2.addChild(ally2GradeLabel)
        
        MoveMarker2.position = ally2.position
        MoveMarker2.alpha = 0.0
        MoveMarker2.name = "MoveMarker2"
        self.addChild(MoveMarker2)
        
        //右上
        ally2Skill1.anchorPoint = CGPoint(x: 0, y: 0)
        ally2Skill1.xScale = 2 / 3
        ally2Skill1.yScale = 2 / 3
        ally2Skill1.name = "ally2Skill1"
        ally2Skill1.alpha = 0.0
        ally2Skill1.zPosition = 2
        ally2Skill1.position = CGPoint(x: 0,y: 0)
        ally2.addChild(ally2Skill1)
        
        //右下
        ally2Skill2.anchorPoint = CGPoint(x: 0, y: 0)
        ally2Skill2.xScale = 2 / 3
        ally2Skill2.yScale = 2 / 3
        ally2Skill2.name = "ally2Skill2"
        ally2Skill2.alpha = 0.0
        ally2Skill2.zPosition = 2
        ally2Skill2.position = CGPoint(x: 0,y: -100)
        ally2.addChild(ally2Skill2)
        
        //左上
        ally2Skill3.anchorPoint = CGPoint(x: 0, y: 0)
        ally2Skill3.xScale = 2 / 3
        ally2Skill3.yScale = 2 / 3
        ally2Skill3.name = "ally2Skill3"
        ally2Skill3.alpha = 0.0
        ally2Skill3.zPosition = 2
        ally2Skill3.position = CGPoint(x: -100,y: 0)
        ally2.addChild(ally2Skill3)
        
        //左下
        ally2Skill4.anchorPoint = CGPoint(x: 0, y: 0)
        ally2Skill4.xScale = 2 / 3
        ally2Skill4.yScale = 2 / 3
        ally2Skill4.name = "ally2Skill4"
        ally2Skill4.alpha = 0.0
        ally2Skill4.zPosition = 2
        ally2Skill4.position = CGPoint(x: -100,y: -100)
        ally2.addChild(ally2Skill4)
        
        //右
        ally2Skill5.anchorPoint = CGPoint(x: 0, y: 0)
        ally2Skill5.name = "ally2Skill5"
        ally2Skill5.alpha = 0.0
        ally2Skill5.zPosition = 2
        ally2.addChild(ally2Skill5)
        
        
    }
    
    func makeAlly3() {
        
        ally3.name = "Ally3"
        ally3.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "monster3a"), size: ally3.size)
        ally3.physicsBody?.isDynamic = false
        ally3.physicsBody?.restitution = 1.0//反発値
        ally3.position = CGPoint(x: 150,y: 225)
        ally3.zPosition = 1 //movermarkerより上に来るようにz=1
        ally3.userData = NSMutableDictionary()
        ally3.userData?.setValue( PhysicsCategory.Ally, forKey: "category")
        ally3.physicsBody?.categoryBitMask = PhysicsCategory.Ally //物体のカテゴリ次元をally
        ally3.physicsBody?.contactTestBitMask = PhysicsCategory.eBullet //衝突を検知するカテゴリBall
        ally3.physicsBody?.collisionBitMask = PhysicsCategory.Ally //衝突させたい物体＝＞なし
        ally3.id = 3
        ally3.grade = 1
        ally3.hp = 1000
        ally3.maxHp = 1000//敵1の最大のHp
        self.addChild(ally3)
        
        ally3HpBarBack.position = CGPoint(x: -5,y: -25)
        ally3HpBarBack.zPosition = 2
        ally3.addChild(ally3HpBarBack)
        
        ally3HpBar.position = CGPoint(x: -5,y: -25)
        ally3HpBar.zPosition = 2
        ally3HpBar.xScale = CGFloat(Double(ally3.hp!) / Double(ally3.maxHp!))//x方向の倍率
        ally3.addChild(ally3HpBar)
        
        ally3GradeIcon.name = "ally3Gradeicon"
        ally3GradeIcon.position = CGPoint(x: -37, y: -25)
        ally3GradeIcon.zPosition = 2
        ally3GradeIcon.xScale = 0.3
        ally3GradeIcon.yScale = 0.3
        ally3.addChild(ally3GradeIcon)
        
        ally3GradeLabel.text = "0"// Labelに文字列を設定.
        ally3GradeLabel.name = "ally3GradeLabel"
        ally3GradeLabel.fontSize = 20// フォントサイズを設定.
        ally3GradeLabel.fontColor = UIColor.black// 色を指定(赤).
        ally3GradeLabel.position = CGPoint(x: -37, y: -30)// 表示するポジションを指定.
        ally3GradeLabel.zPosition = 2
        ally3GradeLabel.text = " \(ally3.grade!)"
        ally3.addChild(ally3GradeLabel)
        
        MoveMarker3.position = ally3.position
        MoveMarker3.alpha = 0.0
        MoveMarker3.name = "MoveMarker3"
        self.addChild(MoveMarker3)
        
        //右上
        ally3Skill1.anchorPoint = CGPoint(x: 0, y: 0)
        ally3Skill1.xScale = 2 / 3
        ally3Skill1.yScale = 2 / 3
        ally3Skill1.name = "ally3Skill1"
        ally3Skill1.alpha = 0.0
        ally3Skill1.zPosition = 2
        ally3Skill1.position = CGPoint(x: 0,y: 0)
        ally3.addChild(ally3Skill1)
        
        //右下
        ally3Skill2.anchorPoint = CGPoint(x: 0, y: 0)
        ally3Skill2.xScale = 2 / 3
        ally3Skill2.yScale = 2 / 3
        ally3Skill2.name = "ally3Skill2"
        ally3Skill2.alpha = 0.0
        ally3Skill2.zPosition = 2
        ally3Skill2.position = CGPoint(x: 0,y: -100)
        ally3.addChild(ally3Skill2)
        
        //左上
        ally3Skill3.anchorPoint = CGPoint(x: 0, y: 0)
        ally3Skill3.xScale = 2 / 3
        ally3Skill3.yScale = 2 / 3
        ally3Skill3.name = "ally3Skill3"
        ally3Skill3.alpha = 0.0
        ally3Skill3.zPosition = 2
        ally3Skill3.position = CGPoint(x: -100,y: 0)
        ally3.addChild(ally3Skill3)
        
        //左下
        ally3Skill4.anchorPoint = CGPoint(x: 0, y: 0)
        ally3Skill4.xScale = 2 / 3
        ally3Skill4.yScale = 2 / 3
        ally3Skill4.name = "ally3Skill4"
        ally3Skill4.alpha = 0.0
        ally3Skill4.zPosition = 2
        ally3Skill4.position = CGPoint(x: -100,y: -100)
        ally3.addChild(ally3Skill4)
        
        //右
        ally3Skill5.anchorPoint = CGPoint(x: 0, y: 0)
        ally3Skill5.name = "ally3Skill5"
        ally3Skill5.alpha = 0.0
        ally3Skill5.zPosition = 2
        ally3.addChild(ally3Skill5)
        
    }
    
    func makeWall() {
        
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
        
    }
    
    //////////////////////////移動系メソッド集/////////////////////////////////
    
    func gotoSelectScene() {
        
        let Scene = SelectScene()
        Scene.size = self.size
        let transition = SKTransition.crossFade(withDuration: 1.0)
        
        self.view?.presentScene(Scene, transition: transition)
        
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
    
    func overlap(location:CGPoint) -> Bool {//ポイントの背面がbackgroundならtrueを返す。
        
        if self.atPoint(location).name == "Background" {
            return true
        }
        
        return false
        
    }
    
}
