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

    var isOn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.addSubview(cameraView)
//        cameraView.setAspectRatio(.custom(width: 1000, height: 200))
        cameraView.setAspectRatio(.landscape)
        cameraView.setBackgroundColor(.white)
        cameraView.setFlashMode(.off)
        cameraView.setCameraPosition(.back)
        
        captureButton.layer.cornerRadius = 50.0
//        cameraView.setCameraCornerRadius(150.0)
        
//        cameraView.layer.cornerRadius = 20
        
        let filter = CIFilter(name: "CIColorMonochrome")!
        filter.setValue(CIColor(red: 1.0, green: 0.0, blue: 0.0), forKey: "inputColor")
        filter.setValue(1.0, forKey: "inputIntensity")
        cameraView.setFilter(filter)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
        cameraView.addGestureRecognizer(pinchGesture)
        
        cameraView.startRunning()
        
        //Transfer the desired photos to the printer
//        let imageToPrint = UIImage(named: "aaaa")!
//        printImageAsPDF(image: imageToPrint)

    
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ButtonDidTap(_ sender: Any) {
        print("capture")
    }
    
    @IBAction func LightButtonDidTap(_ sender: Any) {
        isOn.toggle()
        
        if isOn {
            cameraView.setFlashMode(.on)
            print("on")
        } else {
            cameraView.setFlashMode(.off)
            print("off")
        }
    }
    
    @IBAction func ReversalDidTap(_ sender: Any) {
        isOn.toggle()
        
        if isOn {
            cameraView.setCameraPosition(.back)
            print("back")
        } else {
            cameraView.setCameraPosition(.front)
            print("front")
        }
    }
    
    @objc func handlePinchGesture(_ gesture: UIPinchGestureRecognizer) {
        // cameraZoomPinchAction 함수 호출
        let zoomFactor = cameraView.handleZoomGesture(pinchGesture: gesture)
        print("Zoom factor: \(zoomFactor)")
    }

}
