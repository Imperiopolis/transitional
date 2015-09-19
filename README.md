# Transitional

[![Version](https://img.shields.io/cocoapods/v/Transitional.svg?style=flat)](http://cocoadocs.org/docsets/Transitional)
[![License](https://img.shields.io/cocoapods/l/Transitional.svg?style=flat)](http://cocoadocs.org/docsets/Transitional)
[![Platform](https://img.shields.io/cocoapods/p/Transitional.svg?style=flat)](http://cocoadocs.org/docsets/Transitional)

Quick and easy custom transitions.

## Usage

To run the example project, simply run `pod try transitional`. Alternatively, you can clone the repo and run the project in the example directory.

# Default Transitions

* Slide Down
* Slide Up

```swift
   // Navigation Controller
   transitionalPush(toVC, style: .SlideDown)
   transitionalPop(.SideDown)
   transitionalPopToRoot(.SlideUp)
   transitionalPopToViewController(toVC, style: .SlideUp)

   // Modal Presentation
   transitionalPresentation(toVC, style: .SlideDown)
   transitionalDismissal(.SlideUp)
```

# Custom Transitions

Currently only modal transitions support custom animations. Push/Pop support coming soon!

```swift
        fromVC.transitionalCustomDismissal(0.35) { transition in

        // OR

        fromVC.transitionalCustomPresentation(signInVC, duration: 0.35) { transition in
            if let container = transition.containerView,
                bottomVC = transition.bottomViewController,
                topVC = transition.topViewController {

                container.addSubview(bottomVC.view)
                container.addSubview(topVC.view)

                let originalFrame = bottomVC.view.frame
                var endFrame = originalFrame
                var startFrame = originalFrame

                if transition.presenting {
                    startFrame.origin.y -= startFrame.size.height
                } else {
                    endFrame.origin.y -= endFrame.size.height
                }

                topVC.view.frame = startFrame

                UIView.animateWithDuration(transition.duration, animations: {
                    topVC.view.frame = endFrame
                    }) { _ in
                        topVC.view.frame = originalFrame

                        let cancelled = transition.completeTransition()

                        if cancelled {
                            transition.toViewController?.view.removeFromSuperview()
                        } else {
                            transition.fromViewController?.view.removeFromSuperview()
                        }
                }
            }
        }
```

## Installation

Transitional is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Transitional"
```

## Documentation

Read the documentation [here](http://cocoadocs.org/docsets/Transitional).

## About Transitional

Transitional was created by [@Imperiopolis](https://twitter.com/Imperiopolis).

Transitional is released under the MIT license. See LICENSE for details.
