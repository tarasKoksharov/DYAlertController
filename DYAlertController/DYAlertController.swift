//
//  DYActionViewController.swift
//  
//
//  Created by Dominik Butz on 22/02/16.
//
//

import UIKit

public class DYAlertAction {
    
    public var title:String
    public var iconImage: UIImage?

    public var selected:Bool
    public var handler: ((DYAlertAction) -> Void)?
    public var style:ActionStyle = .Default
    
   public init(title:String, style:ActionStyle?, iconImage:UIImage?, setSelected:Bool, handler: ((DYAlertAction) -> Void)?) {
        
        
        if let _ = style {
            self.style = style!
        }
        
        self.selected = setSelected
        self.title = title
        self.iconImage = iconImage
        self.handler = handler
    }
    
}

public enum ActionStyle {
    case Default
    case Destructive
    case Disabled
}

public class TapView: UIView {
    var touchHandler: ((UIView) -> Void)?
    override public func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        let touch = touches.first!
        let touchLocation = touch.locationInView(self)
        guard CGRectContainsPoint(self.subviews[0].frame, touchLocation) else {
            
             touchHandler?(self)
            return
        }
       
    }
}



public class DYAlertController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    public enum Style {
        case Alert
        case ActionSheet
    }
    
    public enum EffectViewMode {
        
        case blur, dim
    }
    

    @IBOutlet weak var backgroundView: TapView!
    
    @IBOutlet weak var backgroundViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var contentViewCenterYtoSuperviewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var contentViewWidthConstraint: NSLayoutConstraint!
    
    var contentViewCustomWidth:CGFloat?
    
    @IBOutlet weak var mainView: UIView!
    
    var animationEffectView:UIView?
    
    public var textField:UITextField?
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleViewHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var titleImageView: UIImageView?
    @IBOutlet weak var titleLabel: UILabel?

    @IBOutlet weak var messageLabel: UILabel?
    
    @IBOutlet public weak var okButton: UIButton?
    
    @IBOutlet weak var okButtonHeightConstraint: NSLayoutConstraint?
    
    @IBOutlet weak var okButtonToMainViewConstraint: NSLayoutConstraint?
    
    var handleOKAction: (()->Void)?
    
    @IBOutlet weak var buttonSeparatorLine: UIView?
    
    @IBOutlet public weak var cancelButton: UIButton!
    
    @IBOutlet weak var cancelButtonToMainViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var cancelButtonHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var cancelButtonWidthConstraint: NSLayoutConstraint!
    
    public var handleCancelAction: (()->Void)?
    
    @IBOutlet weak var topSeparatorLine: UIView!

    @IBOutlet weak var bottomSeparatorLine: UIView!


    @IBOutlet weak var cancelButtonToOKButtonConstraint: NSLayoutConstraint?

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    
    public var alertActions:[DYAlertAction] = []
    
    var titleText:String?
    var messageText:String?
    var titleIconImage:UIImage?
    var cancelButtonTitle:String?
    
    var okButtonTitle:String?
    var okButtonDisabled = false
    
    var shouldAllowMultipleSelection = false

    var style:Style = .Alert
    
    var backgroundEffectViewMode:EffectViewMode = .dim
    
    var isPresenting = false
    
    public var settings = DYAlertSettings()
    public var actionCellSettings = DYAlertSettings.ActionCellSettings()

    
    
    
    public convenience init() {
        
        self.init(nibName: "DYAlertController", bundle: NSBundle(forClass: DYAlertController.self))
    }
    
    public convenience init(style:Style, title:String?, titleIconImage:UIImage?, message:String?, cancelButtonTitle:String,  multipleSelection:Bool, customFrameWidth:CGFloat?, backgroundEffect: EffectViewMode) {
        
       self.init()
        
        self.style = style
        self.titleText = title
        self.messageText = message
        self.titleIconImage = titleIconImage
        self.cancelButtonTitle = cancelButtonTitle
        
        self.shouldAllowMultipleSelection = multipleSelection
        
        self.contentViewCustomWidth = customFrameWidth
        
        self.backgroundEffectViewMode = backgroundEffect
    

    }

 
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        //super.init()
        modalPresentationStyle = .Custom
        modalTransitionStyle = .CrossDissolve
        transitioningDelegate = self
        

    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        layoutSubviews()


    }
    
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if titleText != nil && titleIconImage == nil && messageText == nil {
            
            let titleLabelYPositionConstraint = NSLayoutConstraint(item: titleView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: titleLabel, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0)
            
            titleView.addConstraint(titleLabelYPositionConstraint)
        }
        
        if style == .ActionSheet {
            backgroundView.touchHandler = { [weak self] view in
                self?.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
        self.setCellSelectedIfNeeded()
        
        
    }
    
    
    override public func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let _ = textField {
            textField!.becomeFirstResponder()
        }
        
    }
    
    

    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if self.animationEffectView == nil {
            return
        }

        if self.style == .ActionSheet { // change layout constraint for Action Sheet: move content view down to bottom
            self.contentViewCenterYtoSuperviewConstraint.constant = self.contentView.superview!.frame.size.height / 2.0 - self.contentView.frame.size.height / 2.0  - 10.0
        }

        if let _ = textField {
            // correct textfield positioning
           textField!.frame = CGRectMake(20.0, 5.0, tableView.tableHeaderView!.bounds.size.width - 40.0, 30.0)

        }
        

        
 
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UI Setup
        
    
    private func layoutSubviews() {
        
        
        contentView.autoresizingMask = .FlexibleHeight
        contentView.layer.cornerRadius = settings.contentViewCornerRadius
        contentView.autoresizesSubviews = true
        if let _ = contentViewCustomWidth {
            contentViewWidthConstraint.constant =   contentViewCustomWidth! 
           
        }
        mainView.clipsToBounds = true
        mainView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        mainView.backgroundColor = settings.mainViewBackgroundColor
        if style == .ActionSheet  {
            bottomSeparatorLine.removeFromSuperview()
        }
        if alertActions.isEmpty {
            topSeparatorLine.removeFromSuperview()
        }

        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNib(UINib(nibName: "DYActionCell", bundle: NSBundle(forClass: DYActionCell.self)), forCellReuseIdentifier: "DYActionCell")
        
        if let _ = okButtonTitle {
            tableView.allowsMultipleSelection = self.shouldAllowMultipleSelection
        }
        tableView.separatorStyle = .SingleLineEtched
        tableView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
    

        layoutTitleView()

        layoutButtons()
        
        if let _ = textField {
            layoutTextField()
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DYAlertController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        }
        
    }
    
    
    private func adjustTableViewHeight() {
        
        var height:CGFloat = 0.0
        
        if let _ = textField {
            
            height = height + textField!.frame.size.height
            
            if alertActions.count == 0 {
                height = height + 30.0
            } else {
                
                height = height + 20.0
            }
        }

        
        if alertActions.count > 0 {
            
           height = height + self.getCellHeight() * CGFloat(alertActions.count)
        }
    
        self.tableViewHeightConstraint.constant = height
    }
    
    private func layoutTitleView() {
        
        titleView.backgroundColor = settings.titleViewBackgroundColor
        
        let padding:CGFloat = 10.0
        
        var viewElementsCounter = 0
        
        var titleViewHeight:CGFloat = 5.0

        if let _ = titleIconImage {
            titleImageView!.image = self.titleIconImage
            titleImageView!.contentMode = .ScaleAspectFit
            titleViewHeight += titleImageView!.frame.size.height + padding
            viewElementsCounter += 1
        } else {
            
            titleImageView?.removeFromSuperview()
           
        }
        
        if let _ = titleText {

            titleLabel!.text = titleText
            titleLabel!.textColor = settings.titleTextColor
            titleLabel!.font = settings.titleTextFont
            titleLabel!.sizeToFit()
            titleViewHeight += titleLabel!.frame.size.height + padding
            viewElementsCounter += 1
            
        } else {

            titleLabel?.removeFromSuperview()

        }
        
        if let _ = messageText {

            messageLabel!.text = messageText!
            messageLabel!.textColor = settings.messageTextColor
            messageLabel!.font = settings.messageTextFont
            messageLabel!.sizeToFit()
            titleViewHeight += messageLabel!.frame.size.height  + padding
            viewElementsCounter += 1
            
        } else {
            messageLabel?.removeFromSuperview()

        }
        
        titleViewHeightConstraint.constant = titleViewHeight
        
        if viewElementsCounter == 0 {
             topSeparatorLine.removeFromSuperview()
        }
        
        else if viewElementsCounter == 1 {
            titleViewHeightConstraint.constant += padding
        }

        
    }
    

    
    private func layoutButtons() {

        
        cancelButton.backgroundColor = settings.cancelButtonBackgroundColor
        
        cancelButton.setTitleColor(settings.cancelButtonTintColorDefault, forState: .Normal)
        cancelButton.setTitle(cancelButtonTitle, forState: .Normal)
        
        
        if let _ = okButtonTitle {
            
            okButton?.backgroundColor = settings.okButtonBackgroundColor
            
            okButton?.setTitle(okButtonTitle!, forState: .Normal)
            okButton?.setTitleColor(settings.okButtonTintColorDefault, forState: .Normal)
            
            if okButtonDisabled {
                okButton?.setTitle(okButtonTitle!, forState: .Disabled)
                okButton?.setTitleColor(settings.okButtonTintColorDisabled, forState: .Disabled)
                okButton?.enabled = false
            }
            
            
            if style == .Alert {
                cancelButtonWidthConstraint.constant = contentViewWidthConstraint.constant / 2.0
            } else { // Action Sheet
                cancelButtonWidthConstraint.constant = contentViewWidthConstraint.constant / 2.0  -  8.0
            }

            
        } else {
            // no ok title, no button!
            okButton?.removeFromSuperview()
            buttonSeparatorLine?.removeFromSuperview()
            cancelButtonWidthConstraint.constant = contentViewWidthConstraint.constant
  
        }
        
        cancelButton.setTitle(cancelButtonTitle, forState: UIControlState.Normal)
        
        if self.style == .Alert {
            
            cancelButtonToMainViewConstraint.constant = 0
            okButtonToMainViewConstraint?.constant = 0
            
            contentView.backgroundColor = UIColor.whiteColor()
            contentView.clipsToBounds = true
            
        } else {
            // Action sheet!
            okButton?.layer.cornerRadius = settings.buttonCornerRadius
            okButtonHeightConstraint?.constant = 30.0
            
            cancelButton.layer.cornerRadius = settings.buttonCornerRadius
            cancelButtonHeightConstraint.constant = 30.0

           mainView.layer.cornerRadius = settings.contentViewCornerRadius
            
            buttonSeparatorLine?.removeFromSuperview()
            
        }
        
        //print("cancel button width: \(cancelButton.frame.size.width), ok button width:\(okButton?.frame.size.width)")

    }
    
    private func layoutTextField() {
        
        self.topSeparatorLine.removeFromSuperview()
        
        let rect = CGRectMake(00.0, 0.0, tableView.frame.size.width, 40.0)
        let headerView = UIView(frame: rect)
        let textFieldFrame = CGRectMake(20.0, 0.0, headerView.bounds.size.width - 40.0, 30.0)
        textField!.frame = textFieldFrame
        textField!.borderStyle = .RoundedRect
        textField!.font = settings.textFieldFont
        textField!.backgroundColor = settings.textFieldBackgroundColor
        textField!.textColor = settings.textFieldTextColor
        textField!.textAlignment = settings.textFieldTextAlignment
        headerView.addSubview(textField!)
        tableView.tableHeaderView = headerView
        
    }
    
    
    //MARK: Actions and Textfield
    
   public func addAction(action: DYAlertAction) {
        
        self.alertActions.append(action)
        
    }
    
    public func allActionsDeselected()->Bool {
        
        var allDeselected = true
        
        for action in alertActions {
            
            if action.selected {
                allDeselected = false
            }
        }
        
        return allDeselected
    }
    
    public func allActionsSelected()->Bool {

        if alertActions.isEmpty  {
            
            return false
        }

        for action in alertActions {
            
            if action.selected == false {
                return false
            }
            
        }
        
        return true
    }
    
    public func addOKButtonAction(title:String, setDisabled:Bool, okbuttonAction:(()->Void)?) {
     
        self.okButtonTitle = title
        self.okButtonDisabled = setDisabled
        self.handleOKAction = okbuttonAction

    }
    
    
    public func addTextField(text: String?)  {
        
        if style == .ActionSheet {
          assertionFailure("Action sheet does not support text fields. Change style to .alert instead!")

        }
        
        guard let _ = textField else {
            
         textField = UITextField()
        textField!.text = text
            
            return
        }
        
        
    }
    
    //MARK: Table view data source and delegate
    
    
    private func setCellSelectedIfNeeded() {
        
        if let _ =  self.okButtonTitle{
            
            var indexCounter = -1
            for actionItem in alertActions {
                indexCounter += 1
                if actionItem.selected == true {
                    tableView.selectRowAtIndexPath(NSIndexPath(forRow: indexCounter, inSection: 0), animated: false, scrollPosition: UITableViewScrollPosition.None)
                    
                }
            }
        }
    }
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        self.adjustTableViewHeight()

        return alertActions.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("DYActionCell") as?
        DYActionCell
        
        let actionItem = alertActions[indexPath.row]

        cell!.configureCell(actionItem, hasAccessoryView: (okButtonTitle != nil), settings:actionCellSettings)

        return cell!
        
    }
    
    

  
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print("did select...")
        
        let action = alertActions[indexPath.row]

        if self.okButtonTitle == nil {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            self.dismissViewControllerAnimated(true, completion: nil)
            action.selected = true
    
        }  else {
            
            action.selected = action.selected ? false : true
            
            if action.selected {
                tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: .Middle)
            } else {
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
            
   
        }

        
        if action.handler != nil {
            action.handler!(action)
            
        }
 
    }
    

  public  func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {

        if let _ = self.okButtonTitle {

            let action = alertActions[indexPath.row]
     //       print("deselecting... seting action.selected to false")
            action.selected = false
            if action.handler != nil {
                action.handler!(action)
                
            }
            
        }
 
    }
    
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        return self.getCellHeight()
        
    }
    
    
    private func getCellHeight()->CGFloat {
        
        let heightLabelFrame = CGRectMake(0, 0, 100.0, 44.0)
        
        let heightLabel = UILabel(frame: heightLabelFrame)
        heightLabel.font = actionCellSettings.actionCellFont
        heightLabel.text = "Height"
        heightLabel.sizeToFit()
        return max(30.0, heightLabel.frame.size.height * 1.8)
    }
    
    //MARK: Actions
    
    
    @IBAction func cancelButtonTapped(sender: UIButton) {
       // print("cancel button tapped")
        handleCancelAction?()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func okButtonTapped(sender: UIButton) {

        handleOKAction?()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
//    func didTapBackground(recognizer: UITapGestureRecognizer) {
//        
//        dismissViewControllerAnimated(true, completion: nil)
//    }

    //MARK: notifications
    
    func keyboardWillShow(notification: NSNotification) {

        let info = notification.userInfo!
        let value: AnyObject = info[UIKeyboardFrameEndUserInfoKey]!
    
        let rawFrame = value.CGRectValue
        
        let keyboardFrame = view.convertRect(rawFrame, fromView: nil)
        
        self.contentViewCenterYtoSuperviewConstraint.constant = self.contentView.superview!.frame.size.height / 2.0 - self.contentView.frame.size.height / 2.0  - keyboardFrame.size.height - 10.0
        
        UIView.animateWithDuration(0.25) { () -> Void in
          
            self.backgroundView.layoutIfNeeded()
          
        }
        
    

    }

}



//MARK: Extensions - Animated Transitioning

extension DYAlertController: UIViewControllerTransitioningDelegate {

    public func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        self.isPresenting = true
        
        return self
    }
    
    public  func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.isPresenting = false
        return self
    }
    
}


