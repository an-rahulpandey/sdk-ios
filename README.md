# Square Reader SDK 2

Build remarkable In-Person experiences using Square's new Reader SDK product now in Alpha. Reader SDK 2 has the advantage of being an API driven framework that allows for full customization as well as using the latest [V2/Payments](https://developer.squareup.com/explorer/square/payments-api/list-payments) API.

For detailed instructions on using the SDK see [quick start guide](quick-start.md)

## Installation

### Cocoapods

Install with [CocoaPods](http://cocoapods.org/) by adding the following to your Podfile:

```
source 'https://github.com/square/Specs.git'

use_frameworks!

pod "ReaderSDK2", "~> 2.0.0.alpha10"

# Optionally include ReaderSDK2UI if you do not wish to build your own UIViewControllers
pod "ReaderSDK2UI", "~> 2.0.0.alpha10"

# Optionally include MockReaderUI if you wish to simulate a physical reader when one is not present.
# This feature is only available when provided a sandbox application id. 
pod "MockReaderUI", "~> 2.0.0.alpha10", configurations: ['Debug']
```
_Note that MockReaderUI framework **requires** that `ReaderSDK2` framework to also be present in podfile_

#### Add build phase to setup the ReaderSDK2 framework ####

On your application targets’ Build Phases settings tab, click the + icon and choose New Run Script Phase. Create a Run Script in which you specify your shell (ex: /bin/sh), add the following contents to the script area below the shell:
```
FRAMEWORKS="${BUILT_PRODUCTS_DIR}/${FRAMEWORKS_FOLDER_PATH}"
"${FRAMEWORKS}/ReaderSDK2.framework/setup"
```

#### Disable Bitcode

Bitcode should be disabled as Reader SDK 2 does not currently support it.

## Run Sample App Locally

To run the project locally and try out our Sample App that showcases directly how to integrate with ReaderSDK2:

* Run `bundle exec pod install`
* Open `ReaderSDK2SampleApp.xcworkspace`
* Configure the [Config.swift](Apps/ReaderSDK2SampleApp/Sources/Config.swift) with squareApplicationID, accessToken and locationID. For more info on how to obtain these, see [Quick Start guide](quick-start.md)
* Build the `ReaderSDK2SampleApp-SampleApp` scheme

## Documentation Links
* [ReaderSDK2 overview](https://docs.google.com/document/d/1SwWf8Q8DQWN8_qZfUCFkUkKCx0Iek5CAsbAPpsJH3FQ/edit?usp=sharing)
* [iOS Setup Guide](https://docs.google.com/document/d/1QixBx8LMzV1WtGrUL_4uZQVMw8RgEPZdBzYX9z0jPeo/edit?usp=sharing)
* [iOS Tech Ref](https://drive.google.com/file/d/1PCAz7XtRkLHevedr7_U88wI0wxkDi_8j/view?usp=sharing)

