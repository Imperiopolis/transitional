//
//  Transitional.swift
//  Transitional
//
//  Created by Nora Trapp on 6/23/15.
//  Copyright (c) 2015 Trapp Design. All rights reserved.
//

import UIKit

@objc public enum TransitionalAnimationStyle: Int, Equatable, CustomStringConvertible {
    case slideDown
    case slideUp
    case flipFromLeft
    case flipFromRight
    case zoomIn
    case zoomOut
    case custom

    public var description: String {
        switch self {
        case .slideDown:
            return "Slide Down"
        case .slideUp:
            return "Slide Up"
        case .flipFromLeft:
            return "Flip From Left"
        case .flipFromRight:
            return "Flip From Right"
        case .zoomIn:
            return "Zoom In"
        case .zoomOut:
            return "Zoom Out"
        case .custom:
            return "Custom"
        }
    }
}

extension UIViewController: Transitional {
    
    /* Modal Transitions */
    public func transitionalPresentation(_ viewController: UIViewController, style: TransitionalAnimationStyle) {
        transitionalPresentation(style, fromViewController: self, toViewController: viewController)
    }
    
    public func transitionalCustomPresentation(_ viewController: UIViewController, duration: TimeInterval, animation: @escaping (_ transition: Transition) -> ()) {
        transitionalCustomPresentation(fromViewController: self, toViewController: viewController, duration: duration, animation: animation)
    }
    
    public func transitionalDismissal(_ style: TransitionalAnimationStyle) {
        if let presentedViewController = presentedViewController {
            transitionalDismissal(fromViewController: presentedViewController, toViewController: self, style: style)
        } else if let presentingViewController = presentingViewController {
            transitionalDismissal(fromViewController: self, toViewController: presentingViewController, style: style)
        } else {
//            fatalError("Cannot dismiss view that is not presented.")
        }
    }
    
    public func transitionalCustomDismissal(_ duration: TimeInterval, animation: @escaping (_ transition: Transition) -> ()) {
        if let presentedViewController = presentedViewController {
            transitionalCustomDismissal(fromViewController: presentedViewController, toViewController: self, duration: duration, animation: animation)
        } else if let presentingViewController = presentingViewController {
            transitionalCustomDismissal(fromViewController: self, toViewController: presentingViewController, duration: duration, animation: animation)
        } else {
            //            fatalError("Cannot dismiss view that is not presented.")
        }
    }
    
    public func transitionalNavigationController() -> UINavigationController? {
        return navigationController
    }
}

public protocol Transitional {
    
    /* Navigation Controller Transitions */
    
    /**
    Defines the navigation controller to use for push/pop transitions.
    
    - returns: A UINavigationController to use for push/pop, or nil
    */
    func transitionalNavigationController() -> UINavigationController?
    
    /**
    Push a view controller onto the navigation controller stack with a transitional animation.
    
    - parameter viewController: View controller to push
    - parameter style:          Animation style

    */
    func transitionalPush(_ viewController: UIViewController, style: TransitionalAnimationStyle)
    
    /**
    Pop the top view controller from the navigation controller stack with a transitional animation.
    
    - parameter style: Animation style
    
    */
    func transitionalPop(_ style: TransitionalAnimationStyle)
    
    /**
    Pop to a specific view controller in the navigation stack with a transitional animation.
    
    - parameter viewController: View controller to pop to
    - parameter style:          Animation style
    
    - returns: An array of view controllers that were popped to reach the target view controller.
    */
    func transitionalPopToViewController(_ viewController: UIViewController, style: TransitionalAnimationStyle) -> [UIViewController]
    
    /**
    Pop to the root view controller within the navigation stack with a transitional animation.
    
    - parameter style: Animation style
    
    - returns: An array of view controllers that were popped to reach the target view controller.
    */
    func transitionalPopToRoot(_ style: TransitionalAnimationStyle) -> [UIViewController]
    
    /* Modal Transitions */
    
    /**
    Present a modal view controller with a transitional animation.
    
    - parameter style:  Animation style
    - parameter fromVC: The view controller presenting the view controller
    - parameter toVC:   The view controller to be presented
    
    */
    func transitionalPresentation(_ style: TransitionalAnimationStyle, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController)
    
