//
//  SlideAnimationDismissed.swift
//  Panda Jump
//
//  Created by Jack Darnell on 9/21/17.
//  Copyright © 2017 Jack Darnell. All rights reserved.
//

import UIKit

/// The reverse of `SlideAnimationForward`: slides the screen back out to the right.
class SlideAnimationDismissed: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        slideTransitionDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        animateSlide(using: transitionContext, direction: -1)
    }
}
