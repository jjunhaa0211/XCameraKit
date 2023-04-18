![XCameraKitLogo](https://user-images.githubusercontent.com/102890390/232702695-52b2079f-379d-48f1-8b04-702c48306357.png)

[![CI Status](https://img.shields.io/travis/102890390/XCameraKit.svg?style=flat)](https://travis-ci.org/102890390/XCameraKit)
[![Version](https://img.shields.io/cocoapods/v/XCameraKit.svg?style=flat)](https://cocoapods.org/pods/XCameraKit)
[![License](https://img.shields.io/cocoapods/l/XCameraKit.svg?style=flat)](https://cocoapods.org/pods/XCameraKit)
[![Platform](https://img.shields.io/cocoapods/p/XCameraKit.svg?style=flat)](https://cocoapods.org/pods/XCameraKit)

## Screenshots

## Features
- 
-
-
-

## Installation

- **For iOS 14+ projects:**

    ```ruby
    pod 'XCameraKit'
    ```

Getting Started
-----------

### XCamera

- **How to declare camera code**:

    ```swift
    var cameraView: XCamera!
    ```
    
- **How to use the camera aspect ratio**:

    ```swift
    cameraView.setAspectRatio() // Defulat fullScreen
    cameraView.setAspectRatio(.square) //square 1 : 1
    cameraView.setAspectRatio(.full) //fullScreen UIView bounds
    cameraView.setAspectRatio(.portrait) // lengthScreen 16 : 9 
    cameraView.setAspectRatio(.landscape) // landscapeScreen 16 : 9
    ```
    
- **Set the background color of the camera.**:

    ```swift
    cameraView.setBackgroundColor(.black) //UIColor
    ```
 
- **Turn the camera's flash off and on.**:

    ```swift
    // Turn on to turn on the flash and turn off to turn off the flash. 
    cameraView.setFlashMode(.off) Default is off.
    ```

## Author

102890390, goodjunha@gmail.com

## License

XCameraKit is available under the MIT license. See the LICENSE file for more info.
