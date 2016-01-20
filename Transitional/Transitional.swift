//
//  Transitional.swift
//  Transitional
//
//  Created by Nora Trapp on 6/23/15.
//  Copyright (c) 2015 Trapp Design. All rights reserved.
//

import UIKit

@objc public enum TransitionalAnimationStyle: Int, Equatable, CustomStringConvertible {
    case SlideDown
    case SlideUp
    case FlipFromLeft
    case FlipFromRight
    case Custom

    public var description: String {
        switch self {
        case .SlideDown:
            return "Slide Down"
        case .SlideUp:
            return "Slide Up"
        case .FlipFromLeft:
            return "Flip From Left"
        case .FlipFromRight:
            return "Flip From Right"
        case .Custom:
            return "Custom"
        }
    }
}

extension UIViewController: Transitional {
    
    /* Modal Transitions */
    public func transitionalPresentation(viewController: UIViewController, style: TransitionalAnimationStyle) {
        transitionalPresentation(style, fromViewController: self, toViewController: viewController)
    }
    
    public func transitionalCustomPresentation(viewController: UIViewController, duration: NSTimeInterval, animation: (transition: Transition) -> ()) {
        transitionalCustomPresentation(fromViewController: self, toViewController: viewController, duration: duration, animation: animation)
    }
    
    public func transitionalDismissal(style: TransitionalAnimationStyle) {
        if let presentedViewController = presentedViewController {
            transitionalDismissal(fromViewController: presentedViewController, toViewController: self, style: style)
        } else if let presentingViewController = presentingViewController {
            transitionalDismissal(fromViewController: self, toViewController: presentingViewController, style: style)
        } else {
//            fatalError("Cannot dismiss view that is not presented.")
        }
    }
    
    public func transitionalCustomDismissal(duration: NSTimeInterval, animation: (transition: Transition) -> ()) {
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
    func transitionalPush(viewController: UIViewController, style: TransitionalAnimationStyle)
    
    /**
    Pop the top view controller from the navigation controller stack with a transitional animation.
    
    - parameter style: Animation style
    
    */
    func transitionalPop(style: TransitionalAnimationStyle)
    
    /**
    Pop to a specific view controller in the navigation stack with a transitional animation.
    
    - parameter viewController: View controller to pop to
    - parameter style:          Animation style
    
    - returns: An array of view controllers that were popped to reach the target view controller.
    */
    func transitionalPopToViewController(viewController: UIViewController, style: TransitionalAnimationStyle) -> [UIViewController]
    
    /**
    Pop to the root view controller within the navigation stack with a transitional animation.
    
    - parameter style: Animation style
    
    - returns: An array of view controllers that were popped to reach the target view controller.
    */
    func transitionalPopToRoot(style: TransitionalAnimationStyle) -> [UIViewController]
    
    /* Modal Transitions */
    
    /**
    Present a modal view controller with a transitional animation.
    
    - parameter style:  Animation style
    - parameter fromVC: The view controller presenting the view controller
    - parameter toVC:   The view controller to be presented
    
    */
    func transitionalPresentation(style: TransitionalAnimationStyle, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController)
    
    /**
    Present a view controller with a custom transitional animation.
    
    - parameter fromVC: The view controller presenting the view controller
    - parameter toVC:   The view controller to be presented
    - parameter duration:  The duration for the custom animation
    - parameter animation: The custom animation to perform. Animations should occur within the containerView of the Transition object.
    */
    func transitionalCustomPresentation(fromViewController fromVC: UIViewController, toViewController toVC: UIViewController, duration: NSTimeInterval, animation: (transition: Transition) -> ())
    
    
    func transitionalDismissal(fromViewController fromVC: UIViewController, toViewController toVC: UIViewController, style: TransitionalAnimationStyle)
    
    /**
     Present a view controller with a custom transitional animation.
     
     - parameter fromVC: The view controller presenting the view controller
     - parameter toVC:   The view controller to be presented
     - parameter duration:  The duration for the custom animation
     - parameter animation: The custom animation to perform. Animations should occur within the containerView of the Transition object.
     */
    func transitionalCustomDismissal(fromViewController fromVC: UIViewController, toViewController toVC: UIViewController, duration: NSTimeInterval, animation: (transition: Transition) -> ())
}

public extension Transitional {
    
