
Pod::Spec.new do |s|
  s.name             = 'MYDearLogin'
  s.version          = '0.1.0'
  s.summary          = 'A short description of MYDearLogin.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/温明妍/MYDearLogin'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '温明妍' => 'wenmy@tuya.com' }
  s.source           = { :git => 'https://github.com/温明妍/MYDearLogin.git', :tag => s.version.to_s }

  s.ios.deployment_target = '15.0'

  s.source_files = 'MYDearLogin/Classes/**/*'
  
   s.resource_bundles = {
     'MYDearLogin' => ['MYDearLogin/Assets/**/*.{png,xib}']
   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
   s.dependency 'MYNetwork'
   
end
