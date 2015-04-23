//
//  CollectionViewCell.swift
//  SoundTouch
//
//  Created by phuc on 4/23/15.
//  Copyright (c) 2015 phuc nguyen. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    var imageView: UIImageView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCell()
    }
    
    func setupCell() {
        imageView = UIImageView(frame: bounds)
        imageView.image = UIImage(named: "placeholder.png")
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.clipsToBounds = true
        addSubview(imageView)
    }
}
