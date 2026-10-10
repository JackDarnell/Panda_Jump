//
//  SlideAnimationForward.swift
//  Panda Jump
//
//  Created by Jack Darnell on 9/20/17.
//  Copyright © 2017 Jack Darnell. All rights reserved.
//

import UIKit

/// Transitioning delegate that slides the new screen in from the right, and back out on dismiss.
class SlideAnimationForward: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        SlideAnimationDismissed()
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        slideTransitionDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        animateSlide(using: transitionContext, direction: 1)
    }
}

let slideTransitionDuration: TimeInterval = 0.5

/// Slides the incoming view in from the side (`direction` 1 = from the right, -1 = from the left)
/// while pushing the outgoing view off the other side.
@MainActor
func animateSlide(using transitionContext: UIViewControllerContextTransitioning, direction: CGFloat) {
    let container = transitionContext.containerView
    let fromView = transitionContext.view(forKey: .from)
    let toView = transitionContext.view(forKey: .to)
    let width = container.frame.width

    if let fromView = fromView {
        container.addSubview(fromView)
    }
    if let toView = toView {
        container.addSubview(toView)
        toView.transform = CGAffineTransform(translationX: direction * width, y: 0)
    }

    UIView.animate(withDuration: slideTransitionDuration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: [], animations: {
        fromView?.transform = CGAffineTransform(translationX: -direction * width, y: 0)
        fromView?.alpha = 0.5
        toView?.transform = .identity
        toView?.alpha = 1
    }, completion: { _ in
        // Reset the outgoing view so it looks right if it's shown again.
        fromView?.transform = .identity
        fromView?.alpha = 1
        // Always complete, otherwise the app is left stuck mid-transition.
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    })
}
