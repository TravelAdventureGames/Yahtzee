//
//  opmaakButton.swift
//  Protobarendt
//
//  Created by Martijn van Gogh on 10-11-15.
//  Copyright © 2015 Martijn van Gogh. All rights reserved.
//

import UIKit

class opmaakButton: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setButtonStyle()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        setButtonStyle()
    }
    
    func setButtonStyle() {
        
        self.layer.cornerRadius = 15
        self.backgroundColor = UIColor(red: 80/255, green: 200/255, blue: 230/255, alpha: 1.0)
        //self.layer.shadowColor = UIColor.grayColor().CGColor
        //self.layer.shadowOpacity = 1.0
        //self.layer.shadowOffset = CGSizeMake(1.0, 1.0)
        self.setTitleColor(UIColor.white, for: UIControlState())
        self.titleLabel!.font = UIFont(name: "MarkerFelt-Wide", size: 17)
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
    }
}
