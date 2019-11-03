//
//  PostAlerts.swift
//  My Idea Pool
//
//  Created by Franco on 2019-10-30.
//  Copyright © 2019 Franco Fantillo. All rights reserved.
//

import Foundation
import UIKit

class PostAlerts {
    
    static func presentAlertController(viewController: UIViewController, titleMsg: String, errorMsg: String){
        let alertController = UIAlertController(title: titleMsg, message: errorMsg, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
}
