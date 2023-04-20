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
    @IBOutlet var captureButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.addSubview(cameraView)
        cameraView.setAspectRatio(.custom(width: 1000, height: 200))
        cameraView.setBackgroundColor(.black)
        cameraView.setFlashMode(.off)
        cameraView.setCameraPosition(.front)
        cameraView.setCameraCornerRadius(100.0)
        
        
//        cameraView.layer.cornerRadius = 20


//        cameraView.translatesAutoresizingMaskIntoConstraints = false
//        cameraView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        cameraView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//        cameraView.widthAnchor.constraint(equalTo: cameraView.heightAnchor).isActive = true
        
        cameraView.startRunning()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ButtonDidTap(_ sender: Any) {
        print("asdf")
    }
    
}
