//
//  Helper.swift
//  Recipy
//
//  Created by Sebastian Jolly on 7/22/19.
//  Copyright © 2019 Sebastian Jolly. All rights reserved.
//

import Foundation
protocol controlOnboardDelegate {
    func updatePageControl(index : Int)
    
}
class Helper {
    var page : Int = 0
    static let shared = Helper()
    private init(){}
    var onboardDelegate : controlOnboardDelegate?
    
    func updateOnboardUI(index : Int){
        self.onboardDelegate?.updatePageControl(index: index)
    }
}
