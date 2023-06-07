import UIKit
import Foundation
import AVFoundation
import Photos

public enum CameraAspectRatio {
    case square // 1 : 1
    case full // UIView bounds
    case portrait // length 16 : 9
    case landscape // width 16 : 9
    case custom(width: CGFloat, height: CGFloat) //custom
}

public enum CameraPosition {
    case front //This is normal camera mode
    case back //This is selfie mode
}

enum CameraError: Error {
    case captureStillImageOutput
    case imageData
}

open class XCamera: UIView, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    let captureSession = AVCaptureSession()
    var cameraDevice: AVCaptureDevice!
    var cameraInput: AVCaptureDeviceInput!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var stillImageOutput: AVCapturePhotoOutput!
    var captureCompletion: ((Result<UIImage, Error>) -> Void)? // 사진 캡처 완료 핸들러
    
    private var filter: CIFilter? // filter 멤버 변수 추가
    
    private let minimumZoom: CGFloat = 1.0
    private let maximumZoom: CGFloat = 5.0
    private var lastZoomFactor: CGFloat = 1.0
    
    ///Default aspectRation is full
    var aspectRatio: CameraAspectRatio = .full
    
    ///Default flashMode is off
    var flashMode: AVCaptureDevice.FlashMode = .off
    
    ///Default cameraPosition is .back
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
        
        /// AVCaptureDevice
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
        
        // 사진 캡처를 위한 AVCapturePhotoOutput 초기화
        stillImageOutput = AVCapturePhotoOutput()
        if captureSession.canAddOutput(stillImageOutput) {
            captureSession.addOutput(stillImageOutput)
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        // AVCaptureVideoPreviewLayer frame == XCamera UIview bounds
        previewLayer.frame = bounds
        
        let size: CGSize
        switch aspectRatio {
        case .square: // 1 : 1
            size = CGSize(width: min(bounds.width, bounds.height), height: min(bounds.width, bounds.height))
        case .full: // UIView bounds
            size = bounds.size
        case .portrait: // length 16 : 9
            size = CGSize(width: bounds.height * 9 / 16, height: bounds.height)
        case .landscape: // width 16 : 9
            size = CGSize(width: bounds.width, height: bounds.width * 3 / 4)
        case .custom(let width, let height):
            size = CGSize(width: width, height: height)
        }
        
        let previewLayerFrame = CGRect(origin: .zero, size: size)
        previewLayer.frame = previewLayerFrame
        
        //Center code
        previewLayer.position = CGPoint(x: bounds.width / 2, y: bounds.maxY / 2)
    }
    
    open func startRunning() {
        //        AVCaptureDeviceInput, AVCaptureSessioning != AVCaptureSession start
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
    
    ///Code to stop the camera
    open func stopRunning() {
        //if AVCaptureSessioning = AVCaptureSession stop
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }
    
    
    ///You can change the aspect ratio of the camera
    /// Camera aspectRatio
    /// - Parameters:
    ///   - aspectRatio: CameraAspectRatio
    open func setAspectRatio(_ aspectRatio: CameraAspectRatio) {
        self.aspectRatio = aspectRatio
        setNeedsLayout()
    }
    
    ///You can turn the camera's flash off and on
    /// Camera flash
    /// - Parameters:
    ///   - mode: .off or .on
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
    
    ///You can set the direction the camera faces
    /// The direction the camera faces
    /// - Parameters:
    ///   - setCameraPosition: CameraPosition
    open func setCameraPosition(_ position: CameraPosition) {
        cameraPosition = position
    }
    
    ///Set corner radius of the camera layer
    /// - Parameters:
    ///   - radius: The radius to use when drawing rounded corners for the layer.
    open func setCameraCornerRadius(_ radius: CGFloat) {
        previewLayer.cornerRadius = radius
        previewLayer.masksToBounds = true
    }
    
    open func setFilter(_ filter: CIFilter?) {
        if let filter = filter {
            guard let connection = previewLayer?.connection else { return }
            connection.videoOrientation = .portrait
            
            let newPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            newPreviewLayer.videoGravity = .resizeAspectFill
            newPreviewLayer.frame = bounds
            layer.addSublayer(newPreviewLayer)
            
            let videoOutput = AVCaptureVideoDataOutput()
            videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sample buffer delegate", attributes: []))
            
            if captureSession.canAddOutput(videoOutput) {
                captureSession.addOutput(videoOutput)
            }
            
            self.filter = filter
        } else {
            self.filter = nil
        }
    }
    
    /// Print the image as a PDF and present a print controller to print the document.
    /// - Parameters:
    ///   - image: The image to be printed as a PDF.
    func printImageAsPDF(image: UIImage) {
        let pdfData = NSMutableData()
        let pdfConsumer = CGDataConsumer(data: pdfData as CFMutableData)!
        var mediaBox = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        let pdfContext = CGContext(consumer: pdfConsumer, mediaBox: &mediaBox, nil)!
        
        pdfContext.beginPage(mediaBox: &mediaBox)
        pdfContext.draw(image.cgImage!, in: mediaBox)
        pdfContext.endPage()
        pdfContext.closePDF()
        
        DispatchQueue.main.async {
            let printController = UIPrintInteractionController.shared
            let printInfo = UIPrintInfo.printInfo()
            printInfo.outputType = .general
            printInfo.jobName = "Print Job"
            printController.printInfo = printInfo
            printController.printingItem = pdfData as Data
            
            printController.present(animated: true) { (printController, completed, error) in
                if let error = error {
                    print("Printing error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    /// Handle pinch gesture to control the zoom level of the camera.
    /// - Parameter pinchGesture: The UIPinchGestureRecognizer for zoom control.
    /// - Returns: The new zoom level as a rounded double value.
    public func handleZoomGesture(pinchGesture: UIPinchGestureRecognizer) -> Double {
        func calculateZoomFactor(factor: CGFloat) -> CGFloat {
            let minZoomFactor = min(min(max(factor, minimumZoom), maximumZoom), cameraDevice?.activeFormat.videoMaxZoomFactor ?? 1.0)
            return minZoomFactor
        }
        
        func updateZoom(factor: CGFloat) {
            guard let device = cameraDevice else {
                return
            }
            
            do {
                try device.lockForConfiguration()
                defer {
                    device.unlockForConfiguration()
                }
                
                device.videoZoomFactor = factor
            } catch {
                print("Error updating zoom: \(error.localizedDescription)")
            }
        }
        
        let newScaleFactor = calculateZoomFactor(factor: pinchGesture.scale * lastZoomFactor)
        
        switch pinchGesture.state {
        case .began, .changed:
            updateZoom(factor: newScaleFactor)
            
        case .ended:
            lastZoomFactor = calculateZoomFactor(factor: newScaleFactor)
            updateZoom(factor: lastZoomFactor)
            
        default:
            break
        }
        
        return Double(newScaleFactor).rounded(places: 1)
    }
    
    /// Capture photos using current camera settings.
    /// - Parameter completion: A completion handler that returns either a captured image or an error.
    open func capturePhoto(completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let connection = stillImageOutput.connection(with: .video) else {
            completion(.failure(CameraError.captureStillImageOutput))
            return
        }
        
        let photoSettings = AVCapturePhotoSettings()
        photoSettings.flashMode = flashMode
        
        stillImageOutput.capturePhoto(with: photoSettings, delegate: self)
        
        // AVCapturePhotoCaptureDelegate
        self.captureCompletion = completion
    }
}

extension Double {
    public func rounded(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self*divisor).rounded() / divisor
    }
}


// AVCapturePhotoCaptureDelegate
extension XCamera: AVCapturePhotoCaptureDelegate {
    public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            captureCompletion?(.failure(error))
            captureCompletion = nil
            return
        }
        
        guard let imageData = photo.fileDataRepresentation(), let capturedImage = UIImage(data: imageData) else {
            captureCompletion?(.failure(CameraError.imageData))
            captureCompletion = nil
            return
        }
        
        captureCompletion?(.success(capturedImage))
        captureCompletion = nil
    }
}

import UIKit

open class GridView: UIView {
    
    open override func draw(_ rect: CGRect) {
        print("draw func has called: \(bounds)")

        // Drawing code
        let borderLayer = gridLayer()
        borderLayer.path = UIBezierPath(rect: self.bounds).cgPath
        layer.addSublayer(borderLayer)
        
        let firstColumnPath = UIBezierPath()
        firstColumnPath.move(to: CGPoint(x: bounds.width / 3, y: 0))
        firstColumnPath.addLine(to: CGPoint(x: bounds.width / 3, y: bounds.height))
        let firstColumnLayer = gridLayer()
        firstColumnLayer.path = firstColumnPath.cgPath
        layer.addSublayer(firstColumnLayer)
        
        let secondColumnPath = UIBezierPath()
        secondColumnPath.move(to: CGPoint(x: (2 * bounds.width) / 3, y: 0))
        secondColumnPath.addLine(to: CGPoint(x: (2 * bounds.width) / 3, y: bounds.height))
        let secondColumnLayer = gridLayer()
        secondColumnLayer.path = secondColumnPath.cgPath
        layer.addSublayer(secondColumnLayer)
        
        let firstRowPath = UIBezierPath()
        firstRowPath.move(to: CGPoint(x: 0, y: bounds.height / 3))
        firstRowPath.addLine(to: CGPoint(x: bounds.width, y: bounds.height / 3))
        let firstRowLayer = gridLayer()
        firstRowLayer.path = firstRowPath.cgPath
        layer.addSublayer(firstRowLayer)
        
        let secondRowPath = UIBezierPath()
        secondRowPath.move(to: CGPoint(x: 0, y: ( 2 * bounds.height) / 3))
        secondRowPath.addLine(to: CGPoint(x: bounds.width, y: ( 2 * bounds.height) / 3))
        let secondRowLayer = gridLayer()
        secondRowLayer.path = secondRowPath.cgPath
        layer.addSublayer(secondRowLayer)
    }
    
    func gridLayer() -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineDashPattern = [1, 1]
        shapeLayer.frame = bounds
        shapeLayer.fillColor = UIColor.clear.cgColor
        // 클리어로 채우기 구현하지 않고, 스토리보드의 이미지 뷰의 투명도를 조절했습니다.
        return shapeLayer
    }
}


