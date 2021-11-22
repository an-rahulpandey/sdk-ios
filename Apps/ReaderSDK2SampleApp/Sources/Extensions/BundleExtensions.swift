//
//  BundleExtensions.swift
//  R2SampleApp
//
//  Created by Mike Silvis on 6/12/20.
//  Copyright © 2020 Square, Inc. All rights reserved.
//

import Foundation

fileprivate final class R2SampleAppBundleFinderClass {
    fileprivate static let bundleFinderBundle: Bundle = {
        Bundle(for: R2SampleAppBundleFinderClass.self)
    }()
}

extension Bundle {
    static var r2SampleAppResources: Bundle {
        let containingBundle = R2SampleAppBundleFinderClass.bundleFinderBundle
        let bundleURL = containingBundle.url(forResource: "ReaderSDK2SampleAppResources", withExtension: "bundle")
        guard let bundle = bundleURL.flatMap(Bundle.init) else {
            fatalError("Could not find resource bundle 'ReaderSDK2SampleAppResources' within main bundle")
        }
        return bundle
    }
}
