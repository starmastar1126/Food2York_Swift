//
//  ExampleOverlayView.swift
//  Recipy
//
//  Created by Sebastian Jolly on 7/20/19.
//  Copyright © 2019 Sebastian Jolly. All rights reserved.
//

import UIKit
import Koloda

//private let overlayRightImageName = "yesOverlayImage"
//private let overlayLeftImageName = "noOverlayImage"

private let overlayRightImageName = "yes"
private let overlayLeftImageName = "skip"

class ExampleOverlayView: OverlayView {
    
    @IBOutlet lazy var overlayImageView: UIImageView! = {
        [unowned self] in
        
        var frm = self.bounds

        var imageView = UIImageView(frame: frm)
        self.addSubview(imageView)
        
        return imageView
        }()
    
    
    
    override var overlayState: SwipeResultDirection? {
        didSet {
            switch overlayState {
            case .left? :
                overlayImageView.image = UIImage(named: overlayLeftImageName)
            case .right? :
                overlayImageView.image = UIImage(named: overlayRightImageName)
            default:
                overlayImageView.image = nil
            }
        }
    }

}
