//
//  ConversationScene.swift
//  Kikisenki
//
//  Created by 田中 颯 on 2019/08/08.
//  Copyright © 2019 tanahaya. All rights reserved.
//

import UIKit
import SpriteKit

class ConversationScene : SKScene, SKPhysicsContactDelegate{
    
    var background = SKSpriteNode()
    
    let nameLabel = SKLabelNode()
    let serifLabel = SKLabelNode()//文字を表示する。
    let serifLabel2 = SKLabelNode()
    
    var serifArray:[String] = []
    
    var pageNumber:Int = 0
    
    var maxPageNumber = 0
    
    let userDefaults = UserDefaults.standard//管理用のuserdefaults
    
    override func didMove(to view: SKView) {
        
        var list:[String] = []//一度入れる。
        
        let world:Int = userDefaults.integer(forKey: "world")
        let story:Int = userDefaults.integer(forKey: "story")
        
        var path = Bundle.main.path(forResource: "story1", ofType: "csv")
        
        if world == 1 {
            
            if story == 1 {
                path = Bundle.main.path(forResource: "story1", ofType: "csv")
            } else if story == 2 {
                path = Bundle.main.path(forResource: "story2", ofType: "csv")
            }
            
        } else if world == 2 {
            
        } else if world == 3 {
                   
        } else if world == 4 {
                   
        } else if world == 5 {
                   
        } else if world == 6 {
                   
        } else if world == 7 {
                   
        } else if world == 8 {
                   
        } else if world == 9 {
                   
        } else if world == 10 {
                   
        } else if world == 11 {
                   
        } else if world == 12 {
                   
        }
        
        do {
            let text = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
            
            let lineChange = text.replacingOccurrences(of: "\r", with: "\n")
            //"\n"の改行コードで区切って、配列csvArrayに格納する
            
            list = lineChange.components(separatedBy: "\n")
            
        } catch let error as NSError {
            print("エラー: \(error)")
            return
        }
        
        for data in list {
            if data == "" {//行がない時を省く
                
            } else {
                
                let detail = data.components(separatedBy: ",")
                
                print("【id】\(detail[0]) 【名前】\(detail[1]) 【位置】\(detail[2]) 【左画像】\(detail[3])【右画像】\(detail[4])【セリフ】\(detail[5])")
                
                serifArray.append(data)
                
            }
            
        }
        
        maxPageNumber = serifArray.count//最大ページ数を追加。
        
        //起動した時の処理
        self.size = CGSize(width: 896, height: 414)//896x414が最適。これはiphoneXRの画面サイズを横にしたもの。
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        self.physicsWorld.contactDelegate = self //didBeginCOntactに必要
        
        self.backgroundColor = UIColor.white
        
        background = SKSpriteNode(imageNamed: "serifback1")
        background.name = "background"
        background.position = CGPoint(x: 448, y: 121)//234,448
        self.addChild(background)
        
        
        nameLabel.fontSize = 40 // フォントサイズを設定.
        nameLabel.fontColor = UIColor.black// 色を指定(青)
        nameLabel.horizontalAlignmentMode = .left
        nameLabel.position = CGPoint(x: 100, y: 170) // 表示するポジションを指定.今回は中央
        //print(nameArray[0].utf16.count)=>文字数を数える。
        self.addChild(nameLabel)//シーンに追加
        
        
        serifLabel.fontSize = 24 // フォントサイズを設定.
        serifLabel.fontColor = UIColor.black// 色を指定(青).
        serifLabel.horizontalAlignmentMode = .left
        serifLabel.position = CGPoint(x: 80, y: 120)// 表示するポジションを指定.今回は中央
        self.addChild(serifLabel)//シーンに追加
        
        serifLabel2.fontSize = 24 // フォントサイズを設定.
        serifLabel2.fontColor = UIColor.black// 色を指定(青).
        serifLabel2.horizontalAlignmentMode = .left
        serifLabel2.position = CGPoint(x: 80, y: 80)// 表示するポジションを指定.今回は中央
        self.addChild(serifLabel2)//シーンに追加
        
        self.text(page: pageNumber)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        pageNumber = pageNumber + 1
        
        if pageNumber == maxPageNumber {//これ以上表示するものがない時。
            
            self.gotoSelectScene()
            
        } else {
            
            self.text(page: pageNumber)
            
        }
        
    }
    
    func text(page:Int) {
        
        let detail = serifArray[page].components(separatedBy: ",")
        
        nameLabel.text = "\(detail[1])"
        
        if detail.count ==  6 {
            serifLabel.text = "\(detail[5])"
            serifLabel2.text = ""
        } else if detail.count == 7 {
            serifLabel.text = "\(detail[5])"
            serifLabel2.text = "\(detail[6])"
        }
        
    }
    
    func gotoSelectScene() {
        
        let Scene = SelectScene()
        Scene.size = self.size
        let transition = SKTransition.crossFade(withDuration: 1.0)
        
        self.view?.presentScene(Scene, transition: transition)
        
    }
    
}
