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

        public var textFieldBackgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.7)
        public var textFieldTextColor = UIColor.whiteColor()
        public var textFieldFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    
    //MARK: button settings

        public var cancelButtonTintColorNormal = UIColor(red: 0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1)
        public var cancelButtonTintColorHightlighted = UIColor.redColor()
    
        public var okButtonTintColorNormal = UIColor(red: 0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1)
        public var okButtonBackgroundColor = UIColor.whiteColor()
        public var okButtonTintColorHighlighted = UIColor.redColor()
    
        public var cancelButtonBackgroundColor = UIColor.whiteColor()
        public var buttonFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        public var buttonCornerRadius:CGFloat = 5.0

    
    //MARK: content view / main view settings
        public var contentViewCornerRadius:CGFloat = 8.0
        public var mainViewBackgroundColor = UIColor.whiteColor()

    //MARK: effect view settings
        public var blurViewStyle: UIBlurEffectStyle = .Dark
        public var dimViewColor = UIColor.blackColor().colorWithAlphaComponent(0.6)
    
//MARK: action cell settings  - separate struct
    public struct ActionCellSettings {
        public var deselectedTintColor = UIColor.grayColor()
        public var defaultTintColor = UIColor(red: 0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1)
        public var destructiveTintColor = UIColor.redColor()
        public var disabledTintColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.5)
        public var actionCellFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    }
    
    
}