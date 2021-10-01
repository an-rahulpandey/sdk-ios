//
//  Bundle+Extensions.swift
//  ReaderSDK2UI
//
//  Created by Mike Silvis on 3/9/20.
//

import Foundation

fileprivate final class ReaderSDK2UIBundleFinderClass {
    fileprivate static let bundleFinderBundle: Bundle = {
        Bundle(for: ReaderSDK2UIBundleFinderClass.self)
    }()
}

extension Bundle {
    static var readerSDK2UIResources: Bundle {
        let containingBundle = ReaderSDK2UIBundleFinderClass.bundleFinderBundle
        let bundleURL = containingBundle.url(forResource: "ReaderSDK2UIResources", withExtension: "bundle")
        guard let bundle = bundleURL.flatMap(Bundle.init) else {
            fatalError("Could not find resource bundle 'ReaderSDK2UIResources' within main bundle")
        }
        return bundle
    }
}
