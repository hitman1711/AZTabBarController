//
//  ViewController.swift
//  AZTabBarController
//
//  Created by Antonio Zaitoun on 9/13/16.
//  Copyright © 2016 Crofis. All rights reserved.
//

import UIKit
import AVFoundation
import EasyNotificationBadge

public enum CenterButtonType: String {
    case checkmark = "IconCheckmark"
    case plus = "IconAdd"
    case profile = "IconUserWhite"
    case save = "IconSave"
    
    public var selected: String {
        switch self {
        case .checkmark:      return "IconCheckmark"
        case .plus:           return "IconAdd"
        case .profile:        return "IconUserSelectedWhite"
        case .save:           return "IconSave"
        }
    }
}


public typealias AZTabBarAction = () -> Void

public protocol AZTabBarDelegate: class {
    
    /// This function is called after `didMoveToTabAtIndex` is called. In order for this function to work you must override the var `childViewControllerForStatusBarStyle` in the root controller to return this instance of AZTabBarController.
    ///
    /// - Parameters:
    ///   - tabBar: The current instance of AZTabBarController.
    ///   - index: The index of the child view controller which you wish to set a status bar style for.
    /// - Returns: The status bar style.
    func tabBar(_ tabBar: AZTabBarController, statusBarStyleForIndex index: Int)-> UIStatusBarStyle
    
    
    /// This function is called whenever user clicks the menu a long click. If returned false, the action will be ignored.
    ///
    /// - Parameters:
    ///   - tabBar: The current instance of AZTabBarController.
    ///   - index: The index of the child view controller which you wish to disable the long menu click for.
    /// - Returns: true if you wish to allow long-click interaction for a specific tab, false otherwise.
    func tabBar(_ tabBar: AZTabBarController, shouldLongClickForIndex index: Int)-> Bool
    
    
    /// This function is used to enable/disable animation for a certian tab.
    ///
    /// - Parameters:
    ///   - tabBar: The current instance of AZTabBarController.
    ///   - index: The index of the tab.
    /// - Returns: true if you wish to enable the animation, false otherwise.
    func tabBar(_ tabBar: AZTabBarController, shouldAnimateButtonInteractionAtIndex index:Int)->Bool
    
    
    /// This function is used to play a sound when a certain tab is selected.
    ///
    /// - Parameters:
    ///   - tabBar: The current instance of the tab bar controller.
    ///   - index: The index you wish to play sound for.
    /// - Returns: The system sound id. if nil is returned nothing will be played.
    func tabBar(_ tabBar: AZTabBarController, systemSoundIdForButtonAtIndex index:Int)->SystemSoundID?
    
    
    /// This function is called whenever user taps one of the menu buttons.
    ///
    /// - Parameters:
    ///   - tabBar: The current instance of AZTabBarController.
    ///   - index: The index of the menu the user tapped.
    func tabBar(_ tabBar: AZTabBarController, didSelectTabAtIndex index: Int)
    
    
    /// This function is called whenever user taps and hold one of the menu buttons. Note that this function will not be called for a certain index if `shouldLongClickForIndex` is implemented and returns false for that very same index.
    ///
    /// - Parameters:
    ///   - tabBar: The current instance of AZTabBarController.
    ///   - index: The index of the menu the user long clicked.
    func tabBar(_ tabBar: AZTabBarController, didLongClickTabAtIndex index:Int)
    
    
    /// This function is called before the child view controllers are switched.
    ///
    /// - Parameters:
    ///   - tabBar: The current instance of AZTabBarController.
    ///   - index: The index of the controller which the tab bar will be switching to.
    func tabBar(_ tabBar: AZTabBarController, willMoveToTabAtIndex index:Int)
    
    
    /// This function is called after the child view controllers are switched.
    ///
    /// - Parameters:
    ///   - tabBar: The current instance of AZTabBarController.
    ///   - index: The index of the controller which the tab bar had switched to.
    func tabBar(_ tabBar: AZTabBarController, didMoveToTabAtIndex index: Int)
    
}

//The point of this extension is to make the delegate functions optional.
public extension AZTabBarDelegate{
    
    func tabBar(_ tabBar: AZTabBarController, statusBarStyleForIndex index: Int)-> UIStatusBarStyle{ return .default }
    
    func tabBar(_ tabBar: AZTabBarController, shouldLongClickForIndex index: Int)-> Bool{ return true }
    
    func tabBar(_ tabBar: AZTabBarController, shouldAnimateButtonInteractionAtIndex index:Int)->Bool{ return true }
    
    func tabBar(_ tabBar: AZTabBarController, systemSoundIdForButtonAtIndex index:Int)->SystemSoundID?{return nil}
    
    func tabBar(_ tabBar: AZTabBarController, didSelectTabAtIndex index: Int){}
    
    func tabBar(_ tabBar: AZTabBarController, didLongClickTabAtIndex index:Int){}
    
    func tabBar(_ tabBar: AZTabBarController, willMoveToTabAtIndex index:Int){}
    
    func tabBar(_ tabBar: AZTabBarController, didMoveToTabAtIndex index: Int){}
}

public class AZTabBarController: UIViewController {
    
    /*
     *  MARK: - Static instance methods
     */
    
    /// This function creates an instance of AZTabBarController using the specifed icons and inserts it into the provided view controller.
    ///
    /// - Parameters:
    ///   - parent: The controller which we are inserting our Tab Bar controller into.
    ///   - names: An array which contains the names of the icons that will be displayed as default.
    ///   - sNames: An optional array which contains the names of the icons that will be displayed when the menu is selected.
    /// - Returns: The instance of AZTabBarController which was created.
    open class func insert(into parent:UIViewController, withTabIconNames names: [String],andSelectedIconNames sNames: [String]? = nil)->AZTabBarController {
        let controller = AZTabBarController(withTabIconNames: names,highlightedIcons: sNames)
        parent.addChildViewController(controller)
        parent.view.addSubview(controller.view)
        controller.view.frame = parent.view.bounds
        controller.didMove(toParentViewController: parent)
        
        return controller
    }
    
    
    /// This function creates an instance of AZTabBarController using the specifed icons and inserts it into the provided view controller.
    ///
    /// - Parameters:
    ///   - parent: The controller which we are inserting our Tab Bar controller into.
    ///   - icons: An array which contains the images of the icons that will be displayed as default.
    ///   - sIcons: An optional array which contains the images of the icons that will be displayed when the menu is selected.
    /// - Returns: The instance of AZTabBarController which was created.
    open class func insert(into parent:UIViewController, withTabIcons icons: [UIImage],andSelectedIcons sIcons: [UIImage]? = nil)->AZTabBarController {
        let controller = AZTabBarController(withTabIcons: icons,highlightedIcons: sIcons)
        parent.addChildViewController(controller)
        parent.view.addSubview(controller.view)
        controller.view.frame = parent.view.bounds
        controller.didMove(toParentViewController: parent)
        return controller
    }
    
