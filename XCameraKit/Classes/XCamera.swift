import UIKit
import Foundation
import AVFoundation

open class XCamera: UIView {
    
    let captureSession = AVCaptureSession()
    var cameraDevice: AVCaptureDevice!
    var cameraInput: AVCaptureDeviceInput!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        //backgroundColor
        backgroundColor = .black
        
        // AVCaptureDevice
        let cameraDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back)
        
        cameraDevice = cameraDeviceDiscoverySession.devices.first
        
        // make AVCaptureDeviceInput
        do {
            cameraInput = try AVCaptureDeviceInput(device: cameraDevice)
        } catch let error {
            print("Error creating AVCaptureDeviceInput: \(error.localizedDescription)")
                        return
        }
        
        //make AVCaptureVideoPreviewLayer
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(previewLayer)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutSubviews() {
         super.layoutSubviews()
        
        //AVCaptureVideoPreviewLayer frame == XCamera UIview bounds
        previewLayer.frame = bounds
        
    }
    
    open func startRunning() {
        //AVCaptureDeviceInput, AVCaptureSessioning != AVCaptureSession start
        if cameraInput != nil && !captureSession.isRunning {
            captureSession.beginConfiguration()
            captureSession.sessionPreset = .photo
            if captureSession.canAddInput(cameraInput) {
                captureSession.addInput(cameraInput)
            }
            captureSession.commitConfiguration()
            captureSession.startRunning()
        }
    }
    
    open func stopRunning() {
        //if AVCaptureSessioning = AVCaptureSession stop
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
}
