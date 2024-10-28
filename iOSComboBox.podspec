#
# Be sure to run `pod lib lint ${POD_NAME}.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'iOSComboBox'
  s.version          = '0.0.3'
  s.summary          = 'A library that provides a customizable combo box (drop-down) view for iOS'

  s.description      = <<-DESC
    iOSComboBox is a custom UI component for iOS that provides a dropdown menu, 
    similar to the combo box UI found on desktop applications. It allows users 
    to select from a list of options within a compact, tappable interface, making 
    it ideal for forms, settings screens, and selection menus in iOS applications. 
    iOSComboBox is highly customizable, supporting a wide range of configuration 
    options including custom colors, fonts, and animations. 

    Key features include:
    - Customizable dropdown appearance with adjustable colors, fonts, and sizes.
    - Smooth animations for opening and closing the dropdown.
    - Configurable max height to prevent overlap with other UI elements.
    - Delegate support for handling item selection and other events.
    - Easy integration with SwiftUI and UIKit.

    iOSComboBox is designed to be lightweight, performant, and user-friendly, 
    fitting seamlessly into modern iOS applications.
DESC

  s.homepage         = 'https://github.com/rojarand/iOSComboBox.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '${USER_NAME}' => '${USER_EMAIL}' }
  s.source           = { :git => 'git@github.com:rojarand/iOSComboBox.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.0'
  s.swift_version = '5.0'

  s.source_files = 'iOSComboBox/Sources/**/*'
  
end
