Pod::Spec.new do |s|
    s.name = 'XCameraKit'
    s.version = '0.1.0'
    s.swift_version = '4.2'
    s.summary = 'This library is a library that allows you to use the camera easily.'
    s.homepage = 'https://github.com/jjunhaa0211/XCameraKit'
    s.license = { :type => 'MIT', :file => 'LICENSE' }
    s.author = { 'jjunhaa0211' => 'goodjunha@gmail.com' }
    s.source = { :git => 'https://github.com/jjunhaa0211/XCameraKit.git', :tag => s.version.to_s }
    s.ios.deployment_target = '14.0'
    s.source_files = 'XCameraKit/Classes/**/*'
end

