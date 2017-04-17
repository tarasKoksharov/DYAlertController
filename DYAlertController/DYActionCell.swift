//
//  DYActionCellTableViewCell.swift
//  SimpleAlertTesting
//
//  Created by Dominik Butz on 24/02/16.
//  Copyright © 2016 Duoyun. All rights reserved.
//

import UIKit

class DYActionCell: UITableViewCell {

   @IBOutlet weak var actionTitleLabel: UILabel!
    
    @IBOutlet weak var actionImageView: UIImageView?
    
    var settings:DYAlertSettings.ActionCellSettings!
 
    var hasAccessoryView = false
    
    var style = ActionStyle.normal
    

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
   
    }

    override  func setSelected(_ selected: Bool, animated: Bool) {

        if self.isSelected == selected  {
           // print("already selected or deselcted, returning")
            return
        }
        
        super.setSelected(selected, animated: animated)

       // print("set selected called")

        if hasAccessoryView {
            // has ok button!

            if selected {
                self.accessoryType = UITableViewCellAccessoryType.checkmark
                self.tintColor = self.getColour(self.style, selected:  true)
      
            } else {
                self.accessoryType = .none
                self.tintColor = self.getColour(self.style, selected: false)

            }

            self.actionTitleLabel.textColor = self.tintColor


        } 


    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    
    internal func configureCell(_ actionItem:DYAlertAction, hasAccessoryView:Bool, settings:DYAlertSettings.ActionCellSettings) {
        
       // print("configure cell called")
        
       self.actionTitleLabel.text = actionItem.title
       self.actionTitleLabel.font = settings.actionCellFont
        
        let iconImage = actionItem.iconImage
        self.actionImageView!.image = iconImage?.withRenderingMode(.alwaysTemplate)
       self.actionImageView!.contentMode = .scaleAspectFit
        
        self.isUserInteractionEnabled = (actionItem.style != .disabled)
        self.hasAccessoryView = hasAccessoryView
        self.style = actionItem.style
        
        self.settings = settings

        if hasAccessoryView {
          //has checkmark
             self.selectionStyle = .none

            self.tintColor = self.getColour(self.style, selected:  actionItem.selected)

            
        } else {
            //  no checkmark
            self.selectionStyle = .gray
            self.tintColor = self.getColour(self.style, selected: true)
           self.centerViewElements()

        }
        
             self.actionTitleLabel.textColor = self.tintColor
  
    
    }
    


    
    fileprivate func getColour(_ style:ActionStyle, selected:Bool)->UIColor {
        
        switch style {
        case .disabled:
            return settings.disabledTintColor
        case .normal:
            if selected {
                return settings.defaultTintColor
            } else {
                return settings.deselectedTintColor
            }
        case .destructive:
            if selected {
                return settings.destructiveTintColor
            } else {
                return settings.deselectedTintColor
            }
            
        }
    }
    

    fileprivate func centerViewElements() {
 
        if let _ = actionImageView?.image {

            self.contentView.constraints[2].constant = 5.0
            
            let labelWidth = self.actionTitleLabel.frame.size.width

          self.contentView.constraints[0].constant =  self.contentView.frame.size.width / 2.0 - labelWidth / 2.0 - self.contentView.constraints[2].constant - actionImageView!.frame.size.width
            

        }   else {
            actionImageView?.removeFromSuperview()
        }
        

        let centerLabelConstraint = NSLayoutConstraint(item: self.contentView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: actionTitleLabel, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0.0)
  
        self.contentView.addConstraint(centerLabelConstraint)


    }

}
