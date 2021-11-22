source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '12.2'

install! 'cocoapods',
         warn_for_multiple_pod_sources: false,
         deterministic_uuids: false,
         generate_multiple_pod_projects: true,
         integrate_targets: false

use_frameworks!

pod 'ReaderSDK2',
  podspec: './ReaderSDK2.podspec'

pod 'MockReaderUI',
  podspec: './MockReaderUI.podspec'

pod 'ReaderSDK2SampleApp',
  path: './',
  appspecs: %w[SampleApp]

pod 'ReaderSDK2UI',
  path: './'
