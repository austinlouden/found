//
//  ListSelectorTableViewCell.swift
//  Found
//
//  Created by Austin Louden on 4/17/16.
//  Copyright © 2016 Austin Louden. All rights reserved.
//

import UIKit

class ListSelectorHeaderView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.foundLightGrayColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ListCreatorTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    let textField = UITextField()
    
    weak var delegate:ListCreatorTableViewCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        textField.delegate = self
        textField.returnKeyType = .Done
        textField.attributedPlaceholder = NSAttributedString.attributedStringWithFont(UIFont.largeBoldFont(), string: "Create a list", color: UIColor.foundLightGrayColor())
        self.addSubview(textField)
        
        textField.snp_makeConstraints { (make) in
            make.edges.equalTo(self).inset(UIEdgeInsetsMake(0, Padding.large, Padding.small, Padding.large))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UITextFieldDelegate
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        textField.typingAttributes = NSAttributedString.typingAttributes()
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if let placeListName = textField.attributedText?.string {
            textField.attributedText = nil
            delegate?.didCreatePlaceList(placeListName)
        }
        
        textField.resignFirstResponder()
        return true
    }
}

protocol ListCreatorTableViewCellDelegate: class {
    func didCreatePlaceList(placeListName: String)
}

class ListSelectorTableViewCell: UITableViewCell {


}