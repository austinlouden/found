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

extension UIColor {
    class func foundDarkGrayColor() -> UIColor {
        return UIColor.init(white: 75.0/255.0, alpha: 1.0)
    }
    
    class func foundLightGrayColor() -> UIColor {
        return UIColor.init(white: 181.0/255.0, alpha: 1.0)
    }
}

extension UIFont {
    class func largeBoldFont() -> UIFont {
        let font = UIFont(name: "HelveticaNeue-Bold", size: FontSizes.Large)
        return font!
    }
    
    class func mediumBoldFont() -> UIFont {
        let font = UIFont(name: "HelveticaNeue-Bold", size: FontSizes.Medium)
        return font!
    }
    
    class func mediumRegularFont() -> UIFont {
        let font = UIFont(name: "HelveticaNeue", size: FontSizes.Medium)
        return font!
    }
    
    class func smallRegularFont() -> UIFont {
        let font = UIFont(name: "HelveticaNeue", size: FontSizes.Small)
        return font!
    }
}

extension NSAttributedString {
    class func attributedStringWithFont(font: UIFont, string: String, color: UIColor) -> NSAttributedString {
        let attributedString = NSAttributedString(string: string, attributes: [NSFontAttributeName: font,
            NSForegroundColorAttributeName: color,
            NSKernAttributeName: -(font.pointSize/18.0)])
        return attributedString
    }
    
    class func navigationTitleAttributes() -> [String : AnyObject]? {
        return [NSFontAttributeName: UIFont.mediumBoldFont(), NSForegroundColorAttributeName: UIColor.foundDarkGrayColor(), NSKernAttributeName: -1.0]
    }
    
    class func navigationButtonAttributes() -> [String : AnyObject]? {
        return [NSFontAttributeName: UIFont.mediumRegularFont(), NSForegroundColorAttributeName: UIColor.foundDarkGrayColor(), NSKernAttributeName: -1.0]
    }
}