require_relative '../../node_modules/@capacitor/ios/scripts/pods_helpers'

platform :ios, '16.0'
use_frameworks!

# workaround to avoid Xcode caching of Pods that requires
# Product -> Clean Build Folder after new Cordova plugins installed
# Requires CocoaPods 1.6 or newer
install! 'cocoapods', :disable_input_output_paths => true

def capacitor_pods
  pod 'Capacitor', :path => '../../node_modules/@capacitor/ios'
  pod 'CapacitorCordova', :path => '../../node_modules/@capacitor/ios'
  pod 'CapacitorCommunityPrivacyScreen', :path => '../../node_modules/@capacitor-community/privacy-screen'
  pod 'CapacitorApp', :path => '../../node_modules/@capacitor/app'
  pod 'CapacitorDevice', :path => '../../node_modules/@capacitor/device'
  pod 'CapacitorFilesystem', :path => '../../node_modules/@capacitor/filesystem'
  pod 'CapacitorPreferences', :path => '../../node_modules/@capacitor/preferences'
  pod 'CapacitorPushNotifications', :path => '../../node_modules/@capacitor/push-notifications'
end

target 'App' do
  capacitor_pods
  # Add your Pods here
end

def normalize_pods_support_file_paths(installer)
  support_file_groups = [
    'Capacitor',
    'CapacitorApp',
    'CapacitorCommunityPrivacyScreen',
    'CapacitorCordova',
    'CapacitorDevice',
    'CapacitorFilesystem',
    'CapacitorPreferences',
    'CapacitorPushNotifications'
  ]
  legacy_prefix = File.join('..', '..', '..', 'ios', 'App', 'Pods')

  installer.pods_project.groups.flat_map(&:recursive_children).grep(Xcodeproj::Project::Object::PBXGroup).each do |group|
    next unless group.display_name == 'Support Files'
    next unless support_file_groups.any? { |name| group.path == "#{legacy_prefix}/Target Support Files/#{name}" }

    group.path = group.path.sub("#{legacy_prefix}/", '')
    group.source_tree = 'SOURCE_ROOT'
  end
end

post_install do |installer|
  assertDeploymentTarget(installer)
  normalize_pods_support_file_paths(installer)
end
