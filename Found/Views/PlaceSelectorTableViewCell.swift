//
//  PlaceSelectorTableViewCell.swift
//  Found
//
//  Created by Austin Louden on 4/4/16.
//  Copyright © 2016 Austin Louden. All rights reserved.
//

import UIKit
import SnapKit

class BaseTableViewCell: UITableViewCell {
    
    static let defaultTableViewCellHeight: CGFloat = 60.0
    
    fileprivate let primaryLabel = UILabel()
    fileprivate let secondaryLabel = UILabel()

    var primaryString: String = "" {
        didSet {
            primaryLabel.attributedText = NSAttributedString.attributedStringWithFont(UIFont.largeBoldFont(), string: primaryString, color: UIColor.foundDarkGrayColor())
        }
    }
    var secondaryString: String = "" {
        didSet {
            secondaryLabel.attributedText = NSAttributedString.attributedStringWithFont(UIFont.smallRegularFont(), string: secondaryString, color: UIColor.foundLightGrayColor())
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(primaryLabel)
        self.contentView.addSubview(secondaryLabel)
        
        primaryLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.contentView).inset(Padding.small)
            make.width.equalTo(self.contentView).inset(Padding.large)
            make.left.equalTo(self.contentView).inset(Padding.large)
            make.height.equalTo(primaryLabel)
        }
        
        secondaryLabel.snp.makeConstraints { (make) in
            make.top.equalTo(primaryLabel.snp.bottom)
            make.width.equalTo(self.contentView).inset(Padding.large)
            make.left.equalTo(self.contentView).inset(Padding.large)
            make.height.equalTo(secondaryLabel)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PlaceSelectorFooterView: UIView {
    
    let seeMoreButton = UIButton()
    
    var seeMoreText: String = "" {
        didSet {
            seeMoreButton.setAttributedTitle(NSAttributedString.attributedStringWithFont(UIFont.mediumBoldFont(), string: seeMoreText, color: UIColor.foundDarkGrayColor()), for: UIControlState())
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        seeMoreButton.contentHorizontalAlignment = .left
        self.addSubview(seeMoreButton)
        
        seeMoreButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.width.equalTo(self).inset(Padding.large)
            make.left.equalTo(self).inset(Padding.large)
            make.height.equalTo(seeMoreButton)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
