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

        public var titleTextColor = UIColor.darkGrayColor()
        public var messageTextColor = UIColor.grayColor()
        public var titleTextFont =  UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        public var messageTextFont = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
        public var titleViewBackgroundColor = UIColor.clearColor()
    
//MARK: text field settings

        public var textFieldBackgroundColor = UIColor.paleGrayColor()
        public var textFieldTextColor = UIColor.whiteColor()
        public var textFieldFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        public var textFieldTextAlignment = NSTextAlignment.Center

    
    //MARK: button settings

        public var okButtonBackgroundColor = UIColor.whiteColor()
        public var okButtonTintColorDefault = UIColor.defaultBlueTintColor()
        public var okButtonTintColorDestructive = UIColor.redColor()
        public var okButtonTintColorDisabled = UIColor.paleGrayColor()
    
        public var cancelButtonTintColorDefault = UIColor.defaultBlueTintColor()
        public var cancelButtonBackgroundColor = UIColor.whiteColor()
    
        public var buttonFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        public var buttonCornerRadius:CGFloat = 5.0

    
    //MARK: content view / main view settings
        public var contentViewCornerRadius:CGFloat = 8.0
        public var mainViewBackgroundColor = UIColor.whiteColor()

    //MARK: effect view settings
        public var blurViewStyle: UIBlurEffectStyle = .Dark
        public var dimViewColor = UIColor.blackColor().colorWithAlphaComponent(0.6)
    
//MARK: action cell settings
    public struct ActionCellSettings {
        public var deselectedTintColor = UIColor.grayColor()
        public var defaultTintColor = UIColor.defaultBlueTintColor()
        public var destructiveTintColor = UIColor.redColor()
        public var disabledTintColor = UIColor.paleGrayColor()
        public var actionCellFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    }
    
    
}


public extension UIButton {
    
    public func setDefaultStyle(title:String, titleColor:UIColor) {
        
        self.setNormalState(title, titleColor: titleColor)
    }
    
    public func setDestructiveStyle(title:String, titleColor:UIColor) {
        
        self.setNormalState(title, titleColor: titleColor)
    }
    
    public func setDisabledStyle(title:String, titleColor:UIColor) {
        
        self.setTitleColor(titleColor, forState: .Disabled)
        self.setTitle(title, forState: .Disabled)
        self.enabled = false
    }
    
    private func setNormalState(title:String, titleColor:UIColor) {
        self.setTitleColor(titleColor, forState: .Normal)
        self.setTitle(title, forState: .Normal)
        self.enabled = true
        
    }
    
}


public extension UIColor {
    
    public class func defaultBlueTintColor()->UIColor {
        
        return UIColor(red: 0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1)
    }
    
    public class func paleGrayColor()->UIColor{
        
        return UIColor.lightGrayColor().colorWithAlphaComponent(0.6)
    }
    
}