    /**
    Present a view controller with a custom transitional animation.
    
    - parameter fromVC: The view controller presenting the view controller
    - parameter toVC:   The view controller to be presented
    - parameter duration:  The duration for the custom animation
    - parameter animation: The custom animation to perform. Animations should occur within the containerView of the Transition object.
    */
    func transitionalCustomPresentation(fromViewController fromVC: UIViewController, toViewController toVC: UIViewController, duration: TimeInterval, animation: @escaping (_ transition: Transition) -> ())
    
    
    func transitionalDismissal(fromViewController fromVC: UIViewController, toViewController toVC: UIViewController, style: TransitionalAnimationStyle)
    
    /**
     Present a view controller with a custom transitional animation.
     
     - parameter fromVC: The view controller presenting the view controller
     - parameter toVC:   The view controller to be presented
     - parameter duration:  The duration for the custom animation
     - parameter animation: The custom animation to perform. Animations should occur within the containerView of the Transition object.
     */
    func transitionalCustomDismissal(fromViewController fromVC: UIViewController, toViewController toVC: UIViewController, duration: TimeInterval, animation: @escaping (_ transition: Transition) -> ())
}

public extension Transitional {
    
    func transitionalPush(_ viewController: UIViewController, style: TransitionalAnimationStyle) {
        if let navController = transitionalNavigationController(), let fromVC = navController.topViewController {
            let transition = Transition(self, style: style, fromVC: fromVC, toVC: viewController)
            transition.navController = navController
            transition.push()
        }
    }
    
    func transitionalPop(_ style: TransitionalAnimationStyle) {
        if let navController = transitionalNavigationController() , navController.viewControllers.count > 1 {
            let count = navController.viewControllers.count
            let fromVC = navController.viewControllers[count - 1]
            let toVC = navController.viewControllers[count - 2]
            let transition = Transition(self, style: style, fromVC: fromVC, toVC: toVC)
            transition.navController = navController
            _ = transition.pop()
        }
    }
    
    func transitionalPopToViewController(_ viewController: UIViewController, style: TransitionalAnimationStyle) -> [UIViewController] {
        if let navController = transitionalNavigationController() , navController.viewControllers.count > 1 {
            let count = navController.viewControllers.count
            let fromVC = navController.viewControllers[count - 1]
            let toVC = viewController
            let transition = Transition(self, style: style, fromVC: fromVC, toVC: toVC)
            transition.navController = navController
            return transition.pop()
        }
        
        return []
    }
    
    func transitionalPopToRoot(_ style: TransitionalAnimationStyle) -> [UIViewController] {
        if let navController = transitionalNavigationController() , navController.viewControllers.count > 1 {
            let count = navController.viewControllers.count
            let fromVC = navController.viewControllers[count - 1]
            let toVC = navController.viewControllers[0]
            let transition = Transition(self, style: style, fromVC: fromVC, toVC: toVC)
            transition.navController = navController
            return transition.pop()
        }
        
        return []
    }
    
    func transitionalCustomPresentation(fromViewController fromVC: UIViewController, toViewController toVC: UIViewController, duration: TimeInterval, animation: @escaping (_ transition: Transition) -> ()) {
        let transition = Transition(self, style: .custom, fromVC: fromVC, toVC: toVC, duration: duration, customAnimation: animation)
        transition.present()
    }
    
    func transitionalPresentation(_ style: TransitionalAnimationStyle, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) {
        let transition = Transition(self, style: style, fromVC: fromVC, toVC: toVC)
        transition.present()
    }
    
    func transitionalCustomDismissal(fromViewController fromVC: UIViewController, toViewController toVC: UIViewController, duration: TimeInterval, animation: @escaping (_ transition: Transition) -> ()) {
        let transition = Transition(self, style: .custom, fromVC: fromVC, toVC: toVC, duration: duration, customAnimation: animation)
        transition.dismiss()
    }
    
