//
//  CircularImageView.swift
//  Recipy
//
//  Created by Sebastian Jolly on 7/25/19.
//  Copyright © 2019 Sebastian Jolly. All rights reserved.
//

import UIKit

class CircularImageView: UIImageView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = self.frame.width/2
        clipsToBounds = true
    }
}
