use_frameworks!
platform :ios, '10.0'

def network_stubber_pod
  pod "NetworkStubber", :path => "LocalPods/NetworkStubber"
end

def access_ids_pod
  pod "AccessIDs", :path => "LocalPods/AccessIDs"
end

target 'WeatherForecast' do
  # Pods for WeatherForecast
  pod 'SnapKit'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'Moya/RxSwift'
  pod 'AlamofireImage'
  access_ids_pod

  target 'WeatherForecastTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'Quick', '~> 5.0.1'
    pod 'Nimble', '~> 9.2.1'
    pod 'RxTest'
    pod 'RxBlocking'
    network_stubber_pod
  end

  target 'WeatherForecastUITests' do
    # Pods for testing
    access_ids_pod
    pod 'Shock', '~> 4.0.1'
  end

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings["ENABLE_TESTABILITY"] = "YES"
      end
    end
  end
end
