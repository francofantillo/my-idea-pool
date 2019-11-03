//
//  NavigationControllerExtension.swift
//  My Idea Pool
//
//  Created by Franco on 2019-10-29.
//  Copyright © 2019 Franco Fantillo. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func setupNavBar(){
        navigationItem.leftBarButtonItems = [barImageView(imageName: "lighbulb"), barLabelView(label: "My Idea Pool")]
    }
    
    func setUpNavBarAddEditIdea(){
        self.navigationItem.leftItemsSupplementBackButton = true
        navigationItem.leftBarButtonItems = [barImageView(imageName: "lighbulb")]
    }
    
    private func imageView(imageName: String) -> UIImageView {
        let logo = UIImage(named: imageName)
        assert(logo != nil)
        let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.image = logo
        logoImageView.widthAnchor.constraint(equalToConstant: 35).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        return logoImageView
    }
    
    private func labelView(label: String) -> UILabel {
        let titleLabel = UILabel()
        titleLabel.text = label
        titleLabel.textColor = UIColor.white
        titleLabel.sizeToFit()
        return titleLabel
    }
    
    private func barLabelView(label: String) -> UIBarButtonItem{
        return UIBarButtonItem(customView: labelView(label: label))
    }

    private func barImageView(imageName: String) -> UIBarButtonItem {
        return UIBarButtonItem(customView: imageView(imageName: imageName))
    }

    private func barButton(imageName: String, selector: Selector) -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        button.widthAnchor.constraint(equalToConstant: 35).isActive = true
        button.heightAnchor.constraint(equalToConstant: 35).isActive = true
        button.addTarget(self, action: selector, for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }
}