extension DYAlertController: UIViewControllerAnimatedTransitioning {
    
    private func animationDuration()->NSTimeInterval {
        return 0.5
    }
    
    private func createDimView(frame: CGRect) -> UIView {
        
        let dimView = UIView(frame: frame)
        dimView.backgroundColor = settings.dimViewColor
        dimView.alpha = 0
        dimView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        return dimView
    }
    
    private func createBlurView(frame:CGRect)->UIView{
        let blurEffect = UIBlurEffect(style: settings.blurViewStyle)
        let blurredView = UIVisualEffectView(effect: blurEffect)
        blurredView.frame = frame
        blurredView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        blurredView.alpha = 0
        return blurredView
        
    }
    
    private func getbackgroundEffectView(frame:CGRect)->UIView {
        
        var effectView:UIView = UIView()
        
        if backgroundEffectViewMode == .dim {
            effectView = self.createDimView(frame)
            
        }
        
        if backgroundEffectViewMode == .blur {
            effectView = self.createBlurView(frame)
        }
        return effectView
    }
    
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return self.animationDuration()
    }
    
   public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        guard let container = transitionContext.containerView() else {
            return transitionContext.completeTransition(false)
        }
        
        guard let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) else {
            return transitionContext.completeTransition(false)
        }
        
        guard let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) else {
            return transitionContext.completeTransition(false)
        }
        
        if isPresenting == true {
            
            if style == .Alert {
                self.presentAlertAnimation(container, fromView: fromVC.view, toView: toVC.view, completion: { (_) -> Void in
                     transitionContext.completeTransition(true)
                })
                
            } else {
                //style Action Sheet
                
                self.presentActionSheetAnimation(container, fromView: fromVC.view, toView: toVC.view, completion: { (_) -> Void in
                    transitionContext.completeTransition(true)
                })
                
            }
           

            
        } else {
            
            if style == .Alert {
                
                self.dismissAlertAnimation(fromVC.view, completion: { (_) -> Void in
                    transitionContext.completeTransition(true)
                })
                
            }
            
            else {
                // Action Sheet
                self.dismissActionSheetAnimation(container, toView: toVC.view, completion: { (_) -> Void in
                    transitionContext.completeTransition(true)
                })
            }

            
        }

            
    }
    
    
    private func presentAlertAnimation(container: UIView, fromView: UIView, toView:UIView, completion: (Bool)->Void) {
       
   
        let dimView = self.getbackgroundEffectView(container.bounds)
        
        container.addSubview(dimView)
        
        toView.frame = container.bounds
        // starting transform:
        toView.transform = CGAffineTransformConcat(fromView.transform, CGAffineTransformMakeScale(0.0, 1.0))
        // this works, too
        //CGAffineTransformConcat(CGAffineTransformMakeScale(1.0, 1.0), CGAffineTransformMakeScale(0.0, 1.0))
        container.addSubview(toView)
        
        self.animationEffectView = dimView
        
        UIView.animateWithDuration(animationDuration(), animations: { () -> Void in
            toView.transform = fromView.transform // set to original transform !
            dimView.alpha = 1.0
            }, completion: completion)
        
    }
    

    
    private func dismissAlertAnimation(fromView:UIView, completion: (Bool)->Void) {
        
        UIView.animateWithDuration(animationDuration(), animations: { () -> Void in
            
            fromView.transform = CGAffineTransformMakeScale(0.01, 1.0)
            self.animationEffectView?.alpha = 0
            self.animationEffectView = nil
            
            }, completion: completion)

    }
    
    
    private func presentActionSheetAnimation(container: UIView, fromView:UIView, toView:UIView, completion: (Bool)->Void) {
        
        let effectView = self.getbackgroundEffectView(container.bounds)
  
        container.addSubview(effectView)
        
        toView.frame = container.bounds

        container.addSubview(toView)
  
        backgroundViewBottomConstraint.constant = -toView.bounds.height
        backgroundViewTopConstraint.constant = toView.bounds.height
 
        backgroundView.layoutIfNeeded()
        
        self.backgroundViewTopConstraint.constant = 0.0
        self.backgroundViewBottomConstraint.constant = 0.0
        
        self.animationEffectView = effectView

        
        UIView.animateWithDuration(animationDuration(), delay: 0.0, options: .CurveEaseIn, animations: { () -> Void in
            
            self.backgroundView.layoutIfNeeded()
            
            effectView.alpha = 1.0
            
            }, completion: completion)

        
        
    }
    
    private func dismissActionSheetAnimation(container:UIView, toView: UIView, completion:  (Bool)->Void)  {
        
        
        backgroundViewTopConstraint.constant = toView.bounds.height
        backgroundViewBottomConstraint.constant = -toView.bounds.height
        
        UIView.animateWithDuration(animationDuration(), animations: { () -> Void in
          
            self.backgroundView.layoutIfNeeded()
            self.animationEffectView?.alpha = 0
            self.animationEffectView = nil
            
            }, completion: completion)
        
    }

    
}



