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
    var gridView: GridView!

    var isOn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.addSubview(cameraView)
//        cameraView.setAspectRatio(.custom(width: 1000, height: 200))
        cameraView.setAspectRatio(.square)
        cameraView.setBackgroundColor(.white)
        cameraView.setFlashMode(.off)
        cameraView.setCameraPosition(.back)
        
        gridView = GridView(frame: cameraView.frame)
        gridView.isUserInteractionEnabled = false
        view.addSubview(gridView)
        
        captureButton.layer.cornerRadius = 50.0
//        cameraView.setCameraCornerRadius(150.0)
//        cameraView.layer.cornerRadius = 20
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
        cameraView.addGestureRecognizer(pinchGesture)
        
        cameraView.startRunning()
        
        //Transfer the desired photos to the printer
//        let imageToPrint = UIImage(named: "aaaa")!
//        printImageAsPDF(image: imageToPrint)
        updateGridViewSize()
    
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        updateGridViewSize()
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateGridViewSize() {
        let cameraViewSize = cameraView.frame.size
        let gridSize = CGSize(width: cameraViewSize.width, height: cameraViewSize.width)
        let gridOrigin = CGPoint(x: cameraView.frame.origin.x, y: cameraView.frame.origin.y + (cameraViewSize.height - gridSize.height) / 2)
        gridView.frame = CGRect(origin: gridOrigin, size: gridSize)
    }
    
    
    @IBAction func ButtonDidTap(_ sender: Any) {
        print("capture")
        cameraView.capturePhoto { result in
            switch result {
            case .success(let image):
                print("사진 저장")
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                break
            case .failure(let error):
                print("저장 실패 \(error)")
                break
            }
        }
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
