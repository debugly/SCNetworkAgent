Pod::Spec.new do |s|
  s.name     = 'AFNetworking'
  s.version  = '2.7.0.1'
  s.license  = 'MIT'
  s.summary  = 'A delightful iOS and OS X networking framework.'
  s.homepage = 'https://github.com/AFNetworking/AFNetworking'
  s.social_media_url = 'https://twitter.com/AFNetworking'
  s.authors  = { 'Mattt Thompson' => 'm@mattt.me' }
  s.source   = { :git => 'https://github.com/AFNetworking/AFNetworking.git', :tag => s.version, :submodules => true }
  s.requires_arc = true
  
  s.public_header_files = 'AFNetworking/AFNetworking.h'
  s.source_files = 'AFNetworking/AFNetworking.h'
  
  s.ios.deployment_target = '7.0'
  s.osx.deployment_target = '10.9'
  
  s.subspec 'Serialization' do |ss|
    ss.source_files = 'AFNetworking/AFURL{Request,Response}Serialization.{h,m}'
    ss.public_header_files = 'AFNetworking/AFURL{Request,Response}Serialization.h'
    ss.ios.frameworks = 'CoreServices', 'CoreGraphics'
    ss.osx.frameworks = 'CoreServices'
  end

  s.subspec 'Security' do |ss|
    ss.source_files = 'AFNetworking/AFSecurityPolicy.{h,m}'
    ss.public_header_files = 'AFNetworking/AFSecurityPolicy.h'
    ss.frameworks = 'Security'
  end

  s.subspec 'NSURLConnection' do |ss|
    ss.ios.deployment_target = '7.0'
    ss.osx.deployment_target = '10.9'

    ss.dependency 'AFNetworking/Serialization'
    ss.dependency 'AFNetworking/Security'

    ss.source_files = 'AFNetworking/AFURLConnectionOperation.{h,m}', 'AFNetworking/AFHTTPRequestOperation.{h,m}', 'AFNetworking/AFHTTPRequestOperationManager.{h,m}'
    ss.public_header_files = 'AFNetworking/AFURLConnectionOperation.h', 'AFNetworking/AFHTTPRequestOperation.h', 'AFNetworking/AFHTTPRequestOperationManager.h'
  end

end