    func transitionalDismissal(fromViewController fromVC: UIViewController, toViewController toVC: UIViewController, style: TransitionalAnimationStyle) {
        let transition = Transition(self, style: style, fromVC: fromVC, toVC: toVC)
        transition.dismiss()
    }
    
}

open class Transition: NSObject {

    // MARK: Public
    
    let identifier: String
    let style: TransitionalAnimationStyle
    open let duration: TimeInterval
    
    open fileprivate(set) var presenting: Bool = false
    
    open fileprivate(set) weak var fromViewController: UIViewController?
    open fileprivate(set) weak var toViewController: UIViewController?
    open fileprivate(set) weak var navController: UINavigationController?
    
    open var bottomViewController: UIViewController? {
        return presenting ? fromViewController : toViewController
    }
    
    open var topViewController: UIViewController? {
        return presenting ? toViewController : fromViewController
    }
    
    open var containerView: UIView? {
        return context?.containerView
    }
    
    open func completeTransition() -> Bool {
        let cancelled = self.context?.transitionWasCancelled ?? true
        
        self.context?.completeTransition(!cancelled)
        
        return cancelled
    }
    
    // MARK: Private
    
    fileprivate let transitional: Transitional
    fileprivate let customAnimation: ((_ transition: Transition) -> ())?
    fileprivate var context: UIViewControllerContextTransitioning?
    fileprivate var originalDelegate: AnyObject?
    
    fileprivate convenience init(_ t: Transitional, style s: TransitionalAnimationStyle, fromVC: UIViewController, toVC: UIViewController) {
        self.init(t, style: s, fromVC: fromVC, toVC: toVC, duration: 0.35, customAnimation: nil)
    }
    
    fileprivate init(_ t: Transitional, style s: TransitionalAnimationStyle, fromVC: UIViewController, toVC: UIViewController, duration d: TimeInterval, customAnimation ca: ((_ transition: Transition) -> ())?) {
        transitional = t
        style = s
        fromViewController = fromVC
        toViewController = toVC
        identifier = UUID().uuidString
        customAnimation = ca
        duration = d
    }
    
    fileprivate func present() {
        if let fromVC = fromViewController, let toVC = toViewController {
            presenting = true
            
            let originalDelegate = toVC.transitioningDelegate
            
            toVC.transitioningDelegate = self
            
            fromVC.present(toVC, animated: true) {
                toVC.transitioningDelegate = originalDelegate
            }
        }
    }
    
    fileprivate func dismiss() {
        if let fromVC = fromViewController {
            presenting = false
            
            let originalDelegate = fromVC.transitioningDelegate
            let originalParentDelegate = fromVC.parent?.transitioningDelegate
            
            fromVC.transitioningDelegate = self
            fromVC.parent?.transitioningDelegate = self
            
            fromVC.dismiss(animated: true) {
                fromVC.transitioningDelegate = originalDelegate
                fromVC.parent?.transitioningDelegate = originalParentDelegate
            }
        }
    }
    
    fileprivate func push() {
        if let navController = navController, let toVC = toViewController {
            originalDelegate = navController.delegate
            navController.delegate = self
            navController.pushViewController(toVC, animated: true)
        }
    }
    
    fileprivate func pop() -> [UIViewController] {
        
        if let navController = navController, let toVC = toViewController {
            originalDelegate = navController.delegate
            navController.delegate = self
            return navController.popToViewController(toVC, animated: true) ?? []
        }
        
        return []
    }
    
    fileprivate func animation() {
        switch style {
        case .slideDown:
            fallthrough
        case .slideUp:
            slide()
        case .flipFromLeft:
            fallthrough
        case .flipFromRight:
            flip()
        case .zoomIn:
            fallthrough
        case .zoomOut:
            zoom()
        default:
            break
        }
    }

