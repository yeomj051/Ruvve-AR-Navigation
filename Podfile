# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'ruvve-ios' do
  pod 'Firebase/Analytics'
  pod 'Firebase/Messaging'
  pod 'GooglePlaces'
  pod 'ARCL', :path => '.'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES'] = 'YES'
        end
    end

  target 'ruvve-iosTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ruvve-iosUITests' do
    # Pods for testing
  end

end
