//
//  NavigationController.swift
//  ConstantPushTransition
//
//  Created by muukii on 2/5/17.
//  Copyright © 2017 eure. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

  fileprivate let transitionController = ConstantPushTransitionController()
  fileprivate lazy var edgePanGesture = UIScreenEdgePanGestureRecognizer()
  fileprivate var willInteractive: Bool = false

  override func viewDidLoad() {
    super.viewDidLoad()

    delegate = self

    edgePanGesture.edges = .left
    edgePanGesture.addTarget(self, action: #selector(pan(gesture:)))
  }

  @objc private func pan(gesture: UIScreenEdgePanGestureRecognizer) {

    func progress(value: CGFloat, start: CGFloat, end: CGFloat) -> CGFloat {
      return (value - start) / (end - start)
    }

    let p = progress(value: abs(gesture.location(in: gesture.view!).x), start: view.bounds.width, end: 0)

    switch gesture.state {
    case .began:
      willInteractive = true
      popViewController(animated: true)
    case .changed:

      transitionController.update(p)

    case .ended:

      willInteractive = false

      if p > 0.3 {
        transitionController.finish()
      } else {
        transitionController.cancel()
      }

    case .cancelled:

      willInteractive = false
    
      transitionController.cancel()

    default:
      break
    }
  }
}

extension NavigationController: UINavigationControllerDelegate {

  func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {

    edgePanGesture.view?.removeGestureRecognizer(edgePanGesture)
    viewController.view.addGestureRecognizer(edgePanGesture)
  }

  func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

    switch operation {
    case .none:
      return nil
    case .push:
      transitionController.forwardAnimation = true
      return transitionController
    case .pop:
      transitionController.forwardAnimation = false
      return transitionController
    }
  }

  func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {

    if willInteractive {
      return transitionController
    }
    return nil
  }
}
