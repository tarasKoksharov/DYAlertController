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
    

    struct TitleViewSettings {
        var titleTextColor = UIColor.darkGrayColor()
        var messageTextColor = UIColor.grayColor()
        var titleTextFont =  UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        var messageTextFont = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
        var backgroundColor = UIColor.clearColor()
    }
    
    struct ActionCellSettings {
        var deselectedTintColor = UIColor.grayColor()
        var defaultTintColor = UIColor(red: 0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1)
        var destructiveTintColor = UIColor.redColor()
        var disabledTintColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.5)
        var actionCellFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    }
    
    struct TextFieldSettings {
        var backgroundColor = UIColor.lightGrayColor()
        var textColor = UIColor.whiteColor()
        var textFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        
    }
    
    struct ButtonSettings {
        var cancelButtonTintColor = UIColor(red: 0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1)
        var okButtonTintColor = UIColor(red: 0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1)
        var okButtonBackgroundColor = UIColor.whiteColor()
        var cancelButtonBackgroundColor = UIColor.whiteColor()
        var buttonFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        var cornerRadius:CGFloat = 5.0
    }
    
    struct ContentViewSettings {
        
        var cornerRadius:CGFloat = 8.0
        var mainViewBackgroundColor = UIColor.whiteColor()
    }

    
    
}