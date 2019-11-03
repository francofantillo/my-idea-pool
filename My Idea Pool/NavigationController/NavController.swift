//
//  NavController.swift
//  My Idea Pool
//
//  Created by Franco on 2019-10-31.
//  Copyright © 2019 Franco Fantillo. All rights reserved.
//

import UIKit

class NavController: UINavigationController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.barTintColor = UIColor(red: 0/255, green: 168/255, blue: 67/255.0, alpha: 1)
        // Do any additional setup after loading the view.
    }
}
