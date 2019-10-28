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
    var waveEnemyNumber:Int = 0//敵の数を管理する。
    var turn:Int = 1
    
    var MainTimer:Timer?
    var phasenumber:Int = 0
    var phaseFlag = true //trueならMovePhase.falseならAttackPhase
    
    var Background = SKSpriteNode(imageNamed: "background")
    
    //ally1ここから
    var ally1  = Ally(imageNamed: "monster1a")//allyの追加
    var MoveMarker1 = SKSpriteNode(imageNamed: "movemarker1")//ally1のmovemader
    var ally1GradeIcon = SKSpriteNode(imageNamed: "gradeicon")
    let ally1GradeLabel = SKLabelNode()
    
    var ally1HpBar = SKSpriteNode(color: UIColor.green, size: CGSize(width: 40.0, height: 10.0))//味方のhpの量を表示
    var ally1HpBarBack = SKSpriteNode(color: UIColor.black, size: CGSize(width: 45.0, height: 14.0))//味方のhpの量を表示
    
    var ally1Skill1 = SKSpriteNode(imageNamed: "ally1skill1")
    var ally1Skill2 = SKSpriteNode(imageNamed: "ally1skill2")
    var ally1Skill3 = SKSpriteNode(imageNamed: "ally1skill3")
    var ally1Skill4 = SKSpriteNode(imageNamed: "ally1skill4")
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
    
    var ally2Skill1 = SKSpriteNode(imageNamed: "ally2skill1")
    var ally2Skill2 = SKSpriteNode(imageNamed: "ally2skill2")
    var ally2Skill3 = SKSpriteNode(imageNamed: "ally2skill3")
    var ally2Skill4 = SKSpriteNode(imageNamed: "ally2skill4")
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
    
    var ally3Skill1 = SKSpriteNode(imageNamed: "ally3skill1")
    var ally3Skill2 = SKSpriteNode(imageNamed: "ally3skill2")
    var ally3Skill3 = SKSpriteNode(imageNamed: "ally3skill3")
    var ally3Skill4 = SKSpriteNode(imageNamed: "ally3skill4")
    var ally3Skill5 = SKSpriteNode(color: UIColor.green, size: CGSize(width: 50.0, height: 50.0))//skill4の四角
    var ally3SkilledFlag = true //スキルを使ったかどうかを判定するflag
    var axFlag:Bool = true //斧を持っているかどうか。trueは持っている。falseは持っていない。
    
    var Ally3Flag = true
    var MoveMarker3Flag = true
    //ally3ここまで
    
    var AllyArray:[Ally] = []
    
    var EnemyArray:[Enemy] = []
    
    var LeftWall = SKSpriteNode(color: UIColor.black, size: CGSize(width: 48, height: 334))
    var RightWall = SKSpriteNode(color: UIColor.black, size: CGSize(width: 48, height: 334))
    var UpperWall = SKSpriteNode(color: UIColor.black, size: CGSize(width: 896, height: 10))
    var LowerWall = SKSpriteNode(color: UIColor.black, size: CGSize(width: 896, height: 10))
    
    var ItemCount:Int = 1 //Itemの数を管理する。
    
    var stopActionFlag:Bool = false
    var stopActionNumber = 0
    var aimPosition:CGPoint = CGPoint(x:0,y:0)
    
    let userDefaults = UserDefaults.standard //管理用のuserdefaults
    
    var battleFlag1:Bool = false
    
    let settingButton = SKSpriteNode(imageNamed: "setting") //設定ボタン。
    
    //衝突判定のためのビットマスク作成
    struct PhysicsCategory {
        
        static let Ally: UInt32 =  0b0001 //味方
        static let Enemy: UInt32 = 0b0010 //敵
        static let Bullet: UInt32 = 0b0100 //ally用の弾
        static let eBullet: UInt32 = 0b1000 //enemy用の弾
        static let Item:UInt32 = 0b00010000 //アイテム
        static let Wall: UInt32 = 0b00100000 //壁
        
    }
    
    override func didMove(to view: SKView) { //起動した時の処理
        
        self.size = CGSize(width: 896, height: 414)//896x414が最適。これはiphoneXRの画面サイズを横にしたもの。
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        self.physicsWorld.contactDelegate = self //didBeginCOntactに必要
        
        self.backgroundColor = UIColor.white
        
        phaseLabel.fontSize = 25
        phaseLabel.fontColor = UIColor.red
        phaseLabel.position = CGPoint(x: 448, y: 390)// 表示するポジションを指定.今は中央
        phaseLabel.text = "MovePhase"
        self.addChild(phaseLabel)//シーンに追加
        
        numberLabel.fontSize = 25
        numberLabel.fontColor = UIColor.red
        numberLabel.position = CGPoint(x: 448, y: 364)// 表示するポジションを指定.今は中央
        numberLabel.text = "0"
        self.addChild(numberLabel)//シーンに追加
        
        waveLabel.fontSize = 35
        waveLabel.fontColor = UIColor.black
        waveLabel.position = CGPoint(x: 748, y: 364)// 表示するポジションを指定.今は中央
        waveLabel.text = "wave: \(waveNumber) / \(maxWaveNumber) "
        self.addChild(waveLabel)//シーンに追加
        
        //設定ボタンの処理
        settingButton.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "setting"), size: settingButton.size)
        settingButton.name = "setting"
        settingButton.position = CGPoint(x: 50,y: 380)
        settingButton.physicsBody?.categoryBitMask = 0b00000000
        settingButton.physicsBody?.collisionBitMask = 0b00000000
        settingButton.physicsBody?.contactTestBitMask = 0b00000000
        settingButton.xScale = 0.1
        settingButton.yScale = 0.1
        self.addChild(settingButton)
        
        
        self.MainTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.mainTimerupdate), userInfo: nil, repeats: true)
        
        //四つの壁
        self.makeWall()
        
        let world:Int = userDefaults.integer(forKey: "world")
        let stage:Int = userDefaults.integer(forKey: "stage")
        
        if world == 5 {
            
            if stage == 1 { //潜入捜査のため、ユニットは一人
                //ally1の処理
                self.makeAlly3(position: CGPoint(x: 75,y: 250))
                AllyArray.append(ally3)
            }
            
        } else {
            
            //ally1の処理、ガンマン
            self.makeAlly1(position: CGPoint(x: 100,y: 75))
            AllyArray.append(ally1)
            
            //ally2の処理、忍者
            self.makeAlly2(position: CGPoint(x: 100,y: 225))
            AllyArray.append(ally2)
            
            //ally3の処理、パラディン
            self.makeAlly3(position: CGPoint(x: 150,y: 150))
            AllyArray.append(ally3)
            
        }
        
        Stage = self.makeStage()
        
        //敵の追加。
        self.addEnemy()
        
        //始める時の処理。フラグ関係。
        self.start()
        
    }
    
    @objc func mainTimerupdate() {
        
        //phaseの切り替えの処理。
        phasenumber = phasenumber + 1
        numberLabel.text = "\( Float(120 - phasenumber) / 10)"
        
        if phasenumber == 120 {
            
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
                
            } else { //Movephaseに切り替わる時。
                
                turn = turn + 1//turnを増やす。
                
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
                    
                    if Int.random(in: 0 ..< 2) == 0 { //毎ターン回復アイテムかgradeupアイテムがフィールドに現れる。
                        
                        print("makeheart")
                        
                        var heartX = 0
                        var heartY = 0
                        
                        repeat { // repeat-while文のため、この処理は最低1回実行される
                            
                            heartX = Int.random(in: 0 ..< 816)
                            heartY = Int.random(in: 0 ..< 254)
                            
                        } while(overlap(location: CGPoint(x: heartX,y: heartY)))
                        
                        self.makeHeart(x: heartX, y: heartY)
                        
                    } else {
                        
                        print("makegrade")
                        
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
            
            phaseLabel.text = "MovePhase"
            
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
                        
                        if length(v: relativepostion) <= 6 {//相対位置の距離が6以下の場合、位置を同じにする。
                            
                            ally1.position = MoveMarker1.position
                            MoveMarker1.alpha = 0.0
                            
                        } else {//違う場合距離にして3づつ近づく。
                            
                            let speed:Double = 3 //移動速度を決定する。
                            let travelTime = SKAction.move( to: CGPoint(x: ally1.position.x - CGFloat( speed * cos(Double(direction))),y: ally1.position.y
                                + CGFloat( speed * sin(Double(direction)))), duration: 0.01)
                            ally1.run(travelTime)
                            
                        }
                        
                        ally1.alpha = 0.0
                        if self.atPoint(ally1.position).name == "poison" {
                            self.changeAllyHp(change: -50, id: 1)
                            self.damageEffect(damageposition: ally1.position, damage: 50)
                        }
                        ally1.alpha = 1.0
                        
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
                        
                        if length(v: relativepostion) <= 6 {//相対位置の距離が6以下の場合、位置を同じにする。
                            
                            ally2.position = MoveMarker2.position
                            MoveMarker2.alpha = 0.0
                            
                        } else {//違う場合距離にして3づつ近づく
                            
                            let speed:Double = 5 //移動速度を決定する。
                            
                            let travelTime = SKAction.move( to: CGPoint(x: ally2.position.x - CGFloat( speed * cos(Double(direction))),y: ally2.position.y
                                + CGFloat( speed * sin(Double(direction)))), duration: 0.01)
                            ally2.run(travelTime)
                            
                        }
                        
                        ally2.alpha = 0.0
                        if self.atPoint(ally2.position).name == "poison" {
                            self.changeAllyHp(change: -50, id: 2)
                            self.damageEffect(damageposition: ally2.position, damage: 50)
                        }
                        ally2.alpha = 1.0
                        
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
                            
                        } else {//違う場合距離にして3づつ近づく
                            
                            let speed:Double = 3 //移動速度を決定する。
                            let travelTime = SKAction.move( to: CGPoint(x: ally3.position.x - CGFloat( speed * cos(Double(direction))),y: ally3.position.y
                                + CGFloat( speed * sin(Double(direction)))), duration: 0.01)
                            ally3.run(travelTime)
                            
                        }
                        
                        ally3.alpha = 0.0
                        if self.atPoint(ally3.position).name == "poison" {
                            self.changeAllyHp(change: -50, id: 3)
                            self.damageEffect(damageposition: ally3.position, damage: 50)
                        }
                        ally3.alpha = 1.0
                        
                    }
                }
                
            } else {
                
            }
            
            self.EnemyAttack()
            
        } else {//Attackphaseの時のタイマー
            phaseLabel.text = "AttackPhase"
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
            
            if self.atPoint(location).name == "setting" {
                
                print("setting")
                self.gotoSelectScene()
                
            }
            
            if stopActionFlag {//途中動作
                
                aimPosition = location
                self.StopAction(actionNumber: 0)
                
            } else {
                
                if self.atPoint(location).name == "Ally1"{
                    Ally1Flag = true
                    
                    if phaseFlag {
                        MoveMarker1.alpha = 1.0
                        MoveMarker1.position = ally1.position
                    } else {
                        if ally1SkilledFlag {
                            ally1Skill1.alpha = 1.0
                            ally1Skill2.alpha = 1.0
                            if ally1.grade! <= 2 {//グレードを上昇させる技のため、グレードが上限の時は表示しない。(grade==3で上限)
                                ally1Skill3.alpha = 1.0
                            }
                            ally1Skill4.alpha = 1.0
                        }
                    }
                    
                }
                if self.atPoint(location).name == "MoveMarker1"{
                    MoveMarker1Flag = true
                }
                if self.atPoint(location).name == "Ally2"{
                    Ally2Flag = true
                    
                    if phaseFlag {
                        MoveMarker2.alpha = 1.0
                        MoveMarker2.position = ally2.position
                    } else {
                        if ally2SkilledFlag {
                            ally2Skill1.alpha = 1.0
                            ally2Skill2.alpha = 1.0
                            ally2Skill3.alpha = 1.0
                            ally2Skill4.alpha = 1.0
                        }
                    }
                    
                }
                if self.atPoint(location).name == "MoveMarker2"{
                    MoveMarker2Flag = true
                }
                
                if self.atPoint(location).name == "Ally3"{
                    Ally3Flag = true
                    
                    if phaseFlag {
                        MoveMarker3.alpha = 1.0
                        MoveMarker3.position = ally3.position
                    } else {
                        if ally3SkilledFlag {
                            if axFlag {
                                ally3Skill1.alpha = 1.0
                                ally3Skill2.alpha = 1.0
                            }
                            ally3Skill3.alpha = 1.0
                            ally3Skill4.alpha = 1.0
                        }
                    }
                    
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
                        
                        if axFlag {
                            
                            ally3Skill1.alpha = 1.0
                            
                            ally3Skill2.alpha = 1.0
                            
                        }
                        
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
                            
                            var bullet = Bullet()
                            
                            if ally1.grade! == 0 {
                                bullet = self.makeBullet(position: CGPoint(x: ally1.position.x,y: ally1.position.y), damage: 10, size: CGSize(width:  30.0, height: 10.0))
                            } else if ally1.grade! == 1 {
                                print("ally1Skill1")
                                bullet = self.makeBullet(position: CGPoint(x: ally1.position.x,y: ally1.position.y), damage: 120, size: CGSize(width:  30.0, height: 10.0))
                            } else if ally1.grade! == 2 {
                                print("ally1Skill1G2")
                                bullet = self.makeBullet(position: CGPoint(x: ally1.position.x,y: ally1.position.y), damage: 400, size: CGSize(width:  30.0, height: 10.0))
                            } else if ally1.grade! == 3 {
                                print("ally1Skill1G3")
                                bullet = self.makeBullet(position: CGPoint(x: ally1.position.x,y: ally1.position.y), damage: 800, size: CGSize(width:  30.0, height: 10.0))
                            }
                            
                            ally1.grade! = 1 //gradeをリセットする。
                            ally1GradeLabel.text = "\(ally1.grade!)"
                            
                            self.addChild(bullet) //Bullet表示
                            
                            let action = SKAction.moveTo(x: self.size.width, duration: 1.0) //アクション作成(移動方向:Y,移動時間:1.0秒)
                            let remove = SKAction.removeFromParent()
                            
                            bullet.run(SKAction.sequence([action,remove]))
                            
                            ally1SkilledFlag = false //Skillを使ったこと判定
                            
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
                            var damage = 0
                            if ally1.grade! == 0 {
                                damage = -( 10 + Int( 0.2 * shortestDistance )) + EnemyArray[savei].defence!
                                if damage > 0 {
                                    damage = 0
                                }
                                self.changeEnemyHp(change: damage, id: EnemyArray[savei].id!)
                                self.damageEffect(damageposition: EnemyArray[savei].position, damage: damage)
                            } else if ally1.grade! == 1 {
                                damage = -( 70 + Int( 0.25 * shortestDistance )) + EnemyArray[savei].defence!
                                if damage > 0 {
                                    damage = 0
                                }
                                self.changeEnemyHp(change: damage, id: EnemyArray[savei].id!)
                                self.damageEffect(damageposition: EnemyArray[savei].position, damage: damage)
                            } else if ally1.grade! == 2 {
                                print("ally2Skill1G1")
                                damage = -( 300 + Int( shortestDistance )) + EnemyArray[savei].defence!
                                if damage > 0 {
                                    damage = 0
                                }
                                self.changeEnemyHp(change: damage, id: EnemyArray[savei].id!)
                                self.damageEffect(damageposition: EnemyArray[savei].position, damage: damage)
                            } else if ally1.grade! == 3 {
                                print("ally2Skill1G2")
                                damage = -3000 //防御貫通攻撃。
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
                
                ally1Skill1.alpha = 0.0 //name判定より後にしないと判定がされなくなる。
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
                            
                            var syuriken1 = Bullet()
                            
                            syuriken1 = self.makeBullet(position: CGPoint(x: ally2.position.x,y: ally2.position.y), damage: 1, size: CGSize(width:  50.0, height: 50.0))
                            
                            self.addChild(syuriken1)//Bullet表示
                            
                            let action1 = SKAction.move(to: CGPoint(x: ally2.position.x + 200, y: ally2.position.y + 200), duration: 0.5)//右上
                            let backaction = SKAction.move(to: CGPoint(x: ally2.position.x, y: ally2.position.y), duration: 0.5)
                            let actionDone = SKAction.removeFromParent()
                            syuriken1.run(SKAction.sequence([action1,backaction,actionDone]))
                            
                            var syuriken2 = Bullet()
                            
                            syuriken2 = self.makeBullet(position: CGPoint(x: ally2.position.x,y: ally2.position.y), damage: 1, size: CGSize(width:  50.0, height: 50.0))
                            
                            self.addChild(syuriken2)//Bullet表示
                            
                            let action2 = SKAction.move(to: CGPoint(x: ally2.position.x + 200, y: ally2.position.y - 200), duration: 0.5)//右下
                            syuriken2.run(SKAction.sequence([action2,backaction,actionDone]))
                            
                            var syuriken3 = Bullet()
                            
                            syuriken3 = self.makeBullet(position: CGPoint(x: ally2.position.x,y: ally2.position.y), damage: 1, size: CGSize(width:  50.0, height: 50.0))
                            
                            self.addChild(syuriken3)//Bullet表示
                            
                            let action3 = SKAction.move(to: CGPoint(x: ally2.position.x - 200, y: ally2.position.y + 200), duration: 0.5)//左上
                            syuriken3.run(SKAction.sequence([action3,backaction,actionDone]))
                            
                            var syuriken4 = Bullet()
                            
                            syuriken4 = self.makeBullet(position: CGPoint(x: ally2.position.x,y: ally2.position.y), damage: 1, size: CGSize(width:  50.0, height: 50.0))
                            
                            self.addChild(syuriken4)//Bullet表示
                            
                            let action4 = SKAction.move(to: CGPoint(x: ally2.position.x - 200, y: ally2.position.y - 200), duration: 0.5)//左下
                            syuriken4.run(SKAction.sequence([action4,backaction,actionDone]))
                            
                            if ally2.grade! == 0 {
                                print("ally2Skill1G0")
                                syuriken1.damage = 5
                                syuriken2.damage = 5
                                syuriken3.damage = 5
                                syuriken4.damage = 5
                            } else if ally2.grade! == 1 {
                                print("ally2Skill1")
                                syuriken1.damage = 80
                                syuriken2.damage = 80
                                syuriken3.damage = 80
                                syuriken4.damage = 80
                            } else if ally2.grade! == 2 {
                                print("ally2Skill1G2")
                                syuriken1.damage = 240
                                syuriken2.damage = 240
                                syuriken3.damage = 240
                                syuriken4.damage = 240
                            } else if ally2.grade! == 3 {
                                print("ally2Skill1G3")
                                syuriken1.damage = 600
                                syuriken2.damage = 600
                                syuriken3.damage = 600
                                syuriken4.damage = 600
                            }
                            
                            ally2.grade! = 1 //gradeをリセットする。
                            ally2GradeLabel.text = "\(ally2.grade!)"
                            
                            ally2SkilledFlag = false//Skillを使ったこと判定
                            
                        }
                        
                        if self.atPoint(location).name == "ally2Skill2" {//skill2の発動。毒霧で攻撃する。敵のグレードを下げる。
                            
                            var poison = Bullet()
                            
                            poison =  self.makeBullet(position: CGPoint(x: ally2.position.x,y: ally2.position.y), damage: 30, size: CGSize(width:  30.0, height: 30.0))
                            poison.name = "poison"
                            self.addChild(poison)//Bullet表示
                            
                            let action = SKAction.moveTo(x: self.size.width, duration: 1.0)//アクション作成(移動方向:Y,移動時間:1.0秒)
                            let actionDone = SKAction.removeFromParent()
                            poison.run(SKAction.sequence([action,actionDone]))
                            
                            ally2SkilledFlag = false
                            
                        }
                        
                        if self.atPoint(location).name == "ally2Skill3" {//skill3の発動。範囲内の敵を全員攻撃する。
                            
                            
                            for i in 0 ..< EnemyArray.count {
                                if 300 >= length(v: CGPoint(x: ally2.position.x - EnemyArray[i].position.x,y: ally2.position.y - EnemyArray[i].position.y)) {
                                    var damage = 0
                                    if ally2.grade! == 0 {
                                        print("ally2Skill2")
                                        damage = -15 + EnemyArray[i].defence!
                                        if damage > 0 {
                                            damage = 0
                                        }
                                        self.changeEnemyHp(change: damage
                                            , id: EnemyArray[i].id!)
                                        self.damageEffect(damageposition: EnemyArray[i].position, damage: damage )
                                    } else if ally2.grade! == 1 {
                                        print("ally2Skill2")
                                        damage = -80 + EnemyArray[i].defence!
                                        if damage > 0 {
                                            damage = 0
                                        }
                                        self.changeEnemyHp(change: damage, id: EnemyArray[i].id!)
                                        self.damageEffect(damageposition: EnemyArray[i].position, damage: damage )
                                    } else if ally2.grade! == 2 {
                                        print("ally2Skill2G2")
                                        damage = -250 + EnemyArray[i].defence!
                                        if damage > 0 {
                                            damage = 0
                                        }
                                        self.changeEnemyHp(change: damage, id: EnemyArray[i].id!)
                                        self.damageEffect(damageposition: EnemyArray[i].position, damage: damage )
                                    } else if ally2.grade! == 3 {
                                        print("ally2Skill2G3")
                                        damage = -1400 + EnemyArray[i].defence!
                                        if damage > 0 {
                                            damage = 0
                                        }
                                        self.changeEnemyHp(change: damage, id: EnemyArray[i].id!)
                                        self.damageEffect(damageposition: EnemyArray[i].position, damage: damage )
                                    }
                                    
                                    ally2.grade! = 1 //gradeをリセットする。
                                    ally2GradeLabel.text = "\(ally2.grade!)"
                                    
                                    
                                }
                            }
                            
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
                            var bullet = Bullet()//skill1の四角
                            
                            bullet = self.makeBullet(position: CGPoint(x: ally3.position.x - 30,y: ally3.position.y), damage: 1, size: CGSize(width:  10.0, height: 70.0))
                            
                            if ally3.grade! == 0 {
                                print("ally3Skill1G0")
                                bullet.damage = 60
                            } else if ally3.grade! == 1 {
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
                            
                            self.addChild(bullet)//Bullet表示
                            
                            let action = SKAction.moveTo(x: ally3.position.x + 80, duration: 0.3)//アクション作成(移動方向:Y,移動時間:1.0秒)
                            let actionDone = SKAction.removeFromParent()
                            bullet.run(SKAction.sequence([action,actionDone]))
                            
                            ally3SkilledFlag = false//Skillを使ったこと判定
                            
                        }
                        
                        if self.atPoint(location).name == "ally3Skill2" {//skill2の発動、斧を投げる
                            
                            //Bullet作成
                            var bullet = Bullet()
                            
                            bullet = self.makeBullet(position: CGPoint(x: ally3.position.x,y: ally3.position.y), damage: 1, size: CGSize(width:  30.0, height: 50.0))
                            
                            if ally3.grade! == 0 {
                                print("ally3Skill2G0")
                                bullet.damage = 60
                            } else if ally3.grade! == 1 {
                                print("ally3Skill2")
                                bullet.damage = 200
                            } else if ally3.grade! == 2 {
                                print("ally3Skill2G1")
                                bullet.damage = 500
                            } else if ally3.grade! == 3 {
                                print("ally3Skill2G2")
                                bullet.damage = 1300
                            }
                            
                            ally3.grade! = 1//gradeをリセットする。
                            ally3GradeLabel.text = "\(ally3.grade!)"
                            
                            self.addChild(bullet)//Bullet表示
                            
                            let action = SKAction.moveTo(x: ally3.position.x + 200, duration: 1.0)//アクション作成(移動方向:Y,移動時間:1.0秒)
                            let actionDone = SKAction.removeFromParent()
                            
                            bullet.run(SKAction.sequence([action,actionDone]))
                            
                            axFlag = false
                            
                            ally3SkilledFlag = false
                            
                        }
                        
                        if self.atPoint(location).name == "ally3Skill3" {//skill3の発動。移動しながら攻撃する。
                            
                            print("ally3Skill3")
                            
                            var bullet = Bullet()
                            
                            bullet = self.makeBullet(position: CGPoint(x: ally3.position.x,y: ally3.position.y), damage: 80, size: CGSize(width:  100.0, height: 100.0))
                            
                            bullet.name = "charge"
                            self.addChild(bullet)
                            
                            var action = SKAction.moveTo(x: ally3.position.x + 150, duration: 1.0)//アクション作成(移動方向:Y,移動時間:1.0秒)
                            if ally3.position.x + 150.0  > 866 {
                                action = SKAction.moveTo(x: 866, duration: 1.0)//アクション作成(移動方向:Y,移動時間:1.0秒)
                            }
                            
                            let actionDone = SKAction.removeFromParent()
                            
                            bullet.run(SKAction.sequence([action,actionDone]))
                            ally3.run(action,withKey: "charge")
                            
                            ally3.moveEnable = false
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                
                                self.MoveMarker3.position = self.ally3.position
                                self.ally3.moveEnable = true
                                
                            }
                            
                            ally3SkilledFlag = false
                            
                        }
                        
                        if self.atPoint(location).name == "ally3Skill4" {//skill4の発動。範囲内にいる敵に攻撃する。攻撃したを移動しなくする。
                            
                            for i in 0 ..< EnemyArray.count {
                                if 200 >= length(v: CGPoint(x: ally3.position.x - EnemyArray[i].position.x,y: ally3.position.y - EnemyArray[i].position.y)) {
                                    var damage = 0
                                    
                                    if ally3.grade! == 0 {
                                        print("ally3Skill4G0")
                                        damage = -10 + EnemyArray[i].defence!
                                        if damage > 0 {
                                            damage = 0
                                        }
                                        self.changeEnemyHp(change: damage, id: EnemyArray[i].id!)
                                        self.damageEffect(damageposition: EnemyArray[i].position, damage: damage)
                                    } else if ally3.grade! == 1 {
                                        print("ally3Skill4")
                                        damage = -60 + EnemyArray[i].defence!
                                        if damage > 0 {
                                            damage = 0
                                        }
                                        self.changeEnemyHp(change: damage, id: EnemyArray[i].id!)
                                        self.damageEffect(damageposition: EnemyArray[i].position, damage: damage)
                                    } else if ally3.grade! == 2 {
                                        print("ally3Skill4G1")
                                        damage = -160 + EnemyArray[i].defence!
                                        if damage > 0 {
                                            damage = 0
                                        }
                                        self.changeEnemyHp(change: damage, id: EnemyArray[i].id!)
                                        self.damageEffect(damageposition: EnemyArray[i].position, damage: damage)
                                    } else if ally3.grade! == 3 {
                                        print("ally3Skill4G2")
                                        damage = -1000 + EnemyArray[i].defence!
                                        if damage > 0 {
                                            damage = 0
                                        }
                                        self.changeEnemyHp(change: damage, id: EnemyArray[i].id!)
                                        self.damageEffect(damageposition: EnemyArray[i].position, damage: damage)
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
                
                if nodeA.physicsBody?.categoryBitMask == PhysicsCategory.Enemy && nodeB.physicsBody?.categoryBitMask == PhysicsCategory.Bullet || nodeA.physicsBody?.categoryBitMask == PhysicsCategory.Bullet && nodeB.physicsBody?.categoryBitMask == PhysicsCategory.Enemy {
                    
                    //ダメージ処理
                    print("EnemyDamaged")
                    
                    if nodeA.physicsBody?.categoryBitMask == PhysicsCategory.Bullet {
                        
                        var damage = -(nodeA as! Bullet).damage! + (nodeB as! Enemy).defence!
                                            
                        if damage > 0 {
                            damage = 0
                        }
                                            
                        self.changeEnemyHp(change: damage, id: (nodeB as! Enemy).id!)
                                            
                        self.damageEffect(damageposition: nodeA.position,damage: -damage)
                                            
                        if nodeA.name == "poison" {
                            if (nodeB as! Enemy).grade! >= 1 {
                                    self.changeEnemyGrade(change: (nodeB as! Enemy).grade! - 1, id: (nodeB as! Enemy).id!)
                            }
                        }
                                            
                        if nodeA.name == "charge" {
                                                
                            ally3.removeAction(forKey: "charge")
                            self.MoveMarker3.position = self.ally3.position
                            self.ally3.moveEnable = true
                                                
                        }
                                            
                        if nodeA.name == "ax" {
                            
                        }
                                            
                        nodeA.removeFromParent()
                                            
                        }
                    
                    if nodeB.physicsBody?.categoryBitMask == PhysicsCategory.Bullet {
                        
                        var damage = -(nodeB as! Bullet).damage! + (nodeA as! Enemy).defence!
                                            
                        if damage > 0 {
                            damage = 0
                        }
                                            
                        self.changeEnemyHp(change: damage, id: (nodeA as! Enemy).id!)
                                            
                        self.damageEffect(damageposition: nodeB.position,damage: -damage)

                                            
                        if nodeB.name == "poison" {
                            if (nodeA as! Enemy).grade! >= 1 {
                                    
                                self.changeEnemyGrade(change: (nodeA as! Enemy).grade! - 1, id: (nodeA as! Enemy).id!)
                                                    
                                }
                        }
                                            
                        if nodeB.name == "charge" {
                            
                            ally3.removeAction(forKey: "charge")
                            self.MoveMarker3.position = self.ally3.position
                            self.ally3.moveEnable = true
                                                
                        }
                                            
                        if nodeB.name == "ax" {
                                
                        }
                                            
                        nodeB.removeFromParent()
                                    
                    }
                    
                }
                
                
                //敵の弾と味方が当たる時の判定メソッド
                if nodeA.physicsBody?.categoryBitMask == PhysicsCategory.Ally && nodeB.physicsBody?.categoryBitMask == PhysicsCategory.eBullet || nodeA.physicsBody?.categoryBitMask == PhysicsCategory.eBullet && nodeB.physicsBody?.categoryBitMask == PhysicsCategory.Ally {
                    
                    print("AllyDamaged")
                    
                    if nodeA.physicsBody?.categoryBitMask == PhysicsCategory.eBullet {
                        
                        if nodeA.name == "camera" {
                            self.gameover(side: "ally")
                        } else {

                            self.changeAllyHp(change: -(nodeA as! Bullet).damage!, id: (nodeB as! Ally).id!)
                            
                            self.damageEffect(damageposition: nodeA.position,damage: (nodeA as! Bullet).damage!)
                            
                        }
                        
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
                        
                    } else if nodeB.physicsBody?.categoryBitMask == PhysicsCategory.eBullet {
                        
                        
                        if nodeB.name == "camera" {
                            self.gameover(side: "ally")
                        } else {

                            self.changeAllyHp(change: -(nodeB as! Bullet).damage!, id: (nodeA as! Ally).id!)
                            self.damageEffect(damageposition: nodeB.position,damage: (nodeB as! Bullet).damage!)
                            
                        }
                        
                        
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
                if nodeA.physicsBody?.categoryBitMask == PhysicsCategory.Item && nodeB.physicsBody?.categoryBitMask == PhysicsCategory.Ally || nodeA.physicsBody?.categoryBitMask == PhysicsCategory.Ally && nodeB.physicsBody?.categoryBitMask == PhysicsCategory.Item {
                    
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
                        
                        print("getgradeupItem")
                        ItemCount = ItemCount - 1
                        
                        if nodeA.name == "Ally1" || nodeB.name == "Ally1" {
                            
                            if ally1.grade! < 3 {
                                ally1.grade! = ally1.grade! + 1
                            }
                            ally1GradeLabel.text =  "\(ally1.grade!)"
                            
                        } else if nodeA.name == "Ally2" || nodeB.name == "Ally2" {
                            
                            if ally2.grade! < 3 {
                                ally2.grade! = ally2.grade! + 1
                            }
                            ally2GradeLabel.text =  "\(ally2.grade!)"
                            
                        } else if nodeA.name == "Ally3" || nodeB.name == "Ally3" {
                            
                            if ally3.grade! < 3 {
                                ally3.grade! = ally3.grade! + 1
                            }
                            ally3GradeLabel.text =  "\(ally3.grade!)"
                        }
                        
                    }
                    
                    if nodeA.physicsBody?.categoryBitMask == PhysicsCategory.Item {
                        nodeA.removeFromParent()
                    }
                    
                    if nodeB.physicsBody?.categoryBitMask == PhysicsCategory.Item {
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
        var needKillFlag:Bool = false
        
        for i in EnemyArray {
            
            EnemyidArray.append(i.id!)
            
        }
        
        if let Index = EnemyidArray.firstIndex(of: id) {
            
            print("hp変化する敵: \(Index)")
            
            let enemy:Enemy = EnemyArray[Index]
            
            enemy.hp! = enemy.hp! + change
            
            if enemy.hp! >= enemy.maxHp! {
                enemy.hp = enemy.maxHp
            }
            
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
                
                for i in EnemyArray { //残っている敵が倒すべき敵かどうかを判定する。
                    
                    if i.needToKill {
                        needKillFlag = true
                    }
                    
                }
                
                if needKillFlag {} else { //残っている敵が倒さなくて良いなら
                    
                    for i in EnemyArray { //残りの敵を消す。
                        i.removeFromParent()
                    }
                    
                    EnemyArray = []
                    
                    waveNumber = waveNumber + 1
                    
                    if waveNumber < maxWaveNumber {
                        
                        waveEnemyNumber = 0
                        self.addEnemy()
                        waveLabel.text = "wave: \(waveNumber + 1) / \(maxWaveNumber) "
                        
                        phaseFlag = true
                        
                        if MainTimer?.isValid == true {
                            MainTimer?.invalidate()
                        }
                        
                        phasenumber = 0
                        
                        self.MainTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.mainTimerupdate), userInfo: nil, repeats: true)
                        
                        
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
            
            EnemyArray[Index].grade! = change
            
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
        Heart.name = "heart"
        Heart.physicsBody?.isDynamic = false
        Heart.physicsBody?.restitution = 1.0 // 1.0にしたい。
        Heart.physicsBody?.allowsRotation = false
        Heart.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "heart.png"), size: Heart.size)
        Heart.physicsBody?.categoryBitMask = PhysicsCategory.Item
        Heart.physicsBody?.collisionBitMask = PhysicsCategory.Item | PhysicsCategory.Ally | PhysicsCategory.Wall | PhysicsCategory.Enemy
        Heart.physicsBody?.contactTestBitMask = PhysicsCategory.Item | PhysicsCategory.Ally | PhysicsCategory.Wall | PhysicsCategory.Enemy
        Heart.position = CGPoint(x: 50 + x,y: 50 + y)
        Heart.xScale = 0.7
        Heart.yScale = 0.7
        self.addChild(Heart)
        
        ItemCount = ItemCount + 1
        
    }
    
    func makeGradeupItem(x: Int,y: Int) {//gradeupItemを作る関数、まだ
        
        let GradeItem = SKSpriteNode(imageNamed: "gradeup")
        
        GradeItem.physicsBody?.usesPreciseCollisionDetection = true//精度の高い衝突判定を行う。
        GradeItem.physicsBody?.friction = 0 //摩擦係数を0にする
        GradeItem.name = "gradeup"
        GradeItem.physicsBody?.isDynamic = false
        GradeItem.physicsBody?.restitution = 1.0 // 1.0にしたい。
        GradeItem.physicsBody?.allowsRotation = false
        GradeItem.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "gradeup.png"), size: GradeItem.size)
        GradeItem.physicsBody?.categoryBitMask = PhysicsCategory.Item
        GradeItem.physicsBody?.collisionBitMask = PhysicsCategory.Item | PhysicsCategory.Ally | PhysicsCategory.Wall | PhysicsCategory.Enemy
        GradeItem.physicsBody?.contactTestBitMask = PhysicsCategory.Item | PhysicsCategory.Ally | PhysicsCategory.Wall | PhysicsCategory.Enemy
        GradeItem.position = CGPoint(x: 50 + x,y: 50 + y)
        GradeItem.xScale = 0.7
        GradeItem.yScale = 0.7
        self.addChild(GradeItem)
        
        ItemCount = ItemCount + 1
        
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
            
            gameclearBack.name = "gameclear"
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
        damageEffectBack.zPosition = 8
        self.addChild(damageEffectBack)
        
        
        let damageLabel = SKLabelNode()
        damageLabel.name = "damageLabel"
        damageLabel.fontSize = 25 // フォントサイズを設定.
        damageLabel.fontColor = UIColor.black// 色を指定
        damageLabel.position = CGPoint(x: damageposition.x,y:damageposition.y - 8)// 表示するポジションを指定.
        damageLabel.zPosition = 8
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
        
        waveEnemyNumber = Stage[waveNumber].count
        
        EnemyArray = Stage[waveNumber]
        
    }
    
    func makeStage() -> [[Enemy]] {
        
        let world:Int = userDefaults.integer(forKey: "world")
        let stage:Int = userDefaults.integer(forKey: "stage")
        
        
        var stagearray:[[Enemy]] = []
        
        if world == 1 {
            
            if stage == 1 {
                
                var firstArray:[Enemy] = []
                
                let Soilder1 = self.makeSoiler(position: CGPoint(x: 450,y: 250))
                Soilder1.id = firstArray.count
                firstArray.append(Soilder1)
                
                stagearray.append(firstArray)
                
                var secondArray:[Enemy] = []
                
                let Soilder2 = self.makeSoiler(position: CGPoint(x: 650,y: 150))
                Soilder2.id = secondArray.count
                secondArray.append(Soilder2)
                
                let Bom1 = self.makeBom(position: CGPoint(x: 450,y: 250))
                Bom1.id = secondArray.count
                secondArray.append(Bom1)
                
                stagearray.append(secondArray)
                
                maxWaveNumber = stagearray.count
                
                waveLabel.text = "wave: \(waveNumber + 1) / \(maxWaveNumber) "
                
            }
            
            if stage == 2 {
                
                var firstArray:[Enemy] = []
                
                let Soilder1 = self.makeSoiler(position: CGPoint(x: 450,y: 250))
                Soilder1.id = firstArray.count
                firstArray.append(Soilder1)
                
                let Soilder2 = self.makeSoiler(position: CGPoint(x: 650,y: 150))
                Soilder2.id = firstArray.count
                firstArray.append(Soilder2)
                
                stagearray.append(firstArray)
                
                var secondArray:[Enemy] = []
                
                let Soilder3 = self.makeSoiler(position: CGPoint(x: 650,y: 150))
                Soilder3.id = secondArray.count
                secondArray.append(Soilder3)
                
                let Soilder4 = self.makeSoiler(position: CGPoint(x: 800,y: 300))
                Soilder4.id = secondArray.count
                secondArray.append(Soilder4)
                
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
                
            }
            
        } else if world == 2 {
            
            if stage == 1 {
                
                var firstArray:[Enemy] = []
                
                let warp1 = self.makeWarp(position: CGPoint(x: 450,y: 250))
                warp1.id = firstArray.count
                firstArray.append(warp1)
                
                stagearray.append(firstArray)
                
                maxWaveNumber = stagearray.count
                
                waveLabel.text = "wave: \(waveNumber + 1) / \(maxWaveNumber) "
                
            } else if stage == 2 {
                
                var firstArray:[Enemy] = []
                
                let warp1 = self.makeWarp(position: CGPoint(x: 450,y: 250))
                warp1.id = firstArray.count
                firstArray.append(warp1)
                
                let warpBoss = self.makeWarpBoss(position: CGPoint(x: 750,y: 250))
                warpBoss.id = firstArray.count
                firstArray.append(warpBoss)
                
                stagearray.append(firstArray)
                
                maxWaveNumber = stagearray.count
                
                waveLabel.text = "wave: \(waveNumber + 1) / \(maxWaveNumber) "
                
            }
            
        } else if world == 3 {
            
            if stage == 1 {
                
                var firstArray:[Enemy] = []
                
                let tank1 = self.makeTank(position: CGPoint(x: 750,y: 200))
                tank1.id = firstArray.count
                firstArray.append(tank1)
                
                stagearray.append(firstArray)
                
                maxWaveNumber = stagearray.count
                
                waveLabel.text = "wave: \(waveNumber + 1) / \(maxWaveNumber) "
                
            } else if stage == 2 { //とりあえず、stage1と同じにしています。
                
                var firstArray:[Enemy] = []
                
                let tank1 = self.makeTank(position: CGPoint(x: 750,y: 200))
                tank1.id = firstArray.count
                firstArray.append(tank1)
                
                stagearray.append(firstArray)
                
                maxWaveNumber = stagearray.count
                
                waveLabel.text = "wave: \(waveNumber + 1) / \(maxWaveNumber) "
                
            }
            
        } else if world == 4 {
            
            if stage == 1 {
                
                var firstArray:[Enemy] = []
                
                let Senjin = self.makeSenjin(position: CGPoint(x: 750,y: 250))
                Senjin.id = firstArray.count
                firstArray.append(Senjin)
                
                stagearray.append(firstArray)
                
                maxWaveNumber = stagearray.count
                
                waveLabel.text = "wave: \(waveNumber + 1) / \(maxWaveNumber) "
                
            } else if stage == 2 { //とりあえず、stage1と同じにしています。
                
                var firstArray:[Enemy] = []
                
                let tank1 = self.makeTank(position: CGPoint(x: 750,y: 200))
                tank1.id = firstArray.count
                firstArray.append(tank1)
                
                stagearray.append(firstArray)
                
                maxWaveNumber = stagearray.count
                
                waveLabel.text = "wave: \(waveNumber + 1) / \(maxWaveNumber) "
                
            }
            
        } else if world == 5 {
            
            if stage == 1 {
                
                var firstArray:[Enemy] = []
                
                let Camera1 = self.makeCamera(position: CGPoint(x: 200,y: 70))
                Camera1.id = firstArray.count
                firstArray.append(Camera1)
                
                let Camera2 = self.makeCamera(position: CGPoint(x: 400,y: 270))
                Camera2.id = firstArray.count
                firstArray.append(Camera2)
                
                let Camera3 = self.makeCamera(position: CGPoint(x: 600,y: 60))
                Camera3.id = firstArray.count
                firstArray.append(Camera3)
                
                let Camera4 = self.makeCamera(position: CGPoint(x: 800,y: 90))
                Camera4.id = firstArray.count
                firstArray.append(Camera4)
                
                
                let Queen1 = self.makeQueen(position: CGPoint(x: 130,y: 280))
                Queen1.hp = 100
                Queen1.id = firstArray.count
                firstArray.append(Queen1)
                
                stagearray.append(firstArray)
                
                maxWaveNumber = stagearray.count
                
                waveLabel.text = "wave: \(waveNumber + 1) / \(maxWaveNumber) "
                
            }
            
            
        } else if world == 6 {
            
            if stage == 1 {
                
                //1
                var firstArray:[Enemy] = []
                
                let Wall1 = self.makeBreakableWall(position: CGPoint(x: 450,y: 290), size: CGSize(width: 30, height: 120),rotate: 135.0)
                Wall1.id = firstArray.count
                for i in Wall1.children {
                    if i.name == "HpBar" || i.name == "HpBarBack" {
                        i.position = CGPoint(x: -5,y: -25)
                    } else if i.name == "Gradeicon" {
                        i.position = CGPoint(x: -37, y: -25)
                    } else if i.name == "GradeLabel" {
                        i.position = CGPoint(x: -37, y: -30)
                    }
                }
                firstArray.append(Wall1)
                
                let Wall2 = self.makeBreakableWall(position: CGPoint(x: 350,y: 50), size: CGSize(width: 30, height: 120), rotate: 45.0)
                Wall2.id = firstArray.count
                for i in Wall2.children {
                    if i.name == "HpBar" || i.name == "HpBarBack" {
                        i.position = CGPoint(x: -5,y: -25)
                    } else if i.name == "Gradeicon" {
                        i.position = CGPoint(x: -37, y: -25)
                    } else if i.name == "GradeLabel" {
                        i.position = CGPoint(x: -37, y: -30)
                    }
                }
                firstArray.append(Wall2)
                
                let Cannon1 = self.makeCannon(position: CGPoint(x: 600,y: 200))
                Cannon1.id = firstArray.count
                firstArray.append(Cannon1)
                
                let Cannon2 = self.makeCannon(position: CGPoint(x: 770,y: 80))
                Cannon2.id = firstArray.count
                firstArray.append(Cannon2)
                                
                let Cannon4 = self.makeCannon(position: CGPoint(x: 550,y: 40))
                Cannon4.id = firstArray.count
                Cannon4.type = "Cannon2"
                firstArray.append(Cannon4)
                
                let Cannon5 = self.makeCannon(position: CGPoint(x: 750,y: 300))
                Cannon5.id = firstArray.count
                Cannon5.type = "Cannon3"
                firstArray.append(Cannon5)
                
                let Cannon6 = self.makeCannon(position: CGPoint(x: 650,y:250))
                Cannon6.id  = firstArray.count
                firstArray.append(Cannon6)
                
                let Hull = self.makeHull(position: CGPoint(x: 770,y: 160))
                Hull.id = firstArray.count
                firstArray.append(Hull)
                
                let Oni1 = self.makeOni(position: CGPoint(x: 300,y: 280))
                Oni1.id = firstArray.count
                Oni1.maxHp = 400
                self.changeEnemyHp(change: 1000, id: Oni1.id!)
                firstArray.append(Oni1)
                
                let Oni2 = self.makeOni(position: CGPoint(x: 650,y: 130))
                Oni2.id = firstArray.count
                Oni2.maxHp = 400
                self.changeEnemyHp(change: 1000, id: Oni2.id!)
                firstArray.append(Oni2)
                
                stagearray.append(firstArray)
                
                //2
                var secondArray:[Enemy] = []
                
                let Oni3 = self.makeOni(position: CGPoint(x: 550,y: 200))
                Oni3.id = secondArray.count
                secondArray.append(Oni3)
                
                stagearray.append(secondArray)
                
                //3
                var thirdArray:[Enemy] = []
                
                let Flog1 = self.makeFlog(position: CGPoint(x: 550,y: 200))
                Flog1.id = thirdArray.count
                thirdArray.append(Flog1)
                
                stagearray.append(thirdArray)
                
                
                var fourthArray:[Enemy] = []
                
                let Pig2 = self.makePig(position: CGPoint(x: 550,y: 200))
                Pig2.id = fourthArray.count
                fourthArray.append(Pig2)
                
                stagearray.append(fourthArray)
                
                
                var fifthArray:[Enemy] = []
                
                let Soilder5 = self.makeSoiler(position: CGPoint(x: 650,y: 150))
                Soilder5.id = fifthArray.count
                fifthArray.append(Soilder5)
                
                stagearray.append(fifthArray)
                
                
                var sixthArray:[Enemy] = []
                
                let Soilder6 = self.makeSoiler(position: CGPoint(x: 650,y: 150))
                Soilder6.id = sixthArray.count
                sixthArray.append(Soilder6)
                
                stagearray.append(sixthArray)
                
                
                var seventhArray:[Enemy] = []
                
                let Soilder7 = self.makeSoiler(position: CGPoint(x: 650,y: 150))
                Soilder7.id = seventhArray.count
                seventhArray.append(Soilder7)
                
                stagearray.append(seventhArray)
                
                
                var eighthArray:[Enemy] = []
                
                let Soilder8 = self.makeSoiler(position: CGPoint(x: 650,y: 150))
                Soilder8.id = eighthArray.count
                eighthArray.append(Soilder8)
                
                stagearray.append(eighthArray)
                
                
                var ninethArray:[Enemy] = []
                
                let Soilder9 = self.makeSoiler(position: CGPoint(x: 650,y: 150))
                Soilder9.id = ninethArray.count
                ninethArray.append(Soilder9)
                
                stagearray.append(ninethArray)
                
                
                var tenthArray:[Enemy] = []
                
                let Soilder10 = self.makeSoiler(position: CGPoint(x: 650,y: 150))
                Soilder10.id = tenthArray.count
                tenthArray.append(Soilder10)
                
                stagearray.append(tenthArray)
                
                
                maxWaveNumber = stagearray.count
                
                waveLabel.text = "wave: \(waveNumber + 1) / \(maxWaveNumber) "
                
            }
            
        } else if world == 7 {
            
            if stage == 1 {
                
                var firstArray:[Enemy] = []
                
                let RedDragon = self.makeRedDragon(position: CGPoint(x: 700,y: 80))
                RedDragon.id = firstArray.count
                firstArray.append(RedDragon)
                
                let BlueDragon = self.makeBlueDragon(position: CGPoint(x: 700,y: 320))
                BlueDragon.id = firstArray.count
                firstArray.append(BlueDragon)
                
                stagearray.append(firstArray)
                
                maxWaveNumber = stagearray.count
                
                waveLabel.text = "wave: \(waveNumber + 1) / \(maxWaveNumber) "
                
            }
        }
        
        return stagearray
        
    }
    
    //////////////////////////敵作成系メソッド集/////////////////////////////////
    
    func makeSoiler(position:CGPoint) -> Enemy {
        
        let Soldier = Enemy(imageNamed: "Soldier")
        
        Soldier.name = "Soldier"
        Soldier.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Soldier"), size: Soldier.size)
        Soldier.physicsBody?.isDynamic = false
        Soldier.physicsBody?.restitution = 1.0
        Soldier.position = position
        Soldier.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        Soldier.physicsBody?.collisionBitMask = PhysicsCategory.Bullet | PhysicsCategory.Wall | PhysicsCategory.Enemy | PhysicsCategory.Ally | PhysicsCategory.Item
        Soldier.physicsBody?.contactTestBitMask = PhysicsCategory.Bullet | PhysicsCategory.Wall | PhysicsCategory.Enemy | PhysicsCategory.Ally | PhysicsCategory.Item
        Soldier.xScale = 1.0
        Soldier.yScale = 1.0
        Soldier.grade = 1
        Soldier.hp = 700
        Soldier.defence = 0
        Soldier.type = "Soldier"
        Soldier.maxHp = 700//最大のHp
        
        let HpBarBack = SKSpriteNode(color: UIColor.black, size: CGSize(width: 45.0, height: 14.0))
        
        HpBarBack.name = "HpBarBack"
        HpBarBack.position = CGPoint(x: -5,y: -25)
        Soldier.addChild(HpBarBack)
        
        let HpBar = SKSpriteNode(color: UIColor.green, size: CGSize(width: 40.0, height: 10.0))
        
        HpBar.name = "HpBar"
        HpBar.position = CGPoint(x: -5,y: -25)
        HpBar.zPosition = 1
        HpBar.xScale = CGFloat( Double(Soldier.hp!) / Double(Soldier.maxHp!) )
        Soldier.addChild(HpBar)
        
        let GradeIcon = SKSpriteNode(imageNamed: "gradeicon")
        
        GradeIcon.name = "Gradeicon"
        GradeIcon.position = CGPoint(x: -37, y: -25)
        GradeIcon.xScale = 0.3
        GradeIcon.yScale = 0.3
        Soldier.addChild(GradeIcon)
        
        let GradeLabel = SKLabelNode()
        
        GradeLabel.name = "GradeLabel"
        GradeLabel.fontSize = 20
        GradeLabel.fontColor = UIColor.black
        GradeLabel.position = CGPoint(x: -37, y: -30)
        GradeLabel.text = " \(Soldier.grade!)"
        Soldier.addChild(GradeLabel)
        
        
        return Soldier
        
    }
    
    func makeQueen(position:CGPoint) -> Enemy  {
        
        let Queen = Enemy(imageNamed: "Queen")
        
        Queen.name = "Queen"
        Queen.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Queen"), size: Queen.size)
        Queen.physicsBody?.isDynamic = false
        Queen.physicsBody?.restitution = 1.0
        Queen.position = position
        Queen.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        Queen.physicsBody?.collisionBitMask = PhysicsCategory.Bullet | PhysicsCategory.Wall | PhysicsCategory.Enemy | PhysicsCategory.Ally | PhysicsCategory.Item
        Queen.physicsBody?.contactTestBitMask = PhysicsCategory.Bullet | PhysicsCategory.Wall | PhysicsCategory.Enemy | PhysicsCategory.Ally | PhysicsCategory.Item
        Queen.xScale = 1.0
        Queen.yScale = 1.0
        Queen.grade = 1
        Queen.hp = 1000
        Queen.defence = 0
        Queen.type = "Queen"
        Queen.maxHp = 1000//最大のHp
        
        let HpBarBack = SKSpriteNode(color: UIColor.black, size: CGSize(width: 45.0, height: 14.0))
        
        HpBarBack.name = "HpBarBack"
        HpBarBack.position = CGPoint(x: -5,y: -25)
        Queen.addChild(HpBarBack)
        
        let HpBar = SKSpriteNode(color: UIColor.green, size: CGSize(width: 40.0, height: 10.0))
        
        HpBar.name = "HpBar"
        HpBar.position = CGPoint(x: -5,y: -25)
        HpBar.zPosition = 1
        HpBar.xScale = CGFloat( Double(Queen.hp!) / Double(Queen.maxHp!) )
        Queen.addChild(HpBar)
        
        let GradeIcon = SKSpriteNode(imageNamed: "gradeicon")
        
        GradeIcon.name = "Gradeicon"
        GradeIcon.position = CGPoint(x: -37, y: -25)
        GradeIcon.xScale = 0.3
        GradeIcon.yScale = 0.3
        Queen.addChild(GradeIcon)
        
        let GradeLabel = SKLabelNode()
        
        GradeLabel.name = "GradeLabel"
        GradeLabel.fontSize = 20
        GradeLabel.fontColor = UIColor.black
        GradeLabel.position = CGPoint(x: -37, y: -30)
        GradeLabel.text = " \(Queen.grade!)"
        Queen.addChild(GradeLabel)
        
        
        return Queen
        
    }
    
    func makeBom(position:CGPoint) -> Enemy  {
        
        let Bom = Enemy(imageNamed: "Bom")
        
        Bom.name = "Bom"
        Bom.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Bom"), size: Bom.size)
        Bom.physicsBody?.isDynamic = false
        Bom.physicsBody?.restitution = 1.0
        Bom.position = position
        Bom.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        Bom.physicsBody?.collisionBitMask = PhysicsCategory.Bullet | PhysicsCategory.Wall | PhysicsCategory.Enemy | PhysicsCategory.Ally | PhysicsCategory.Item
        Bom.physicsBody?.contactTestBitMask = PhysicsCategory.Bullet | PhysicsCategory.Wall | PhysicsCategory.Enemy | PhysicsCategory.Ally | PhysicsCategory.Item
        Bom.xScale = 1.0
        Bom.yScale = 1.0
        Bom.grade = 3
        Bom.hp = 100
        Bom.defence = 0
        Bom.type = "Bom"
        Bom.maxHp = 100//最大のHp
        
        let HpBarBack = SKSpriteNode(color: UIColor.black, size: CGSize(width: 45.0, height: 14.0))
        
        HpBarBack.name = "HpBarBack"
        HpBarBack.position = CGPoint(x: -5,y: -25)
        Bom.addChild(HpBarBack)
        
        let HpBar = SKSpriteNode(color: UIColor.green, size: CGSize(width: 40.0, height: 10.0))
        
        HpBar.name = "HpBar"
        HpBar.position = CGPoint(x: -5,y: -25)
        HpBar.zPosition = 1
        HpBar.xScale = CGFloat( Double(Bom.hp!) / Double(Bom.maxHp!) )
        Bom.addChild(HpBar)
        
        let GradeIcon = SKSpriteNode(imageNamed: "gradeicon")
        
        GradeIcon.name = "Gradeicon"
        GradeIcon.position = CGPoint(x: -37, y: -25)
        GradeIcon.xScale = 0.3
        GradeIcon.yScale = 0.3
        Bom.addChild(GradeIcon)
        
        let GradeLabel = SKLabelNode()
        
        GradeLabel.name = "GradeLabel"
        GradeLabel.fontSize = 20
        GradeLabel.fontColor = UIColor.black
        GradeLabel.position = CGPoint(x: -37, y: -30)
        GradeLabel.text = " \(Bom.grade!)"
        Bom.addChild(GradeLabel)
        
        
        return Bom
        
    }
    
    func makeWarp(position:CGPoint) -> Enemy  {
        
        let Warp = Enemy(imageNamed: "warp")
        
        Warp.name = "Warp"
        Warp.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "warp"), size: Warp.size)
        Warp.physicsBody?.isDynamic = false
        Warp.physicsBody?.restitution = 1.0
        Warp.position = position
        Warp.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        Warp.physicsBody?.collisionBitMask = PhysicsCategory.Bullet | PhysicsCategory.Wall | PhysicsCategory.Enemy | PhysicsCategory.Ally | PhysicsCategory.Item
        Warp.physicsBody?.contactTestBitMask = PhysicsCategory.Bullet | PhysicsCategory.Wall | PhysicsCategory.Enemy | PhysicsCategory.Ally | PhysicsCategory.Item
        Warp.xScale = 1.0
        Warp.yScale = 1.0
        Warp.grade = 1
        Warp.hp = 500
        Warp.defence = 0
        Warp.type = "Warp"
        Warp.maxHp = 500//最大のHp
        
        let HpBarBack = SKSpriteNode(color: UIColor.black, size: CGSize(width: 45.0, height: 14.0))
        
        HpBarBack.name = "HpBarBack"
        HpBarBack.position = CGPoint(x: -5,y: -25)
        Warp.addChild(HpBarBack)
        
        let HpBar = SKSpriteNode(color: UIColor.green, size: CGSize(width: 40.0, height: 10.0))
        
        HpBar.name = "HpBar"
        HpBar.position = CGPoint(x: -5,y: -25)
        HpBar.zPosition = 1
        HpBar.xScale = CGFloat( Double(Warp.hp!) / Double(Warp.maxHp!) )
        Warp.addChild(HpBar)
        
        let GradeIcon = SKSpriteNode(imageNamed: "gradeicon")
        
        GradeIcon.name = "Gradeicon"
        GradeIcon.position = CGPoint(x: -37, y: -25)
        GradeIcon.xScale = 0.3
        GradeIcon.yScale = 0.3
        Warp.addChild(GradeIcon)
        
        let GradeLabel = SKLabelNode()
        
        GradeLabel.name = "GradeLabel"
        GradeLabel.fontSize = 20
        GradeLabel.fontColor = UIColor.black
        GradeLabel.position = CGPoint(x: -37, y: -30)
        GradeLabel.text = " \(Warp.grade!)"
        Warp.addChild(GradeLabel)
        
        
        return Warp
        
    }
    
    func makeWarpBoss(position:CGPoint) -> Enemy  {
        
        let WarpBoss = Enemy(imageNamed: "warpBoss")
        
        WarpBoss.name = "WarpBoss"
        WarpBoss.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "warpBoss"), size: WarpBoss.size)
        WarpBoss.physicsBody?.isDynamic = false
        WarpBoss.physicsBody?.restitution = 1.0
        WarpBoss.position = position
        WarpBoss.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        WarpBoss.physicsBody?.collisionBitMask = PhysicsCategory.Bullet | PhysicsCategory.Wall | PhysicsCategory.Enemy | PhysicsCategory.Ally | PhysicsCategory.Item
        WarpBoss.physicsBody?.contactTestBitMask = PhysicsCategory.Bullet | PhysicsCategory.Wall | PhysicsCategory.Enemy | PhysicsCategory.Ally | PhysicsCategory.Item
        WarpBoss.xScale = 1.5
        WarpBoss.yScale = 1.5
        WarpBoss.grade = 1
        WarpBoss.hp = 1000
        WarpBoss.defence = 20
        WarpBoss.type = "WarpBoss"
        WarpBoss.maxHp = 1000//最大のHp
        
        let HpBarBack = SKSpriteNode(color: UIColor.black, size: CGSize(width: 45.0, height: 14.0))
        
        HpBarBack.name = "HpBarBack"
        HpBarBack.position = CGPoint(x: -5,y: -25)
        WarpBoss.addChild(HpBarBack)
        
        let HpBar = SKSpriteNode(color: UIColor.green, size: CGSize(width: 40.0, height: 10.0))
        
        HpBar.name = "HpBar"
        HpBar.position = CGPoint(x: -5,y: -25)
        HpBar.zPosition = 1
        HpBar.xScale = CGFloat( Double(WarpBoss.hp!) / Double(WarpBoss.maxHp!) )
        WarpBoss.addChild(HpBar)
        
        let GradeIcon = SKSpriteNode(imageNamed: "gradeicon")
        
        GradeIcon.name = "Gradeicon"
        GradeIcon.position = CGPoint(x: -37, y: -25)
        GradeIcon.xScale = 0.3
        GradeIcon.yScale = 0.3
        WarpBoss.addChild(GradeIcon)
        
        let GradeLabel = SKLabelNode()
        
        GradeLabel.name = "GradeLabel"
        GradeLabel.fontSize = 20
        GradeLabel.fontColor = UIColor.black
        GradeLabel.position = CGPoint(x: -37, y: -30)
        GradeLabel.text = " \(WarpBoss.grade!)"
        WarpBoss.addChild(GradeLabel)
        
        
        return WarpBoss
        
    }
    
    func makeTank(position:CGPoint) -> Enemy  {
        
        let Tank = Enemy(imageNamed: "Tank")
        
        Tank.name = "Tank"
        Tank.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Tank"), size: Tank.size)
        Tank.physicsBody?.isDynamic = false
        Tank.physicsBody?.restitution = 1.0
        Tank.position = position
        Tank.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        Tank.physicsBody?.collisionBitMask = PhysicsCategory.Bullet | PhysicsCategory.Wall | PhysicsCategory.Enemy | PhysicsCategory.Ally | PhysicsCategory.Item
        Tank.physicsBody?.contactTestBitMask = PhysicsCategory.Bullet | PhysicsCategory.Wall | PhysicsCategory.Enemy | PhysicsCategory.Ally | PhysicsCategory.Item
        Tank.xScale = 1.5
        Tank.yScale = 1.5
        Tank.grade = 1
        Tank.hp = 1500
        Tank.defence = 100
        Tank.type = "Tank"
        Tank.maxHp = 1500//最大のHp
        
        let HpBarBack = SKSpriteNode(color: UIColor.black, size: CGSize(width: 45.0, height: 14.0))
        
        HpBarBack.name = "HpBarBack"
        HpBarBack.position = CGPoint(x: -5,y: -25)
        Tank.addChild(HpBarBack)
        
        let HpBar = SKSpriteNode(color: UIColor.green, size: CGSize(width: 40.0, height: 10.0))
        
        HpBar.name = "HpBar"
        HpBar.position = CGPoint(x: -5,y: -25)
        HpBar.zPosition = 1
        HpBar.xScale = CGFloat( Double(Tank.hp!) / Double(Tank.maxHp!) )
        Tank.addChild(HpBar)
        
        let GradeIcon = SKSpriteNode(imageNamed: "gradeicon")
        
        GradeIcon.name = "Gradeicon"
        GradeIcon.position = CGPoint(x: -37, y: -25)
        GradeIcon.xScale = 0.3
        GradeIcon.yScale = 0.3
        Tank.addChild(GradeIcon)
        
        let GradeLabel = SKLabelNode()
        
        GradeLabel.name = "GradeLabel"
        GradeLabel.fontSize = 20
        GradeLabel.fontColor = UIColor.black
        GradeLabel.position = CGPoint(x: -37, y: -30)
        GradeLabel.text = " \(Tank.grade!)"
        Tank.addChild(GradeLabel)
        
        
        return Tank
        
    }
    
    func makeSenjin(position:CGPoint) -> Enemy  {
        
        let Senjin = Enemy(imageNamed: "Senjin")
        
        Senjin.name = "Senjin"
        Senjin.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Senjin"), size: Senjin.size)
        Senjin.physicsBody?.isDynamic = false
        Senjin.physicsBody?.restitution = 1.0
        Senjin.position = position
        Senjin.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        Senjin.physicsBody?.collisionBitMask = PhysicsCategory.Bullet | PhysicsCategory.Wall | PhysicsCategory.Enemy | PhysicsCategory.Ally | PhysicsCategory.Item
        Senjin.physicsBody?.contactTestBitMask = PhysicsCategory.Bullet | PhysicsCategory.Wall | PhysicsCategory.Enemy | PhysicsCategory.Ally | PhysicsCategory.Item
        Senjin.xScale = 1.0
        Senjin.yScale = 1.0
        Senjin.grade = 1
        Senjin.hp = 1500
        Senjin.defence = 100
        Senjin.type = "Senjin"
        Senjin.maxHp = 1500//最大のHp
        
        let HpBarBack = SKSpriteNode(color: UIColor.black, size: CGSize(width: 45.0, height: 14.0))
        
        HpBarBack.name = "HpBarBack"
        HpBarBack.position = CGPoint(x: -5,y: -25)
        Senjin.addChild(HpBarBack)
        
        let HpBar = SKSpriteNode(color: UIColor.green, size: CGSize(width: 40.0, height: 10.0))
        
        HpBar.name = "HpBar"
        HpBar.position = CGPoint(x: -5,y: -25)
        HpBar.zPosition = 1
        HpBar.xScale = CGFloat( Double(Senjin.hp!) / Double(Senjin.maxHp!) )
        Senjin.addChild(HpBar)
        
        let GradeIcon = SKSpriteNode(imageNamed: "gradeicon")
        
        GradeIcon.name = "Gradeicon"
        GradeIcon.position = CGPoint(x: -37, y: -25)
        GradeIcon.xScale = 0.3
        GradeIcon.yScale = 0.3
        Senjin.addChild(GradeIcon)
        
        let GradeLabel = SKLabelNode()
        
        GradeLabel.name = "GradeLabel"
        GradeLabel.fontSize = 20
        GradeLabel.fontColor = UIColor.black
        GradeLabel.position = CGPoint(x: -37, y: -30)
        GradeLabel.text = " \(Senjin.grade!)"
        Senjin.addChild(GradeLabel)
        
        
        return Senjin
        
    }
    
    func makeCamera(position:CGPoint) -> (Enemy) {
        
        let Camera = Enemy(imageNamed: "Camera")
        
        Camera.name = "Camera"
        Camera.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Camera"), size: Camera.size)
        Camera.physicsBody?.isDynamic = false
        Camera.physicsBody?.restitution = 1.0
        Camera.position = position
        Camera.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        Camera.physicsBody?.collisionBitMask = PhysicsCategory.Bullet | PhysicsCategory.Wall | PhysicsCategory.Enemy | PhysicsCategory.Ally | PhysicsCategory.Item
        Camera.physicsBody?.contactTestBitMask = PhysicsCategory.Bullet | PhysicsCategory.Wall | PhysicsCategory.Enemy | PhysicsCategory.Ally | PhysicsCategory.Item
        Camera.xScale = 0.7
        Camera.yScale = 0.7
        Camera.grade = 1
        Camera.hp = 1000
        Camera.defence = 0
        Camera.type = "Camera"
        Camera.maxHp = 1000//最大のHp
        Camera.needToKill = false //監視カメラは倒す必要はない
        
        let HpBarBack = SKSpriteNode(color: UIColor.black, size: CGSize(width: 45.0, height: 14.0))
        
        HpBarBack.name = "HpBarBack"
        HpBarBack.position = CGPoint(x: -5,y: -25)
        Camera.addChild(HpBarBack)
        
        let HpBar = SKSpriteNode(color: UIColor.green, size: CGSize(width: 40.0, height: 10.0))
        
        HpBar.name = "HpBar"
        HpBar.position = CGPoint(x: -5,y: -25)
        HpBar.zPosition = 1
        HpBar.xScale = CGFloat( Double(Camera.hp!) / Double(Camera.maxHp!) )
        Camera.addChild(HpBar)
        
        let GradeIcon = SKSpriteNode(imageNamed: "gradeicon")
        
        GradeIcon.name = "Gradeicon"
        GradeIcon.position = CGPoint(x: -37, y: -25)
        GradeIcon.xScale = 0.3
        GradeIcon.yScale = 0.3
        Camera.addChild(GradeIcon)
        
        let GradeLabel = SKLabelNode()
        
        GradeLabel.name = "GradeLabel"
        GradeLabel.fontSize = 20
        GradeLabel.fontColor = UIColor.black
        GradeLabel.position = CGPoint(x: -37, y: -30)
        GradeLabel.text = " \(Camera.grade!)"
        Camera.addChild(GradeLabel)
        
        
        return Camera
        
    }
    
    func makeOni(position:CGPoint) -> (Enemy) {
        
        let Oni = Enemy(imageNamed: "Oni")
        
        Oni.name = "Oni"
        Oni.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Oni"), size: Oni.size)
        Oni.physicsBody?.isDynamic = false
        Oni.physicsBody?.restitution = 1.0
        Oni.position = position
        Oni.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        Oni.physicsBody?.collisionBitMask = PhysicsCategory.Bullet | PhysicsCategory.Wall | PhysicsCategory.Enemy | PhysicsCategory.Ally | PhysicsCategory.Item
        Oni.physicsBody?.contactTestBitMask = PhysicsCategory.Bullet | PhysicsCategory.Wall | PhysicsCategory.Enemy | PhysicsCategory.Ally | PhysicsCategory.Item
        Oni.xScale = 1.0
        Oni.yScale = 1.0
        Oni.grade = 1
        Oni.hp = 1000
        Oni.defence = 0
        Oni.type = "Oni"
        Oni.maxHp = 1000//最大のHp
        
        let HpBarBack = SKSpriteNode(color: UIColor.black, size: CGSize(width: 45.0, height: 14.0))
        
        HpBarBack.name = "HpBarBack"
        HpBarBack.position = CGPoint(x: -5,y: -25)
        Oni.addChild(HpBarBack)
        
        let HpBar = SKSpriteNode(color: UIColor.green, size: CGSize(width: 40.0, height: 10.0))
        
        HpBar.name = "HpBar"
        HpBar.position = CGPoint(x: -5,y: -25)
        HpBar.zPosition = 1
        HpBar.xScale = CGFloat( Double(Oni.hp!) / Double(Oni.maxHp!) )
        Oni.addChild(HpBar)
        
        let GradeIcon = SKSpriteNode(imageNamed: "gradeicon")
        
        GradeIcon.name = "Gradeicon"
        GradeIcon.position = CGPoint(x: -37, y: -25)
        GradeIcon.xScale = 0.3
        GradeIcon.yScale = 0.3
        Oni.addChild(GradeIcon)
        
        let GradeLabel = SKLabelNode()
        
        GradeLabel.name = "GradeLabel"
        GradeLabel.fontSize = 20
        GradeLabel.fontColor = UIColor.black
        GradeLabel.position = CGPoint(x: -37, y: -30)
        GradeLabel.text = " \(Oni.grade!)"
        Oni.addChild(GradeLabel)
        
        
        return Oni
        
    }
    
    func makeFlog(position:CGPoint) -> (Enemy) {
        
        let Flog = Enemy(imageNamed: "Flog")
        
        Flog.name = "Flog"
        Flog.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Flog"), size: Flog.size)
        Flog.physicsBody?.isDynamic = false
        Flog.physicsBody?.restitution = 1.0
        Flog.position = position
        Flog.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        Flog.physicsBody?.collisionBitMask = PhysicsCategory.Bullet | PhysicsCategory.Wall | PhysicsCategory.Enemy | PhysicsCategory.Ally | PhysicsCategory.Item
        Flog.physicsBody?.contactTestBitMask = PhysicsCategory.Bullet | PhysicsCategory.Wall | PhysicsCategory.Enemy | PhysicsCategory.Ally | PhysicsCategory.Item
        Flog.xScale = 1.0
        Flog.yScale = 1.0
        Flog.grade = 1
        Flog.hp = 1000
        Flog.defence = 0
        Flog.type = "Flog"
        Flog.maxHp = 1000//最大のHp
        
        let HpBarBack = SKSpriteNode(color: UIColor.black, size: CGSize(width: 45.0, height: 14.0))
        
        HpBarBack.name = "HpBarBack"
        HpBarBack.position = CGPoint(x: -5,y: -25)
        Flog.addChild(HpBarBack)
        
        let HpBar = SKSpriteNode(color: UIColor.green, size: CGSize(width: 40.0, height: 10.0))
        
        HpBar.name = "HpBar"
        HpBar.position = CGPoint(x: -5,y: -25)
        HpBar.zPosition = 1
        HpBar.xScale = CGFloat( Double(Flog.hp!) / Double(Flog.maxHp!) )
        Flog.addChild(HpBar)
        
        let GradeIcon = SKSpriteNode(imageNamed: "gradeicon")
        
        GradeIcon.name = "Gradeicon"
        GradeIcon.position = CGPoint(x: -37, y: -25)
        GradeIcon.xScale = 0.3
        GradeIcon.yScale = 0.3
        Flog.addChild(GradeIcon)
        
        let GradeLabel = SKLabelNode()
        
        GradeLabel.name = "GradeLabel"
        GradeLabel.fontSize = 20
        GradeLabel.fontColor = UIColor.black
        GradeLabel.position = CGPoint(x: -37, y: -30)
        GradeLabel.text = " \(Flog.grade!)"
        Flog.addChild(GradeLabel)
        
        
        return Flog
        
    }
    
    func makePig(position:CGPoint) -> (Enemy) {
        
        let Pig = Enemy(imageNamed: "Pig")
        
        Pig.name = "Pig"
        Pig.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Pig"), size: Pig.size)
        Pig.physicsBody?.isDynamic = false
        Pig.physicsBody?.restitution = 1.0
        Pig.position = position
        Pig.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        Pig.physicsBody?.collisionBitMask = PhysicsCategory.Bullet | PhysicsCategory.Wall | PhysicsCategory.Enemy | PhysicsCategory.Ally | PhysicsCategory.Item
        Pig.physicsBody?.contactTestBitMask = PhysicsCategory.Bullet | PhysicsCategory.Wall | PhysicsCategory.Enemy | PhysicsCategory.Ally | PhysicsCategory.Item
        Pig.xScale = 1.0
        Pig.yScale = 1.0
        Pig.grade = 1
        Pig.hp = 600
        Pig.defence = 0
        Pig.type = "Pig"
        Pig.maxHp = 600//最大のHp
        
        let HpBarBack = SKSpriteNode(color: UIColor.black, size: CGSize(width: 45.0, height: 14.0))
        
        HpBarBack.name = "HpBarBack"
        HpBarBack.position = CGPoint(x: -5,y: -25)
        Pig.addChild(HpBarBack)
        
        let HpBar = SKSpriteNode(color: UIColor.green, size: CGSize(width: 40.0, height: 10.0))
        
        HpBar.name = "HpBar"
        HpBar.position = CGPoint(x: -5,y: -25)
        HpBar.zPosition = 1
        HpBar.xScale = CGFloat( Double(Pig.hp!) / Double(Pig.maxHp!) )
        Pig.addChild(HpBar)
        
        let GradeIcon = SKSpriteNode(imageNamed: "gradeicon")
        
        GradeIcon.name = "Gradeicon"
        GradeIcon.position = CGPoint(x: -37, y: -25)
        GradeIcon.xScale = 0.3
        GradeIcon.yScale = 0.3
        Pig.addChild(GradeIcon)
        
        let GradeLabel = SKLabelNode()
        
        GradeLabel.name = "GradeLabel"
        GradeLabel.fontSize = 20
        GradeLabel.fontColor = UIColor.black
        GradeLabel.position = CGPoint(x: -37, y: -30)
        GradeLabel.text = " \(Pig.grade!)"
        Pig.addChild(GradeLabel)
        
        
        return Pig
        
    }
    
    func makeHull(position:CGPoint) -> (Enemy) {
        
        let Hull = Enemy(imageNamed: "Hull")
        
        Hull.name = "Hull"
        Hull.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Hull"), size: Hull.size)
        Hull.physicsBody?.isDynamic = false
        Hull.physicsBody?.restitution = 1.0
        Hull.position = position
        Hull.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        Hull.physicsBody?.collisionBitMask = PhysicsCategory.Bullet | PhysicsCategory.Wall | PhysicsCategory.Enemy | PhysicsCategory.Ally | PhysicsCategory.Item
        Hull.physicsBody?.contactTestBitMask = PhysicsCategory.Bullet | PhysicsCategory.Wall | PhysicsCategory.Enemy | PhysicsCategory.Ally | PhysicsCategory.Item
        Hull.xScale = 1.0
        Hull.yScale = 1.0
        Hull.grade = 1
        Hull.hp = 600
        Hull.defence = 0
        Hull.type = "Hull"
        Hull.maxHp = 600//最大のHp
        
        let HpBarBack = SKSpriteNode(color: UIColor.black, size: CGSize(width: 45.0, height: 14.0))
        
        HpBarBack.name = "HpBarBack"
        HpBarBack.position = CGPoint(x: -5,y: -25)
        Hull.addChild(HpBarBack)
        
        let HpBar = SKSpriteNode(color: UIColor.green, size: CGSize(width: 40.0, height: 10.0))
        
        HpBar.name = "HpBar"
        HpBar.position = CGPoint(x: -5,y: -25)
        HpBar.zPosition = 1
        HpBar.xScale = CGFloat( Double(Hull.hp!) / Double(Hull.maxHp!) )
        Hull.addChild(HpBar)
        
        let GradeIcon = SKSpriteNode(imageNamed: "gradeicon")
        
        GradeIcon.name = "Gradeicon"
        GradeIcon.position = CGPoint(x: -37, y: -25)
        GradeIcon.xScale = 0.3
        GradeIcon.yScale = 0.3
       Hull.addChild(GradeIcon)
        
        let GradeLabel = SKLabelNode()
        
        GradeLabel.name = "GradeLabel"
        GradeLabel.fontSize = 20
        GradeLabel.fontColor = UIColor.black
        GradeLabel.position = CGPoint(x: -37, y: -30)
        GradeLabel.text = " \(Hull.grade!)"
        Hull.addChild(GradeLabel)
        
        
        return Hull
        
    }
    
    func makeBreakableWall(position:CGPoint , size: CGSize, rotate: Double) -> (Enemy) {
        
        let BreakableWall = Enemy(color: UIColor.black,size: size)
        
        BreakableWall.name = "BreakableWall"
        BreakableWall.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "BreakableWall"), size: BreakableWall.size)
        BreakableWall.size = BreakableWall.size
        BreakableWall.physicsBody?.isDynamic = false
        BreakableWall.physicsBody?.restitution = 1.0
        BreakableWall.position = position
        BreakableWall.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        BreakableWall.physicsBody?.collisionBitMask = PhysicsCategory.Bullet | PhysicsCategory.Wall | PhysicsCategory.Enemy | PhysicsCategory.Ally | PhysicsCategory.Item
        BreakableWall.physicsBody?.contactTestBitMask = PhysicsCategory.Bullet | PhysicsCategory.Wall | PhysicsCategory.Enemy | PhysicsCategory.Ally | PhysicsCategory.Item
        BreakableWall.xScale = 1.0
        BreakableWall.yScale = 1.0
        BreakableWall.grade = 1
        BreakableWall.hp = 600
        BreakableWall.defence = 0
        BreakableWall.type = "BreakableWall"
        BreakableWall.maxHp = 600//最大のHp
        BreakableWall.needToKill = false //壊れる壁は倒す必要はない
        BreakableWall.zRotation = CGFloat( rotate  / 180.0 * Double.pi)
        
        
        let HpBarBack = SKSpriteNode(color: UIColor.black, size: CGSize(width: 45.0, height: 14.0))
        
        HpBarBack.name = "HpBarBack"
        HpBarBack.position = CGPoint(x: -5,y: -25)
        HpBarBack.zRotation = CGFloat( -rotate  / 180.0 * Double.pi)
        BreakableWall.addChild(HpBarBack)
        
        let HpBar = SKSpriteNode(color: UIColor.green, size: CGSize(width: 40.0, height: 10.0))
        
        HpBar.name = "HpBar"
        HpBar.position = CGPoint(x: -5,y: -25)
        HpBar.zPosition = 1
        HpBar.xScale = CGFloat( Double(BreakableWall.hp!) / Double(BreakableWall.maxHp!) )
        HpBar.zRotation = CGFloat( -rotate  / 180.0 * Double.pi)
        BreakableWall.addChild(HpBar)
        
        let GradeIcon = SKSpriteNode(imageNamed: "gradeicon")
        
        GradeIcon.name = "Gradeicon"
        GradeIcon.position = CGPoint(x: -37, y: -25)
        GradeIcon.xScale = 0.3
        GradeIcon.yScale = 0.3
        GradeIcon.zRotation = CGFloat( -rotate  / 180.0 * Double.pi)
        BreakableWall.addChild(GradeIcon)
        
        let GradeLabel = SKLabelNode()
        
        GradeLabel.name = "GradeLabel"
        GradeLabel.fontSize = 20
        GradeLabel.fontColor = UIColor.black
        GradeLabel.position = CGPoint(x: -37, y: -30)
        GradeLabel.text = " \(BreakableWall.grade!)"
        GradeLabel.zRotation = CGFloat( -rotate  / 180.0 * Double.pi)
        BreakableWall.addChild(GradeLabel)
        
        
        return BreakableWall
        
    }
    
    func makeCannon(position:CGPoint) -> (Enemy) {
        
        let Cannon = Enemy(imageNamed: "Cannon")
        
        Cannon.name = "Cannon"
        Cannon.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Cannon"), size: Cannon.size)
        Cannon.physicsBody?.isDynamic = false
        Cannon.physicsBody?.restitution = 1.0
        Cannon.position = position
        Cannon.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        Cannon.physicsBody?.collisionBitMask = PhysicsCategory.Bullet | PhysicsCategory.Wall | PhysicsCategory.Enemy | PhysicsCategory.Ally | PhysicsCategory.Item
        Cannon.physicsBody?.contactTestBitMask = PhysicsCategory.Bullet | PhysicsCategory.Wall | PhysicsCategory.Enemy | PhysicsCategory.Ally | PhysicsCategory.Item
        Cannon.xScale = 0.7
        Cannon.yScale = 0.7
        Cannon.grade = 1
        Cannon.hp = 600
        Cannon.defence = 0
        Cannon.type = "Cannon"
        Cannon.maxHp = 600 //最大のHp
        Cannon.needToKill = false //大砲は倒す必要なし
        
        let HpBarBack = SKSpriteNode(color: UIColor.black, size: CGSize(width: 45.0, height: 14.0))
        
        HpBarBack.name = "HpBarBack"
        HpBarBack.position = CGPoint(x: -5,y: -25)
        Cannon.addChild(HpBarBack)
        
        let HpBar = SKSpriteNode(color: UIColor.green, size: CGSize(width: 40.0, height: 10.0))
        
        HpBar.name = "HpBar"
        HpBar.position = CGPoint(x: -5,y: -25)
        HpBar.zPosition = 1
        HpBar.xScale = CGFloat( Double(Cannon.hp!) / Double(Cannon.maxHp!) )
        Cannon.addChild(HpBar)
        
        let GradeIcon = SKSpriteNode(imageNamed: "gradeicon")
        
        GradeIcon.name = "Gradeicon"
        GradeIcon.position = CGPoint(x: -37, y: -25)
        GradeIcon.xScale = 0.3
        GradeIcon.yScale = 0.3
        Cannon.addChild(GradeIcon)
        
        let GradeLabel = SKLabelNode()
        
        GradeLabel.name = "GradeLabel"
        GradeLabel.fontSize = 20
        GradeLabel.fontColor = UIColor.black
        GradeLabel.position = CGPoint(x: -37, y: -30)
        GradeLabel.text = " \(Cannon.grade!)"
        Cannon.addChild(GradeLabel)
        
        
        return Cannon
        
    }
    
    func makeRedDragon(position:CGPoint) -> (Enemy) {
        
        let RedDragon = Enemy(imageNamed: "RedDragon")
        
        RedDragon.name = "RedDragon"
        RedDragon.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "RedDragon"), size: RedDragon.size)
        RedDragon.physicsBody?.isDynamic = false
        RedDragon.physicsBody?.restitution = 1.0
        RedDragon.position = position
        RedDragon.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        RedDragon.physicsBody?.collisionBitMask = PhysicsCategory.Bullet | PhysicsCategory.Wall | PhysicsCategory.Enemy | PhysicsCategory.Ally | PhysicsCategory.Item
        RedDragon.physicsBody?.contactTestBitMask = PhysicsCategory.Bullet | PhysicsCategory.Wall | PhysicsCategory.Enemy | PhysicsCategory.Ally | PhysicsCategory.Item
        RedDragon.xScale = 1.0
        RedDragon.yScale = 1.0
        RedDragon.grade = 1
        RedDragon.hp = 100
        RedDragon.defence = 0
        RedDragon.type = "RedDragon"
        RedDragon.maxHp = 100 //最大のHp
        
        let HpBarBack = SKSpriteNode(color: UIColor.black, size: CGSize(width: 45.0, height: 14.0))
        
        HpBarBack.name = "HpBarBack"
        HpBarBack.position = CGPoint(x: -5,y: -25)
        RedDragon.addChild(HpBarBack)
        
        let HpBar = SKSpriteNode(color: UIColor.green, size: CGSize(width: 40.0, height: 10.0))
        
        HpBar.name = "HpBar"
        HpBar.position = CGPoint(x: -5,y: -25)
        HpBar.zPosition = 1
        HpBar.xScale = CGFloat( Double(RedDragon.hp!) / Double(RedDragon.maxHp!) )
        RedDragon.addChild(HpBar)
        
        let GradeIcon = SKSpriteNode(imageNamed: "gradeicon")
        
        GradeIcon.name = "Gradeicon"
        GradeIcon.position = CGPoint(x: -37, y: -25)
        GradeIcon.xScale = 0.3
        GradeIcon.yScale = 0.3
        RedDragon.addChild(GradeIcon)
        
        let GradeLabel = SKLabelNode()
        
        GradeLabel.name = "GradeLabel"
        GradeLabel.fontSize = 20
        GradeLabel.fontColor = UIColor.black
        GradeLabel.position = CGPoint(x: -37, y: -30)
        GradeLabel.text = " \(RedDragon.grade!)"
        RedDragon.addChild(GradeLabel)
        
        
        return RedDragon
        
    }
    
    func makeBlueDragon(position:CGPoint) -> (Enemy) {
        
        let BlueDragon = Enemy(imageNamed: "BlueDragon")
        
        BlueDragon.name = "BlueDragon"
        BlueDragon.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "BlueDragon"), size: BlueDragon.size)
        BlueDragon.physicsBody?.isDynamic = false
        BlueDragon.physicsBody?.restitution = 1.0
        BlueDragon.position = position
        BlueDragon.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        BlueDragon.physicsBody?.collisionBitMask = PhysicsCategory.Bullet | PhysicsCategory.Wall | PhysicsCategory.Enemy | PhysicsCategory.Ally | PhysicsCategory.Item
        BlueDragon.physicsBody?.contactTestBitMask = PhysicsCategory.Bullet | PhysicsCategory.Wall | PhysicsCategory.Enemy | PhysicsCategory.Ally | PhysicsCategory.Item
        BlueDragon.xScale = 1.0
        BlueDragon.yScale = 1.0
        BlueDragon.grade = 1
        BlueDragon.hp = 100
        BlueDragon.defence = 0
        BlueDragon.type = "BlueDragon"
        BlueDragon.maxHp = 100 //最大のHp
        
        let HpBarBack = SKSpriteNode(color: UIColor.black, size: CGSize(width: 45.0, height: 14.0))
        
        HpBarBack.name = "HpBarBack"
        HpBarBack.position = CGPoint(x: -5,y: -25)
        BlueDragon.addChild(HpBarBack)
        
        let HpBar = SKSpriteNode(color: UIColor.green, size: CGSize(width: 40.0, height: 10.0))
        
        HpBar.name = "HpBar"
        HpBar.position = CGPoint(x: -5,y: -25)
        HpBar.zPosition = 1
        HpBar.xScale = CGFloat( Double(BlueDragon.hp!) / Double(BlueDragon.maxHp!) )
        BlueDragon.addChild(HpBar)
        
        let GradeIcon = SKSpriteNode(imageNamed: "gradeicon")
        
        GradeIcon.name = "Gradeicon"
        GradeIcon.position = CGPoint(x: -37, y: -25)
        GradeIcon.xScale = 0.3
        GradeIcon.yScale = 0.3
        BlueDragon.addChild(GradeIcon)
        
        let GradeLabel = SKLabelNode()
        
        GradeLabel.name = "GradeLabel"
        GradeLabel.fontSize = 20
        GradeLabel.fontColor = UIColor.black
        GradeLabel.position = CGPoint(x: -37, y: -30)
        GradeLabel.text = " \(BlueDragon.grade!)"
        BlueDragon.addChild(GradeLabel)
        
        
        return BlueDragon
        
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
                        
                        let travelTime = SKAction.move( to: CGPoint(x: enemy.position.x - CGFloat( 2 * cos(Double(direction))),y: enemy.position.y
                            + CGFloat( 2 * sin(Double(direction)))), duration: 0.01)
                        enemy.run(travelTime)
                        
                    } else { //距離が近い時は近づかない
                        
                    }
                    
                }
                
                if enemy.type == "Warp" {
                    
                    
                    if phasenumber == 50 {
                        
                        let fadeout = SKAction.fadeOut(withDuration: 0.8)
                        var move = SKAction.move(to: CGPoint(x: 650,y: 150), duration: 0.1)
                        
                        if enemy.position.x == 650 {
                            move = SKAction.move(to: CGPoint(x: 450,y: 150), duration: 0.1)
                        }
                        
                        let fadein = SKAction.fadeIn(withDuration: 0.8)
                        
                        enemy.run(SKAction.sequence([fadeout,move,fadein]))
                        
                    }
                    
                    if phasenumber == 100 {
                        
                        let fadeout = SKAction.fadeOut(withDuration: 0.8)
                        var move = SKAction.move(to: CGPoint(x: 450,y: 250), duration: 0.1)
                        
                        if enemy.position.x == 450 {
                            move = SKAction.move(to: CGPoint(x: 650,y: 250), duration: 0.1)
                        }
                        
                        let fadein = SKAction.fadeIn(withDuration: 0.8)
                        
                        enemy.run(SKAction.sequence([fadeout,move,fadein]))
                        
                    }
                    
                }
                
                if enemy.type == "WarpBoss" {
                    //移動しない。
                }
                
                if enemy.type == "Tank"  {
                    
                    if phasenumber == 20 {
                        
                        var shortestDistance:CGFloat = 50000.0 //大きい数字をとりあえず、代入します。
                        var savei:Int = 0
                        
                        for i in 0 ..< AllyArray.count {
                            
                            if shortestDistance >= length(v: CGPoint(x: enemy.position.x - AllyArray[i].position.x,y: enemy.position.y - AllyArray[i].position.y)) {
                                shortestDistance = length(v: CGPoint(x: enemy.position.x - AllyArray[i].position.x,y: enemy.position.y - AllyArray[i].position.y))
                                savei = i
                            }
                            
                        }
                        
                        let travelTime = SKAction.move(to: CGPoint(x: enemy.position.x,y: AllyArray[savei].position.y), duration: 5.0)
                        
                        enemy.run(travelTime)
                        
                    }
                    
                }
                
                if enemy.type == "Senjin" {
                    
                    if phasenumber == 20 {
                        
                        if turn % 6 == 1 {//右下に移動
                            
                            let godown = SKAction.moveTo(y: 100.0, duration: 5.0)
                            enemy.run(godown)
                            
                        } else if turn % 6 == 2 {//右に行き、消える
                            
                            enemy.texture = SKTexture(imageNamed: "Senjin2.png")
                            enemy.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Senjin2.png"), size: enemy.size)
                            enemy.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
                            enemy.physicsBody?.collisionBitMask = PhysicsCategory.Bullet | PhysicsCategory.Wall | PhysicsCategory.Enemy | PhysicsCategory.Ally | PhysicsCategory.Item
                            enemy.physicsBody?.contactTestBitMask = PhysicsCategory.Bullet | PhysicsCategory.Wall | PhysicsCategory.Enemy | PhysicsCategory.Ally | PhysicsCategory.Item
                            
                            let goright = SKAction.moveTo(x: 1000.0, duration: 5.0)
                            enemy.run(goright)
                            
                        } else if turn % 6 == 3 {//左上に現れる
                            
                            if MainTimer?.isValid == true {
                                MainTimer?.invalidate()
                            }
                            
                            var ally1gotoright = SKAction.moveTo(x: ally1.position.x  + 400, duration: 1.8)
                            
                            if ally1.position.x > 850 {
                                ally1gotoright = SKAction.moveTo(x: ally1.position.x, duration: 0.1)
                            } else if ally1.position.x + 400 > 850 {
                                ally1gotoright = SKAction.moveTo(x: 850, duration: Double(1.8 * (850 - ally1.position.x) / 400))
                            }
                            
                            ally1.run(ally1gotoright)
                            
                            var ally2gotoright = SKAction.moveTo(x: ally2.position.x  + 400, duration: 1.8)
                            
                            if ally2.position.x > 850 {
                                ally2gotoright = SKAction.moveTo(x: ally2.position.x, duration: 0.1)
                            } else if ally2.position.x + 400 > 850 {
                                ally2gotoright = SKAction.moveTo(x: 850, duration: Double(1.8 * (850 - ally2.position.x) / 400))
                            }
                            
                            ally2.run(ally2gotoright)
                            
                            var ally3gotoright = SKAction.moveTo(x: ally3.position.x  + 400, duration: 1.8)
                            
                            if ally3.position.x > 850 {
                                ally3gotoright = SKAction.moveTo(x: ally3.position.x, duration: 0.1)
                            } else if ally3.position.x + 400 > 850 {
                                ally3gotoright = SKAction.moveTo(x: 850, duration: Double(1.8 * (850 - ally3.position.x) / 400))
                            }
                            
                            ally3.run(ally3gotoright)
                            
                            let Backmove = SKAction.moveTo(x: Background.position.x + 400, duration: 1.8)
                            Background.run(Backmove)
                            
                            let godown = SKAction.moveTo(y: -200.0, duration: 0.1)
                            let goleft = SKAction.moveTo(x: -200.0, duration: 0.1)
                            let goup = SKAction.moveTo(y: 250.0, duration: 0.1)
                            enemy.run(SKAction.sequence([godown,goleft,goup]))
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                let goright = SKAction.moveTo(x: 100, duration: 0.3)
                                
                                enemy.run(goright)
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                                
                                self.MoveMarker1.position = self.ally1.position
                                self.MoveMarker2.position = self.ally2.position
                                self.MoveMarker3.position = self.ally3.position
                                
                                self.MainTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.mainTimerupdate), userInfo: nil, repeats: true)
                                
                            }
                            
                            
                        } else if turn % 6 == 4 {//左下に移動
                            
                            let godown = SKAction.moveTo(y: 100, duration: 5.0)
                            enemy.run(godown)
                            
                        } else if turn % 6 == 5 {//左に行き、消える
                            
                            enemy.texture = SKTexture(imageNamed: "Senjin.png")
                            enemy.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Senjin.png"), size: enemy.size)
                            enemy.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
                            enemy.physicsBody?.collisionBitMask = PhysicsCategory.Bullet | PhysicsCategory.Wall | PhysicsCategory.Enemy | PhysicsCategory.Ally | PhysicsCategory.Item
                            enemy.physicsBody?.contactTestBitMask = PhysicsCategory.Bullet | PhysicsCategory.Wall | PhysicsCategory.Enemy | PhysicsCategory.Ally | PhysicsCategory.Item
                            
                            let goleft = SKAction.moveTo(x: -200, duration: 5.0)
                            enemy.run(goleft)
                            
                        } else if turn % 6 == 0 {//右上に現れる
                            
                            if MainTimer?.isValid == true {
                                MainTimer?.invalidate()
                            }
                            
                            var ally1gotoright = SKAction.moveTo(x: ally1.position.x  - 400, duration: 1.8)
                            
                            if ally1.position.x < 50 {
                                ally1gotoright = SKAction.moveTo(x: ally1.position.x, duration: 0.1)
                            } else if ally1.position.x - 400 < 50 {
                                ally1gotoright = SKAction.moveTo(x: 50, duration: Double(1.8 * (ally1.position.x - 50) / 400))
                            }
                            
                            ally1.run(ally1gotoright)
                            
                            var ally2gotoright = SKAction.moveTo(x: ally2.position.x  - 400, duration: 1.8)
                            
                            if ally2.position.x < 50 {
                                ally2gotoright = SKAction.moveTo(x: ally2.position.x, duration: 0.1)
                            } else if ally2.position.x - 400 < 50 {
                                ally2gotoright = SKAction.moveTo(x: 50, duration: Double(1.8 * (ally2.position.x - 50) / 400))
                            }
                            
                            ally2.run(ally2gotoright)
                            
                            var ally3gotoright = SKAction.moveTo(x: ally1.position.x  - 400, duration: 1.8)
                            
                            if ally3.position.x  < 50 {
                                ally3gotoright = SKAction.moveTo(x: ally3.position.x, duration: 0.1)
                            } else if ally3.position.x - 400 < 50 {
                                ally3gotoright = SKAction.moveTo(x: 50, duration: Double(1.8 * (ally3.position.x - 50) / 400))
                            }
                            
                            ally3.run(ally3gotoright)
                            
                            let Backmove = SKAction.moveTo(x: Background.position.x - 400, duration: 1.8)
                            Background.run(Backmove)
                            
                            let godown = SKAction.moveTo(y: -200.0, duration: 0.1)
                            let goright = SKAction.moveTo(x: 1000.0, duration: 0.1)
                            let goup = SKAction.moveTo(y: 250.0, duration: 0.1)
                            enemy.run(SKAction.sequence([godown,goright,goup]))
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                
                                let goleft = SKAction.moveTo(x: 750, duration: 0.3)
                                enemy.run(goleft)
                                
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                                
                                self.MoveMarker1.position = self.ally1.position
                                self.MoveMarker2.position = self.ally2.position
                                self.MoveMarker3.position = self.ally3.position
                                
                                self.MainTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.mainTimerupdate), userInfo: nil, repeats: true)
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
                if enemy.type == "Camera" {
                    //移動しない
                }
                
                if enemy.type == "Oni" {
                    
                    var shortestDistance:CGFloat = 50000.0 //大きい数字をとりあえず、代入します。
                    var savei:Int = 0
                    
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
                    
                    if shortestDistance >= 100 { //距離が遠い時は近づく。xy方向に
                        
                        let travelTime = SKAction.move( to: CGPoint(x: enemy.position.x - CGFloat( 1 * cos(Double(direction))),y: enemy.position.y
                            + CGFloat( 1 * sin(Double(direction)))), duration: 0.01)
                        enemy.run(travelTime)
                        
                    } else { //距離が近い時は近づかない。y方向に
                        
                        let travelTime = SKAction.move( to: CGPoint(x: enemy.position.x,y: enemy.position.y + CGFloat( 1 * sin(Double(direction)))), duration: 0.01)
                        enemy.run(travelTime)
                        
                    }
                    
                }
                
                if enemy.type == "Flog" { //ジグザグに動く
                    
                    if phasenumber == 10 {
                        
                        var  move = SKAction.move(to: CGPoint(x: enemy.position.x,y: enemy.position.y), duration: 0.01)
                        
                        if turn % 2 == 0 { //偶数ターン
                            
                            if enemy.position.x - 120 < 80 {
                                move = SKAction.move(to: CGPoint(x: enemy.position.x,y: 100), duration: 7.0)
                            } else {
                                move = SKAction.move(to: CGPoint(x: enemy.position.x - 120,y: 100), duration: 7.0)
                            }
                            
                        } else { //奇数ターン
                            
                            if enemy.position.x - 120 < 80 {
                                move = SKAction.move(to: CGPoint(x: enemy.position.x,y: 30), duration: 7.0)
                            } else {
                                move = SKAction.move(to: CGPoint(x: enemy.position.x - 120,y: 300), duration: 7.0)
                            }
                            
                        }
                        
                        enemy.run(move)
                        
                    }
                    
                }
                
                if enemy.type == "Pig" {
                    //移動しない
                }
                
                if enemy.type == "Boar" {
                    
                    if enemy.position.x > 100  && enemy.position.x < 850 {
                        
                    } else {
                        
                        if phasenumber == 5 { //画面外に居る時に横から出てくる。
                            
                            let moveDown = SKAction.moveTo(y: -100, duration: 0.1)
                            let moveRight = SKAction.moveTo(x: 1000, duration: 0.1)
                            
                            let moveUp = SKAction.moveTo(y: CGFloat(Int.random(in: 50 ..< 280)), duration: 0.1)
                            let moveLeft = SKAction.moveTo(x: 700, duration: 3.0)
                            
                            enemy.run(SKAction.sequence([moveDown,moveRight,moveUp,moveLeft]))
                            
                        }
                        
                    }
                    
                }
                
                if enemy.type == "Hull" {
                    //移動しない
                }
                
                if enemy.type == "Wall" {
                    //移動しない。
                }
                
                if enemy.type == "Cannon" {
                    //移動しない
                }
                
                if enemy.type == "RedDragon" {
                    //移動多め
                    if phasenumber == 0 || phasenumber == 60 {
                        
                        let move1 = SKAction.move(to: CGPoint(x: 700 + 40,y: 200 - 105), duration: 0.5)
                        let move2 = SKAction.move(to: CGPoint(x: 700 + 70,y: 200 - 60), duration: 0.5)
                        let move3 = SKAction.move(to: CGPoint(x: 700 + 80,y: 200), duration: 0.5)
                        let move4 = SKAction.move(to: CGPoint(x: 700 + 70,y: 200 + 60), duration: 0.5)
                        let move5 = SKAction.move(to: CGPoint(x: 700 + 40,y: 200 + 105), duration: 0.5)
                        let move6 = SKAction.move(to: CGPoint(x: 700,y: 200 + 120), duration: 0.5)
                        let move7 = SKAction.move(to: CGPoint(x: 700 - 40,y: 200 + 105), duration: 0.5)
                        let move8 = SKAction.move(to: CGPoint(x: 700 - 70,y: 200 + 60), duration: 0.5)
                        let move9 = SKAction.move(to: CGPoint(x: 700 - 80,y: 200), duration: 0.5)
                        let move10 = SKAction.move(to: CGPoint(x: 700 - 70,y: 200 - 60), duration: 0.5)
                        let move11 = SKAction.move(to: CGPoint(x: 700 - 40,y: 200 - 105), duration: 0.5)
                        let move12 = SKAction.move(to: CGPoint(x: 700,y: 200 - 120), duration: 0.5)
                        
                        enemy.run(SKAction.sequence([move1,move2,move3,move4,move5,move6,move7,move8,move9,move10,move11,move12]))
                        
                    }
                }
                
                if enemy.type == "BlueDragon" {
                    //移動多め
                    if phasenumber == 0 || phasenumber == 60 {
                        
                        let move1 = SKAction.move(to: CGPoint(x: 700 + 40,y: 200 - 105), duration: 0.5)
                        let move2 = SKAction.move(to: CGPoint(x: 700 + 70,y: 200 - 60), duration: 0.5)
                        let move3 = SKAction.move(to: CGPoint(x: 700 + 80,y: 200), duration: 0.5)
                        let move4 = SKAction.move(to: CGPoint(x: 700 + 70,y: 200 + 60), duration: 0.5)
                        let move5 = SKAction.move(to: CGPoint(x: 700 + 40,y: 200 + 105), duration: 0.5)
                        let move6 = SKAction.move(to: CGPoint(x: 700,y: 200 + 120), duration: 0.5)
                        let move7 = SKAction.move(to: CGPoint(x: 700 - 40,y: 200 + 105), duration: 0.5)
                        let move8 = SKAction.move(to: CGPoint(x: 700 - 70,y: 200 + 60), duration: 0.5)
                        let move9 = SKAction.move(to: CGPoint(x: 700 - 80,y: 200), duration: 0.5)
                        let move10 = SKAction.move(to: CGPoint(x: 700 - 70,y: 200 - 60), duration: 0.5)
                        let move11 = SKAction.move(to: CGPoint(x: 700 - 40,y: 200 - 105), duration: 0.5)
                        let move12 = SKAction.move(to: CGPoint(x: 700,y: 200 - 120), duration: 0.5)
                        
                        enemy.run(SKAction.sequence([move7,move8,move9,move10,move11,move12,move1,move2,move3,move4,move5,move6]))
                        
                    }
                }
                
                if enemy.type == "Queen" {
                    //移動しない。
                }
                
            }
            
        }
        
    }
    
    func EnemyAttack() {
        
        let remove = SKAction.removeFromParent()
        
        //敵の攻撃
        for enemy in EnemyArray {
            
            if enemy.type == "Soldier" {
                
                if phasenumber == 40 {
                    
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
                    let bulletdamage:Int = 30
                    
                    let bullet1 = self.makeeBullet(position: CGPoint(x: enemy.position.x,y: enemy.position.y), damage: bulletdamage, size: CGSize(width:  30.0, height: 10.0))
                    self.addChild(bullet1)//Bullet表示
                    
                    let travelTime1 = SKAction.move( to: CGPoint(x: enemy.position.x - CGFloat( 300 * cos(Double(direction))),y: enemy.position.y
                        + CGFloat( 300 * sin(Double(direction)))), duration: 0.8)
                    bullet1.run(SKAction.sequence([travelTime1,remove]))
                    
                    
                    let bullet2 = self.makeeBullet(position: CGPoint(x: enemy.position.x,y: enemy.position.y), damage: bulletdamage, size: CGSize(width:  30.0, height: 10.0))
                    self.addChild(bullet2)//Bullet表示
                    
                    let travelTime2 = SKAction.move( to: CGPoint(x: enemy.position.x - CGFloat( 300 * cos(Double(direction + 0.2))),y: enemy.position.y
                        + CGFloat( 300 * sin(Double(direction + 0.2)))), duration: 0.8)
                    bullet2.run(SKAction.sequence([travelTime2,remove]))
                    
                    let bullet3 = self.makeeBullet(position: CGPoint(x: enemy.position.x,y: enemy.position.y), damage: bulletdamage, size: CGSize(width:  30.0, height: 10.0))
                    self.addChild(bullet3)//Bullet表示
                    
                    let travelTime3 = SKAction.move( to: CGPoint(x: enemy.position.x - CGFloat( 300 * cos(Double(direction - 0.2))),y: enemy.position.y
                        + CGFloat( 300 * sin(Double(direction - 0.2)))), duration: 0.8)
                    bullet3.run(SKAction.sequence([travelTime3,remove]))
                    
                }
                
            }
            
            if enemy.type == "Bom" {
                
                if phasenumber == 20 {
                    
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
                        
                        print("bomFire")
                        
                        let bomDamage:Int = 200
                        
                        let bom1 = makeeBullet(position: CGPoint(x: BomPosition.x,y: BomPosition.y), damage: bomDamage, size: CGSize(width:  20.0, height: 20.0))
                        self.addChild(bom1)
                        
                        let action1 = SKAction.move(to: CGPoint(x: BomPosition.x, y: BomPosition.y + 100), duration: 1.0)//上
                        bom1.run(SKAction.sequence([action1,remove]))
                        
                        let bom2 = makeeBullet(position: CGPoint(x: BomPosition.x,y: BomPosition.y), damage: bomDamage, size: CGSize(width:  20.0, height: 20.0))
                        self.addChild(bom2)
                        
                        let action2 = SKAction.move(to: CGPoint(x: BomPosition.x + 100, y: BomPosition.y + 100), duration: 1.0)//右上
                        bom2.run(SKAction.sequence([action2,remove]))
                        
                        
                        let bom3 = makeeBullet(position: CGPoint(x: BomPosition.x,y: BomPosition.y), damage: bomDamage, size: CGSize(width:  20.0, height: 20.0))
                        self.addChild(bom3)
                        
                        let action3 = SKAction.move(to: CGPoint(x: BomPosition.x + 100, y: BomPosition.y), duration: 1.0)//右
                        bom3.run(SKAction.sequence([action3,remove]))
                                                
                        
                        let bom4 = makeeBullet(position: CGPoint(x: BomPosition.x,y: BomPosition.y), damage: bomDamage, size: CGSize(width:  20.0, height: 20.0))
                        self.addChild(bom4)
                        
                        let action4 = SKAction.move(to: CGPoint(x: BomPosition.x + 100, y: BomPosition.y - 100), duration: 1.0)//右下
                        bom4.run(SKAction.sequence([action4,remove]))
                        
                        
                        let bom5 = makeeBullet(position: CGPoint(x: BomPosition.x,y: BomPosition.y), damage: bomDamage, size: CGSize(width:  20.0, height: 20.0))
                        self.addChild(bom5)
                        
                        let action5 = SKAction.move(to: CGPoint(x: BomPosition.x, y: BomPosition.y - 100), duration: 1.0)//した
                        bom5.run(SKAction.sequence([action5,remove]))
                        
                        
                        let bom6 = makeeBullet(position: CGPoint(x: BomPosition.x,y: BomPosition.y), damage: bomDamage, size: CGSize(width:  20.0, height: 20.0))
                        self.addChild(bom6)
                        
                        let action6 = SKAction.move(to: CGPoint(x: BomPosition.x - 100, y: BomPosition.y - 100), duration: 1.0)//左した
                        bom6.run(SKAction.sequence([action6,remove]))
                        
                        
                        let bom7 = makeeBullet(position: CGPoint(x: BomPosition.x,y: BomPosition.y), damage: bomDamage, size: CGSize(width:  20.0, height: 20.0))
                        self.addChild(bom7)
                        
                        let action7 = SKAction.move(to: CGPoint(x: BomPosition.x - 100, y: BomPosition.y), duration: 1.0)//左
                        bom7.run(SKAction.sequence([action7,remove]))
                        
                        
                        let bom8 = makeeBullet(position: CGPoint(x: BomPosition.x,y: BomPosition.y), damage: bomDamage, size: CGSize(width:  20.0, height: 20.0))
                        self.addChild(bom8)
                        
                        let action8 = SKAction.move(to: CGPoint(x: BomPosition.x - 100, y: BomPosition.y + 100), duration: 1.0)//左うえ
                        bom8.run(SKAction.sequence([action8,remove]))
                        
                    }
                    
                }
                
            }
            
            if enemy.type == "Warp" {
                
                if phasenumber == 24 {
                        
                    if enemy.position.x - 10 - enemy.size.width / 2 > 0 {
                        
                        let fadeIn = SKAction.fadeIn(withDuration: 0.2)
                        let fadeOut = SKAction.fadeOut(withDuration: 0.2)
                        
                        let alert = self.makeAlert(position: CGPoint(x: enemy.position.x / 2 - enemy.size.width / 4 + 5 ,y: enemy.position.y), size: CGSize(width: enemy.position.x - 10 - enemy.size.width / 2, height: 30.0))
                        self.addChild(alert)
                        
                        alert.run(SKAction.sequence([fadeIn,fadeOut,fadeIn,fadeOut,fadeIn,fadeOut,fadeIn,fadeIn,fadeOut,remove]))
                        
                    }
                    
                }
                
                if phasenumber == 40 {
                    
                    var bulletdamage:Int = 200
                    
                    if enemy.grade == 0 {
                        bulletdamage = 10
                    } else if enemy.grade == 1 {
                        bulletdamage = 200
                    } else if enemy.grade == 2 {
                        bulletdamage = 500
                    } else if enemy.grade == 3 {
                        bulletdamage = 1000
                    }
                    self.changeEnemyGrade(change: 1, id: enemy.id!)
                    
                    let bullet1 = self.makeeBullet(position: CGPoint(x: enemy.position.x,y: enemy.position.y), damage: bulletdamage, size: CGSize(width:  30.0, height: 15.0))
                    self.addChild(bullet1)
                    
                    let travelTime1 = SKAction.moveTo(x: enemy.position
                        .x - 400, duration: 0.5)
                    
                    bullet1.run(SKAction.sequence([travelTime1,remove]))
                    
                }
                
            }
            
            if enemy.type == "WarpBoss" {
                
                if phasenumber == 40 {//爆弾を生成する。
                    if enemy.grade == 0 {} else { //gradeが0なら爆弾を生成しない。
                        
                        let bom = self.makeBom(position: CGPoint(x: enemy.position.x + 100,y: enemy.position.y))
                        bom.id = waveEnemyNumber
                        bom.moveEnable = false
                        waveEnemyNumber = waveEnemyNumber + 1
                        EnemyArray.append(bom)
                        
                        bom.alpha = 0.0
                        self.addChild(bom)
                        
                        let fadeIn = SKAction.fadeIn(withDuration: 0.5)
                        bom.run(fadeIn)
                        
                    }
                    self.changeEnemyGrade(change: 1, id: enemy.id!)
                    
                }
                
                if phasenumber == 90 {//爆弾を送る。
                    
                    for i in EnemyArray {
                        
                        if i.type == "Bom" {
                            
                            let fadeOut = SKAction.fadeOut(withDuration: 0.6)
                            
                            var move = SKAction.moveTo(x: i.position.x - 200, duration: 0.1)
                            if i.position.x - 200 < 50 {
                              move = SKAction.moveTo(x: 50, duration: 0.1)
                            }
                            
                            let fadeIn = SKAction.fadeIn(withDuration: 0.6)
                            
                            i.run(SKAction.sequence([fadeOut,move,fadeIn]))
                            
                        }
                        
                    }
                    
                }
                
            }
            
            if enemy.type == "Tank" {
                
                if phasenumber == 24 {
                    
                    let fadeIn = SKAction.fadeIn(withDuration: 0.2)
                    let fadeOut = SKAction.fadeOut(withDuration: 0.2)
                    
                    if turn % 2 == 0 {//偶数ターン
                        
                        let alert = self.makeAlert(position: CGPoint(x: enemy.position.x / 2 - 5 - enemy.size.width / 4,y: enemy.position.y), size: CGSize(width: enemy.position.x - 10 - enemy.size.width / 2, height: 50.0))
                        self.addChild(alert)
                        
                        alert.run(SKAction.sequence([fadeIn,fadeOut,fadeIn,fadeOut,fadeIn,fadeOut,fadeIn,fadeIn,fadeOut,remove]))
                        
                    } else {//奇数ターン
                        
                        if 284 - enemy.position.y - (enemy.size.height / 2)  > 0 {
                            
                            let alert1 = self.makeAlert(position: CGPoint(x: enemy.position.x ,y: enemy.position.y / 2 + 167 ), size: CGSize(width: 60, height: 274 - enemy.position.y))
                            self.addChild(alert1)
                            
                            let alert3 = self.makeAlert(position: CGPoint(x: enemy.position.x / 2 - 10,y: 274), size: CGSize(width: enemy.position.x - 40, height: 60.0))
                            self.addChild(alert3)
                            
                            alert1.run(SKAction.sequence([fadeIn,fadeOut,fadeIn,fadeOut,fadeIn,fadeOut,fadeIn,fadeIn,fadeOut,remove]))
                            alert3.run(SKAction.sequence([fadeIn,fadeOut,fadeIn,fadeOut,fadeIn,fadeOut,fadeIn,fadeIn,fadeOut,remove]))
                            
                        }
                        
                        if enemy.position.y - enemy.size.height / 2 - 70 > 0 {
                            
                            let alert2 = self.makeAlert(position: CGPoint(x: enemy.position.x ,y: enemy.position.y / 2 - 10), size: CGSize(width: 60, height: enemy.position.y - 80))
                            self.addChild(alert2)
                            
                            let alert4 = self.makeAlert(position: CGPoint(x: enemy.position.x / 2 - 10,y: 60), size: CGSize(width: enemy.position.x - 40, height: 60.0))
                            alert4.alpha = 0.0
                            self.addChild(alert4)

                            alert2.run(SKAction.sequence([fadeIn,fadeOut,fadeIn,fadeOut,fadeIn,fadeOut,fadeIn,fadeIn,fadeOut,remove]))
                            alert4.run(SKAction.sequence([fadeIn,fadeOut,fadeIn,fadeOut,fadeIn,fadeOut,fadeIn,fadeIn,fadeOut,remove]))
                            
                        }
                        
                    }
                    
                }
                
                if phasenumber == 40 {
                    
                    if turn % 2 == 0 {//偶数ターン
                        
                        var bulletdamage:Int = 400
                        
                        if enemy.grade == 0 {
                            bulletdamage = 120
                        } else if enemy.grade == 1 {
                            bulletdamage = 400
                        } else if enemy.grade == 2 {
                            bulletdamage = 600
                        } else if enemy.grade == 3 {
                            bulletdamage = 1000
                        }
                        self.changeEnemyGrade(change: 1, id: enemy.id!)
                        
                        let bullet1 = self.makeeBullet(position: CGPoint(x: enemy.position.x,y: enemy.position.y), damage: bulletdamage, size: CGSize(width:  30.0, height: 15.0))
                        self.addChild(bullet1)//Bullet表示
                        
                        let travelTime = SKAction.moveTo(x: enemy.position.x - self.size.width, duration: 0.6)
                        
                        bullet1.run(SKAction.sequence([travelTime,remove]))
                        
                        
                        let bullet2 = self.makeeBullet(position: CGPoint(x: enemy.position.x,y: enemy.position.y), damage: bulletdamage, size: CGSize(width:  30.0, height: 15.0))
                        self.addChild(bullet2)//Bullet表示
                        
                        let wait = SKAction.wait(forDuration: 0.2)
                        bullet2.run(SKAction.sequence([wait,travelTime,remove]))
                        
                    } else {//奇数ターン
                        
                        var bulletdamage:Int = 400
                        
                        if enemy.grade == 0 {
                            bulletdamage = 10
                        } else if enemy.grade == 1 {
                            bulletdamage = 400
                        } else if enemy.grade == 2 {
                            bulletdamage = 600
                        } else if enemy.grade == 3 {
                            bulletdamage = 1000
                        }
                        self.changeEnemyGrade(change: 1, id: enemy.id!)
                        
                        let bullet1 = self.makeeBullet(position: CGPoint(x: enemy.position.x,y: enemy.position.y), damage: bulletdamage, size: CGSize(width:  30.0, height: 15.0))
                        self.addChild(bullet1)//Bullet表示
                        
                        let goup = SKAction.moveTo(y: 274, duration: 0.4)
                        let travelTime = SKAction.moveTo(x: 10, duration: 0.6)
                        
                        bullet1.run(SKAction.sequence([goup,travelTime,remove]))
                        
                        let bullet2 = self.makeeBullet(position: CGPoint(x: enemy.position.x,y: enemy.position.y), damage: bulletdamage, size: CGSize(width:  30.0, height: 15.0))
                        self.addChild(bullet2)//Bullet表示
                        
                        let godown = SKAction.moveTo(y: 70, duration: 0.4)
                        
                        bullet2.run(SKAction.sequence([godown,travelTime,remove]))
                        
                        
                    }
                    
                }
                
            }
            
            if enemy.type == "Senjin" {
                
                let fadeIn = SKAction.fadeIn(withDuration: 0.2)
                let fadeOut = SKAction.fadeOut(withDuration: 0.2)
                
                if phasenumber == 24 {
                    
                    if turn % 6 == 1 {//右上
                        
                        if Double(enemy.hp!) / Double(enemy.maxHp!) > 0.3 {//hpが30%より多い時の攻撃
                            let alert = self.makeAlert(position: CGPoint(x: (enemy.position.x - 10 - (enemy.size.width / 2)) / 2,y: enemy.position.y), size: CGSize(width: enemy.position.x - 10 - (enemy.size.width / 2), height: 50.0))
                            self.addChild(alert)
                            
                            alert.run(SKAction.sequence([fadeIn,fadeOut,fadeIn,fadeOut,fadeIn,fadeOut,fadeIn,fadeIn,fadeOut,remove]))
                            
                        } else {//hpが30%より少ない時の攻撃
                            
                        }
                        
                    } else if turn % 6 == 2 {//右下
                        
                        if Double(enemy.hp!) / Double(enemy.maxHp!) > 0.3 {//hpが30%より多い時の攻撃
                            
                            let alert = self.makeAlert(position: CGPoint(x: (enemy.position.x - 10 - (enemy.size.width / 2)) / 2,y: enemy.position.y), size: CGSize(width: enemy.position.x - 10 - (enemy.size.width / 2), height: 50.0))
                            self.addChild(alert)
                            
                            alert.run(SKAction.sequence([fadeIn,fadeOut,fadeIn,fadeOut,fadeIn,fadeOut,fadeIn,fadeIn,fadeOut,remove]))
                            
                        } else {//hpが30%より少ない時の攻撃
                            
                        }
                        
                    } else if turn % 6 == 3 {//画面外
                        
                        let alert1 = self.makeAlert(position: CGPoint(x: 170,y: 177), size: CGSize(width: 50, height: 334))
                        self.addChild(alert1)
                        
                        alert1.run(SKAction.sequence([fadeIn,fadeOut,fadeIn,fadeOut,fadeIn,fadeOut,fadeIn,fadeIn,fadeOut,remove]))
                        
                        let alert2 = self.makeAlert(position: CGPoint(x: 340,y: 177), size: CGSize(width: 50, height: 334))
                        self.addChild(alert2)
                        
                        alert2.run(SKAction.sequence([fadeIn,fadeOut,fadeIn,fadeOut,fadeIn,fadeOut,fadeIn,fadeIn,fadeOut,remove]))
                        
                        let alert3 = self.makeAlert(position: CGPoint(x: 510,y: 177), size: CGSize(width: 50, height: 334))
                        self.addChild(alert3)
                        
                        alert3.run(SKAction.sequence([fadeIn,fadeOut,fadeIn,fadeOut,fadeIn,fadeOut,fadeIn,fadeIn,fadeOut,remove]))
                        
                        let alert4 = self.makeAlert(position: CGPoint(x: 680,y: 177), size: CGSize(width: 50, height: 334))
                        self.addChild(alert4)
                        
                        alert4.run(SKAction.sequence([fadeIn,fadeOut,fadeIn,fadeOut,fadeIn,fadeOut,fadeIn,fadeIn,fadeOut,remove]))
                        
                    } else if turn % 6 == 4 {//左上
                        
                        if Double(enemy.hp!) / Double(enemy.maxHp!) > 0.3 {//hpが30%より多い時の攻撃
                            let alert = self.makeAlert(position: CGPoint(x: 443 + enemy.position.x / 2 + enemy.size.width / 4 ,y: enemy.position.y), size: CGSize(width: 886 - enemy.position.x - enemy.size.width / 2, height: 50.0))
                            self.addChild(alert)
                            
                            alert.run(SKAction.sequence([fadeIn,fadeOut,fadeIn,fadeOut,fadeIn,fadeOut,fadeIn,fadeIn,fadeOut,remove]))
                        } else {//hpが30%より少ない時の攻撃
                            
                        }
                        
                    } else if turn % 6 == 5 {//左下
                        
                        if Double(enemy.hp!) / Double(enemy.maxHp!) > 0.3 {//hpが30%より多い時の攻撃
                            
                            let alert = self.makeAlert(position: CGPoint(x: 443 + enemy.position.x / 2 + enemy.size.width / 4 ,y: enemy.position.y), size: CGSize(width: 886 - enemy.position.x - enemy.size.width / 2, height: 50.0))
                            self.addChild(alert)
                            
                            alert.run(SKAction.sequence([fadeIn,fadeOut,fadeIn,fadeOut,fadeIn,fadeOut,fadeIn,fadeIn,fadeOut,remove]))
                            
                        } else {//hpが30%より少ない時の攻撃
                            
                        }
                        
                    } else if turn % 6 == 0 {//画面外
                        
                        let alert1 = self.makeAlert(position: CGPoint(x: 260,y: 177), size: CGSize(width: 50, height: 334))
                        self.addChild(alert1)
                        
                        alert1.run(SKAction.sequence([fadeIn,fadeOut,fadeIn,fadeOut,fadeIn,fadeOut,fadeIn,fadeIn,fadeOut,remove]))
                        
                        let alert2 = self.makeAlert(position: CGPoint(x: 430,y: 177), size: CGSize(width: 50, height: 334))
                        self.addChild(alert2)
                        
                        alert2.run(SKAction.sequence([fadeIn,fadeOut,fadeIn,fadeOut,fadeIn,fadeOut,fadeIn,fadeIn,fadeOut,remove]))
                        
                        let alert3 = self.makeAlert(position: CGPoint(x: 600,y: 177), size: CGSize(width: 50, height: 334))
                        self.addChild(alert3)
                        
                        alert3.run(SKAction.sequence([fadeIn,fadeOut,fadeIn,fadeOut,fadeIn,fadeOut,fadeIn,fadeIn,fadeOut,remove]))
                        
                        let alert4 = self.makeAlert(position: CGPoint(x: 770,y: 177), size: CGSize(width: 50, height: 334))
                        self.addChild(alert4)
                        
                        alert4.run(SKAction.sequence([fadeIn,fadeOut,fadeIn,fadeOut,fadeIn,fadeOut,fadeIn,fadeIn,fadeOut,remove]))
                        
                    }
                    
                }
                
                if phasenumber == 40 {
                    
                    if turn % 6 == 1 {//右上
                        
                        if Double(enemy.hp!) / Double(enemy.maxHp!) > 0.3 {//hpが30%より多い時の攻撃
                            
                            var bulletdamage:Int = 400
                            if enemy.grade == 0 {
                                bulletdamage = 10
                            } else if enemy.grade == 1 {
                                bulletdamage = 400
                            } else if enemy.grade == 2 {
                                bulletdamage = 600
                            } else if enemy.grade == 3 {
                                bulletdamage = 1000
                            }
                            self.changeEnemyGrade(change: 1, id: enemy.id!)
                            
                            let bullet1 = self.makeeBullet(position: CGPoint(x: enemy.position.x,y: enemy.position.y), damage: bulletdamage, size: CGSize(width:  30.0, height: 15.0))
                            
                            self.addChild(bullet1)//Bullet表示
                            
                            let travelTime = SKAction.moveTo(x: enemy.position
                                .x - self.size.width, duration: 0.6)
                            
                            bullet1.run(SKAction.sequence([travelTime,remove]))
                            
                        } else {//hpが30%より少ない時の攻撃
                            
                            var bulletdamage:Int = 200
                            if enemy.grade == 0 {
                                bulletdamage = 10
                            } else if enemy.grade == 1 {
                                bulletdamage = 200
                            } else if enemy.grade == 2 {
                                bulletdamage = 500
                            } else if enemy.grade == 3 {
                                bulletdamage = 1000
                            }
                            self.changeEnemyGrade(change: 1, id: enemy.id!)
                            
                            let bullet1 = self.makeeBullet(position: CGPoint(x: enemy.position.x,y: enemy.position.y), damage: bulletdamage, size: CGSize(width: 70,height: 50))
                            self.addChild(bullet1)
                            
                            let goleft = SKAction.moveTo(x: 10, duration: 15.0)
                            
                            bullet1.run(SKAction.sequence([goleft,remove]))
                            
                            
                            let bullet2 = self.makeeBullet(position: CGPoint(x: enemy.position.x,y: enemy.position.y), damage: bulletdamage, size: CGSize(width: 70,height: 50))
                            self.addChild(bullet2)
                            
                            let gozero = SKAction.move(to: CGPoint(x:10,y:10), duration: 15.0)
                            
                            bullet2.run(SKAction.sequence([gozero,remove]))
                            
                        }
                        
                    } else if turn % 6 == 2 {//右下
                        
                        if Double(enemy.hp!) / Double(enemy.maxHp!) > 0.3 {//hpが30%より多い時の攻撃
                            
                            var bulletdamage:Int = 400
                            if enemy.grade == 0 {
                                bulletdamage = 10
                            } else if enemy.grade == 1 {
                                bulletdamage = 400
                            } else if enemy.grade == 2 {
                                bulletdamage = 600
                            } else if enemy.grade == 3 {
                                bulletdamage = 1000
                            }
                            self.changeEnemyGrade(change: 1, id: enemy.id!)
                            
                            let bullet1 = self.makeeBullet(position: CGPoint(x: enemy.position.x,y: enemy.position.y), damage: bulletdamage, size: CGSize(width:  30.0, height: 15.0))
                            
                            self.addChild(bullet1)//Bullet表示
                            
                            let travelTime = SKAction.moveTo(x: enemy.position
                                .x - self.size.width, duration: 0.6)
                            
                            bullet1.run(SKAction.sequence([travelTime,remove]))
                            
                        } else {//hpが30%より少ない時の攻撃
                            
                            var bulletdamage:Int = 200
                            if enemy.grade == 0 {
                                bulletdamage = 10
                            } else if enemy.grade == 1 {
                                bulletdamage = 200
                            } else if enemy.grade == 2 {
                                bulletdamage = 500
                            } else if enemy.grade == 3 {
                                bulletdamage = 1000
                            }
                            self.changeEnemyGrade(change: 1, id: enemy.id!)
                            
                            let bullet1 = self.makeeBullet(position: CGPoint(x: enemy.position.x,y: enemy.position.y), damage: bulletdamage, size: CGSize(width: 70,height: 50))
                            self.addChild(bullet1)
                            
                            let goleft = SKAction.moveTo(x: 10, duration: 15.0)
                            
                            bullet1.run(SKAction.sequence([goleft,remove]))
                            
                            
                            let bullet2 = self.makeeBullet(position: CGPoint(x: enemy.position.x,y: enemy.position.y), damage: bulletdamage, size: CGSize(width: 70,height: 50))
                            self.addChild(bullet2)
                            
                            let gozero = SKAction.move(to: CGPoint(x: 330,y:10), duration: 15.0)
                            
                            bullet2.run(SKAction.sequence([gozero,remove]))
                            
                        }
                        
                    } else if turn % 6 == 3 {//画面外
                        
                        var bulletdamage:Int = 200
                        if enemy.grade == 0 {
                            bulletdamage = 10
                        } else if enemy.grade == 1 {
                            bulletdamage = 200
                        } else if enemy.grade == 2 {
                            bulletdamage = 500
                        } else if enemy.grade == 3 {
                            bulletdamage = 1000
                        }
                        self.changeEnemyGrade(change: 1, id: enemy.id!)
                        
                        
                        let goup = SKAction.moveTo(y: 500, duration: 1.5)
                        let godown = SKAction.moveTo(y: 0, duration: 1.5)
                        
                        let bullet1 = self.makeeBullet(position: CGPoint(x: 170,y: -100), damage: bulletdamage, size: CGSize(width:  30.0, height: 30.0))
                        self.addChild(bullet1)
                        
                        bullet1.run(SKAction.sequence([goup,remove]))
                        
                        let bullet2 = self.makeeBullet(position: CGPoint(x: 340,y: 500), damage: bulletdamage, size: CGSize(width:  30.0, height: 30.0))
                        self.addChild(bullet2)
                        
                        bullet2.run(SKAction.sequence([godown,remove]))
                        
                        let bullet3 = self.makeeBullet(position: CGPoint(x: 510,y: -100), damage: bulletdamage, size: CGSize(width:  30.0, height: 30.0))
                        self.addChild(bullet3)
                        
                        bullet3.run(SKAction.sequence([goup,remove]))
                        
                        let bullet4 = self.makeeBullet(position: CGPoint(x: 680,y: 500), damage: bulletdamage, size: CGSize(width:  30.0, height: 30.0))
                        self.addChild(bullet4)
                        
                        bullet4.run(SKAction.sequence([godown,remove]))
                        
                        
                    } else if turn % 6 == 4 {//左上
                        
                        if Double(enemy.hp!) / Double(enemy.maxHp!) > 0.3 {//hpが30%より多い時の攻撃
                            
                            var bulletdamage:Int = 400
                            if enemy.grade == 0 {
                                bulletdamage = 10
                            } else if enemy.grade == 1 {
                                bulletdamage = 400
                            } else if enemy.grade == 2 {
                                bulletdamage = 500
                            } else if enemy.grade == 3 {
                                bulletdamage = 1000
                            }
                            self.changeEnemyGrade(change: 1, id: enemy.id!)
                            
                            let bullet1 = self.makeeBullet(position: CGPoint(x: enemy.position.x,y: enemy.position.y), damage: bulletdamage, size: CGSize(width:  30.0, height: 15.0))
                            
                            self.addChild(bullet1)//Bullet表示
                            
                            let travelTime = SKAction.moveTo(x: self.size.width - enemy.position
                            .x, duration: 0.6)
                            
                            bullet1.run(SKAction.sequence([travelTime,remove]))
                            
                        } else {//hpが30%より少ない時の攻撃
                            
                            var bulletdamage:Int = 200
                            if enemy.grade == 0 {
                                bulletdamage = 10
                            } else if enemy.grade == 1 {
                                bulletdamage = 200
                            } else if enemy.grade == 2 {
                                bulletdamage = 500
                            } else if enemy.grade == 3 {
                                bulletdamage = 1000
                            }
                            self.changeEnemyGrade(change: 1, id: enemy.id!)
                            
                            let bullet1 = self.makeeBullet(position: CGPoint(x: enemy.position.x,y: enemy.position.y), damage: bulletdamage, size: CGSize(width: 70,height: 50))
                            self.addChild(bullet1)
                            
                            let goright = SKAction.moveTo(x: 880, duration: 15.0)
                            
                            bullet1.run(SKAction.sequence([goright,remove]))
                            
                            
                            let bullet2 = self.makeeBullet(position: CGPoint(x: enemy.position.x,y: enemy.position.y), damage: bulletdamage, size: CGSize(width: 70,height: 50))
                            self.addChild(bullet2)
                            
                            let gozero = SKAction.move(to: CGPoint(x: 880,y: 10), duration: 15.0)
                            
                            bullet2.run(SKAction.sequence([gozero,remove]))
                            
                        }
                        
                    } else if turn % 6 == 5 {//左下
                        
                        if Double(enemy.hp!) / Double(enemy.maxHp!) > 0.3 {//hpが30%より多い時の攻撃
                            
                            var bulletdamage:Int = 400
                            if enemy.grade == 0 {
                                bulletdamage = 10
                            } else if enemy.grade == 1 {
                                bulletdamage = 400
                            } else if enemy.grade == 2 {
                                bulletdamage = 500
                            } else if enemy.grade == 3 {
                                bulletdamage = 1000
                            }
                            self.changeEnemyGrade(change: 1, id: enemy.id!)
                            
                            let bullet1 = self.makeeBullet(position: CGPoint(x: enemy.position.x,y: enemy.position.y), damage: bulletdamage, size: CGSize(width:  30.0, height: 15.0))
                            
                            self.addChild(bullet1)//Bullet表示
                            
                            let travelTime = SKAction.moveTo(x: self.size.width - enemy.position
                            .x, duration: 0.6)
                            
                            bullet1.run(SKAction.sequence([travelTime,remove]))
                            
                        } else {//hpが30%より少ない時の攻撃
                            
                            var bulletdamage:Int = 200
                            if enemy.grade == 0 {
                                bulletdamage = 10
                            } else if enemy.grade == 1 {
                                bulletdamage = 200
                            } else if enemy.grade == 2 {
                                bulletdamage = 500
                            } else if enemy.grade == 3 {
                                bulletdamage = 1000
                            }
                            self.changeEnemyGrade(change: 1, id: enemy.id!)
                            
                            
                            let bullet1 = self.makeeBullet(position: CGPoint(x: enemy.position.x,y: enemy.position.y), damage: bulletdamage, size: CGSize(width: 70,height: 50))
                            self.addChild(bullet1)
                            
                            let goright = SKAction.moveTo(x: 880, duration: 15.0)
                            
                            bullet1.run(SKAction.sequence([goright,remove]))
                            
                            
                            let bullet2 = self.makeeBullet(position: CGPoint(x: enemy.position.x,y: enemy.position.y), damage: bulletdamage, size: CGSize(width: 70,height: 50))
                            self.addChild(bullet2)
                            
                            let gozero = SKAction.move(to: CGPoint(x: 880,y: 330), duration: 15.0)
                            
                            bullet2.run(SKAction.sequence([gozero,remove]))
                            
                        }
                        
                    } else if turn % 6 == 0 {//画面外
                        
                        var bulletdamage:Int = 200
                        if enemy.grade == 0 {
                            bulletdamage = 10
                        } else if enemy.grade == 1 {
                            bulletdamage = 200
                        } else if enemy.grade == 2 {
                            bulletdamage = 500
                        } else if enemy.grade == 3 {
                            bulletdamage = 1000
                        }
                        self.changeEnemyGrade(change: 1, id: enemy.id!)
                        
                        
                        let goup = SKAction.moveTo(y: 500, duration: 1.5)
                        let godown = SKAction.moveTo(y: 0, duration: 1.5)
                        
                        let bullet1 = self.makeeBullet(position: CGPoint(x: 260,y: 500), damage: bulletdamage, size: CGSize(width:  30.0, height: 30.0))
                        self.addChild(bullet1)
                        
                        bullet1.run(SKAction.sequence([godown,remove]))
                        
                        let bullet2 = self.makeeBullet(position: CGPoint(x: 430,y: -100), damage: bulletdamage, size: CGSize(width:  30.0, height: 30.0))
                        self.addChild(bullet2)
                        
                        bullet2.run(SKAction.sequence([goup,remove]))
                        
                        let bullet3 = self.makeeBullet(position: CGPoint(x: 600,y: 500), damage: bulletdamage, size: CGSize(width:  30.0, height: 30.0))
                        self.addChild(bullet3)
                        
                        bullet3.run(SKAction.sequence([godown,remove]))
                        
                        let bullet4 = self.makeeBullet(position: CGPoint(x: 770,y: -100), damage: bulletdamage, size: CGSize(width:  30.0, height: 30.0))
                        self.addChild(bullet4)
                        
                        bullet4.run(SKAction.sequence([goup,remove]))
                        
                    }
                    
                }
                
            }
            
            if enemy.type == "Camera" {
                
                if phasenumber == 30 { //監視する
                    
                    let bullet = self.makeeBullet(position: enemy.position, damage: 0, size: CGSize(width: 10, height: 240))
                    bullet.zPosition = -1
                    bullet.name = "camera"
                    bullet.physicsBody?.isDynamic = false
                    self.addChild(bullet)
                    
                    let rotateAction = SKAction.rotate(byAngle: self.DegreeToRadian(Degree: -1080), duration: 8)
                    
                    bullet.run(SKAction.sequence([rotateAction,remove]))
                    
                }
                
            }
            
            if enemy.type == "Oni" {
                
                if phasenumber == 14 {
                    
                    let fadeIn = SKAction.fadeIn(withDuration: 0.2)
                    let fadeOut = SKAction.fadeOut(withDuration: 0.2)
                    
                    let alert = self.makeAlert(position: CGPoint(x: enemy.position.x - 80,y: enemy.position.y), size: CGSize(width: 160, height: 100.0))
                    self.addChild(alert)
                    
                    alert.run(SKAction.sequence([fadeIn,fadeOut,fadeIn,fadeOut,fadeIn,fadeOut,fadeIn,fadeIn,fadeOut,remove]))
                    
                }
                
                if phasenumber == 30 || phasenumber == 50 { //近距離に強めの攻撃。
                    
                    //Oniの挙動、棒を振る。
                    var bulletdamage:Int = 200
                    if enemy.grade == 0 {
                        bulletdamage = 10
                    } else if enemy.grade == 1 {
                        bulletdamage = 200
                    } else if enemy.grade == 2 {
                        bulletdamage = 500
                    } else if enemy.grade == 3 {
                        bulletdamage = 1000
                    }
                    
                    if phasenumber == 50 {
                        self.changeEnemyGrade(change: 1, id: enemy.id!)
                    }
                    
                    let bullet1 = self.makeeBullet(position: CGPoint(x: enemy.position.x,y: enemy.position.y), damage: bulletdamage, size: CGSize(width:  10.0, height: 100.0))
                    self.addChild(bullet1)//Bullet表示
                    
                    let travelTime1 = SKAction.moveTo(x: enemy.position.x - 160, duration: 0.2)
                    bullet1.run(SKAction.sequence([travelTime1,remove]))
                    
                }
                
            }
            
            if enemy.type == "Flog" {
                
                if phasenumber == 24 {
                    
                    let fadeIn = SKAction.fadeIn(withDuration: 0.2)
                    let fadeOut = SKAction.fadeOut(withDuration: 0.2)
                    
                    let alert = self.makeAlert(position: CGPoint(x: enemy.position.x - 130,y: enemy.position.y), size: CGSize(width: 160, height: 120.0))
                    self.addChild(alert)
                    
                    alert.run(SKAction.sequence([fadeIn,fadeOut,fadeIn,fadeOut,fadeIn,fadeOut,fadeIn,fadeIn,fadeOut,remove]))
                    
                }
                
                if phasenumber == 40 { //毒を吐き出す。
                    
                    var bulletdamage = 100
                    if enemy.grade == 0 {
                        bulletdamage = 10
                    } else if enemy.grade == 1 {
                        bulletdamage = 100
                    } else if enemy.grade == 2 {
                        bulletdamage = 300
                    } else if enemy.grade == 3 {
                        bulletdamage = 800
                    }
                    self.changeEnemyGrade(change: 1, id: enemy.id!)
                    
                    
                    let move  = SKAction.move(to: CGPoint(x: enemy.position.x - 200,y: enemy.position.y - 50), duration: 1.5)
                    let scaleup = SKAction.scale(by: 2.5, duration: 1.5)
                    
                    let bullet1 = self.makeeBullet(position: CGPoint(x: enemy.position.x - 60,y: enemy.position.y + 50), damage: bulletdamage, size: CGSize(width:  50.0, height: 30.0))
                    bullet1.color = UIColor.purple
                    bullet1.name = "poison"
                    self.addChild(bullet1)//Bullet表示
                    
                    bullet1.run(SKAction.group([move,scaleup]))
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        
                        bullet1.physicsBody?.categoryBitMask = 0
                        bullet1.physicsBody?.collisionBitMask = 0
                        bullet1.physicsBody?.contactTestBitMask = 0
                        
                        bullet1.zPosition = -1
                        
                    }
                    
                }
                
            }
            
            if enemy.type == "Pig" {
                
                if phasenumber == 80 {
                    if Double(enemy.hp!) / Double(enemy.maxHp!) < 0.5 {//hpが半分以下の時にイノシシに変身する。
                        
                        enemy.texture = SKTexture(imageNamed: "Boar.png")
                        enemy.type = "Boar"
                        enemy.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
                        enemy.physicsBody?.collisionBitMask = PhysicsCategory.Bullet | PhysicsCategory.Wall | PhysicsCategory.Enemy | PhysicsCategory.Ally | PhysicsCategory.Item
                        enemy.physicsBody?.contactTestBitMask = PhysicsCategory.Bullet | PhysicsCategory.Wall | PhysicsCategory.Enemy | PhysicsCategory.Ally | PhysicsCategory.Item
                        enemy.maxHp = 1500
                        self.changeEnemyHp(change: 1500, id: enemy.id!)//hpを回復する。
                        
                    }
                }
                
                if phasenumber == 24 {
                    
                    let fadeIn = SKAction.fadeIn(withDuration: 0.2)
                    let fadeOut = SKAction.fadeOut(withDuration: 0.2)
                    
                    let alert = self.makeAlert(position: CGPoint(x: enemy.position.x - 130,y: enemy.position.y), size: CGSize(width: 160, height: 120.0))
                    self.addChild(alert)
                    
                    alert.run(SKAction.sequence([fadeIn,fadeOut,fadeIn,fadeOut,fadeIn,fadeOut,fadeIn,fadeIn,fadeOut,remove]))
                    
                }
                
                if phasenumber == 40 { //弱めの攻撃。
                    
                    var bulletdamage = 50
                    if enemy.grade == 0 {
                        bulletdamage = 10
                    } else if enemy.grade == 1 {
                        bulletdamage = 50
                    } else if enemy.grade == 2 {
                        bulletdamage = 200
                    } else if enemy.grade == 3 {
                        bulletdamage = 400
                    }
                    self.changeEnemyGrade(change: 1, id: enemy.id!)
                    
                    let move  = SKAction.move(to: CGPoint(x: enemy.position.x - 200,y: enemy.position.y), duration: 1.0)
                    
                    let bullet1 = self.makeeBullet(position: CGPoint(x: enemy.position.x,y: enemy.position.y), damage: bulletdamage, size: CGSize(width:  50.0, height: 30.0))
                    self.addChild(bullet1)//Bullet表示
                    
                    bullet1.run(SKAction.sequence([move,remove]))
                    
                }
                
            }
            
            if enemy.type == "Boar" { //突進する。
                
                if phasenumber == 14 {
                    
                    if enemy.position.x > 10 {
                        
                        let fadeIn = SKAction.fadeIn(withDuration: 0.2)
                        let fadeOut = SKAction.fadeOut(withDuration: 0.2)
                        
                        let alert = self.makeAlert(position: CGPoint(x: enemy.position.x / 2 - 5,y: enemy.position.y), size: CGSize(width: enemy.position.x - 10, height: 100))
                        self.addChild(alert)
                        
                        alert.run(SKAction.sequence([fadeIn,fadeOut,fadeIn,fadeOut,fadeIn,fadeOut,fadeIn,fadeIn,fadeOut,remove]))
                        
                    }
                }
                
                if phasenumber == 30 {
                    
                    var bullet = Bullet()
                    
                    var bulletdamage = 100
                    if enemy.grade == 0 {
                        bulletdamage = 10
                    } else if enemy.grade == 1 {
                        bulletdamage = 400
                    } else if enemy.grade == 2 {
                        bulletdamage = 700
                    } else if enemy.grade == 3 {
                        bulletdamage = 1000
                    }
                    self.changeEnemyGrade(change: 1, id: enemy.id!)
                    
                    bullet = self.makeBullet(position: CGPoint(x: enemy.position.x,y: enemy.position.y), damage: bulletdamage, size: CGSize(width:  150.0, height: 150.0))
                    
                    bullet.name = "charge"
                    self.addChild(bullet)
                    
                    let move = SKAction.moveTo(x: -100, duration: 1.0)
                    
                    bullet.run(SKAction.sequence([move,remove]))
                    enemy.run(move)
                    
                }
            }
            
            if enemy.type == "Hull" {
                
                if phasenumber == 40 {//鬼を生成する。
                    if enemy.grade == 0 {} else { //gradeが0なら鬼を生成しない。
                        
                        let Oni = self.makeOni(position: CGPoint(x: 650,y: 130))
                        Oni.id = waveEnemyNumber
                        Oni.maxHp = 400//鬼の最大hpを調整する。
                        self.changeEnemyHp(change: 1000, id: Oni.id!)//鬼のhpを実際に調整する。
                        waveEnemyNumber = waveEnemyNumber + 1
                        EnemyArray.append(Oni)
                        
                        Oni.alpha = 0.0
                        self.addChild(Oni)
                        
                        let fadeIn = SKAction.fadeIn(withDuration: 0.5)
                        Oni.run(fadeIn)
                        
                    }
                    self.changeEnemyGrade(change: 1, id: enemy.id!)
                    
                }
                
            }
            
            if enemy.type == "Wall" {
                //攻撃しない。
            }
            
            if enemy.type == "Cannon" {
                //右前方に直線上に弾を発射する。
                
                if phasenumber == 54 {
                    
                    let fadeIn = SKAction.fadeIn(withDuration: 0.2)
                    let fadeOut = SKAction.fadeOut(withDuration: 0.2)
                    
                    let alert = self.makeAlert(position: CGPoint(x: enemy.position.x / 2 - 24,y: enemy.position.y), size: CGSize(width: enemy.position.x - 48, height: 30.0))
                    self.addChild(alert)
                    
                    alert.run(SKAction.sequence([fadeIn,fadeOut,fadeIn,fadeOut,fadeIn,fadeOut,fadeIn,fadeIn,fadeOut,remove]))
                    
                }
                
                if phasenumber == 70 {
                    
                    var bulletdamage = 200
                    
                    if enemy.grade == 0 {
                        bulletdamage = 10
                    } else if enemy.grade == 1 {
                        bulletdamage = 200
                    } else if enemy.grade == 2 {
                        bulletdamage = 400
                    } else if enemy.grade == 3 {
                        bulletdamage = 700
                    }
                    self.changeEnemyGrade(change: 1, id: enemy.id!)
                    
                    let move  = SKAction.move(to: CGPoint(x: 48,y: enemy.position.y), duration: 0.5)
                    
                    let bullet1 = self.makeeBullet(position: CGPoint(x: enemy.position.x,y: enemy.position.y), damage: bulletdamage, size: CGSize(width:  20.0, height: 20.0))
                    self.addChild(bullet1)//Bullet表示
                    
                    bullet1.run(SKAction.sequence([move,remove]))
                    
                }
                
            }
            
            if enemy.type == "Cannon2" {
                //左上に向けて弾を発射する。
                
                if phasenumber == 54 {
                    
                    let fadeIn = SKAction.fadeIn(withDuration: 0.2)
                    let fadeOut = SKAction.fadeOut(withDuration: 0.2)
                    
                    let alert = self.makeAlert(position: CGPoint(x: enemy.position.x + enemy.position.y / 2 - 172,y: 172), size: CGSize(width: ( 344 - enemy.position.y ) * 1.4 , height: 30.0))
                    alert.zRotation = CGFloat( 135  / 180.0 * Double.pi)
                    
                    self.addChild(alert)
                    
                    alert.run(SKAction.sequence([fadeIn,fadeOut,fadeIn,fadeOut,fadeIn,fadeOut,fadeIn,fadeIn,fadeOut,remove]))
                    
                }
                
                if phasenumber == 70 {
                    
                    var bulletdamage = 200
                    
                    if enemy.grade == 0 {
                        bulletdamage = 10
                    } else if enemy.grade == 1 {
                        bulletdamage = 200
                    } else if enemy.grade == 2 {
                        bulletdamage = 400
                    } else if enemy.grade == 3 {
                        bulletdamage = 700
                    }
                    self.changeEnemyGrade(change: 1, id: enemy.id!)
                    
                    let move  = SKAction.move(to: CGPoint(x: enemy.position.x + enemy.position.y - 344,y: 344), duration: 0.5)
                    
                    let bullet1 = self.makeeBullet(position: CGPoint(x: enemy.position.x,y: enemy.position.y), damage: bulletdamage, size: CGSize(width:  20.0, height: 20.0))
                    self.addChild(bullet1)//Bullet表示
                    
                    bullet1.run(SKAction.sequence([move,remove]))
                    
                }
                
            }
            
            if enemy.type == "Cannon3" {
                //左下に向けて弾を発射する。
                
                if phasenumber == 54 {
                    
                    let fadeIn = SKAction.fadeIn(withDuration: 0.2)
                    let fadeOut = SKAction.fadeOut(withDuration: 0.2)
                    
                    let alert = self.makeAlert(position: CGPoint(x: enemy.position.x - enemy.position.y / 2,y: 172), size: CGSize(width: ( enemy.position.y - 10) * 1.4, height: 30.0))
                    alert.zRotation = CGFloat( 45  / 180.0 * Double.pi)
                    self.addChild(alert)
                    
                    alert.run(SKAction.sequence([fadeIn,fadeOut,fadeIn,fadeOut,fadeIn,fadeOut,fadeIn,fadeIn,fadeOut,remove]))
                    
                }
                
                if phasenumber == 70 {
                    
                    var bulletdamage = 200
                    
                    if enemy.grade == 0 {
                        bulletdamage = 10
                    } else if enemy.grade == 1 {
                        bulletdamage = 200
                    } else if enemy.grade == 2 {
                        bulletdamage = 400
                    } else if enemy.grade == 3 {
                        bulletdamage = 700
                    }
                    self.changeEnemyGrade(change: 1, id: enemy.id!)
                    
                    let move  = SKAction.move(to: CGPoint(x: enemy.position.x - enemy.position.x,y: 0), duration: 0.5)
                    
                    let bullet1 = self.makeeBullet(position: CGPoint(x: enemy.position.x,y: enemy.position.y), damage: bulletdamage, size: CGSize(width:  20.0, height: 20.0))
                    self.addChild(bullet1)//Bullet表示
                    
                    bullet1.run(SKAction.sequence([move,remove]))
                    
                }
                
            }
            
            if enemy.type == "RedDragon" {
                
                if phasenumber == 5 {
                    
                    var enemys:[String] = []
                    for i in EnemyArray {
                        enemys.append(i.type!)
                    }
                    
                    if let i = enemys.firstIndex(of: "BlueDragon") {
                        print(i)
                    } else { //BlueDragonがいなかったら復活させる。
                        
                        let BlueDragon = self.makeBlueDragon(position: CGPoint(x: 400,y: 200))
                        BlueDragon.id = waveEnemyNumber
                        waveEnemyNumber = waveEnemyNumber + 1
                        EnemyArray.append(BlueDragon)
                        
                        BlueDragon.alpha = 0.0
                        self.addChild(BlueDragon)
                        
                        let fadeIn = SKAction.fadeIn(withDuration: 0.5)
                        BlueDragon.run(fadeIn)
                        
                    }
                }
                
                if phasenumber == 0 || phasenumber == 60 {
                    
                    let move1 = SKAction.move(to: CGPoint(x: 700 + 40,y: 200 - 105), duration: 0.5)
                    let move2 = SKAction.move(to: CGPoint(x: 700 + 70,y: 200 - 60), duration: 0.5)
                    let move3 = SKAction.move(to: CGPoint(x: 700 + 80,y: 200), duration: 0.5)
                    let move4 = SKAction.move(to: CGPoint(x: 700 + 70,y: 200 + 60), duration: 0.5)
                    let move5 = SKAction.move(to: CGPoint(x: 700 + 40,y: 200 + 105), duration: 0.5)
                    let move6 = SKAction.move(to: CGPoint(x: 700,y: 200 + 120), duration: 0.5)
                    let move7 = SKAction.move(to: CGPoint(x: 700 - 40,y: 200 + 105), duration: 0.5)
                    let move8 = SKAction.move(to: CGPoint(x: 700 - 70,y: 200 + 60), duration: 0.5)
                    let move9 = SKAction.move(to: CGPoint(x: 700 - 80,y: 200), duration: 0.5)
                    let move10 = SKAction.move(to: CGPoint(x: 700 - 70,y: 200 - 60), duration: 0.5)
                    let move11 = SKAction.move(to: CGPoint(x: 700 - 40,y: 200 - 105), duration: 0.5)
                    let move12 = SKAction.move(to: CGPoint(x: 700,y: 200 - 120), duration: 0.5)
                    
                    enemy.run(SKAction.sequence([move1,move2,move3,move4,move5,move6,move7,move8,move9,move10,move11,move12]))
                    
                }
                
            }
            
            if enemy.type == "BlueDragon" {
                
                if phasenumber == 5 {
                    
                    var enemys:[String] = []
                    for i in EnemyArray {
                        enemys.append(i.type!)
                    }
                    
                    if let i = enemys.firstIndex(of: "RedDragon") {
                        print(i)
                    } else { //RedDragonがいなかったら復活させる。
                        
                        let RedDragon = self.makeRedDragon(position: CGPoint(x: 650,y: 50))
                        RedDragon.id = waveEnemyNumber
                        waveEnemyNumber = waveEnemyNumber + 1
                        EnemyArray.append(RedDragon)
                        
                        RedDragon.alpha = 0.0
                        self.addChild(RedDragon)
                        
                        let fadeIn = SKAction.fadeIn(withDuration: 0.5)
                        RedDragon.run(fadeIn)
                        
                    }
                }
                
                if phasenumber == 0 || phasenumber == 60 {
                    
                    let move1 = SKAction.move(to: CGPoint(x: 700 + 40,y: 200 - 105), duration: 0.5)
                    let move2 = SKAction.move(to: CGPoint(x: 700 + 70,y: 200 - 60), duration: 0.5)
                    let move3 = SKAction.move(to: CGPoint(x: 700 + 80,y: 200), duration: 0.5)
                    let move4 = SKAction.move(to: CGPoint(x: 700 + 70,y: 200 + 60), duration: 0.5)
                    let move5 = SKAction.move(to: CGPoint(x: 700 + 40,y: 200 + 105), duration: 0.5)
                    let move6 = SKAction.move(to: CGPoint(x: 700,y: 200 + 120), duration: 0.5)
                    let move7 = SKAction.move(to: CGPoint(x: 700 - 40,y: 200 + 105), duration: 0.5)
                    let move8 = SKAction.move(to: CGPoint(x: 700 - 70,y: 200 + 60), duration: 0.5)
                    let move9 = SKAction.move(to: CGPoint(x: 700 - 80,y: 200), duration: 0.5)
                    let move10 = SKAction.move(to: CGPoint(x: 700 - 70,y: 200 - 60), duration: 0.5)
                    let move11 = SKAction.move(to: CGPoint(x: 700 - 40,y: 200 - 105), duration: 0.5)
                    let move12 = SKAction.move(to: CGPoint(x: 700,y: 200 - 120), duration: 0.5)
                    
                    enemy.run(SKAction.sequence([move7,move8,move9,move10,move11,move12,move1,move2,move3,move4,move5,move6]))
                    
                }
                
                
            }
            
            if enemy.type == "Queen" {
                //攻撃しない
            }
            
        }
        
    }
    
    func StopAction(actionNumber: Int) {
        
        if actionNumber == 0 {
            
            var bullet1 = Bullet()
            
            if ally1.grade! == 0 {
                print("ally1Skill4G0")
                bullet1 = self.makeBullet(position: CGPoint(x: 200,y: 1000), damage: 50, size: CGSize(width:  100.0, height: 100.0))

            } else if ally1.grade! == 1 {
                print("ally1Skill4")
                bullet1 = self.makeBullet(position: CGPoint(x: 200,y: 1000), damage: 300, size: CGSize(width:  100.0, height: 100.0))

            } else if ally1.grade! == 2 {
                print("ally1Skill4G2")
                bullet1 = self.makeBullet(position: CGPoint(x: 200,y: 1000), damage: 800, size: CGSize(width:  100.0, height: 100.0))

            } else if ally1.grade! == 3 {
                print("ally1Skill4G3")
                bullet1 = self.makeBullet(position: CGPoint(x: 200,y: 1000), damage: 2000, size: CGSize(width:  100.0, height: 100.0))
            }

            ally1.grade! = 1
            ally1GradeLabel.text = "\(ally1.grade!)"
            
            bullet1.physicsBody?.collisionBitMask = PhysicsCategory.Enemy //壁をすり抜けるように調整。
            
            self.addChild(bullet1)//Bullet表示
            
            let wait = SKAction.wait(forDuration: 5.0)
            let action = SKAction.move(to: aimPosition, duration: 1.0)//アクション作成(移動方向:Y,移動時間:1.0秒)
            let actionDone = SKAction.removeFromParent()
            bullet1.run(SKAction.sequence([wait,action,actionDone]))

            stopActionFlag = false
            
            self.MainTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.mainTimerupdate), userInfo: nil, repeats: true)
            
        }
        
    }
    
    func makeBullet(position:CGPoint,damage:Int,size:CGSize) -> Bullet {
        
        let bullet = Bullet(color: UIColor.black, size: size)
        bullet.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Back"), size: bullet.size)
        bullet.position = position
        bullet.name  = "bullet"
        bullet.damage = damage
        bullet.physicsBody?.categoryBitMask = PhysicsCategory.Bullet
        bullet.physicsBody?.collisionBitMask = PhysicsCategory.Enemy | PhysicsCategory.Wall
        bullet.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy | PhysicsCategory.Wall
        
        return bullet
        
    }
    
    
    func makeeBullet(position:CGPoint,damage:Int,size:CGSize) -> Bullet {
        
        let bullet = Bullet(color: UIColor.black, size: size)
        bullet.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Back"), size: bullet.size)
        bullet.position = position
        bullet.name  = "bullet"
        bullet.damage = damage
        bullet.physicsBody?.categoryBitMask = PhysicsCategory.eBullet
        bullet.physicsBody?.collisionBitMask = PhysicsCategory.Ally | PhysicsCategory.Wall
        bullet.physicsBody?.contactTestBitMask = PhysicsCategory.Ally | PhysicsCategory.Wall
        
        return bullet
        
    }
    
    func makeAlert(position:CGPoint,size:CGSize) -> SKSpriteNode {
        
        let alert = SKSpriteNode(color: UIColor.red, size: size)
        alert.position = position
        alert.name  = "alert"
        alert.physicsBody?.categoryBitMask = 0b00000000
        alert.physicsBody?.collisionBitMask = 0b00000000
        alert.physicsBody?.contactTestBitMask = 0b00000000
        alert.alpha = 0.0
        
        return alert
        
    }
    
    func makeWall(position:CGPoint,size:CGSize) -> SKSpriteNode {
        
        let Wall = SKSpriteNode(color: UIColor.black, size: size)
        
        Wall.name = "Wall"
        Wall.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Back"), size: Wall.size)
        Wall.physicsBody?.restitution = 1.0 //反発値
        Wall.physicsBody?.isDynamic = false //ぶつかったときに移動するかどうか =>しない
        Wall.physicsBody?.categoryBitMask = PhysicsCategory.Wall
        Wall.physicsBody?.collisionBitMask = PhysicsCategory.Ally | PhysicsCategory.Enemy | PhysicsCategory.Bullet | PhysicsCategory.eBullet | PhysicsCategory.Item
        Wall.physicsBody?.contactTestBitMask = PhysicsCategory.Ally | PhysicsCategory.Enemy | PhysicsCategory.Bullet | PhysicsCategory.eBullet | PhysicsCategory.Item
        Wall.physicsBody?.allowsRotation = false
        Wall.position = position
        
        return Wall
        
    }
    
    //////////////////////////味方系メソッド集/////////////////////////////////
    
    func makeAlly1(position:CGPoint) {
        
        ally1.name = "Ally1"
        ally1.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "monster1a"), size: ally1.size)
        //ally1.physicsBody?.isDynamic = false
        ally1.physicsBody?.allowsRotation = false
        ally1.physicsBody?.restitution = 1.0//反発値
        ally1.position = position//CGPoint(x: 100,y: 75)
        ally1.zPosition = 1 //movermarkerより上に来るようにz=1
        ally1.physicsBody?.categoryBitMask = PhysicsCategory.Ally
        ally1.physicsBody?.collisionBitMask = PhysicsCategory.eBullet | PhysicsCategory.Item | PhysicsCategory.Wall | PhysicsCategory.Ally
            | PhysicsCategory.Enemy
        ally1.physicsBody?.contactTestBitMask = PhysicsCategory.eBullet | PhysicsCategory.Item | PhysicsCategory.Wall | PhysicsCategory.Ally
        | PhysicsCategory.Enemy
        ally1.xScale = 0.7
        ally1.yScale = 0.7
        ally1.id = 1
        ally1.grade = 1
        ally1.hp = 250
        ally1.maxHp = 250
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
        ally1Skill1.position = CGPoint(x: 15,y: 15)
        ally1.addChild(ally1Skill1)
        
        //右下
        ally1Skill2.anchorPoint = CGPoint(x: 0, y: 0)
        ally1Skill2.xScale = 2 / 3
        ally1Skill2.yScale = 2 / 3
        ally1Skill2.name = "ally1Skill2"
        ally1Skill2.alpha = 0.0
        ally1Skill2.zPosition = 2
        ally1Skill2.position = CGPoint(x: 15,y: -115)
        ally1.addChild(ally1Skill2)
        
        //左上
        ally1Skill3.anchorPoint = CGPoint(x: 0, y: 0)
        ally1Skill3.xScale = 2 / 3
        ally1Skill3.yScale = 2 / 3
        ally1Skill3.name = "ally1Skill3"
        ally1Skill3.alpha = 0.0
        ally1Skill3.position = CGPoint(x: -115,y: 15)
        ally1Skill3.zPosition = 2
        ally1.addChild(ally1Skill3)
        
        //左下
        ally1Skill4.anchorPoint = CGPoint(x: 0, y: 0)
        ally1Skill4.xScale = 2 / 3
        ally1Skill4.yScale = 2 / 3
        ally1Skill4.name = "ally1Skill4"
        ally1Skill4.alpha = 0.0
        ally1Skill4.position = CGPoint(x: -115,y: -115)
        ally1Skill4.zPosition = 2
        ally1.addChild(ally1Skill4)
        
        //右
        ally1Skill5.anchorPoint = CGPoint(x: 0, y: 0)
        ally1Skill5.name = "ally1Skill5"
        ally1Skill5.alpha = 0.0
        ally1Skill5.zPosition = 2
        ally1.addChild(ally1Skill5)
        
    }
    
    func makeAlly2(position:CGPoint) {
        
        ally2.name = "Ally2"
        ally2.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "monster2a"), size: ally2.size)
        //ally2.physicsBody?.isDynamic = false
        ally2.physicsBody?.allowsRotation = false
        ally2.physicsBody?.restitution = 1.0//反発値
        ally2.position = position//CGPoint(x: 100,y: 225)
        ally2.zPosition = 1 //movermarkerより上に来るようにz=1
        ally2.physicsBody?.categoryBitMask = PhysicsCategory.Ally
        ally2.physicsBody?.collisionBitMask = PhysicsCategory.eBullet | PhysicsCategory.Item | PhysicsCategory.Wall | PhysicsCategory.Ally
        | PhysicsCategory.Enemy
        ally2.physicsBody?.contactTestBitMask = PhysicsCategory.eBullet | PhysicsCategory.Item | PhysicsCategory.Wall | PhysicsCategory.Ally
        | PhysicsCategory.Enemy
        ally2.xScale = 0.7
        ally2.yScale = 0.7
        ally2.id = 2
        ally2.grade = 1
        ally2.hp = 500
        ally2.maxHp = 500
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
        ally2Skill1.position = CGPoint(x: 15,y: 15)
        ally2.addChild(ally2Skill1)
        
        //右下
        ally2Skill2.anchorPoint = CGPoint(x: 0, y: 0)
        ally2Skill2.xScale = 2 / 3
        ally2Skill2.yScale = 2 / 3
        ally2Skill2.name = "ally2Skill2"
        ally2Skill2.alpha = 0.0
        ally2Skill2.zPosition = 2
        ally2Skill2.position = CGPoint(x: 15,y: -115 )
        ally2.addChild(ally2Skill2)
        
        //左上
        ally2Skill3.anchorPoint = CGPoint(x: 0, y: 0)
        ally2Skill3.xScale = 2 / 3
        ally2Skill3.yScale = 2 / 3
        ally2Skill3.name = "ally2Skill3"
        ally2Skill3.alpha = 0.0
        ally2Skill3.zPosition = 2
        ally2Skill3.position = CGPoint(x: -115,y: 15)
        ally2.addChild(ally2Skill3)
        
        //左下
        ally2Skill4.anchorPoint = CGPoint(x: 0, y: 0)
        ally2Skill4.xScale = 2 / 3
        ally2Skill4.yScale = 2 / 3
        ally2Skill4.name = "ally2Skill4"
        ally2Skill4.alpha = 0.0
        ally2Skill4.zPosition = 2
        ally2Skill4.position = CGPoint(x: -115,y: -115)
        ally2.addChild(ally2Skill4)
        
        //右
        ally2Skill5.anchorPoint = CGPoint(x: 0, y: 0)
        ally2Skill5.name = "ally2Skill5"
        ally2Skill5.alpha = 0.0
        ally2Skill5.zPosition = 2
        ally2.addChild(ally2Skill5)
        
        
    }
    
    func makeAlly3(position: CGPoint) {
        
        ally3.name = "Ally3"
        ally3.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "monster3a"), size: ally3.size)
        //ally3.physicsBody?.isDynamic = false
        ally3.physicsBody?.allowsRotation = false
        ally3.physicsBody?.restitution = 1.0//反発値
        ally3.position = position //CGPoint(x: 150,y: 150)
        ally3.zPosition = 1 //movermarkerより上に来るようにz=1
        ally3.physicsBody?.categoryBitMask = PhysicsCategory.Ally
        ally3.physicsBody?.collisionBitMask = PhysicsCategory.eBullet | PhysicsCategory.Item | PhysicsCategory.Wall | PhysicsCategory.Ally
        | PhysicsCategory.Enemy
        ally3.physicsBody?.contactTestBitMask = PhysicsCategory.eBullet | PhysicsCategory.Item | PhysicsCategory.Wall | PhysicsCategory.Ally
        | PhysicsCategory.Enemy
        ally3.xScale = 0.7
        ally3.yScale = 0.7
        ally3.id = 3
        ally3.grade = 1
        ally3.hp = 1000
        ally3.maxHp = 1000
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
        ally3Skill1.position = CGPoint(x: 15,y: 15)
        ally3.addChild(ally3Skill1)
        
        //右下
        ally3Skill2.anchorPoint = CGPoint(x: 0, y: 0)
        ally3Skill2.xScale = 2 / 3
        ally3Skill2.yScale = 2 / 3
        ally3Skill2.name = "ally3Skill2"
        ally3Skill2.alpha = 0.0
        ally3Skill2.zPosition = 2
        ally3Skill2.position = CGPoint(x: 15,y: -115)
        ally3.addChild(ally3Skill2)
        
        //左上
        ally3Skill3.anchorPoint = CGPoint(x: 0, y: 0)
        ally3Skill3.xScale = 2 / 3
        ally3Skill3.yScale = 2 / 3
        ally3Skill3.name = "ally3Skill3"
        ally3Skill3.alpha = 0.0
        ally3Skill3.zPosition = 2
        ally3Skill3.position = CGPoint(x: -115,y: 15)
        ally3.addChild(ally3Skill3)
        
        //左下
        ally3Skill4.anchorPoint = CGPoint(x: 0, y: 0)
        ally3Skill4.xScale = 2 / 3
        ally3Skill4.yScale = 2 / 3
        ally3Skill4.name = "ally3Skill4"
        ally3Skill4.alpha = 0.0
        ally3Skill4.zPosition = 2
        ally3Skill4.position = CGPoint(x: -115,y: -115)
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
        LeftWall.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Back"), size: LeftWall.size)
        LeftWall.physicsBody?.restitution = 1.0 //反発値
        LeftWall.physicsBody?.isDynamic = false //ぶつかったときに移動するかどうか =>しない
        LeftWall.physicsBody?.categoryBitMask = PhysicsCategory.Wall
        LeftWall.physicsBody?.collisionBitMask = PhysicsCategory.Ally | PhysicsCategory.Enemy | PhysicsCategory.Bullet | PhysicsCategory.eBullet | PhysicsCategory.Item
        LeftWall.physicsBody?.contactTestBitMask = PhysicsCategory.Ally | PhysicsCategory.Enemy | PhysicsCategory.Bullet | PhysicsCategory.eBullet | PhysicsCategory.Item
        LeftWall.physicsBody?.allowsRotation = false
        LeftWall.position = CGPoint(x: 24,y: 177)
        self.addChild(LeftWall)
        
        RightWall.name = "WallRight"
        RightWall.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Back"), size: RightWall.size)
        RightWall.physicsBody?.restitution = 1.0 //反発値
        RightWall.physicsBody?.isDynamic = false//ぶつかったときに移動するかどうか =>しない
        RightWall.physicsBody?.categoryBitMask = PhysicsCategory.Wall
        RightWall.physicsBody?.collisionBitMask = PhysicsCategory.Ally | PhysicsCategory.Enemy | PhysicsCategory.Bullet | PhysicsCategory.eBullet | PhysicsCategory.Item
        RightWall.physicsBody?.contactTestBitMask = PhysicsCategory.Ally | PhysicsCategory.Enemy | PhysicsCategory.Bullet | PhysicsCategory.eBullet | PhysicsCategory.Item
        RightWall.physicsBody?.allowsRotation = false
        RightWall.position = CGPoint(x: 872,y: 177)
        self.addChild(RightWall)
        
        UpperWall.name = "UpperWall"
        UpperWall.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Back"), size: UpperWall.size)
        UpperWall.physicsBody?.restitution = 1.0 //反発値
        UpperWall.physicsBody?.isDynamic = false//ぶつかったときに移動するかどうか =>しない
        UpperWall.physicsBody?.categoryBitMask = PhysicsCategory.Wall
        UpperWall.physicsBody?.collisionBitMask = PhysicsCategory.Ally | PhysicsCategory.Enemy | PhysicsCategory.Bullet | PhysicsCategory.eBullet | PhysicsCategory.Item
        UpperWall.physicsBody?.contactTestBitMask = PhysicsCategory.Ally | PhysicsCategory.Enemy | PhysicsCategory.Bullet | PhysicsCategory.eBullet | PhysicsCategory.Item
        UpperWall.physicsBody?.allowsRotation = false
        UpperWall.position = CGPoint(x: 448,y: 349)
        self.addChild(UpperWall)
        
        LowerWall.name = "LowerWall"
        LowerWall.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Back"), size: LowerWall.size)
        LowerWall.physicsBody?.restitution = 1.0 //反発値
        LowerWall.physicsBody?.isDynamic = false//ぶつかったときに移動するかどうか =>しない
        LowerWall.physicsBody?.categoryBitMask = PhysicsCategory.Wall
        LowerWall.physicsBody?.collisionBitMask = PhysicsCategory.Ally | PhysicsCategory.Enemy | PhysicsCategory.Bullet | PhysicsCategory.eBullet | PhysicsCategory.Item
        LowerWall.physicsBody?.contactTestBitMask = PhysicsCategory.Ally | PhysicsCategory.Enemy | PhysicsCategory.Bullet | PhysicsCategory.eBullet | PhysicsCategory.Item
        LowerWall.physicsBody?.allowsRotation = false
        LowerWall.position = CGPoint(x: 448,y: 5)
        self.addChild(LowerWall)
        
        Background.anchorPoint = CGPoint(x:0,y:0)
        Background.position = CGPoint(x: -390,y: 10)
        Background.zPosition = -2
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
            return false
        }
        
        return true
        
    }

    func DegreeToRadian(Degree : Double!)-> CGFloat{//度数からラジアンに変換するメソッド


        return CGFloat(Degree) / CGFloat(180.0 * M_1_PI)

    }
    
}
