//
//  BaseTabBarController.swift
//  MediVol
//
//  Created by Nawaf Aldosari on 02/08/2018.
//  Copyright © 2018 Nawaf Aldosari. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {
    @IBInspectable var defaultIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = defaultIndex
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
    }

}
