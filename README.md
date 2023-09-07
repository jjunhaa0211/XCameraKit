![XCameraKitLogo](https://user-images.githubusercontent.com/102890390/232702695-52b2079f-379d-48f1-8b04-702c48306357.png)

[![CI Status](https://img.shields.io/travis/102890390/XCameraKit.svg?style=flat)](https://travis-ci.org/102890390/XCameraKit)
[![Version](https://img.shields.io/cocoapods/v/XCameraKit.svg?style=flat)](https://cocoapods.org/pods/XCameraKit)
[![License](https://img.shields.io/cocoapods/l/XCameraKit.svg?style=flat)](https://cocoapods.org/pods/XCameraKit)
[![Platform](https://img.shields.io/cocoapods/p/XCameraKit.svg?style=flat)](https://cocoapods.org/pods/XCameraKit)

#sorry
```ruby
 We will stop the service until
```

## Screenshots
    ⚠️ preparing! ⚠️


## Support Function
- Camera-related features 
- Video-related features (🙏 Please wait)
- Filter-related functions (🙏 Please wait)
- Frame-related features (🙏 Please wait)

# Installation

## CocoaPods:
- **For iOS 14+ projects:** 😈

    ```ruby
    pod 'XCameraKit'
    ```
    
## Carthage: 
- **For iOS 14+ projects:** 👾

    ```ruby
    🙏 Please wait
    ```

## SPM:
- **For iOS 14+ projects:** 💜

    ```ruby
    🙏 Please wait
    ```

Getting Started
-----------

### Info.plist 📄

- **How to allow camera access**:

    ```swift
    Privacy - Camera Usage Description // To access the camera, you must put it in info 🤙
    ```
    
- **How to allow album access**:

    ```swift
    Privacy - Photo Library Additions Usage Description //In order to access the album, it is mandatory to put it in info 🤙
    ```

### XCamera 📸

- **How to declare camera code**:

    ```swift
    var cameraView: XCamera!
    ```
    
- **How to run the camera**:

    ```swift
    cameraView.startRunning()
    ```
    
- **To stop the camera you need to do as below**:

    ```swift
    cameraView.stopRunning()
    ```
    
- **How to use the camera aspect ratio**:

    ```swift
    cameraView.setAspectRatio() // Defulat fullScreen
    cameraView.setAspectRatio(.square) //square 1 : 1
    cameraView.setAspectRatio(.full) //fullScreen UIView bounds
    cameraView.setAspectRatio(.portrait) // lengthScreen 16 : 9 
    cameraView.setAspectRatio(.landscape) // landscapeScreen 16 : 9
    cameraView.setAspectRatio(.custom(width: 1000, height: 200)) //custom
    ```
    
- **Set the background color of the camera**:

    ```swift
    cameraView.setBackgroundColor(.black) //UIColor
    ```
 
- **Turn the camera's flash off and on**:

    ```swift
    // Turn on to turn on the flash and turn off to turn off the flash. 
    cameraView.setFlashMode(.off) // Default is off.
    ```
    
- **How to change camera orientation**:

    ```swift
    // there is a .front and a .back
    cameraView.setCameraPosition(.front) // Defulat back
    ```
    
- **How to get the cornerRadius of the camera itself**:

    ```swift
    cameraView.setCameraCornerRadius(100.0)
    ```
 ### printing method 🖨️
 - **How to convert to pdf and print**:

    ```swift
    //go to print Options
    let imageToPrint = UIImage(named: "aaaa")! 
    printImageAsPDF(image: imageToPrint)
    ```
    
    
## Author

- 🎇 Github = jjunhaa0211
- 🌄 Gmail = goodjunha@gmail.com
- 🌆 Dm = jn_xhx

## Realization

- 🇺🇸 The library is constantly being updated. If you need a camera-related feature you want or find a bug, please send me an issue. 😎
- 🇰🇷 라이브러리에는 꾸준히 업데이트되고 있습니다. 혹시 원하는 카메라관련 기능이 필요하거나 버그를 발견하셨다면 저에게 Issues를 날려주세요. 😏

## License

XCameraKit is available under the MIT license. See the LICENSE file for more info.
