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
    var label: UILabel!
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
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.clipsToBounds = true
        addSubview(imageView)
        label = UILabel(frame: CGRect(x: 0, y: frame.height - 30, width: frame.width, height: 30))
        label.textAlignment = NSTextAlignment.Center
        addSubview(label)
    }
    override func prepareForReuse() {
        imageView.image = nil
    }
}
