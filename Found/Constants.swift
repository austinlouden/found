//
//  Constants.swift
//  Found
//
//  Created by Austin Louden on 4/4/16.
//  Copyright © 2016 Austin Louden. All rights reserved.
//


struct Padding {
    static let small: CGFloat = 4.0 // used for padding between things
    static let large: CGFloat = 20.0 // used for left app margins
}

struct FontSizes {
    static let Small: CGFloat = 12.0
    static let Medium: CGFloat = 16.0
    static let Large: CGFloat = 24.0
}

struct Sizes {
    static let defaultCellHeight: CGFloat = 60.0
    static let kerningConstant: CGFloat = 22.0
}

extension UIColor {
    class func foundBlueColor() -> UIColor {
        return UIColor.init(red: 124.0/255.0, green: 152.0/255.0, blue: 236.0/255.0, alpha: 1.0)
    }
    
    class func foundDarkGrayColor() -> UIColor {
        return UIColor.init(white: 75.0/255.0, alpha: 1)
    }
    
    class func foundLightGrayColor() -> UIColor {
        return UIColor.init(white: 181.0/255.0, alpha: 1)
    }
    
    class func foundUltraLightGrayColor() -> UIColor {
        return UIColor.init(white: 229.0/255.0, alpha: 1)
    }
}

extension UIFont {
    class func largeBoldFont() -> UIFont {
        let font = UIFont(name: "AvenirNext-DemiBold", size: FontSizes.Large)
        return font!
    }
    
    class func mediumBoldFont() -> UIFont {
        let font = UIFont(name: "AvenirNext-DemiBold", size: FontSizes.Medium)
        return font!
    }
    
    class func mediumRegularFont() -> UIFont {
        let font = UIFont(name: "AvenirNext-Regular", size: FontSizes.Medium)
        return font!
    }
    
    class func smallRegularFont() -> UIFont {
        let font = UIFont(name: "AvenirNext-Regular", size: FontSizes.Small)
        return font!
    }
}

extension NSAttributedString {
    
    class func attributedStringWithFont(font: UIFont, string: String, color: UIColor) -> NSAttributedString {
        let attributedString = NSAttributedString(string: string, attributes: [NSFontAttributeName: font,
            NSForegroundColorAttributeName: color,
            NSKernAttributeName: -(font.pointSize/Sizes.kerningConstant)])
        return attributedString
    }
    
    class func navigationTitleAttributes() -> [String : AnyObject]? {
        let font = UIFont.mediumBoldFont()
        return [NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor.foundDarkGrayColor(), NSKernAttributeName: -(font.pointSize/Sizes.kerningConstant)]
    }
    
    class func tabBarTitleAttributes() -> [String : AnyObject]? {
        let font = UIFont.smallRegularFont()
        return [NSFontAttributeName: UIFont.smallRegularFont(), NSForegroundColorAttributeName: UIColor.foundDarkGrayColor(), NSKernAttributeName: -(font.pointSize/Sizes.kerningConstant)]
    }
    
    class func navigationButtonAttributes(controlState: UIControlState) -> [String : AnyObject]? {
        let font = UIFont.mediumRegularFont()
        
        if (controlState == .Normal) {
            return [NSFontAttributeName: UIFont.mediumRegularFont(), NSForegroundColorAttributeName: UIColor.foundLightGrayColor(), NSKernAttributeName: -(font.pointSize/Sizes.kerningConstant)]
        } else {
            return [NSFontAttributeName: UIFont.mediumRegularFont(), NSForegroundColorAttributeName: UIColor.foundLightGrayColor(), NSKernAttributeName: -(font.pointSize/Sizes.kerningConstant)]
        }
    }
    
    class func typingAttributes() -> [String : AnyObject]? {
        return [NSFontAttributeName: UIFont.largeBoldFont(), NSForegroundColorAttributeName: UIColor.foundDarkGrayColor(), NSKernAttributeName: -1.0]
    }
}