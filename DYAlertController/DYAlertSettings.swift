//
//  DYAlert.swift
//  SimpleAlertTesting
//
//  Created by Dominik Butz on 23/02/16.
//  Copyright © 2016 Duoyun. All rights reserved.
//

import Foundation
import UIKit

public struct DYAlertSettings {
    
//MARK: title view settings

        public var titleTextColor = UIColor.darkGray
        public var messageTextColor = UIColor.gray
        public var titleTextFont =  UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
        public var messageTextFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.footnote)
        public var titleViewBackgroundColor = UIColor.clear
    
//MARK: text field settings

        public var textFieldBackgroundColor = UIColor.paleGrayColor()
        public var textFieldTextColor = UIColor.white
        public var textFieldFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        public var textFieldTextAlignment = NSTextAlignment.center

    
    //MARK: button settings

        public var okButtonBackgroundColor = UIColor.white
        public var okButtonTintColorDefault = UIColor.defaultBlueTintColor()
        public var okButtonTintColorDestructive = UIColor.red
        public var okButtonTintColorDisabled = UIColor.paleGrayColor()
    
        public var cancelButtonTintColorDefault = UIColor.defaultBlueTintColor()
        public var cancelButtonBackgroundColor = UIColor.white
    
        public var buttonFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        public var buttonCornerRadius:CGFloat = 5.0

    
    //MARK: content view / main view settings
        public var contentViewCornerRadius:CGFloat = 8.0
        public var mainViewBackgroundColor = UIColor.white

    //MARK: effect view settings
        public var blurViewStyle: UIBlurEffectStyle = .dark
        public var dimViewColor = UIColor.black.withAlphaComponent(0.6)
    
//MARK: action cell settings
    public struct ActionCellSettings {
        public var deselectedTintColor = UIColor.gray
        public var defaultTintColor = UIColor.defaultBlueTintColor()
        public var destructiveTintColor = UIColor.red
        public var disabledTintColor = UIColor.paleGrayColor()
        public var actionCellFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
    }
    
    
}


public extension UIButton {
    
    public func setNormalStyle(_ title:String, titleColor:UIColor) {
        
        self.setNormalState(title, titleColor: titleColor)
    }
    
    public func setDestructiveStyle(_ title:String, titleColor:UIColor) {
        
        self.setNormalState(title, titleColor: titleColor)
    }
    
    public func setDisabledStyle(_ title:String, titleColor:UIColor) {
        
        self.setTitleColor(titleColor, for: .disabled)
        self.setTitle(title, for: .disabled)
        self.isEnabled = false
    }
    
    fileprivate func setNormalState(_ title:String, titleColor:UIColor) {
        self.setTitleColor(titleColor, for: UIControlState())
        self.setTitle(title, for: UIControlState())
        self.isEnabled = true
        
    }
    
}


public extension UIColor {
    
    public class func defaultBlueTintColor()->UIColor {
        
        return UIColor(red: 0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1)
    }
    
    public class func paleGrayColor()->UIColor{
        
        return UIColor.lightGray.withAlphaComponent(0.6)
    }
    
}
