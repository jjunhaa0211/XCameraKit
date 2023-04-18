Pod::Spec.new do |s|
    s.name = 'XCameraKit'
    s.version = '0.1.0'
    s.swift_version = '5.5'
    s.summary = 'An easy-to-use library for camera management in iOS apps.'
    s.homepage = 'https://github.com/jjunhaa0211/XCameraKit'
    s.license = { :type => 'MIT', :file => 'LICENSE' }
    s.authors = { 'jjunhaa0211' => 'goodjunha@gmail.com' }
    s.source = { :git => 'https://github.com/jjunhaa0211/XCameraKit.git', :tag => s.version.to_s }
    s.ios.deployment_target = '14.0'
    s.source_files = 'XCameraKit/Classes/*.swift'
end
