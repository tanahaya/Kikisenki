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

    var backImageview: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backImageview = UIImageView(frame: CGRect(x: 0, y: 0, width: 414, height: 160))
        let backImage: UIImage = UIImage(named: "serif1.png")!
        backImageview.image = backImage// 画像をUIImageViewに設定する
        self.addSubview(backImageview)
        
        nameLabel.backgroundColor = UIColor.clear
        nameLabel.textColor = UIColor.black
        nameLabel.text = "名前"
        self.addSubview(nameLabel)
        
        speechLabel.backgroundColor = UIColor.clear
        speechLabel.textColor = UIColor.black
        speechLabel.text = "セリフ"
        self.addSubview(speechLabel)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
