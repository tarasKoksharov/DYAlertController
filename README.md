[![CocoaPods](https://img.shields.io/cocoapods/v/DYAlertController.svg?style=flat)](http://cocoadocs.org/docsets/DYAlertController)
[![license](https://img.shields.io/github/license/DominikButz/DYAlertController.svg?style=flat)](http://cocoadocs.org/docsets/DYAlertController)
[![CocoaPods](https://img.shields.io/cocoapods/dt/DYAlertController.svg)]()



# DYAlertController

DYAlertController can be used as a replacement for Apple’s UIAlertController. 
It supports checkmarks, single and multiple selection and icons. DYAlertController also features two styles, alert and actionSheet. Tapping an action and tapping the ok or cancel button will trigger actions you define in the action item’s handler or in the cancel and ok button handlers, similar to UIAlertController.
Pull the framework and checkout the example project in the subfolder. 


## Installation


Install DYAlertController through Cocoapods. Enter the following information into your Podfile (see current version in header):

```Ruby
platform :ios, '10.0'

use_frameworks!

target '[Your app project title]' do
pod 'DYAlertController', '~> [current version - see header]'
end

```
Make sure to import DYAlertController into your View Controller subclass:

```Swift
	import DYAlertController
```
**Important**: The Xcode compiler might show an error after you open your project .xcworkspace file including DYAlertController for the first time (something like "No such module DYAlertController"). I have had this issue with a lot of other Cocoapods which I tried to install before. Simply run your code and the error should disappear. 

Alternatively, you can pull this framework and copy the DYAlertController folder (in the pods folder) from the example project into your project.

 

##Features

As alternative to UIAlertController, DYAlertController has the following additional features:

* updated to the latest **Swift 3** syntax!
* Add an icon image to the title view right above the title
* Add an icon image to an action
* If you add an ok button (which is optional), clicking on an action will not dismiss the alert or action sheet but will toggle a checkmark instead. You can also set the controller to multiple selection. If you don’t add an ok button action, the alert or action sheet will be dismissed when tapping an action
* change the ok button style (normal, destructive, disabled) in your action item handlers
* Add several text fields
* Choose from two background effect view styles, blur and dim
* Set a custom width for the alert or action sheet (its height will be set automatically depending on the content view’s subviews)
* Customise colours, fonts, corner radius etc.



## Usage

The usage is similar to UIAlertController. See the following example.


###Code example: Creating an alert

```Swift
let titleImage = UIImage(named: "shareIcon")
let alert = DYAlertController(style: .alert, title: "Doing stuff", titleIconImage: titleImage, message:"Select one option", cancelButtonTitle: "Cancel", multipleSelection: false, customFrameWidth:200, backgroundEffect: DYAlertController.EffectViewMode.blur)

    
alert.addAction(DYAlertAction(title: "Do stuff 1", style:.normal, iconImage: nil, setSelected:false, handler: { (alertAction) -> Void in
    
  print("executing first action! selected: \(alertAction.selected)")
                
}))
    
alert.addAction(DYAlertAction(title: "Do stuff 2", style:.normal, iconImage: nil, setSelected:false, handler: { (alertAction) -> Void in
    
  print("executing 2nd action! selected: \(alertAction.selected)")
    
}))
    
    
alert.addAction(DYAlertAction(title: "Beware!", style:.destructive, iconImage: nil, setSelected:true, handler: { (alertAction) -> Void in
 
    print("executing 3rd action! selected: \(alertAction.selected)")
}))

alert.handleCancelAction = {
    
    print("cancel tapped")
}
    
self.present(alert, animated: true, completion: nil)
    


```

![Alert example 1](https://github.com/DominikButz/DYAlertController/blob/master/gitResources/AlertExample1.gif "Alert example 1")




### Adding text fields
```Swift
 	let textfield1 = UITextField()
	textfield1.placeholder = "username"
	textfield1.autocorrectionType = UITextAutocorrectionType.no
	  
	let textfield2 = UITextField()
	textfield2.placeholder = "password"
	textfield2.isSecureTextEntry = true
	  
	let textfield3 = UITextField()
	textfield3.placeholder = "hostname"
	textfield3.autocorrectionType = UITextAutocorrectionType.no
	  
	textfield1.delegate = self
	textfield2.delegate = self
	textfield3.delegate = self
	  
	alert.addTextField(textField: textfield1)
	alert.addTextField(textField: textfield2)
	alert.addTextField(textField: textfield3)

```

You can get the text input like so: alert.textFields[0].text etc. 
Make sure to only add text fields to an alert, not to an action sheet - just like UIAlertController, **your app will crash at runtime if you try to add a text field to an action sheet**.

![Alert example 2](https://github.com/DominikButz/DYAlertController/blob/master/gitResources/AlertExample2.gif "Alert example 2")

### Adding an ok button action

Add an ok button action as follows:

```Swift
alert.addOKButtonAction("OK", setDisabled: false) { 
   print("ok button tapped!")
}
```
You can set the ok button to disabled state initially (e.g. if the user should change the selection first before he can tap the ok button. 
The button style can be changed in the action handlers. For example:

```Swift

let actionSheet = DYAlertController(style: .actionSheet, title: "Doing stuff", titleIconImage: nil, message:"Select one option", cancelButtonTitle: "Cancel", multipleSelection: false, customFrameWidth:nil, backgroundEffect:.dim)
    
enum SelectedOption: String {
 case firstOption = "First Option"
 case secondOption = "Second Option"
 case thirdOption = "Third Option"
 case none  = "None"
}
  
var selected:SelectedOption = .firstOption
            
actionSheet.addAction(DYAlertAction(title: "Option 1", style:.normal, iconImage: UIImage(named: "eyeIcon"), setSelected:true, handler: { (action) -> Void in
    
	if action.selected {
	//selected
		selected = .firstOption
		// this function call changes the ok button style when the user selects this action: 
		actionSheet.okButton!.setNormalStyle("OK", titleColor: 			actionSheet.settings.okButtonTintColorDefault)
	
	} else {
	// deselected
	     
		if actionSheet.allActionsDeselected() {
		    selected = .none
		    actionSheet.okButton!.setDisabledStyle("Disabled", titleColor: 			actionSheet.settings.okButtonTintColorDisabled)
		 }
	                    
	}
	                
	  print("changing state of first option.  selected: \(action.selected)")
}))


// ... add other actions...


actionSheet.addOKButtonAction("OK", setDisabled: false) { 
     print("ok button tapped -  option selected: \(selected.rawValue)")
 }
            
 // ...

```
Download the example project for more details and check out the examples as animations below. 

### Action sheet examples

Action sheet with simple selection:

![Action Sheet example 1](https://github.com/DominikButz/DYAlertController/blob/master/gitResources/ActionSheetExample1.gif "ActionSheet example 1")


Action sheet with multiple selection:

![Action Sheet example 2](https://github.com/DominikButz/DYAlertController/blob/master/gitResources/ActionSheetExample2.gif "ActionSheet example 2")

### Customising
If you intend to create several alerts or action sheets with the same fonts and colours in your app you can simply change the default settings in the DYAlertSettings struct. Alternatively, you can change single properties in code by changing the properties in the struct instances. For example:

```Swift
// create alert or action sheet first
// ... 

alert.settings.contentViewCornerRadius = 2.0

alert.settings.titleTextColor = UIColor.black

```

These changes only overwrite the settings properties of your current DYAlertViewController instance. Check out the DYAlertSettings.swift file. 

## License

The MIT License (MIT)

Copyright (c) 2016 Dominik Butz

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