    /*
     * MARK: - Public Properties
     */
    
    /// The color of icon in the tab bar when the menu is selected.
    open var selectedColor:UIColor! {
        didSet{
            updateInterfaceIfNeeded()
            if didSetUpInterface , let button = (buttons[self.selectedIndex] as? UIButton) {
                button.isSelected = true
            }
        }
    }
    
    
    /// The default icon color of the buttons in the tab bar.
    open var defaultColor:UIColor! {
        didSet{
            updateInterfaceIfNeeded()
            if didSetUpInterface , let button = (buttons[self.selectedIndex] as? UIButton) {
                button.isSelected = true
            }
        }
    }
    
    open var highlightColor: UIColor! {
        didSet{
            updateInterfaceIfNeeded()
            if didSetUpInterface , let button = (buttons[self.selectedIndex] as? UIButton) {
                button.isSelected = true
            }
        }
    }
    
    /// The background color of a highlighted button.
    open var highlightedBackgroundColor: UIColor! {
        didSet{
            updateInterfaceIfNeeded()
            if didSetUpInterface , let button = (buttons[self.selectedIndex] as? UIButton) {
                button.isSelected = true
            }
        }
    }
    
    
    open var selectionIndicatorColor: UIColor!{
        didSet{
            self.updateInterfaceIfNeeded()
            if didSetUpInterface , let button = (buttons[self.selectedIndex] as? UIButton) {
                button.isSelected = true
            }
        }
    }
    
    /// The background color of the buttons in the tab bar.
    open var buttonsBackgroundColor:UIColor!{
        didSet{
            if buttonsBackgroundColor != oldValue {
                self.updateInterfaceIfNeeded()
            }
            
        }
    }
    
    open var ignoreIconColors: Bool = false {
        didSet{
            updateInterfaceIfNeeded()
            if didSetUpInterface , let button = (buttons[self.selectedIndex] as? UIButton) {
                button.isSelected = true
            }
        }
    }
    
    open var animateTabChange: Bool = false
    
    /// The current selected index.
    fileprivate (set) open var selectedIndex:Int!
    
    fileprivate (set) open var isAnimating: Bool = false
    
    
    /// If the separator line view that is between the buttons container and the primary view container is visable.
    open var separatorLineVisible:Bool = true{
        didSet{
            if separatorLineVisible != oldValue {
                self.setupSeparatorLine()
            }
        }
    }
    
    
    /// The color of the separator.
    open var separatorLineColor:UIColor!{
        didSet{
            if self.separatorLine != nil {
                self.separatorLine.backgroundColor = separatorLineColor
            }
        }
    }
    
    
    /// Change the alpha of the deselected menus that do not have actions set on them to 0.5
    open var highlightsSelectedButton:Bool = false
    
    
    /// The appearance of the notification badge.
    open var notificationBadgeAppearance: BadgeAppearnce = BadgeAppearnce()
    
    
    /// The height of the selection indicator.
    open var selectionIndicatorHeight:CGFloat = 3.0{
        didSet{
            updateInterfaceIfNeeded()
        }
    }
    
    
    /// Set the tab bar height.
    open var tabBarHeight: CGFloat{
        get{
            return self.buttonsContainerHeightConstraintInitialConstant
        }set{
            self.buttonsContainerHeightConstraintInitialConstant = newValue
            self.buttonsContainerHeightConstraint.constant = newValue
        }
    }
    
    //  Distance between center button top and tab bar top
    open var centerButtonOffsetY: CGFloat = 0
    
    /// The duration that is needed to invoke a long click.
    open var longClickTriggerDuration: TimeInterval = 0.5
    
    
    /// The duration of the starting animation.
    open var iconStartAnimationDuration: TimeInterval = 0.2
    
    
    /// The duration of the ending (spring) animation.
    open var iconEndAnimationDuration: TimeInterval = 0.25
    
    
    /// Spring damping.
    open var iconSpringWithDamping: CGFloat = 0.2
    
    
    /// Initial spring velocity.
    open var iconInitialSpringVelocity: CGFloat = 6.0
    
    
    /// The AZTabBar Delegate
    open weak var delegate: AZTabBarDelegate?
    
    /*
     * MARK: - Internal Properties
     */
    
    override public var preferredStatusBarStyle: UIStatusBarStyle{
        return self.statusBarStyle
    }
    
    override public var childViewControllerForStatusBarStyle: UIViewController?{
        return nil
    }
    
    /// A var to change the status bar appearnce
    internal var statusBarStyle: UIStatusBarStyle = .default{
        didSet{
            if oldValue != statusBarStyle {
                self.setNeedsStatusBarAppearanceUpdate()
            }
        }
    }
    
    public var centerIndex: Int { return Int(round(Double(buttons.count)/2.0)) - 1 }
    
    
    public var isCustomCenterButton: Bool {
        var result = false
        if let centerType = currentCenterButton, centerType == .checkmark || centerType == .save {
            result = true
        }
        return result
    }
    
    public func setCenterButton(type: CenterButtonType) {
        if let current = currentCenterButton, current == type {
            return
        }
        currentCenterButton = type
    }
    
