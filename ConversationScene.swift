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
    
    let nameArray:[String] = ["フランソワ","2","3","ゴリラゴリあ"]
    
    let serifArray:[String] = ["フランソワ","2","3","ゴリラゴリあ"]
    
    
    
    override func didMove(to view: SKView) {
        
        var list:[String] = []//一度入れる。
        
        let path = Bundle.main.path(forResource: "story1", ofType: "csv")
        
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
                print("【id】\(detail[0])　【名前】\(detail[1])　【説明】\(detail[2])")
                
            }
            
        }
        
        
        
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
        nameLabel.text = nameArray[0]
        //print(nameArray[0].utf16.count)=>文字数を数える。
        self.addChild(nameLabel)//シーンに追加
        
        
        serifLabel.fontSize = 27 // フォントサイズを設定.
        serifLabel.fontColor = UIColor.black// 色を指定(青).
        serifLabel.text = "セリフあああああああああ"
        serifLabel.horizontalAlignmentMode = .left
        
        if serifLabel.numberOfLines == 1 {
            serifLabel.position = CGPoint(x: 80, y: 120)// 表示するポジションを指定.今回は中央
        } else if serifLabel.numberOfLines == 2 {
            serifLabel.position = CGPoint(x: 80, y: 70)// 表示するポジションを指定.今回は中央
        }
        self.addChild(serifLabel)//シーンに追加
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
}
