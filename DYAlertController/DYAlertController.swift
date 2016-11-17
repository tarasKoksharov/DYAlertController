//
//  DYActionViewController.swift
//  
//
//  Created by Dominik Butz on 22/02/16.
//
//

import UIKit

open class DYAlertAction {
    
    open var title:String
    
    open var iconImage: UIImage?
    

    open var selected:Bool
    
    open var handler: ((DYAlertAction) -> Void)?
    
    open var style:ActionStyle = .normal
    
    
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
    case normal
    case destructive
    case disabled
}

open class TapView: UIView {
    var touchHandler: ((UIView) -> Void)?
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        let touch = touches.first!
        let touchLocation = touch.location(in: self)
        guard self.subviews[0].frame.contains(touchLocation) else {
            
             touchHandler?(self)
            return
        }
       
    }
}



open class DYAlertController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    public enum Style {
        case alert
        case actionSheet
    }
    
    public enum EffectViewMode {
        
        case blur, dim
    }
    

    @IBOutlet weak var backgroundView: TapView!
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var contentViewCenterYtoSuperviewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var contentViewWidthConstraint: NSLayoutConstraint!
    
    var contentViewCustomWidth:CGFloat?
    
    @IBOutlet weak var mainView: UIView!
    
    var animationEffectView:UIView?
    
    open var textFields:[UITextField] = []
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleViewHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var titleImageView: UIImageView?
    @IBOutlet weak var titleLabel: UILabel?

    @IBOutlet weak var messageLabel: UILabel?
    
    @IBOutlet open weak var okButton: UIButton?
    
    @IBOutlet weak var okButtonHeightConstraint: NSLayoutConstraint?
    
    @IBOutlet weak var okButtonToMainViewConstraint: NSLayoutConstraint?
    
    var handleOKAction: (()->Void)?
    
    @IBOutlet weak var buttonSeparatorLine: UIView?
    
    @IBOutlet open weak var cancelButton: UIButton!
    
    @IBOutlet weak var cancelButtonToMainViewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var cancelButtonHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var cancelButtonWidthConstraint: NSLayoutConstraint!
    
    open var handleCancelAction: (()->Void)?
    
    @IBOutlet weak var topSeparatorLine: UIView!

    @IBOutlet weak var bottomSeparatorLine: UIView!


    @IBOutlet weak var cancelButtonToOKButtonConstraint: NSLayoutConstraint?

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    
    open var alertActions:[DYAlertAction] = []
    
    var titleText:String?
    var messageText:String?
    var titleIconImage:UIImage?
    var cancelButtonTitle:String?
    
    var okButtonTitle:String?
    var okButtonDisabled = false
    
    var shouldAllowMultipleSelection = false

    var style:Style = .alert
    
    var backgroundEffectViewMode:EffectViewMode = .dim
    
    var isPresenting = false
    
    open var settings = DYAlertSettings()
    open var actionCellSettings = DYAlertSettings.ActionCellSettings()

    
    
    
    public convenience init() {
        
        self.init(nibName: "DYAlertController", bundle: Bundle(for: DYAlertController.self))
    }
    
    public convenience init(style:Style, title:String?, titleIconImage:UIImage?, message:String?, cancelButtonTitle:String,  multipleSelection:Bool, customFrameWidth:CGFloat?, backgroundEffect: EffectViewMode) {
        
   //   type(of: self).init()
        
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

 
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        //super.init()
        modalPresentationStyle = .custom
        modalTransitionStyle = .crossDissolve
        transitioningDelegate = self
        

    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        
        layoutSubviews()


    }
    
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if titleText != nil && titleIconImage == nil && messageText == nil {
            
            let titleLabelYPositionConstraint = NSLayoutConstraint(item: titleView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: titleLabel, attribute: NSLayoutAttribute.centerY, multiplier: 1.0, constant: 0.0)
            
            titleView.addConstraint(titleLabelYPositionConstraint)
        }
        
        if style == .actionSheet {
            backgroundView.touchHandler = { [weak self] view in
                self?.dismiss(animated: true, completion: nil)
            }
        }
        
        self.setCellSelectedIfNeeded()
        
        
    }
    
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        if self.textFields.count > 0 {
             self.textFields[0].becomeFirstResponder()
        }

        
    }
    
    

    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if self.animationEffectView == nil {
            return
        }

        if self.style == .actionSheet { // change layout constraint for Action Sheet: move content view down to bottom
            self.contentViewCenterYtoSuperviewConstraint.constant = self.contentView.superview!.frame.size.height / 2.0 - self.contentView.frame.size.height / 2.0  - 10.0
        }

       
        if self.textFields.count > 0 {
                    layoutTextFields()
                    NotificationCenter.default.addObserver(self, selector: #selector(DYAlertController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
            }

    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UI Setup
        
    
    fileprivate func layoutSubviews() {
        
        
        contentView.autoresizingMask = .flexibleHeight
        contentView.layer.cornerRadius = settings.contentViewCornerRadius
        contentView.autoresizesSubviews = true
        if let _ = contentViewCustomWidth {
            contentViewWidthConstraint.constant =   contentViewCustomWidth! 
           
        }
        mainView.clipsToBounds = true
        mainView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        mainView.backgroundColor = settings.mainViewBackgroundColor
        if style == .actionSheet  {
            bottomSeparatorLine.removeFromSuperview()
        }
        if alertActions.isEmpty {
            topSeparatorLine.removeFromSuperview()
        }

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "DYActionCell", bundle: Bundle(for: DYActionCell.self)), forCellReuseIdentifier: "DYActionCell")
        
        if let _ = okButtonTitle {
            tableView.allowsMultipleSelection = self.shouldAllowMultipleSelection
        }
        tableView.separatorStyle = .singleLineEtched
        tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    

        layoutTitleView()

        layoutButtons()
        
        // text fields (if any) layout only in the didLayoutSubviews method!
        
    }
    
    
    fileprivate func adjustTableViewHeight() {
        
        var height:CGFloat = 0.0
        
        if self.textFields.count > 0 {
            print("there are text fields, adjusting TV height")
            height = height + (CGFloat(self.textFields.count) * self.textFields[0].frame.size.height + 10.0)
        
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
    
    fileprivate func layoutTitleView() {
        
        titleView.backgroundColor = settings.titleViewBackgroundColor
        
        let padding:CGFloat = 10.0
        
        var viewElementsCounter = 0
        
        var titleViewHeight:CGFloat = 5.0

        if let _ = titleIconImage {
            titleImageView!.image = self.titleIconImage
            titleImageView!.contentMode = .scaleAspectFit
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
    

    
    fileprivate func layoutButtons() {

        
        cancelButton.backgroundColor = settings.cancelButtonBackgroundColor
        
        cancelButton.setTitleColor(settings.cancelButtonTintColorDefault, for: UIControlState())
        cancelButton.setTitle(cancelButtonTitle, for: UIControlState())
        
        
        if let _ = okButtonTitle {
            
            okButton?.backgroundColor = settings.okButtonBackgroundColor
            
            okButton?.setTitle(okButtonTitle!, for: UIControlState())
            okButton?.setTitleColor(settings.okButtonTintColorDefault, for: UIControlState())
            
            if okButtonDisabled {
                okButton?.setTitle(okButtonTitle!, for: .disabled)
                okButton?.setTitleColor(settings.okButtonTintColorDisabled, for: .disabled)
                okButton?.isEnabled = false
            }
            
            
            if style == .alert {
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
        
        cancelButton.setTitle(cancelButtonTitle, for: UIControlState())
        
        if self.style == .alert {
            
            cancelButtonToMainViewConstraint.constant = 0
            okButtonToMainViewConstraint?.constant = 0
            
            contentView.backgroundColor = UIColor.white
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
    
    fileprivate func layoutTextFields() {
        
        self.topSeparatorLine.removeFromSuperview()
        
        let rect = CGRect(x: 00.0, y: 0.0, width: Double(tableView.frame.size.width), height: 40.0 * Double(textFields.count))
        let headerView = UIView(frame: rect)
        
        var y = 0.0
        
        for textfield in textFields {
            print("there are text fields")
            let textFieldFrame = CGRect(x: 20.0, y: y, width: Double(headerView.bounds.size.width - 40.0), height: 30.0)
            textfield.frame = textFieldFrame
            textfield.borderStyle = .roundedRect
            textfield.font = settings.textFieldFont
            textfield.backgroundColor = settings.textFieldBackgroundColor
            textfield.textColor = settings.textFieldTextColor
            textfield.textAlignment = settings.textFieldTextAlignment
            headerView.addSubview(textfield)
            
            y += 40.0
        }
        
        tableView.tableHeaderView = headerView
        
    }
    
    
    //MARK: Actions and Textfield
    
   public func addAction(_ action: DYAlertAction) {
        
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
    
    public func addOKButtonAction(_ title:String, setDisabled:Bool, okbuttonAction:(()->Void)?) {
     
        self.okButtonTitle = title
        self.okButtonDisabled = setDisabled
        self.handleOKAction = okbuttonAction

    }
    
    
    public func addTextField(textField: UITextField)  {
        
        if style == .actionSheet {
          assertionFailure("Action sheet does not support text fields. Change style to .alert instead!")

        }
        
       self.textFields.append(textField)
        
        print("counting text fields: \(self.textFields.count)")
    }
    
    //MARK: Table view data source and delegate
    
    
    fileprivate func setCellSelectedIfNeeded() {
        
        if let _ =  self.okButtonTitle{
            
            var indexCounter = -1
            for actionItem in alertActions {
                indexCounter += 1
                if actionItem.selected == true {
                    tableView.selectRow(at: IndexPath(row: indexCounter, section: 0), animated: false, scrollPosition: UITableViewScrollPosition.none)
                    
                }
            }
        }
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        self.adjustTableViewHeight()

        return alertActions.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DYActionCell") as?
        DYActionCell
        
        let actionItem = alertActions[(indexPath as NSIndexPath).row]

        cell!.configureCell(actionItem, hasAccessoryView: (okButtonTitle != nil), settings:actionCellSettings)

        return cell!
        
    }
    
    

  
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("did select...")
        
        let action = alertActions[(indexPath as NSIndexPath).row]

        if self.okButtonTitle == nil {
            tableView.deselectRow(at: indexPath, animated: true)
            self.dismiss(animated: true, completion: nil)
            action.selected = true
    
        }  else {
            
            action.selected = action.selected ? false : true
            
            if action.selected {
                tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
            } else {
                tableView.deselectRow(at: indexPath, animated: true)
            }
            
   
        }

        
        if action.handler != nil {
            action.handler!(action)
            
        }
 
    }
    

  public  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {

        if let _ = self.okButtonTitle {

            let action = alertActions[(indexPath as NSIndexPath).row]

            action.selected = false
            if action.handler != nil {
                action.handler!(action)
                
            }
            
        }
 
    }
    
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return self.getCellHeight()
        
    }
    
    
    fileprivate func getCellHeight()->CGFloat {
        
        let heightLabelFrame = CGRect(x: 0, y: 0, width: 100.0, height: 44.0)
        
        let heightLabel = UILabel(frame: heightLabelFrame)
        heightLabel.font = actionCellSettings.actionCellFont
        heightLabel.text = "Height"
        heightLabel.sizeToFit()
        return max(30.0, heightLabel.frame.size.height * 1.8)
    }
    
    //MARK: Actions
    
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
       // print("cancel button tapped")
        handleCancelAction?()
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func okButtonTapped(_ sender: UIButton) {

        handleOKAction?()
        dismiss(animated: true, completion: nil)
    }
    


    //MARK: notifications
    
    func keyboardWillShow(_ notification: Notification) {

        let info = (notification as NSNotification).userInfo!
        let value: AnyObject = info[UIKeyboardFrameEndUserInfoKey]! as AnyObject
    
        let rawFrame = value.cgRectValue
        
        let keyboardFrame = view.convert(rawFrame!, from: nil)
        
        self.contentViewCenterYtoSuperviewConstraint.constant = self.contentView.superview!.frame.size.height / 2.0 - self.contentView.frame.size.height / 2.0  - keyboardFrame.size.height - 10.0
        
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
          
            self.backgroundView.layoutIfNeeded()
          
        }) 
        
    

    }

}



//MARK: Extensions - Animated Transitioning

extension DYAlertController: UIViewControllerTransitioningDelegate {

    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        self.isPresenting = true
        
        return self
    }
    
    public  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.isPresenting = false
        
        return self
    }
    
}


extension DYAlertController: UIViewControllerAnimatedTransitioning {
    
    fileprivate func animationDuration()->TimeInterval {
        return 0.5
    }
    
    fileprivate func createDimView(_ frame: CGRect) -> UIView {
        
        let dimView = UIView(frame: frame)
        dimView.backgroundColor = settings.dimViewColor
        dimView.alpha = 0
       dimView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return dimView
    }
    
    fileprivate func createBlurView(_ frame:CGRect)->UIView{
        let blurEffect = UIBlurEffect(style: settings.blurViewStyle)
        let blurredView = UIVisualEffectView(effect: blurEffect)
        blurredView.frame = frame
        blurredView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurredView.alpha = 0
        return blurredView
        
    }
    
    fileprivate func getbackgroundEffectView(_ frame:CGRect)->UIView {
        
        var effectView:UIView = UIView()
        
        if backgroundEffectViewMode == .dim {
            effectView = self.createDimView(frame)
            
        }
        
        if backgroundEffectViewMode == .blur {
            effectView = self.createBlurView(frame)
        }
        return effectView
    }
    
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.animationDuration()
    }
    
   public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
//        guard let container = transitionContext.containerView else {
//            return transitionContext.completeTransition(false)
//        }
    
        guard let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
            return transitionContext.completeTransition(false)
        }
        
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else {
            return transitionContext.completeTransition(false)
        }
        
        if isPresenting == true {
            
            if style == .alert {
                self.presentAlertAnimation(transitionContext.containerView, fromView: fromVC.view, toView: toVC.view, completion: { (_) -> Void in
                     transitionContext.completeTransition(true)
                })
                
            } else {
                //style Action Sheet
                
                self.presentActionSheetAnimation(transitionContext.containerView, fromView: fromVC.view, toView: toVC.view, completion: { (_) -> Void in
                    
                    transitionContext.completeTransition(true)
                })
                
            }
           

            
        } else {
            
            if style == .alert {
                
                self.dismissAlertAnimation(fromVC.view, completion: { (_) -> Void in
                    transitionContext.completeTransition(true)
                })
                
            }
            
            else {
                // Action Sheet
                self.dismissActionSheetAnimation(transitionContext.containerView, toView: toVC.view, completion: { (_) -> Void in
                    transitionContext.completeTransition(true)
                })
            }

            
        }

            
    }
    
    
    fileprivate func presentAlertAnimation(_ container: UIView, fromView: UIView, toView:UIView, completion: @escaping (Bool)->Void) {
       
   
        let dimView = self.getbackgroundEffectView(container.bounds)
        
        container.addSubview(dimView)
        
        toView.frame = container.bounds
        // starting transform:
        toView.transform = fromView.transform.concatenating(CGAffineTransform(scaleX: 0.0, y: 1.0))
        // this works, too
        //CGAffineTransformConcat(CGAffineTransformMakeScale(1.0, 1.0), CGAffineTransformMakeScale(0.0, 1.0))
        container.addSubview(toView)
        
        self.animationEffectView = dimView
        
        UIView.animate(withDuration: animationDuration(), animations: { () -> Void in
            toView.transform = fromView.transform // set to original transform !
            dimView.alpha = 1.0
            }, completion: completion)
        
    }
    

    
    fileprivate func dismissAlertAnimation(_ fromView:UIView, completion: @escaping (Bool)->Void) {
        
        UIView.animate(withDuration: animationDuration(), animations: { () -> Void in
            
            fromView.transform = CGAffineTransform(scaleX: 0.01, y: 1.0)
            self.animationEffectView?.alpha = 0
            self.animationEffectView = nil
            
            }, completion: completion)

    }
    
    
    fileprivate func presentActionSheetAnimation(_ container: UIView, fromView:UIView, toView:UIView, completion: @escaping (Bool)->Void) {
        
        let effectView = self.getbackgroundEffectView(container.bounds)
  
        container.addSubview(effectView)
        
        toView.frame = container.bounds

        container.addSubview(toView)

            self.animationEffectView = effectView

        self.backgroundView.center.y = 3 * toView.center.y
        self.backgroundView.center.x = toView.center.x

           self.backgroundView.layoutIfNeeded()

        
        UIView.animate(withDuration: animationDuration(), delay: 0.0, options: .curveEaseIn, animations: { () -> Void in
    

            self.backgroundView.center = toView.center
            

        
            self.backgroundView.layoutIfNeeded()

              effectView.alpha = 1.0
            
            }, completion: completion)

        
    }
    
    fileprivate func dismissActionSheetAnimation(_ container:UIView, toView: UIView, completion:  @escaping (Bool)->Void)  {
        
        
        UIView.animate(withDuration: animationDuration(), delay: 0.0, options: .curveEaseOut, animations: { () -> Void in

            self.backgroundView.center.y = 3 * toView.center.y
            self.backgroundView.center.x = toView.center.x
            
            self.backgroundView.layoutIfNeeded()
            self.animationEffectView?.alpha = 0
            self.animationEffectView = nil
            
            }, completion: completion)
        
    }

    
}