    public var blackLineHidden: Bool {
        get {
            return blackLine.isHidden
        }
        set {
            blackLine.isHidden = newValue
        }
    }
    
    
    private var currentCenterButton: CenterButtonType? {
        didSet {
            guard let centerType = currentCenterButton else {  return  }
            let image = UIImage(named: centerType.rawValue)!
            
            let isHighlighted = self.highlightedButtonIndexes.contains(centerButtonOverlay)
            let highlightedImage = UIImage(named: centerType.selected)
            //.withRenderingMode(.alwaysOriginal)//selectedImages[centerIndex]
            
            var color: UIColor!
            if isHighlighted{
                color = self.highlightedBackgroundColor ?? UIColor.black
            }else{
                color = self.selectedColor ?? UIColor.black
                
            }
            //            centerButtonOverlay.setImage(ignoreIconColors ? image : image.withRenderingMode(.alwaysTemplate), for: .normal)
            //
            //            centerButtonOverlay.setImage(ignoreIconColors ? image : image.imageWithColor(color: defaultColor), for: [])
            //            centerButtonOverlay.setImage(ignoreIconColors ? image : image.imageWithColor(color: defaultColor), for: .highlighted)
            //
            //            centerButtonOverlay.setImage(ignoreIconColors ? image : image.imageWithColor(color: selectedColor), for: .selected)
            //            centerButtonOverlay.setImage(ignoreIconColors ? image : image.imageWithColor(color: selectedColor), for: [.normal, .selected, .highlighted])
            
            //            self.updateInterfaceIfNeeded()
            
            
            centerButtonOverlay.customizeForTabBarWithImage(image,
                                                            highlightImage: highlightedImage,
                                                            selectedColor: color,
                                                            highlighted: isHighlighted,
                                                            defaultColor: self.defaultColor ?? UIColor.gray,
                                                            highlightColor: self.highlightColor ?? UIColor.white,
                                                            ignoreColor: ignoreIconColors)
            //            tabItem.image = image
            //            tabItem.selectedImage = selectedImage
            //            tabItem.iconView?.icon.image = tabItem.image
            
        }
    }

    
    /// The view that holds the views of the controllers.
    fileprivate var controllersContainer:UIView!
    
    /// The view which holds the buttons.
    fileprivate var buttonsContainer:UIView!
    
    // The 1px width view at the top of buttons container
    fileprivate var blackLine:UIView!
    
    /// The separator line between the controllers container and the buttons container.
    fileprivate var separatorLine:UIView!
    
    /// NSLayoutConstraint of the height of the seperator line.
    fileprivate var separatorLineHeightConstraint:NSLayoutConstraint!
    
    /// NSLayoutConstraint of the height of the button container.
    fileprivate var buttonsContainerHeightConstraint:NSLayoutConstraint!
    
    /// Array which holds the buttons.
    internal var buttons: NSMutableArray!
    
    internal var centerButton: UIButton? {
        var resultButton: UIButton?
        if buttons.count >= 3 {
            resultButton = buttons.object(at: centerIndex) as! UIButton
        }
        return resultButton
    }
    
    /// Array which holds the default tab icons.
    internal var tabIcons: [UIImage]!
    
    /// Optional Array which holds the highlighted tab icons.
    internal var selectedTabIcons: [UIImage]?
    
    /// The view that goes inside the buttons container and indicates which menu is selected.
    internal var selectionIndicator:UIView!
    
    internal var selectionIndicatorLeadingConstraint:NSLayoutConstraint!
    
    internal var buttonsContainerHeightConstraintInitialConstant:CGFloat!
    
    internal var selectionIndicatorHeightConstraint:NSLayoutConstraint!
    
    internal var centerButtonOverlay: AZTabBarButton!
    
    /*
     * MARK: - Private Properties
     */
    
    ///Array which holds the controllers.
    fileprivate var controllers: [UIViewController?]!
    
    ///Array which holds the actions.
    fileprivate var actions: [AZTabBarAction?]!
    
    ///A flag to indicate if the interface was set up.
    fileprivate var didSetupInterface:Bool = false
    
    ///An array which keeps track of the highlighted menus.
    fileprivate var highlightedButtonIndexes:NSMutableSet!
    
    fileprivate var badgeValues: [String?]!
    
    fileprivate var tabCount: Int{ return tabIcons.count }
    
    fileprivate var didSetUpInterface = false
    
    /*
     * MARK: - Init
     */
    
    override public func loadView() {
        super.loadView()
        
        //init primary views
        self.controllersContainer = UIView()
        self.buttonsContainer = UIView()
        self.blackLine = UIView()
        self.blackLine.isHidden = true
        self.separatorLine = UIView()
        
        //add in correct hierachy
        self.buttonsContainer.addSubview(self.blackLine)
        self.view.addSubview(self.buttonsContainer)
        self.view.addSubview(self.controllersContainer)
        self.view.addSubview(self.separatorLine)
        
        //disable autoresizing mask
        self.controllersContainer.translatesAutoresizingMaskIntoConstraints = false
        self.buttonsContainer.translatesAutoresizingMaskIntoConstraints = false
        self.blackLine.translatesAutoresizingMaskIntoConstraints = false
        self.separatorLine.translatesAutoresizingMaskIntoConstraints = false
        
        //setup constraints
        let margins = self.view!
        
        self.buttonsContainer.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        self.buttonsContainer.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        self.buttonsContainer.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        self.buttonsContainer.topAnchor.constraint(equalTo: self.controllersContainer.bottomAnchor).isActive = true
        self.buttonsContainer.topAnchor.constraint(equalTo: self.separatorLine.topAnchor).isActive = true
        self.buttonsContainerHeightConstraint = self.buttonsContainer.heightAnchor.constraint(equalToConstant: 50)
        self.buttonsContainerHeightConstraint.isActive = true
        
        self.blackLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        self.blackLine.topAnchor.constraint(equalTo: self.buttonsContainer.topAnchor).isActive = true
        self.blackLine.leadingAnchor.constraint(equalTo: self.buttonsContainer.leadingAnchor).isActive = true
        self.blackLine.trailingAnchor.constraint(equalTo: self.buttonsContainer.trailingAnchor).isActive = true
        
        self.separatorLine.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        self.separatorLine.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        self.separatorLineHeightConstraint = separatorLine.heightAnchor.constraint(equalToConstant: 1)
        self.separatorLineHeightConstraint.isActive = true
        
        self.controllersContainer.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        self.controllersContainer.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        self.controllersContainer.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
    }
    
    /// Public initializer that creates a controller using tabIcons and (optional) highlightedIcons.
    ///
    /// - Parameters:
    ///   - tabIcons: The default icons of the tabs.
    ///   - highlightedIcons: The icons of the tabs when selected.
    public init(withTabIcons tabIcons: [UIImage],highlightedIcons: [UIImage]? = nil) {
        super.init(nibName: nil,bundle: nil)
        self.initialize(withTabIcons: tabIcons,highlightedIcons: highlightedIcons)
    }
    
    
    /// Public initializer that creates a controller using tabIcons and (optional) highlightedIcon names.
    ///
    /// - Parameters:
    ///   - iconNames: The names of the icons.
    ///   - highlightedIcons: The names of the highlighted icons.
    public convenience init(withTabIconNames iconNames: [String],highlightedIcons: [String]? = nil) {
        var icons = [UIImage]()
        for name in iconNames {
            icons.append(UIImage(named: name)!)
        }
        
        var highlighted: [UIImage]?
        if let imageNames = highlightedIcons{
            highlighted = [UIImage]()
            for name in imageNames{
                highlighted?.append(UIImage(named: name)!)
            }
        }
        
        self.init(withTabIcons: icons,highlightedIcons: highlighted)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
     * MARK: - UIViewController
     */
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.buttonsContainerHeightConstraintInitialConstant = self.buttonsContainerHeightConstraint.constant
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !didSetUpInterface {
            self.setupInterface()
            self.moveToController(at: selectedIndex, animated: false)
            
            if let badgeValues = badgeValues {
                for i in 0..<badgeValues.count{
                    if let value = badgeValues[i]{
                        self.setBadgeText(value, atIndex: i)
                    }
                }
                self.badgeValues = nil
            }
            didSetUpInterface = true
        }
    }
    
