#
# Be sure to run `pod lib lint MYDearHome.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MYDearHome'
  s.version          = '0.1.0'
  s.summary          = 'A short description of MYDearHome.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/温明妍/MYDearHome'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '温明妍' => 'wenmingyan1990@163.com' }
  s.source           = { :git => 'https://github.com/温明妍/MYDearHome.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '15.0'

  s.source_files = 'MYDearHome/Classes/**/*'
  
  # s.resource_bundles = {
  #   'MYDearHome' => ['MYDearHome/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
   s.dependency 'MYNetwork'
   
end
