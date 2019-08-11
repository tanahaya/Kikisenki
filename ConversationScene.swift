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
    
    
    var gameTableView = GameRoomTableView()
    
    var skipButton = SKSpriteNode(color: UIColor.red, size: CGSize(width: 50.0, height: 30.0))//エナジーの量を表示
    
    var Background = SKSpriteNode(imageNamed: "Background")//キャラクターの背景
    
    
    override func didMove(to view: SKView) {
        
        self.size = CGSize(width: 414, height: 896)//414x896が最適。これはiphoneXRの画面サイズ。これがないと画面が(1,1)のサイズになります。
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        self.physicsWorld.contactDelegate = self //didBeginCOntactに必要
        
        self.backgroundColor = UIColor.white
        
        
        // Table setup
        gameTableView.register (UINib(nibName: "SpeechTableviewCell", bundle: nil),forCellReuseIdentifier:"speechCell")
        gameTableView.frame=CGRect(x: 0,y: 448,width: 414,height: 448)
        gameTableView.name = "tableview"
        self.scene?.view?.addSubview(gameTableView)
        gameTableView.reloadData()
        
        //背景。今は茶色
        Background.size = CGSize(width: 414, height: 448)
        Background.anchorPoint = CGPoint(x: 0,y: 0)//ノードの位置配置などの起点を設定。
        Background.position = CGPoint(x: 0,y: 448)
        Background.name = "Background"
        Background.physicsBody?.categoryBitMask = 0
        Background.physicsBody?.contactTestBitMask = 0
        Background.physicsBody?.collisionBitMask = 0
        self.addChild(Background)
        
        
        skipButton.name = "skipButton"
        skipButton.position = CGPoint(x: 350,y: 800)
        skipButton.physicsBody?.categoryBitMask = 0
        skipButton.physicsBody?.contactTestBitMask = 0
        skipButton.physicsBody?.collisionBitMask = 0
        self.addChild(skipButton)
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first as UITouch? {
                    
            let location = touch.location(in: self)
            print(self.atPoint(location))
            
            
            if self.atPoint(location).name == "skipButton" {
                
                print("skip")
                
                //移動用コード。gametableviewを隠す必要あり。
                gameTableView.isHidden =  true
                
                let selectScene = SelectScene()
                selectScene.size = self.size
                let transition = SKTransition.crossFade(withDuration: 1.0)
                
                self.view?.presentScene(selectScene, transition: transition)
                
            }
            
        }

    }
    
}

class GameRoomTableView: UITableView,UITableViewDelegate,UITableViewDataSource {
    
    var items: [String] = ["Player1"]
    var additionalitems: [String] =  ["Player2","Player3","Player4", "Player5", "Player6"]
    var itemnumber:Int = 0
    var name:String = "tableview"
    
    override init(frame: CGRect, style: UITableView.Style) {
        
        super.init(frame: frame, style: style)
        self.delegate = self
        self.dataSource = self
        
        self.estimatedRowHeight = 160
        self.rowHeight = UITableView.automaticDimension
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {//sectionの数を返す。
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {//cellの数を返す。
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {//cellの内容を返す
        let cell:SpeechTableviewCell = tableView.dequeueReusableCell(withIdentifier: "speechCell")! as! SpeechTableviewCell
        cell.nameLabel.text = "名前"
        cell.speechLabel.text = "セリフ"
        cell.selectionStyle = UITableViewCell.SelectionStyle.none//選択不可にするためのコード。
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {//tapしたときの内容(selection)
        return "Section \(section)"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {//tapしたときの内容(cell)
        
        print("You selected cell #\(indexPath.row)!")
        
        if itemnumber >= additionalitems.count {
            
        }else {
            items.insert(additionalitems[itemnumber], at: 0)//順番を指定してarrayに追加する。
            itemnumber = itemnumber + 1
            self.reloadData()//こんな感じでデータの追加が可能です。
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        tableView.estimatedRowHeight = 160 //セルの高さ
        return 160
        
    }
    
}