    fileprivate func zoom() {
        if let fromVC = fromViewController,
            let toVC = toViewController,
            let container = containerView {

                container.addSubview(fromVC.view)
                container.addSubview(toVC.view)

                let startTransform: CGAffineTransform
                let endTransform: CGAffineTransform

                if style == .zoomIn {
                    startTransform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                    endTransform = CGAffineTransform(scaleX: 1.65, y: 1.65)
                } else {
                    startTransform = CGAffineTransform(scaleX: 1.65, y: 1.65)
                    endTransform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                }

                toVC.view.transform = startTransform
                toVC.view.alpha = 0

                UIView.animate(withDuration: duration, animations: {
                    toVC.view.transform = CGAffineTransform(scaleX: 1, y: 1)
                    fromVC.view.transform = endTransform
                    toVC.view.alpha = 1
                    fromVC.view.alpha = 0
                    }, completion: { [unowned self] _ in
                        let cancelled = self.context?.transitionWasCancelled ?? true

                        toVC.view.transform = CGAffineTransform(scaleX: 1, y: 1)
                        toVC.view.alpha = 1
                        fromVC.view.transform = CGAffineTransform(scaleX: 1, y: 1)
                        fromVC.view.alpha = 1

                        if cancelled {
                            toVC.view.removeFromSuperview()
                        } else {
                            fromVC.view.removeFromSuperview()
                        }

                        self.context?.completeTransition(!cancelled)
                }) 
        }
    }

    fileprivate func flip() {
        if let fromVC = fromViewController,
            let toVC = toViewController,
            let bottomVC = bottomViewController,
            let topVC = topViewController,
            let container = containerView {

                container.addSubview(bottomVC.view)

                // If this a modal presentation, we need to `flush` before the animation
                // otherwise the presented viewController will not animate correctly.
                // This sometimes causes a slight animation delay, so I need to find a better
                // way to deal with this behavior.
                if presenting && navController == nil {
                    CATransaction.flush()
                }

                container.addSubview(topVC.view)

                let options: UIViewAnimationOptions

                switch style {
                case .flipFromRight:
                    options = .transitionFlipFromRight
                case .flipFromLeft:
                    options = .transitionFlipFromLeft
                default:
                    fatalError("Only flip styles support this flip animation. This path should never be hit.")
                }

                UIView.transition(from: fromVC.view, to: toVC.view, duration: duration, options: options) { _ in

                    let cancelled = self.context?.transitionWasCancelled ?? true

                    if cancelled {
                        toVC.view.removeFromSuperview()
                    } else {
                        fromVC.view.removeFromSuperview()
                    }

                    self.context?.completeTransition(!cancelled)
                }
        }
    }

    fileprivate func slide() {
        if let fromVC = fromViewController,
            let toVC = toViewController,
            let bottomVC = bottomViewController,
            let topVC = topViewController,
            let container = containerView {

                container.addSubview(bottomVC.view)
                container.addSubview(topVC.view)

                let originalFrame = bottomVC.view.frame
                var endFrame = originalFrame
                var startFrame = originalFrame

                if presenting {
                    switch style {
                    case .slideDown:
                        startFrame.origin.y -= startFrame.size.height
                    case .slideUp:
                        startFrame.origin.y += startFrame.size.height
                    default:
                        break
                    }
                } else {
                    switch style {
                    case .slideDown:
                        endFrame.origin.y += endFrame.size.height
                    case .slideUp:
                        endFrame.origin.y -= endFrame.size.height
                    default:
                        break
                    }
                }

                
                topVC.view.frame = startFrame
                
                UIView.animate(withDuration: duration, animations: {
                    topVC.view.frame = endFrame
                    }, completion: { [unowned self] _ in
                        topVC.view.frame = originalFrame
                        
                        let cancelled = self.context?.transitionWasCancelled ?? true
                        
                        if cancelled {
                            toVC.view.removeFromSuperview()
                        } else {
                            fromVC.view.removeFromSuperview()
                        }
                        
                        self.context?.completeTransition(!cancelled)
                }) 
                
        }
    }
    
}

extension Transition: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presenting = operation == .push
        return self
    }
    
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        navigationController.delegate = originalDelegate as? UINavigationControllerDelegate
    }
}

extension Transition: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    //    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    //        return self
    //    }
    //
    //    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    //        return self
    //    }
}

extension Transition: UIViewControllerAnimatedTransitioning {
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        context = transitionContext
        
        switch style {
        case .custom:
            customAnimation?(self)
        default:
            animation()
            
            // do stuff
            break
        }
    }
    
}