    func transitionalPush(viewController: UIViewController, style: TransitionalAnimationStyle) {
        if let navController = transitionalNavigationController(), fromVC = navController.topViewController {
            let transition = Transition(self, style: style, fromVC: fromVC, toVC: viewController)
            transition.navController = navController
            transition.push()
        }
    }
    
    func transitionalPop(style: TransitionalAnimationStyle) {
        if let navController = transitionalNavigationController() where navController.viewControllers.count > 1 {
            let count = navController.viewControllers.count
            let fromVC = navController.viewControllers[count - 1]
            let toVC = navController.viewControllers[count - 2]
            let transition = Transition(self, style: style, fromVC: fromVC, toVC: toVC)
            transition.navController = navController
            transition.pop()
        }
    }
    
    func transitionalPopToViewController(viewController: UIViewController, style: TransitionalAnimationStyle) -> [UIViewController] {
        if let navController = transitionalNavigationController() where navController.viewControllers.count > 1 {
            let count = navController.viewControllers.count
            let fromVC = navController.viewControllers[count - 1]
            let toVC = viewController
            let transition = Transition(self, style: style, fromVC: fromVC, toVC: toVC)
            transition.navController = navController
            return transition.pop()
        }
        
        return []
    }
    
    func transitionalPopToRoot(style: TransitionalAnimationStyle) -> [UIViewController] {
        if let navController = transitionalNavigationController() where navController.viewControllers.count > 1 {
            let count = navController.viewControllers.count
            let fromVC = navController.viewControllers[count - 1]
            let toVC = navController.viewControllers[0]
            let transition = Transition(self, style: style, fromVC: fromVC, toVC: toVC)
            transition.navController = navController
            return transition.pop()
        }
        
        return []
    }
    
    func transitionalCustomPresentation(fromViewController fromVC: UIViewController, toViewController toVC: UIViewController, duration: NSTimeInterval, animation: (transition: Transition) -> ()) {
        let transition = Transition(self, style: .Custom, fromVC: fromVC, toVC: toVC, duration: duration, customAnimation: animation)
        transition.present()
    }
    
    func transitionalPresentation(style: TransitionalAnimationStyle, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) {
        let transition = Transition(self, style: style, fromVC: fromVC, toVC: toVC)
        transition.present()
    }
    
    func transitionalCustomDismissal(fromViewController fromVC: UIViewController, toViewController toVC: UIViewController, duration: NSTimeInterval, animation: (transition: Transition) -> ()) {
        let transition = Transition(self, style: .Custom, fromVC: fromVC, toVC: toVC, duration: duration, customAnimation: animation)
        transition.dismiss()
    }
    
    func transitionalDismissal(fromViewController fromVC: UIViewController, toViewController toVC: UIViewController, style: TransitionalAnimationStyle) {
        let transition = Transition(self, style: style, fromVC: fromVC, toVC: toVC)
        transition.dismiss()
    }
    
}

public class Transition: NSObject {

    // MARK: Public
    
    let identifier: String
    let style: TransitionalAnimationStyle
    public let duration: NSTimeInterval
    
    public private(set) var presenting: Bool = false
    
    public private(set) weak var fromViewController: UIViewController?
    public private(set) weak var toViewController: UIViewController?
    public private(set) weak var navController: UINavigationController?
    
    public var bottomViewController: UIViewController? {
        return presenting ? fromViewController : toViewController
    }
    
    public var topViewController: UIViewController? {
        return presenting ? toViewController : fromViewController
    }
    
    public var containerView: UIView? {
        return context?.containerView()
    }
    
    public func completeTransition() -> Bool {
        let cancelled = self.context?.transitionWasCancelled() ?? true
        
        self.context?.completeTransition(!cancelled)
        
        return cancelled
    }
    
    // MARK: Private
    
    private let transitional: Transitional
    private let customAnimation: ((transition: Transition) -> ())?
    private var context: UIViewControllerContextTransitioning?
    private var originalDelegate: AnyObject?
    
    private convenience init(_ t: Transitional, style s: TransitionalAnimationStyle, fromVC: UIViewController, toVC: UIViewController) {
        self.init(t, style: s, fromVC: fromVC, toVC: toVC, duration: 0.35, customAnimation: nil)
    }
    
    private init(_ t: Transitional, style s: TransitionalAnimationStyle, fromVC: UIViewController, toVC: UIViewController, duration d: NSTimeInterval, customAnimation ca: ((transition: Transition) -> ())?) {
        transitional = t
        style = s
        fromViewController = fromVC
        toViewController = toVC
        identifier = NSUUID().UUIDString
        customAnimation = ca
        duration = d
    }
    
