import UIKit
import Foundation
import AVFoundation

public enum CameraAspectRatio {
    case square // 1 : 1
    case full // UIView bounds
    case portrait // length 16 : 9
    case landscape // width 16 : 9
}

public enum CameraPosition {
    case front
    case back
}

open class XCamera: UIView {
    
    let captureSession = AVCaptureSession()
    var cameraDevice: AVCaptureDevice!
    var cameraInput: AVCaptureDeviceInput!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var aspectRatio: CameraAspectRatio = .full
    
    var flashMode: AVCaptureDevice.FlashMode = .off
    
    var cameraPosition: CameraPosition = .back {
        didSet {
            guard let currentInput = cameraInput else {
                return
            }
            captureSession.beginConfiguration()
            captureSession.removeInput(currentInput)
            
            let newPosition: AVCaptureDevice.Position = (cameraPosition == .back) ? .back : .front
            let newCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: newPosition)
            do {
                let newInput = try AVCaptureDeviceInput(device: newCameraDevice!)
                if captureSession.canAddInput(newInput) {
                    captureSession.addInput(newInput)
                    cameraInput = newInput
                    cameraDevice = newCameraDevice
                } else {
                    captureSession.addInput(currentInput)
                }
            } catch {
                captureSession.addInput(currentInput)
                print("Error creating AVCaptureDeviceInput: \(error.localizedDescription)")
            }
            
            captureSession.commitConfiguration()
        }
    }
        
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    ///You can set the background color of the camera.
    /// Camera BackgroundColor
    /// - Parameters:
    ///   - color: UIColor
    open func setBackgroundColor(_ color: UIColor = .black) {
        // background color
        backgroundColor = color
    }
    
    private func commonInit() {
        
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
        
        // make AVCaptureVideoPreviewLayer
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(previewLayer)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        // AVCaptureVideoPreviewLayer frame == XCamera UIview bounds
        previewLayer.frame = bounds
        
        let size: CGSize
        switch aspectRatio {
        case .square:
            size = CGSize(width: min(bounds.width, bounds.height), height: min(bounds.width, bounds.height))
        case .full:
            size = bounds.size
        case .portrait:
            size = CGSize(width: bounds.height * 9 / 16, height: bounds.height)
        case .landscape:
            size = CGSize(width: bounds.width, height: bounds.width * 3 / 4)
        }
        
        let previewLayerFrame = CGRect(origin: .zero, size: size)
        previewLayer.frame = previewLayerFrame
        previewLayer.position = CGPoint(x: bounds.width / 2, y: bounds.maxY / 2)
    }
    
    open func startRunning() {
        //AVCaptureDeviceInput, AVCaptureSessioning != AVCaptureSession start
        if cameraInput != nil && !captureSession.isRunning {
            captureSession.beginConfiguration()
            captureSession.sessionPreset = .high
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
    
    open func setAspectRatio(_ aspectRatio: CameraAspectRatio) {
        self.aspectRatio = aspectRatio
        setNeedsLayout()
    }
    
    open func setFlashMode(_ mode: AVCaptureDevice.FlashMode) {
        guard let device = cameraDevice else {
            return
        }
        guard device.hasFlash else {
            return
        }
        do {
            try device.lockForConfiguration()
            let photoSettings = AVCapturePhotoSettings()
            photoSettings.flashMode = mode
            device.unlockForConfiguration()
        } catch {
            print("Error setting flash mode: \(error.localizedDescription)")
        }
    }
    
    open func setCameraPosition(_ position: CameraPosition) {
        cameraPosition = position
    }
}
