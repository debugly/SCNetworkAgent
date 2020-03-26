#
# Be sure to run `pod lib lint SCNetworkAgent.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SCNetworkAgent'
  s.version          = '0.1.10'
  s.summary          = 'A cocoa network abstract layer.'
  s.description      = <<-DESC
  SCNetworkAgent module is a cocoa network abstract layer, business module needn't care the owner network implementation.
  The owner must implement SCNetworkAgent's methods by registration before business module send request!
                       DESC

  s.homepage         = 'https://github.com/debugly/SCNetworkAgent'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'MattReach' => 'qianglongxu@gmail.com' }
  s.source           = { :git => 'https://github.com/debugly/SCNetworkAgent.git', :tag => s.version.to_s }

  s.ios.deployment_target = '7.0'
  s.osx.deployment_target = '10.10'
  s.source_files = 'SCNetworkAgent/Classes/**/*'  
  s.frameworks = 'Foundation'

end
