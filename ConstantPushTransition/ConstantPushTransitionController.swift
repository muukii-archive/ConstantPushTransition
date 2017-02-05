//
//  ConstantPushTransitionController.swift
//  ConstantPushTransition
//
//  Created by muukii on 2/5/17.
//  Copyright © 2017 eure. All rights reserved.
//

import UIKit

public final class ConstantPushTransitionController: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning {

  public var forwardAnimation: Bool = true

  override init() {
    super.init()
    completionCurve = .easeOut
  }

  public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.5
  }

  public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

    let containerView = transitionContext.containerView

    let fromVC = transitionContext.viewController(forKey: .from)!
    let toVC = transitionContext.viewController(forKey: .to)!

    if forwardAnimation {

      guard transitionContext.isAnimated == true else {

        containerView.addSubview(toVC.view)
        transitionContext.completeTransition(true)
        return
      }

      containerView.addSubview(toVC.view)
      toVC.view.transform = .init(translationX: toVC.view.bounds.width, y: 0)

      UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {

        toVC.view.transform = .identity
        fromVC.view.transform = .init(translationX: -fromVC.view.bounds.width, y: 0)

      }, completion: { (finish) in

        fromVC.view.transform = .identity
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
      })

    } else {

      guard transitionContext.isAnimated == true else {

        fromVC.view.removeFromSuperview()
        transitionContext.completeTransition(true)
        return
      }

      containerView.insertSubview(toVC.view, belowSubview: fromVC.view)

      toVC.view.transform = .init(translationX: -fromVC.view.bounds.width, y: 0)

      if transitionContext.isInteractive {

        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear], animations: {

          toVC.view.transform = .identity
          fromVC.view.transform = .init(translationX: fromVC.view.bounds.width, y: 0)

        }, completion: { (finish) in

          if !transitionContext.transitionWasCancelled {
            fromVC.view.removeFromSuperview()
          }

          transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })

      } else {

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {

          toVC.view.transform = .identity
          fromVC.view.transform = .init(translationX: fromVC.view.bounds.width, y: 0)

        }, completion: { (finish) in

          if !transitionContext.transitionWasCancelled {
            fromVC.view.removeFromSuperview()
          }

          transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
      }

    }
  }
}