    override public func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        // When rotating, have to update the selection indicator leading to match
        // the selected button x, that might have changed because of the rotation.
        
        let selectedButtonX: CGFloat = (self.buttons[self.selectedIndex] as! UIButton).frame.origin.x
        
        if self.selectionIndicatorLeadingConstraint.constant != selectedButtonX {
            UIView.animate(withDuration: 0.1, animations: {() -> Void in
                self.selectionIndicatorLeadingConstraint.constant = selectedButtonX
                self.view.layoutIfNeeded()
            })
        }
    }
    
    /*
     * MARK: - AZTabBarController
     */
    
    /// Set a UIViewController at an index.
    ///
    /// - Parameters:
    ///   - controller: The view controller which you wish to display at a certain index.
    ///   - index: The index of the menu.
    open func setViewController(_ controller: UIViewController, atIndex index: Int) {
        if let currentViewController = self.controllers[index]{
            currentViewController.removeFromParentViewController()
        }
        self.controllers[index] = controller
        self.addChildViewController(controller)
        if index == self.selectedIndex {
            // If the index is the selected one, we have to update the view
            // controller at that index so that the change is reflected.
            self.moveToController(at: index, animated: false)
        }
    }
    
  
    /// Change the current menu programatically.
    ///
    /// - Parameters:
    ///   - index: The index of the menu.
    ///   - animated: animate the selection indicator or not.
    open func setIndex(_ index:Int,animated: Bool = true){
        
        if index >= tabCount{
            return
        }
        
        if index == centerIndex, let action = actions[centerIndex] {
            action()
            return
        }
        if self.selectedIndex != index {
            moveToController(at: index, animated: animated)
        }
        
        if let action = actions[index] {
            action()
        }
    }
    
    
    /// Set an action at a certain index.
    ///
    /// - Parameters:
    ///   - action: A closure which contains the action that will be executed when clicking the menu at a certain index.
    ///   - index: The index of the menu of which you would like to add an action to.
    open func setAction(atIndex index: Int, action: @escaping AZTabBarAction) {
        self.actions[(index)] = action
    }
    
    open func removeAction(atIndex index: Int) {
        self.actions[(index)] = nil
    }
    
    
    /// Set a badge with a text on a menu at a certain index. In order to remove an existing badge use `nil` for the `text` parameter.
    ///
    /// - Parameters:
    ///   - text: The text you wish to set.
    ///   - index: The index of the menu in which you would like to add the badge.
    open func setBadgeText(_ text: String?, atIndex index:Int){
        if let buttons = buttons{
            if let button = buttons[index] as? UIButton {
                self.notificationBadgeAppearance.distenceFromCenterX = 15
                self.notificationBadgeAppearance.distenceFromCenterY = -10
                button.badge(text: text, appearnce: self.notificationBadgeAppearance)
            }
        }else{
            self.badgeValues[index] = text
        }
    }
    

    /// Make a button look highlighted.
    ///
    /// - Parameter index: The index of the button which you would like to highlight.
    open func highlightButton(atIndex index: Int) {
        self.highlightedButtonIndexes.add(index)
        self.updateInterfaceIfNeeded()
    }
    
    
    /// Set a tint color for a button at a certain index.
    ///
    /// - Parameters:
    ///   - color: The color which you would like to set as tint color for the button at a certain index.
    ///   - index: The index of the button.
    open func setButtonTintColor(color: UIColor, atIndex index: Int) {
        if !self.highlightedButtonIndexes.contains((index)) {
            let button:UIButton = self.buttons[index] as! UIButton
            button.tintColor! = color
            let buttonImage = button.image(for: .normal)!
            button.setImage(buttonImage.withRenderingMode(.alwaysTemplate), for: .normal)
            button.setImage(buttonImage.withRenderingMode(.alwaysTemplate), for: .selected)
        }
    }
    
    
    /// Show and hide the tab bar.
    ///
    /// - Parameters:
    ///   - hidden: To hide or show.
    ///   - animated: To animate or not.
    open func setBar(hidden: Bool, animated: Bool,duration: TimeInterval = 0.3, completion: ((Bool)->Void)? = nil) {
        let animations = {() -> Void in
            self.centerButtonOverlay.alpha = hidden ? 0.0 : 1.0
            self.centerButtonOverlay.isHidden = hidden
            self.buttonsContainerHeightConstraint.constant = hidden ? 0 : self.buttonsContainerHeightConstraintInitialConstant
            self.view.layoutIfNeeded()
        }
        if animated {
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: duration, animations: animations, completion: completion)
        }
        else {
            animations()
        }
    }
    
    /*
     * MARK: - Actions
     */
    
    
    func tabButtonAction(button:UIButton){
        let index = (button == self.centerButtonOverlay) ? centerIndex : self.buttons.index(of: button)
        delegate?.tabBar(self, didSelectTabAtIndex: index)
        
        if let id = delegate?.tabBar(self, systemSoundIdForButtonAtIndex: index), !isAnimating{
            AudioServicesPlaySystemSound(id)
        }
        
        if index != NSNotFound {
            self.setIndex(index, animated: true)
        }
    }
    
    func longClick(sender:AnyObject?){
        let button = sender as! UIButton
        let index = self.buttons.index(of: button)
        
        if let delegate = delegate{
            if !delegate.tabBar(self, shouldLongClickForIndex: index) {
                return
            }
        }
        
        delegate?.tabBar(self, didLongClickTabAtIndex: index)
        
        
        if selectedIndex != index {
            tabButtonAction(button: button)
        }
        
    }
    
    /*
     * MARK: - Private methods
     */
    
    private func initialize(withTabIcons tabIcons:[UIImage],highlightedIcons: [UIImage]? = nil){
        assert(tabIcons.count > 0, "The array of tab icons shouldn't be empty.")
        
        if let highlightedIcons = highlightedIcons {
            assert(tabIcons.count == highlightedIcons.count,"Default and highlighted icons must come in pairs.")
        }
        
        self.badgeValues = [String?](repeating: nil, count: tabIcons.count)
        
        self.tabIcons = tabIcons
        
        self.selectedTabIcons = highlightedIcons
        
        self.controllers = [UIViewController?](repeating: nil, count: tabIcons.count)
        
        self.actions = [AZTabBarAction?](repeating: nil, count: tabIcons.count)
        
        self.highlightedButtonIndexes = NSMutableSet()
        
        self.selectedIndex = 0
        
        self.separatorLineColor = UIColor.lightGray
        
        self.modalPresentationCapturesStatusBarAppearance = true
        
    }
    
    private func updateInterfaceIfNeeded() {
        
//        let centerBtnExist = (self.buttons.count > self.centerIndex)
//        if centerBtnExist {
//            self.view.bringSubview(toFront: (self.buttons[centerIndex] as! UIButton))
//            (self.buttons[centerIndex] as! UIButton).layer.zPosition = 1
//        } 
        if self.didSetupInterface {
            // If the UI was already setup, it's necessary to update it.
            self.setupInterface()
            
            if (self.buttons.count > self.centerIndex) {
                self.view.bringSubview(toFront: (self.buttons[centerIndex] as! UIButton))
                (self.buttons[centerIndex] as! UIButton).layer.zPosition = 1
            }
        }
    }
    
    private func setupInterface() {
        self.blackLine.backgroundColor = UIColor(white: 0, alpha: 0.7)
        self.setupButtons()
        self.setupSelectionIndicator()
        self.setupSeparatorLine()
        self.didSetupInterface = true
    }
    
    
    private func setupButtons(){
        
        if self.buttons == nil {
            self.buttons = NSMutableArray(capacity: self.tabIcons.count)
            
            for i in 0 ..< self.tabIcons.count {
                
                let button:UIButton = self.createButton(forIndex: i)

                self.buttonsContainer.addSubview(button)
                self.buttons[i] = button
                if i == centerIndex {
                    self.centerButtonOverlay = AZTabBarButton(type: .custom)
                    self.centerButtonOverlay.delegate = self
                    self.centerButtonOverlay.tag = i
                    self.centerButtonOverlay.isExclusiveTouch = true
                    self.centerButtonOverlay.imageView?.contentMode = .scaleAspectFit
                    self.centerButtonOverlay.addTarget(self, action: #selector(self.tabButtonAction(button:)), for: .touchUpInside)
                    self.view.addSubview(centerButtonOverlay)
                }
            }
            self.setupButtonsConstraints()
        }
        self.customizeButtons()
        
        self.buttonsContainer.backgroundColor = self.buttonsBackgroundColor != nil ? self.buttonsBackgroundColor : UIColor.lightGray
    }
    
    private func customizeButtons(){
        for i in 0 ..< self.tabIcons.count {
            let button:AZTabBarButton = self.buttons[i] as! AZTabBarButton
            
            let isHighlighted = self.highlightedButtonIndexes.contains(i)
            
            var highlightedImage: UIImage?
            if let selectedImages = self.selectedTabIcons {
                highlightedImage = selectedImages[i]
            }
            var color: UIColor!
            
            if isHighlighted{
                color = self.highlightedBackgroundColor ?? UIColor.black
            }else{
                color = self.selectedColor ?? UIColor.black
            }

            if i == centerIndex {
                button.isHidden = true
                centerButtonOverlay.customizeForTabBarWithImage(self.tabIcons[i],
                                                                highlightImage: highlightedImage,
                                                                selectedColor: color,
                                                                highlighted: isHighlighted,
                                                                defaultColor: self.defaultColor ?? UIColor.gray,
                                                                highlightColor: self.highlightColor ?? UIColor.white,
                                                                ignoreColor: ignoreIconColors)
                customizeCenterButtonBackground(button: self.centerButtonOverlay)
            } else {
                button.customizeForTabBarWithImage(self.tabIcons[i],
                           highlightImage: highlightedImage,
                           selectedColor: color,
                           highlighted: isHighlighted,
                           defaultColor: self.defaultColor ?? UIColor.gray,
                           highlightColor: self.highlightColor ?? UIColor.white,
                           ignoreColor: ignoreIconColors)
            }
        }
    }
    
    private var backLayer: CALayer?
    
    private func customizeCenterButtonBackground(button: AZTabBarButton) {
        if let plusImgView = button.imageView {
            let imgSize = plusImgView.frame.size
            let halfSize: CGFloat = (min( imgSize.width/2, imgSize.height/2)) * 1.2
            let backSize = imgSize.width * 1.2
            
            if backLayer == nil {
                backLayer = CALayer()
                backLayer!.backgroundColor = buttonsBackgroundColor.cgColor
                backLayer!.cornerRadius = halfSize
                backLayer!.shadowColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1).cgColor
                backLayer!.shadowOpacity = 0.35
                backLayer!.shadowRadius = 1.5
                backLayer!.shadowOffset = CGSize(width: 0, height: -2.5)
            }
            if backLayer!.superlayer == nil {
                button.layer.insertSublayer(backLayer!, at: 0)
            }
            
            var imgLayerFrame = plusImgView.layer.frame
            imgLayerFrame.size.width *= 1.17
            imgLayerFrame.size.height *= 1.17
            imgLayerFrame.origin.x -= (imgLayerFrame.size.width - plusImgView.layer.frame.size.width) / 2
            imgLayerFrame.origin.y -= (imgLayerFrame.size.height - plusImgView.layer.frame.size.height) / 2
            backLayer!.frame = imgLayerFrame
        }
    }
    
    private func createButton(forIndex index:Int)-> UIButton{
        let button = AZTabBarButton(type: .custom)
        button.tag = index
        button.imageView?.contentMode = .scaleAspectFit
        if index != centerIndex {
            button.delegate = self
            button.isExclusiveTouch = true
            button.addTarget(self, action: #selector(self.tabButtonAction(button:)), for: .touchUpInside)
        }
        return button
    }
    
    private func moveToController(at index:Int,animated:Bool){
        if let controller = controllers[index], !(animated && isAnimating) {
            
            if buttons == nil{
                selectedIndex = index
                return
            }
            
            // Deselect all the buttons excepting the selected one.
            for i in 0 ..< self.tabIcons.count{
                
                let button:UIButton = self.buttons[i] as! UIButton
                
                let selected:Bool = i == index
                
                button.isSelected = selected
                
                if self.highlightsSelectedButton && !(self.actions[i] != nil && self.controllers[i] != nil){
                    button.alpha = selected ? 1.0 : 0.5
                }
                
            }
            
            delegate?.tabBar(self, willMoveToTabAtIndex: index)
            
            
            var currentViewControllerView: UIView?
            
            if self.selectedIndex >= 0 {
                let currentController:UIViewController = self.controllers[selectedIndex]!
                currentViewControllerView = currentController.view
                if !animateTabChange {
                    currentController.view.removeFromSuperview()
                }
                //currentController.removeFromParentViewController()
            }
            
            
            if !self.childViewControllers.contains(controller){
                controller.willMove(toParentViewController: self)
            }
            
            if NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1 {
                // Table views have an issue when disabling autoresizing
                // constraints in iOS 7.
                // Their width is set to zero initially and then it's not able to
                // adjust it again, causing constraint conflicts with the cells
                // inside the table.
                // For this reason, we just adjust the frame to the container
                // bounds leaving the autoresizing constraints enabled.
                controller.view.frame = self.controllersContainer.bounds
                self.controllersContainer.addSubview(controller.view)
                
            }else{
                controller.view.translatesAutoresizingMaskIntoConstraints = false
                self.controllersContainer.addSubview(controller.view)
                self.setupConstraints(forChildController: controller)
            }
            //self.addChildViewController(controller)
            controller.didMove(toParentViewController: self)
            
                if let currentViewControllerView = currentViewControllerView, animated, animateTabChange {
                    //animate
                    
                    let offset: CGFloat = self.view.frame.size.width / 5
                    //let startX = index > selectedIndex ? self.view.frame.size.width + offset : -offset
                    let startX = index > selectedIndex ? offset : -offset
                    controller.view.transform = CGAffineTransform(translationX: startX, y: 0)
                    controller.view.alpha = 0
                    
                    UIView.animate(withDuration: 0.2, animations: {
                        self.isAnimating = true
                        controller.view.transform = .identity
                        controller.view.alpha = 1
                        currentViewControllerView.transform = CGAffineTransform(translationX: -startX, y: 0)
                    }, completion: { (bool) in
                        self.isAnimating = false
                        currentViewControllerView.removeFromSuperview()
                    })
                }

            
            self.moveSelectionIndicator(toIndex: index,animated:animated)
            self.selectedIndex = index
            delegate?.tabBar(self, didMoveToTabAtIndex: index)
            self.statusBarStyle = delegate?.tabBar(self, statusBarStyleForIndex: index) ?? .default
            self.updateInterfaceIfNeeded()
            
        }
        
    }
    
    private func setupSelectionIndicator() {
        if self.selectionIndicator == nil {
            self.selectionIndicator = UIView()
            self.selectionIndicator.translatesAutoresizingMaskIntoConstraints = false
            self.buttonsContainer.addSubview(self.selectionIndicator)
            self.setupSelectionIndicatorConstraints()
        }
        self.selectionIndicatorHeightConstraint.constant = self.selectionIndicatorHeight
        self.selectionIndicator.backgroundColor = self.selectionIndicatorColor ?? UIColor.black
    }
    
    private func setupSeparatorLine() {
        self.separatorLine.backgroundColor = self.separatorLineColor
        self.separatorLine.isHidden = !self.separatorLineVisible
        self.separatorLineHeightConstraint.constant = 0.5
    }
    
    private func moveSelectionIndicator(toIndex index: Int,animated:Bool){
        let constant:CGFloat = (self.buttons[index] as! UIButton).frame.origin.x
        
        self.buttonsContainer.layoutIfNeeded()
        
        let animations = {() -> Void in
            self.selectionIndicatorLeadingConstraint.constant = constant
            self.buttonsContainer.layoutIfNeeded()
            self.updateInterfaceIfNeeded()
        }
        
        if animated {
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: animations, completion: { _ in })
        }
        else {
            animations()
        }
    }
}

