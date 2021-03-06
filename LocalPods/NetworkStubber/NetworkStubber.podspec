Pod::Spec.new do |s|
  s.name             = 'NetworkStubber'
  s.version          = '0.0.1'
  s.summary          = 'A lib to stub networking API requests and responses'
  s.homepage         = 'https://test.me'
  s.license          = 'test'
  s.author           = 'test'
  s.source           = { :path => "." }

  s.ios.deployment_target = '10.0'
  s.static_framework = true
  
  s.source_files = 'Classes/**/*'

  s.dependency 'OHHTTPStubs/Swift' 
  s.dependency 'Moya/RxSwift'
end
