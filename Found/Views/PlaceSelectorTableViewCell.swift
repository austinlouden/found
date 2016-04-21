//
//  PlaceSelectorTableViewCell.swift
//  Found
//
//  Created by Austin Louden on 4/4/16.
//  Copyright © 2016 Austin Louden. All rights reserved.
//

import UIKit
import SnapKit

class PlaceSelectorTableViewCell: UITableViewCell {
    
    private let nameLabel = UILabel()
    private let addressLabel = UILabel()

    var name: String = "" {
        didSet {
            nameLabel.attributedText = NSAttributedString.attributedStringWithFont(UIFont.largeBoldFont(), string: name, color: UIColor.foundDarkGrayColor())
        }
    }
    var address: String = "No address available" {
        didSet {
            addressLabel.attributedText = NSAttributedString.attributedStringWithFont(UIFont.smallRegularFont(), string: address, color: UIColor.foundLightGrayColor())
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(addressLabel)
        
        nameLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self.contentView).inset(Padding.small)
            make.width.equalTo(self.contentView).inset(Padding.large)
            make.left.equalTo(self.contentView).inset(Padding.large)
            make.height.equalTo(nameLabel)
        }
        
        addressLabel.snp_makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp_bottom)
            make.width.equalTo(self.contentView).inset(Padding.large)
            make.left.equalTo(self.contentView).inset(Padding.large)
            make.height.equalTo(addressLabel)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PlaceSelectorFooterView: UIView {
    
    let seeMoreButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        seeMoreButton.contentHorizontalAlignment = .Left
        self.addSubview(seeMoreButton)
        
        seeMoreButton.snp_makeConstraints { (make) in
            make.top.equalTo(self.snp_top)
            make.width.equalTo(self).inset(Padding.large)
            make.left.equalTo(self).inset(Padding.large)
            make.height.equalTo(seeMoreButton)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