extension AZTabBarController: AZTabBarButtonDelegate{
    
    internal func beginAnimationDuration(_ tabBarButton: AZTabBarButton) -> TimeInterval {
        return self.iconStartAnimationDuration
    }
    
    internal func endAnimationDuration(_ tabBarButton: AZTabBarButton) -> TimeInterval {
        return self.iconEndAnimationDuration
    }

    internal func usingSpringWithDamping(_ tabBarButton: AZTabBarButton) -> CGFloat {
        return self.iconSpringWithDamping
    }

    internal func initialSpringVelocity(_ tabBarButton: AZTabBarButton) -> CGFloat {
        return self.iconInitialSpringVelocity
    }
    
    internal func longClickTriggerDuration(_ tabBarButton: AZTabBarButton) -> TimeInterval {
        return self.longClickTriggerDuration
    }

    internal func longClickAction(_ tabBarButton: AZTabBarButton) {
        self.longClick(sender: tabBarButton)
    }

    internal func shouldLongClick(_ tabBarButton: AZTabBarButton) -> Bool {
        return delegate?.tabBar(self, shouldLongClickForIndex: tabBarButton.tag) ?? false
    }

    internal func shouldAnimate(_ tabBarButton: AZTabBarButton) -> Bool {
        if tabBarButton.tag == selectedIndex || self.highlightedButtonIndexes.contains(tabBarButton.tag) || isAnimating{
            return false
        }
        return delegate?.tabBar(self, shouldAnimateButtonInteractionAtIndex: tabBarButton.tag) ?? false
    }
}

