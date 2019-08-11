//
//  SpeechTableviewCell.swift
//  Kikisenki
//
//  Created by 田中 颯 on 2019/08/10.
//  Copyright © 2019 tanahaya. All rights reserved.
//

import UIKit

class SpeechTableviewCell: UITableViewCell {
    
    var nameLabel:UILabel = UILabel(frame: CGRect(x: 10, y: 10, width: 100, height: 30))
    var speechLabel:UILabel = UILabel(frame: CGRect(x: 10, y: 45, width: 380, height: 100))

    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLabel.backgroundColor = UIColor.blue
        nameLabel.textColor = UIColor.black
        nameLabel.text = "名前"
        self.addSubview(nameLabel)
        
        speechLabel.backgroundColor = UIColor.orange
        speechLabel.textColor = UIColor.black
        speechLabel.text = "セリフ"
        self.addSubview(speechLabel)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
