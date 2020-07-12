//
//  WebViewController.swift
//  Recipy
//
//  Created by Sucharu on 11/08/19.
//  Copyright © 2019 Sebastian Jolly. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!

    
    var loadURL:URL!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if self.loadURL  != nil {
            
            self.webView.loadRequest(URLRequest.init(url: self.loadURL))
            
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