/*
 * MARK: - AutoLayout
 */

fileprivate extension AZTabBarController {
    
    /*
     * MARK: - Public Methods
     */
    
    func setupButtonsConstraints(){
        for i in 0 ..< self.tabIcons.count {
            let button:UIButton = self.buttons[i] as! UIButton
            
            button.translatesAutoresizingMaskIntoConstraints = false
            
            self.view.addConstraints(self.leftLayoutConstraintsForButtonAtIndex(index: i))
            self.view.addConstraints(self.verticalLayoutConstraintsForButtonAtIndex(index: i))
            self.view.addConstraint(self.widthLayoutConstraintForButtonAtIndex(index: i))
            self.view.addConstraint(self.heightLayoutConstraintForButtonAtIndex(index: i))
            
            if i == centerIndex {
//                let bounds = self.buttonsContainer.convert(button.frame, to: self.view)
                centerButtonOverlay.translatesAutoresizingMaskIntoConstraints = false
                centerButtonOverlay.topAnchor.constraint(equalTo: button.topAnchor).isActive = true
                centerButtonOverlay.bottomAnchor.constraint(equalTo: button.bottomAnchor).isActive = true
                centerButtonOverlay.leadingAnchor.constraint(equalTo: button.leadingAnchor).isActive = true
                centerButtonOverlay.trailingAnchor.constraint(equalTo: button.trailingAnchor).isActive = true
            }
        }
    }
    
    func setupSelectionIndicatorConstraints(){
        self.selectionIndicatorLeadingConstraint = self.leadingLayoutConstraintForIndicator()
        
        self.buttonsContainer.addConstraint(self.selectionIndicatorLeadingConstraint)
        self.buttonsContainer.addConstraints(self.widthLayoutConstraintsForIndicator())
        self.buttonsContainer.addConstraints(self.heightLayoutConstraintsForIndicator())
        self.buttonsContainer.addConstraints(self.bottomLayoutConstraintsForIndicator())
    }
    
    func setupConstraints(forChildController controller: UIViewController) {
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: [], metrics: nil, views: ["view": controller.view])
        self.controllersContainer.addConstraints(horizontalConstraints)
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: [], metrics: nil, views: ["view": controller.view])
        self.controllersContainer.addConstraints(verticalConstraints)
    }
    
    /*
     * MARK: - Private Methods
     */
    private func leftLayoutConstraintsForButtonAtIndex(index: Int)-> [NSLayoutConstraint]{
        let button:UIButton = self.buttons[index] as! UIButton
        let offset: CGFloat = self.view.frame.width / 3
        
        var leftConstraints:[NSLayoutConstraint]!
        
        if index == 0 {
            leftConstraints = NSLayoutConstraint.constraints(withVisualFormat: "|-(0)-[button]", options: [], metrics: nil, views: ["button": button])
//        }
//        else if index == centerIndex {
//            leftConstraints = [button.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: offset)]
//            leftConstraints = NSLayoutConstraint.constraints(withVisualFormat: "|-offset-[button]", options: [], metrics: ["offset": offset], views: ["button": button])
        } else {
            let views = ["previousButton": self.buttons[index - 1], "button": button]
            leftConstraints = NSLayoutConstraint.constraints(withVisualFormat: "[previousButton]-(0)-[button]", options: [], metrics: nil, views: views)
        }
        return leftConstraints
    }
    
    private func verticalLayoutConstraintsForButtonAtIndex(index: Int)-> [NSLayoutConstraint]{
        let button:UIButton = self.buttons[index] as! UIButton
        var offsetY: CGFloat = 0
        if index == centerIndex {
            offsetY = self.centerButtonOffsetY
        }
        return NSLayoutConstraint.constraints(withVisualFormat: "V:|-offsetY-[button]", options: [], metrics: ["offsetY": offsetY], views: ["button": button])
//        }
    }
    
    private func widthLayoutConstraintForButtonAtIndex(index: Int)->NSLayoutConstraint {
        let button:UIButton = self.buttons[index] as! UIButton
        let sizePercents = 1.0 / CGFloat(self.buttons.count)
//        if index == centerIndex {
//            return button.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: sizePercents)
//        } else {
            return NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: self.buttonsContainer, attribute: .width, multiplier: sizePercents, constant: 0.0)
