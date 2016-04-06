//
//  Constants.swift
//  Found
//
//  Created by Austin Louden on 4/4/16.
//  Copyright © 2016 Austin Louden. All rights reserved.
//


struct Insets {
    static let small: CGFloat = 4.0 // used for padding between things
    static let large: CGFloat = 20.0 // used for left app margins
}

struct FontSizes {
    static let fontSizeMedium: CGFloat = 14.0
    static let fontSizeLarge: CGFloat = 24.0
}

extension UIColor {
    class func foundDarkGrayColor() -> UIColor {
        return UIColor.init(white: 75.0/255.0, alpha: 1.0)
    }
}

extension UIFont {
    class func largeBoldFont() -> UIFont {
        let font = UIFont(name: "HelveticaNeue-Bold", size: FontSizes.fontSizeLarge)
        return font!
    }
}

extension NSAttributedString {
    class func largeBoldAttributedString(string: String, color: UIColor) -> NSAttributedString {
        let attributedString = NSAttributedString(string: string, attributes: [NSFontAttributeName: UIFont.largeBoldFont(),
                                                                               NSForegroundColorAttributeName: color,
                                                                               NSKernAttributeName: -1.0])
        return attributedString
    }
}