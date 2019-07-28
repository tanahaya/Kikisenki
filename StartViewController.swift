//
//  StartViewController.swift
//  Kikisenki
//
//  Created by 田中 颯 on 2019/07/28.
//  Copyright © 2019 tanahaya. All rights reserved.
//

import Foundation
import UIKit


class StartViewController: UIViewController {
    
    var StartButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Buttonを生成する.
        StartButton = UIButton()
        
        StartButton.frame = CGRect(x: self.view.frame.width/2 - 100, y: self.view.frame.height/2 - 25, width: 200, height: 50)
        // ボタンの設置座標とサイズを設定する.
        StartButton.backgroundColor = UIColor.red        // ボタンの背景色を設定.
        StartButton.layer.masksToBounds = true      // ボタンの枠を丸くする.
        StartButton.layer.cornerRadius = 20.0       // コーナーの半径を設定する.
        StartButton.setTitle("Start", for: .normal)            // タイトルを設定する(通常時).
        StartButton.setTitleColor(UIColor.white, for: .normal)
        StartButton.setTitle("ボタン(押された時)", for: .highlighted)
        StartButton.setTitleColor(UIColor.black, for: .highlighted)
        StartButton.addTarget(self, action: #selector(self.onClickStartButton(sender:)), for: .touchUpInside) // イベントを追加する
        
        self.view.addSubview(StartButton) // ボタンをViewに追加.
        
    }
    
    @objc internal func onClickStartButton(sender: UIButton) {//スタートボタンを押した時の処理
        
        //遷移の処理を書く。
        
        print("hello")
        
    }
    
    
    
    
}
