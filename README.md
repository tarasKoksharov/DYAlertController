# DYAlertController

DYAlertController can be used as a replacement for Apple’s UIAlertController. DYAlertController also features two styles, alert and actionSheet. Tapping an action and tapping the ok or cancel button will trigger actions you define in the action item’s handler and in the cancel and ok button handlers, similar to UIAlertController.

## Installation

Pull this example project and copy the DYAlertController folder from the example project into your project. 
Alternatively, you may install DYAlertController through cocoapods. Enter the following information into your podfile:

```Ruby
platform :ios, '8.0'
source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/DominikButz/DYAlertControllerSpecs.git'

use_frameworks!

target '[Your app project title]' do
pod 'DYAlertController', '~> 0.2.0'
end

```

##Features

As alternative to UIAlertController, DYAlertController has the following additional features:

* Add an icon image to the title view right above the title
* Add an icon image to an action
* If you set an ok button title (which is optional), clicking on an action will not dismiss the alert or action sheet but will toggle a checkmark instead. You can also set the controller to multiple selection. If you don’t define an ok button title, the alert or action sheet will be dismissed when tapping an action
* Choose from two background effect view styles, blur and dim
* Set a custom width for the alert or action sheet (its height will be set automatically depending on the content view’s subviews)
* Customise colours, fonts, corner radius etc.



## Usage
The usage is very similar to UIAlertController. See an alert example below. 
Before you can access the 

###Code example: Creating an alert

```Swift
let titleImage = UIImage(named: "shareIcon")
let alert = DYAlertController(style: .Alert, title: "Doing stuff", titleIconImage: titleImage, message:"Select one option", cancelButtonTitle: "Cancel", okButtonTitle: nil, multipleSelection: false, customFrameWidth:200, backgroundEffect: .blur)

alert.addAction(AlertAction(title: "Do stuff 1", style:.Default, iconImage: UIImage(named: "editIcon"), setSelected:false, handler: { (alertAction) -> Void in

print("executing first action! selected: \(alertAction.selected)")
}))

alert.addAction(AlertAction(title: "Do stuff 2", style:.Default, iconImage: UIImage(named: "locationIcon"), setSelected:false, handler: { (alertAction) -> Void in

print("executing 2nd action! selected: \(alertAction.selected)")

}))


alert.addAction(AlertAction(title: "Beware!", style:.Destructive, iconImage: UIImage(named: "eyeIcon"), setSelected:true, handler: { (alertAction) -> Void in


print("executing 3rd action! selected: \(alertAction.selected)")

}))

alert.handleCancelAction = {

print("cancel tapped")
}

alert.handleOKAction = {

print("OK button tapped")
}


self.presentViewController(alert, animated: true, completion: nil)

```

TODO: Write usage instructions

### Adding a text field
```Swift
alert.addTextField(“Title")   // set parameter nil if the text field should be empty

// simply access the textField instance variable of the alert you created. e.g.:
alert.textField!.delegate = self
```

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

