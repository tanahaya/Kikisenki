//
//  serif.swift
//  Kikisenki
//
//  Created by 田中 颯 on 2019/09/13.
//  Copyright © 2019 tanahaya. All rights reserved.
//

import Foundation
import RealmSwift

class Serif: Object{
    
    @objc dynamic var story_id:Int = 0
    @objc dynamic var name: String? = ""
    @objc dynamic var person_id: Int = 0
    
    @objc dynamic var position: String? = ""
    
    @objc dynamic var serif: String? = ""
    
}
