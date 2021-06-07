Pod::Spec.new do |s|
  s.name = 'ReaderSDK2SampleApp'
  s.version = '2.0.0-alpha8'
  s.license = {:type=>"Square Developer License", :text=>"Copyright (c) 2020-present, Square, Inc. All rights reserved.\nYour use of this software is subject to the Square Developer Terms of\nService (https://squareup.com/legal/developers). This copyright notice shall\nbe included in all copies or substantial portions of the software.\nTHE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR\nIMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,\nFITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE\nAUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER\nLIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,\nOUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN\nTHE SOFTWARE.\n"}
  s.homepage = 'https://github.com/Square-Beta-Testers/reader-sdk-2-ios'
  s.authors = 'Square'
  s.summary = 'Example app to integrate with the ReaderSDK2 framework'

  s.swift_version = ['5.0']

  s.ios.deployment_target = '11.0'

  s.source = { git: 'https://github.com/Square-Beta-Testers/reader-sdk-2-ios', tag: s.version }
  s.source_files = 'Apps/ReaderSDK2SampleApp/Sources/**/*.swift'
  s.resource_bundle = { 'ReaderSDK2SampleAppResources' => ['Apps/ReaderSDK2SampleApp/Resources/**/*']}
  
  s.dependency 'ReaderSDK2', '2.0.0-alpha8'
  
  s.dependency 'ReaderSDK2UI', '2.0.0-alpha8'
  
  s.dependency 'MockReaderUI', '2.0.0-alpha8'
  
  s.pod_target_xcconfig = s.consumer(:ios).pod_target_xcconfig.merge(
    'ENABLE_BITCODE' => 'NO'
  )
  s.app_spec 'SampleApp' do |app_spec|
    app_spec.source_files = 'Apps/ReaderSDK2SampleApp/Main/**/*.swift'

    app_spec.pod_target_xcconfig = s.consumer(:ios).pod_target_xcconfig.merge(
      'PRODUCT_NAME' => 'ReaderSDK2SampleApp Sample App',
      'PRODUCT_SHORT_NAME' => 'ReaderSDK2SampleApp Sample App',
      'INFOPLIST_FILE' => '${PODS_TARGET_SRCROOT}/Apps/ReaderSDK2SampleApp/Support/Info.plist',
      'SKIP_INSTALL' => 'NO',
      'ENABLE_BITCODE' => 'NO'
    )

    app_spec.script_phases = [
      {
        name: 'Run the setup script',
        script: 'FRAMEWORKS="${BUILT_PRODUCTS_DIR}/${FRAMEWORKS_FOLDER_PATH}" && "${FRAMEWORKS}/ReaderSDK2.framework/setup" || { echo "Setup script failed (See README)." >&2 && exit 1 }',
        shell_path: '/bin/zsh',
        execution_position: :after_compile
      }
    ]
  end
end
