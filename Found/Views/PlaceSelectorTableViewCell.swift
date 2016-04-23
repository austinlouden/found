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
    
    private let primaryLabel = UILabel()
    private let secondaryLabel = UILabel()

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
        
        primaryLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self.contentView).inset(Padding.small)
            make.width.equalTo(self.contentView).inset(Padding.large)
            make.left.equalTo(self.contentView).inset(Padding.large)
            make.height.equalTo(primaryLabel)
        }
        
        secondaryLabel.snp_makeConstraints { (make) in
            make.top.equalTo(primaryLabel.snp_bottom)
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
            seeMoreButton.setAttributedTitle(NSAttributedString.attributedStringWithFont(UIFont.mediumBoldFont(), string: seeMoreText, color: UIColor.foundDarkGrayColor()), forState: .Normal)
        }
    }
    
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
