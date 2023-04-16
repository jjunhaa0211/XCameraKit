//
//  ViewController.swift
//  XCameraKit
//
//  Created by 102890390 on 04/15/2023.
//  Copyright (c) 2023 102890390. All rights reserved.
//

import UIKit
import XCameraKit

class ViewController: UIViewController {
    
    @IBOutlet var cameraView: XCamera!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        cameraView = XCamera(frame: view.bounds)
        view.addSubview(cameraView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        cameraView.startRunning()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

