//
//  IdeaViewController.swift
//  My Idea Pool
//
//  Created by Franco on 2019-10-29.
//  Copyright © 2019 Franco Fantillo. All rights reserved.
//

import UIKit

class IdeaViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBarIdeas()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        configureNextVCBackBtn()
    }
    
    private func configureNextVCBackBtn(){
        let backItem = UIBarButtonItem()
        backItem.title = ""
        backItem.tintColor = UIColor.white
        navigationItem.backBarButtonItem = backItem
    }
}
