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
    
    let nameLabel = UILabel()
    let addressLabel = UILabel()
    
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

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
