//
//  IdeaCollectionViewCell.swift
//  My Idea Pool
//
//  Created by Franco on 2019-10-31.
//  Copyright © 2019 Franco Fantillo. All rights reserved.
//

import UIKit

class IdeaCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var impactValue: UILabel!
    @IBOutlet weak var easeValue: UILabel!
    @IBOutlet weak var confidenceValue: UILabel!
    @IBOutlet weak var avgValue: UILabel!
    @IBOutlet weak var btn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configure(){
        self.contentView.layer.cornerRadius = 6.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true

        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 0.2
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
        
        self.btn.imageView?.contentMode = .scaleAspectFit
    }
    
    // Editing the cell must take place in tha apply function.  The awakefromnib function will apply chnages to the unaltered collectionview nib.
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        configure()
    }
}
