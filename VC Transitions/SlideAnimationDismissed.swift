//
//  SlideAnimationDismissed.swift
//  Panda Jump
//
//  Created by Jack Darnell on 9/21/17.
//  Copyright © 2017 Jack Darnell. All rights reserved.
//

import UIKit

class SlideAnimationDismissed: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    let duration = 0.5
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else {
            return
        }
        
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else {
            return
        }
        let container = transitionContext.containerView
        
        let screenOffUp = CGAffineTransform(translationX: -container.frame.width, y: 0)//-container.frame.height)
        let screenOffDown = CGAffineTransform(translationX: container.frame.width, y: 0)//container.frame.height)
        
        container.addSubview(fromView)
        container.addSubview(toView)
        
        toView.transform = screenOffUp
        
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: [], animations: {
            
            fromView.transform = screenOffDown
            fromView.alpha = 0.5
            toView.transform = CGAffineTransform.identity
            toView.alpha = 1
            
        }) { (success) in
            transitionContext.completeTransition(success)
        }
    }
    
    
}
