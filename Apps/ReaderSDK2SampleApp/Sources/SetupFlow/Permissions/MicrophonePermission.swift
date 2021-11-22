//
//  MicrophonePermission.swift
//  ReaderSDK2-SampleApp
//
//  Created by James Smith on 3/18/19.
//

import AVFoundation

struct MicrophonePermission: Permission {
    let prompt = Strings.Permissions.microphonePrompt

    var reason: String {
        return Bundle.main.object(forInfoDictionaryKey: "NSMicrophoneUsageDescription") as! String
    }

    var status: PermissionStatus {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .undetermined:
            return .notDetermined
        case .granted:
            return .granted
        case .denied:
            return .denied
        @unknown default:
            return .denied
        }
    }

    func requestFromUser(completion: @escaping () -> Void) {
        AVAudioSession.sharedInstance().requestRecordPermission { _ in
            DispatchQueue.main.async(execute: completion)
        }
    }
}
