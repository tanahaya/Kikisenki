//
//  ConversationScene.swift
//  Kikisenki
//
//  Created by 田中 颯 on 2019/08/08.
//  Copyright © 2019 tanahaya. All rights reserved.
//

import UIKit
import SpriteKit
import RealmSwift

class ConversationScene : SKScene, SKPhysicsContactDelegate{
    
    var background = SKSpriteNode()
    
    let nameLabel = SKLabelNode()
    let serifLabel = SKLabelNode()//文字を表示する。
    
    let nameArray:[String] = ["フランソワ","2","3","ゴリラゴリあ"]
    
    let serifArray:[String] = ["フランソワ","2","3","ゴリラゴリあ"]
    
    // 作成したTodoModel型の変数を用意。<Serif>という書き方はいわゆるジェネリック
    //Realmから受け取るデータを突っ込む変数を準備
    var serifList: Results<Serif>!
    
    override func didMove(to view: SKView) {
        
        //起動した時の処理
        self.size = CGSize(width: 896, height: 414)//896x414が最適。これはiphoneXRの画面サイズを横にしたもの。
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        self.physicsWorld.contactDelegate = self //didBeginCOntactに必要
        
        self.backgroundColor = UIColor.white
        
        background = SKSpriteNode(imageNamed: "serifback1")
        background.name = "background"
        background.position = CGPoint(x: 448, y: 121)//234,448
        self.addChild(background)
        
        // スキーマバージョンを上げる。デフォルトのスキーマバージョンは0。serifclassを更新する時に必要
        let config = Realm.Configuration(schemaVersion: 1)
        Realm.Configuration.defaultConfiguration = config
        
        // Realmのインスタンスを取得
        let RealmInstance = try! Realm()
        // Realmのfunctionでデータを取得。functionを更に追加することで、フィルターもかけられる
        // Realmデータベースに登録されているデータを全て取得
        // try!はエラーが発生しなかった場合は通常の値が返されるが、エラーの場合はクラッシュ
        self.serifList = RealmInstance.objects(Serif.self)
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        
        nameLabel.fontSize = 40 // フォントサイズを設定.
        nameLabel.fontColor = UIColor.black// 色を指定(青)
        nameLabel.horizontalAlignmentMode = .left
        nameLabel.position = CGPoint(x: 100, y: 170) // 表示するポジションを指定.今回は中央
        nameLabel.text = nameArray[0]
        print(nameArray[0].utf16.count)
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
