use_frameworks!

target 'Found' do
  pod 'GoogleMaps', '~> 2.1.0'
  pod 'GooglePlaces', '~> 2.1.0'
  pod 'SnapKit', '~> 3.0'
  pod 'RealmSwift', '~> 2.0.1'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end
