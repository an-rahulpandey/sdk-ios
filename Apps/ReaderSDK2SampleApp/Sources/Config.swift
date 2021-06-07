//
//  Config.swift
//  ReaderSDK2-SampleApp
//
//  Created by James Smith on 3/14/19.
//

import Foundation
import ReaderSDK2

enum Config {
     static let squareApplicationID: String = <# squareApplicationID #>

    // In a production application you should use your server to obtain an access token and locationID.
    // For this sample app, we can just authorize Reader SDK using hardcoded values.
     static let accessToken: String = <# squareAccessToken #>
     static let locationID: String = <# locationID #>
}
