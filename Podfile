# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

target 'Icarus' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Icarus
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'Firebase/Storage'
  pod 'RSLoadingView', '1.1.1'
  pod 'Kingfisher', '5.4.0'
  pod 'Mapbox-iOS-SDK', '~> 4.0'
  pod 'MapboxDirections.swift', '0.27.0'
  pod 'MapboxCoreNavigation', '0.30.0'
  pod 'MapboxNavigation', '0.30.0'
  
  target 'IcarusTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'IcarusUITests' do
    inherit! :search_paths
    # Pods for testing
  end
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '4.0'
      end
    end
  end

end
