#
# Be sure to run `pod lib lint MYDearBusiness.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MYDearBusiness'
  s.version          = '0.1.0'
  s.summary          = 'A short description of MYDearBusiness.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/温明妍/MYDearBusiness'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '温明妍' => 'wenmingyan1990@163.com' }
  s.source           = { :git => 'https://github.com/温明妍/MYDearBusiness.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '15.0'

  s.source_files = 'MYDearBusiness/Classes/**/*'
  
  # s.resource_bundles = {
  #   'MYDearBusiness' => ['MYDearBusiness/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
   s.dependency 'MYNetwork'
   s.dependency 'MYRouter'
   s.dependency 'MYUtils'
   

   s.subspec 'Debug' do |subspec|
     subspec.source_files = 'MYDearBusiness/Debug/**/*'  # 模块的源代码文件
     
     # 模块的依赖关系
     subspec.dependency 'MYDearDebug'

     
#     # 模块的其他设置
#     module.frameworks = 'UIKit', 'Foundation'
#     module.weak_frameworks = 'SomeFramework'
#     module.pod_target_xcconfig = { 'OTHER_SWIFT_FLAGS' => '-D MODULE_NAME_ENABLED' }
   end
   
   
end