//        }
    }
    
    private func heightLayoutConstraintForButtonAtIndex(index: Int)-> NSLayoutConstraint {
        let button:UIButton = self.buttons[index] as! UIButton
        
        return NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: self.buttonsContainerHeightConstraintInitialConstant)
    }
    
    private func leadingLayoutConstraintForIndicator()->NSLayoutConstraint {
        let constraints = NSLayoutConstraint.constraints(withVisualFormat: "|-(0)-[selectionIndicator]", options: [], metrics: nil, views: ["selectionIndicator": self.selectionIndicator])
        
        return constraints.first!
    }
    
    private func widthLayoutConstraintsForIndicator()-> [NSLayoutConstraint]{
        let views = ["button": self.buttons[0], "selectionIndicator": self.selectionIndicator]
        
        return NSLayoutConstraint.constraints(withVisualFormat: "[selectionIndicator(==button)]", options: [], metrics: nil, views: views)
    }
    
    private func heightLayoutConstraintsForIndicator()-> [NSLayoutConstraint] {
        let heightConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[selectionIndicator(==3)]", options: [], metrics: nil, views: ["selectionIndicator": self.selectionIndicator])
        
        self.selectionIndicatorHeightConstraint = heightConstraints.first!
        
        return heightConstraints
    }
    
    private func bottomLayoutConstraintsForIndicator()-> [NSLayoutConstraint] {
        return NSLayoutConstraint.constraints(withVisualFormat: "V:[selectionIndicator]-(0)-|", options: [], metrics: nil, views: ["selectionIndicator": self.selectionIndicator])
    }
}

/*
 * MARK: - Button Extension
 */

protocol AZTabBarButtonDelegate: class {
    
    
    /// Function used to decide if the TabBarButton should animate upon interaction.
    ///
    /// - Parameter tabBarButton: The sender.
    func shouldAnimate(_ tabBarButton: AZTabBarButton)->Bool
    
    
    /// The start animation duration.
    ///
    /// - Parameter tabBarButton: The sender.
    func beginAnimationDuration(_ tabBarButton: AZTabBarButton)->TimeInterval
    
    
    /// The ending animation duration.
    ///
    /// - Parameter tabBarButton: The sender.
    func endAnimationDuration(_ tabBarButton: AZTabBarButton)->TimeInterval
    
    
    /// The initial Spring Velocity for the ending animation.
    ///
    /// - Parameter tabBarButton: The sender.
    func initialSpringVelocity(_ tabBarButton: AZTabBarButton)->CGFloat
    
    
    /// The Spring Damping value.
    ///
    /// - Parameter tabBarButton: The sender.
    /// - Returns: The value of the damping
    func usingSpringWithDamping(_ tabBarButton: AZTabBarButton)->CGFloat
    
    
    /// Function used to decide if the action of the button can be triggered using a long click gesture.
    ///
    /// - Parameter tabBarButton: The sender.
    /// - Returns: True if you wish to enable long-click-gesture for the button.
    func shouldLongClick(_ tabBarButton: AZTabBarButton)->Bool
    
    
    /// Set the duration that takes for the long click gesture to be triggered.
    ///
    /// - Parameter tabBarButton: The sender.
    /// - Returns: The duration that takes for the long click gesture to be triggered.
    func longClickTriggerDuration(_ tabBarButton: AZTabBarButton)-> TimeInterval
    
    
    /// A function that is invoked when long-click gesture occurs.
    ///
    /// - Parameter tabBarButton: The sender.
    func longClickAction(_ tabBarButton: AZTabBarButton)
}

