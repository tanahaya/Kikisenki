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
    private var label : SKLabelNode?
    
    
    override func didMove(to view: SKView) {
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        // Table setup
        gameTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        gameTableView.frame=CGRect(x:20,y:50,width:280,height:200)
        self.scene?.view?.addSubview(gameTableView)
        gameTableView.reloadData()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first as UITouch? {
                    
            let location = touch.location(in: self)
            print(location)
        }
        
        let Scene = HomeScene()
        Scene.size = self.size
        let transition = SKTransition.crossFade(withDuration: 1.0)
        
        self.view?.presentScene(Scene, transition: transition)
        
    }
    
}

class GameRoomTableView: UITableView,UITableViewDelegate,UITableViewDataSource {
    
    var items: [String] = ["Player1", "Player2", "Player3"]
    
    override init(frame: CGRect, style: UITableView.Style) {
        
        super.init(frame: frame, style: style)
        self.delegate = self
        self.dataSource = self
        
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
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        cell.textLabel?.text = self.items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {//tapしたときの内容(selection)
        return "Section \(section)"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {//tapしたときの内容(cell)
        print("You selected cell #\(indexPath.row)!")
    }
    
}
