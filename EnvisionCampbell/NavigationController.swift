//
//  NavigationController.swift
//  EnvisionCampbell
//
//  Created by Ari Chen on 1/17/16.
//  Copyright © 2016 Ari Chen. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func shouldAutorotate() -> Bool {
        if let vc = self.viewControllers.last {
            return vc.shouldAutorotate()
        }
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if let vc = self.viewControllers.last {
            return vc.supportedInterfaceOrientations()
        }
        return super.supportedInterfaceOrientations()
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        if let vc = self.viewControllers.last {
            return vc.preferredInterfaceOrientationForPresentation()
        }
        return super.preferredInterfaceOrientationForPresentation()
    }
    
}