class AZTabBarButton: UIButton{
    
    var longClickTimer: Timer?
    
    open weak var delegate:AZTabBarButtonDelegate!
    
    open var shouldAnimateInteraction:Bool {
        get{
            return delegate.shouldAnimate(self)
        }
    }
    
    open var beginAnimationDuration: TimeInterval{
        get{
            return delegate.beginAnimationDuration(self)
        }
    }
    
    open var endAnimationDuration: TimeInterval{
        get{
            return delegate.endAnimationDuration(self)
        }
    }
    
    open var initialSpringVelocity: CGFloat{
        get{
            return delegate.initialSpringVelocity(self)
        }
    }
    
    open var usingSpringWithDamping: CGFloat{
        get{
            return delegate.usingSpringWithDamping(self)
        }
    }
    
    open var longClickTriggerDuration: TimeInterval{
        get{
            return delegate.longClickTriggerDuration(self)
        }
    }
    
    open var isLongClickEnabled: Bool{
        get{
            return delegate.shouldLongClick(self)
        }
    }
    
    func longClickPerformed(){
        if isLongClickEnabled{
            self.touchesCancelled(Set<UITouch>(), with: nil)
            self.delegate.longClickAction(self)
        }
        
    }
    
}

extension AZTabBarButton {
    // MARK: - Public methods
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        longClickTimer = Timer.scheduledTimer(timeInterval: self.longClickTriggerDuration,
                                              target: self,
                                              selector: #selector(longClickPerformed),
                                              userInfo: nil, repeats: false)
        if self.shouldAnimateInteraction{
            UIView.animate(withDuration: self.beginAnimationDuration, animations: {
                self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }) { (complete) in
            }
        }
        super.touchesBegan(touches, with: event)
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let tap:UITouch = touches.first!
        let point = tap.location(in: self)
        //longClickTimer?.invalidate()
        if !self.bounds.contains(point){
            if self.shouldAnimateInteraction{
                UIView.animate(withDuration: self.beginAnimationDuration, animations: {
                    self.transform = .identity
                }) { (complete) in
                }
            }
        }else{
            if self.shouldAnimateInteraction{
                UIView.animate(withDuration: self.beginAnimationDuration, animations: {
                    self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                }) { (complete) in
                }
            }
        }
        
        
        super.touchesMoved(touches, with: event)
        
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //let tap:UITouch = touches.first!
        //let point = tap.location(in: self)
        longClickTimer?.invalidate()
        if self.shouldAnimateInteraction{
            UIView.animate(withDuration: self.endAnimationDuration,
                           delay: 0,
                           usingSpringWithDamping: self.usingSpringWithDamping,
                           initialSpringVelocity: self.initialSpringVelocity,
                           options: .allowUserInteraction,
                           animations: {
                            self.transform = .identity
            },
                           completion: nil)
        }
        super.touchesEnded(touches, with: event)
        
    }
    
    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        longClickTimer?.invalidate()
        if self.shouldAnimateInteraction{
            UIView.animate(withDuration: self.endAnimationDuration,
                           delay: 0,
                           usingSpringWithDamping: self.usingSpringWithDamping,
                           initialSpringVelocity: self.initialSpringVelocity,
                           options: .allowUserInteraction,
                           animations: {
                            self.transform = .identity
            },
                           completion: nil)
        }
        super.touchesCancelled(touches, with: event)
    }
    
    func customizeForTabBarWithImage(_ image: UIImage,
                                     highlightImage: UIImage? = nil,
                                     selectedColor: UIColor,
                                     highlighted: Bool,
                                     defaultColor: UIColor = UIColor.gray,
                                     highlightColor: UIColor = UIColor.white,
                                     ignoreColor: Bool = false) {
        if highlighted {
            self.customizeAsHighlighted(image: image, selectedColor: selectedColor, highlightedColor: highlightColor,ignoreColor: ignoreColor)
        }
        else {
            self.customizeAsNormal(image: image,highlightImage: highlightImage, selectedColor: selectedColor,defaultColor: defaultColor, ignoreColor: ignoreColor)
        }
    }
    // MARK: - Private methods
    
    private func customizeAsHighlighted(image: UIImage,selectedColor: UIColor,highlightedColor: UIColor,ignoreColor: Bool = false) {
        // We want the image to be always white in highlighted state.
        self.tintColor = highlightedColor
        self.setImage(ignoreColor ? image : image.withRenderingMode(.alwaysTemplate), for: .normal)
        // And its background color should always be the selected color.
        self.backgroundColor = selectedColor
    }
    
    private func customizeAsNormal(image: UIImage,highlightImage: UIImage? = nil,selectedColor: UIColor,defaultColor: UIColor = UIColor.gray,ignoreColor: Bool = false) {

        self.tintColor = selectedColor
        
        self.setImage(ignoreColor ? image : image.imageWithColor(color: defaultColor), for: [])
        self.setImage(ignoreColor ? image : image.imageWithColor(color: defaultColor), for: .highlighted)
        if let hImage = highlightImage {
            self.setImage(ignoreColor ? hImage : hImage.imageWithColor(color: selectedColor), for: .selected)
            self.setImage(ignoreColor ? hImage : hImage.imageWithColor(color: selectedColor), for: [.selected, .highlighted])
        }else{
            self.setImage(ignoreColor ? image : image.imageWithColor(color: selectedColor), for: .selected)
            self.setImage(ignoreColor ? image : image.imageWithColor(color: selectedColor), for: [.selected, .highlighted])
        }
        
        // We don't want a background color to use the one in the tab bar.
        self.backgroundColor = UIColor.clear
    }
}

fileprivate extension UIImage {
    func imageWithColor(color: UIColor) -> UIImage? {
        var image = withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.set()
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

public extension UIViewController{
    
    public var currentTabBar: AZTabBarController?{
        var current: UIViewController? = parent
        
        repeat{
            if current is AZTabBarController{ return current as? AZTabBarController }
            current = current?.parent
        }while current != nil
        
        return nil
    }
}


