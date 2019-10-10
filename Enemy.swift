//
//  Enemy.swift
//  Kikisenki
//
//  Created by 田中 颯 on 2019/09/01.
//  Copyright © 2019 tanahaya. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class Enemy : SKSpriteNode {
    
    var id: Int?
    var hp:Int?//現在のhpを保存する
    var maxHp:Int?//maxhpを設定する。
    var grade:Int?//現在のgradeを保存する。
    var moveEnable:Bool = true//移動できるかどうか判定する。
    var type: String?//敵の種類を把握する。
    var defence: Int?
    
    func test() -> String {
        return "Hello"
    }
    
    
    
}
