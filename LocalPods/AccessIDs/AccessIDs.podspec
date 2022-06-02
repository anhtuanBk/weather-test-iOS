Pod::Spec.new do |s|
  s.name             = 'AccessIDs'
  s.version          = '0.0.1'
  s.summary          = 'A lib consists of all accessibility identifiers to be shared between main target and UI test target'
  s.homepage         = 'https://test.me'
  s.license          = 'test'
  s.author           = 'test'
  s.source           = { :path => "." }

  s.ios.deployment_target = '10.0'
  s.static_framework = true
  
  s.source_files = 'Classes/**/*'
end
