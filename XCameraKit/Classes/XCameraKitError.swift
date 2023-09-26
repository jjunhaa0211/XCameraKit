//
//  XCameraKitError.swift
//  XCameraKit
//
//  Created by 박준하 on 2023/06/07.
//


import UIKit
import Photos

public enum XCameraKitError: Error {
    case XCameraError(condition: XCameraError)
    case XFilterError(condition: XFilterError)
    case XVideoError(condition: XVideoError)
    case XAlbumError(condition: XAlbum)
    case XPrinterError(condition: XPrinter)
}

public enum XCameraError {
    case noCamera
    case noWorking
    case noCapturing
    case noPermission
    case noZoom
    case noFlash
    case noTransform
}

public enum XFilterError {
    case filterFailed
    case noWorking
    case noPermission
}

public enum XVideoError {
    case noVideo
    case noWorking
    case noPermission
}

public enum XAlbum {
    case saveError
    case noWorking
    case noPermission
}

public enum XPrinter {
    case noprinter
    case noWorking
    case noPermission
}

extension XCameraKitError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .XCameraError(let condition):
            switch condition {
            case .noCamera:
                return "The camera is not functioning."
            case .noWorking:
                return "The camera is working but not capturing."
            case .noCapturing:
                return "Unable to capture photos."
            case .noPermission:
                return "No permission to access the camera."
            case .noZoom:
                return "Unable to zoom the camera."
            case .noFlash:
                return "Unable to activate the camera's flash."
            case .noTransform:
                return "Unable to rotate the camera's orientation."
            }
        case .XFilterError(let condition):
            switch condition {
            case .filterFailed:
                return "Failed to apply filters."
            case .noWorking:
                return "Filters applied, but no changes were made."
            case .noPermission:
                return "No permission to apply filters."
            }
        case .XVideoError(let condition):
            switch condition {
            case .noVideo:
                return "Video is not functioning."
            case .noWorking:
                return "Video is working but not capturing."
            case .noPermission:
                return "No permission to access the video."
            }
        case .XAlbumError(let condition):
            switch condition {
            case .saveError:
                return "Unable to save the photo."
            case .noWorking:
                return "Unable to save photos."
            case .noPermission:
                return "No permission to save photos."
            }
        case .XPrinterError(let condition):
            switch condition {
            case .noprinter:
                return "Unable to print."
            case .noWorking:
                return "Unable to perform printing operation."
            case .noPermission:
                return "No permission to access the printer."
            }
        }
    }
}