    private func present() {
        if let fromVC = fromViewController, toVC = toViewController {
            presenting = true
            
            let originalDelegate = toVC.transitioningDelegate
            
            toVC.transitioningDelegate = self
            
            fromVC.presentViewController(toVC, animated: true) {
                toVC.transitioningDelegate = originalDelegate
            }
        }
    }
    
    private func dismiss() {
        if let fromVC = fromViewController {
            presenting = false
            
            let originalDelegate = fromVC.transitioningDelegate
            let originalParentDelegate = fromVC.parentViewController?.transitioningDelegate
            
            fromVC.transitioningDelegate = self
            fromVC.parentViewController?.transitioningDelegate = self
            
            fromVC.dismissViewControllerAnimated(true) {
                fromVC.transitioningDelegate = originalDelegate
                fromVC.parentViewController?.transitioningDelegate = originalParentDelegate
            }
        }
    }
    
    private func push() {
        if let navController = navController, toVC = toViewController {
            originalDelegate = navController.delegate
            navController.delegate = self
            navController.pushViewController(toVC, animated: true)
        }
    }
    
    private func pop() -> [UIViewController] {
        
        if let navController = navController, toVC = toViewController {
            originalDelegate = navController.delegate
            navController.delegate = self
            return navController.popToViewController(toVC, animated: true) ?? []
        }
        
        return []
    }
    
    private func animation() {
        switch style {
        case .SlideDown:
            fallthrough
        case .SlideUp:
            slide()
        case .FlipFromLeft:
            fallthrough
        case .FlipFromRight:
            flip()
        default:
            break
        }
    }

    private func flip() {
        if let fromVC = fromViewController,
            toVC = toViewController,
            bottomVC = bottomViewController,
            topVC = topViewController,
            container = containerView {

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
                case .FlipFromRight:
                    options = .TransitionFlipFromRight
                case .FlipFromLeft:
                    options = .TransitionFlipFromLeft
                default:
                    fatalError("Only flip styles support this flip animation. This path should never be hit.")
                }

                UIView.transitionFromView(fromVC.view, toView: toVC.view, duration: duration, options: options) { _ in

                    let cancelled = self.context?.transitionWasCancelled() ?? true

                    if cancelled {
                        toVC.view.removeFromSuperview()
                    } else {
                        fromVC.view.removeFromSuperview()
                    }

                    self.context?.completeTransition(!cancelled)
                }
        }
    }

    private func slide() {
        if let fromVC = fromViewController,
            toVC = toViewController,
            bottomVC = bottomViewController,
            topVC = topViewController,
            container = containerView {

                container.addSubview(bottomVC.view)
                container.addSubview(topVC.view)

                let originalFrame = bottomVC.view.frame
                var endFrame = originalFrame
                var startFrame = originalFrame

                if presenting {
                    switch style {
                    case .SlideDown:
                        startFrame.origin.y -= startFrame.size.height
                    case .SlideUp:
                        startFrame.origin.y += startFrame.size.height
                    default:
                        break
                    }
                } else {
                    switch style {
                    case .SlideDown:
                        endFrame.origin.y += endFrame.size.height
                    case .SlideUp:
                        endFrame.origin.y -= endFrame.size.height
                    default:
                        break
                    }
                }

                
                topVC.view.frame = startFrame
                
                UIView.animateWithDuration(duration, animations: {
                    topVC.view.frame = endFrame
                    }) { [unowned self] _ in
                        topVC.view.frame = originalFrame
                        
                        let cancelled = self.context?.transitionWasCancelled() ?? true
                        
                        if cancelled {
                            toVC.view.removeFromSuperview()
                        } else {
                            fromVC.view.removeFromSuperview()
                        }
                        
                        self.context?.completeTransition(!cancelled)
                }
                
        }
    }
    
}

extension Transition: UINavigationControllerDelegate {
    public func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presenting = operation == .Push
        return self
    }
    
    public func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
        navigationController.delegate = originalDelegate as? UINavigationControllerDelegate
    }
}

extension Transition: UIViewControllerTransitioningDelegate {
    public func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
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
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        context = transitionContext
        
        switch style {
        case .Custom:
            customAnimation?(transition: self)
        default:
            animation()
            
            // do stuff
            break
        }
    }
    
}
