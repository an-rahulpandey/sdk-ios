//
//  ReaderSDK2UIStrings.swift
//  ReaderSDK2UI
//
//  Created by Mike Silvis on 9/23/19.
//

import Foundation

/// A namespace for localized string constants
public enum ReaderSDK2UIStrings {}

// MARK: - Generic strings
extension ReaderSDK2UIStrings {

    static var errorDismissButtonTitle: String {
        return NSLocalizedString(
            "ReaderSDK2UI_GenericStrings_ErrorDismissButtonTitle",
            tableName: nil,
            bundle: .readerSDK2UIResources,
            value: "Dismiss",
            comment: "The title of button used to dismiss an error."
        )
    }
}


// MARK: - Readers List Strings
extension ReaderSDK2UIStrings {
    enum Readers {
        static var title: String {
            return NSLocalizedString(
                "ReaderSDK2UI_Readers_Title",
                tableName: nil,
                bundle: .readerSDK2UIResources,
                value: "Readers",
                comment: "The title of the screen that allows the user to manage their connected readers"
            )
        }

        static var connectReaderButtonTitle: String {
            return NSLocalizedString(
                "ReaderSDK2UI_Readers_ConnectReaderButtonTitle",
                tableName: nil,
                bundle: .readerSDK2UIResources,
                value: "Connect a reader",
                comment: "The title of the button used to start pairing with nearby Square bluetooth readers."
            )
        }

        static var hardwareSectionTitle: String {
            return NSLocalizedString(
                "ReaderSDK2UI_Readers_HardwareSection",
                tableName: nil,
                bundle: .readerSDK2UIResources,
                value: "Hardware",
                comment: "The title of the table which displays all Square hardware that is currently connected to the device."
            )
        }
    }
}

// MARK: - Reader Detail strings

extension ReaderSDK2UIStrings {
    enum ReaderDetail {
        static var generalSectionTitle: String {
            return NSLocalizedString(
                "ReaderSDK2UI_ReaderDetail_GeneralSection",
                tableName: nil,
                bundle: .readerSDK2UIResources,
                value: "General",
                comment: "The title of the table which displays general information about the connected Square reader, including the battery level, firmware version, etc."
            )
        }

        static var readerStateRowTitle: String {
            return NSLocalizedString(
                "ReaderSDK2UI_ReaderDetail_ReaderStateRow",
                tableName: nil,
                bundle: .readerSDK2UIResources,
                value: "State",
                comment: "The title of the row which displays the current state of the connected Square reader."
            )
        }

        static var supportedInputMethodsRowTitle: String {
            return NSLocalizedString(
                "ReaderSDK2UI_ReaderDetail_SupportedInputMethodsRow",
                tableName: nil,
                bundle: .readerSDK2UIResources,
                value: "Accepts",
                comment: "The title of the row which displays the card input methods which are accepted by the connected Square reader (e.g. swipe, chip, contactless)."
            )
        }

        static var batteryRowTitle: String {
            return NSLocalizedString(
                "ReaderSDK2UI_ReaderDetail_BatteryRow",
                tableName: nil,
                bundle: .readerSDK2UIResources,
                value: "Battery",
                comment: "The title of the row which displays the battery level of the connected Square reader."
            )
        }

        static var firmwareRowTitle: String {
            return NSLocalizedString(
                "ReaderSDK2UI_ReaderDetail_FirmwareRow",
                tableName: nil,
                bundle: .readerSDK2UIResources,
                value: "Firmware",
                comment: "The title of the row which displays the firmware version of the connected Square reader."
            )
        }

        static var serialNumberRowTitle: String {
            return NSLocalizedString(
                "ReaderSDK2UI_ReaderDetail_SerialNumberRow",
                tableName: nil,
                bundle: .readerSDK2UIResources,
                value: "Serial Number",
                comment: "The title of the row which displays the serial number of the connected Square reader."
            )
        }

        static var identifyReaderButtonTitle: String {
            return NSLocalizedString(
                "ReaderSDK2UI_ReaderDetail_IdentifyReaderButton",
                tableName: nil,
                bundle: .readerSDK2UIResources,
                value: "Identify this Reader",
                comment: "The title of the button which, when pressed, identifies the connected Square reader by flashing its LEDs."
            )
        }

        static var reconnectReaderButtonTitle: String {
            return NSLocalizedString(
                "ReaderSDK2UI_ReaderDetail_ReconnectReaderButtonTitle",
                tableName: nil,
                bundle: .readerSDK2UIResources,
                value: "Retry connection",
                comment: "The title of the button which, when pressed, reconnects it with Square's servers."
            )
        }

        static var forgetReaderButtonTitle: String {
            return NSLocalizedString(
                "ReaderSDK2UI_ReaderDetail_ForgetReaderButton",
                tableName: nil,
                bundle: .readerSDK2UIResources,
                value: "Forget",
                comment: "The title of the button which, when pressed, forgets the connected Square reader. The reader will need to be paired again before it can be used."
            )
        }

        static var firmwareFailedAlertTitle: String {
            return NSLocalizedString(
                "ReaderSDK2UI_ReaderDetail_FirmwareFailedAlertTitle",
                tableName: nil,
                bundle: .readerSDK2UIResources,
                value: "Firmware Upgrade failure",
                comment: "The title of the alert displayed when firmware upgrade fails."
            )
        }
    }
}

// MARK: - Reader Row Swipe Actions
extension ReaderSDK2UIStrings {
    enum ReaderSwipeActions {
        static var forget: String {
            return NSLocalizedString(
                "ReaderSDK2UI_ReaderSwipeAction_Forget",
                tableName: nil,
                bundle: .readerSDK2UIResources,
                value: "Forget",
                comment: "The title for the button that forgets the reader."
            )
        }

        static var identify: String {
            return NSLocalizedString(
                "ReaderSDK2UI_ReaderSwipeAction_Identify",
                tableName: nil,
                bundle: .readerSDK2UIResources,
                value: "Identify",
                comment: "The title for the button that identifies the reader."
            )
        }
    }
}

// MARK: - Reader Pairing strings
extension ReaderSDK2UIStrings {
    enum ReaderPairing {
        static var title: String {
            return NSLocalizedString(
                "ReaderSDK2UI_ReaderPairing_Title",
                tableName: nil,
                bundle: .readerSDK2UIResources,
                value: "Pair Your Reader",
                comment: "The title displayed when pairing a Square reader via bluetooth."
            )
        }

        static var errorTitle: String {
            return NSLocalizedString(
                "ReaderSDK2UI_ReaderPairing_ErrorTitle",
                tableName: nil,
                bundle: .readerSDK2UIResources,
                value: "Failed to Pair",
                comment: "The title displayed when a bluetooth reader fails to pair."
            )
        }

        static var bluetoothPairingInstructions: String {
            return NSLocalizedString(
                "ReaderSDK2UI_ReaderPairing_BluetoothPairingInstructions",
                tableName: nil,
                bundle: .readerSDK2UIResources,
                value: "Press and hold the button on your reader until the lights flash orange. Then release the button and place the reader next to this device to pair.",
                comment: "The instructions for pairing a bluetooth Square reader."
            )
        }

        static var lookingForReaders: String {
            return NSLocalizedString(
                "ReaderSDK2UI_ReaderPairing_LookingForReaders",
                tableName: nil,
                bundle: .readerSDK2UIResources,
                value: "Looking for readers...",
                comment: "The message displayed to the user when the app is looking for bluetooth readers to pair with."
            )
        }

        static var pairingWithReader: String {
            return NSLocalizedString(
                "ReaderSDK2UI_ReaderPairing_PairingWithReader",
                tableName: nil,
                bundle: .readerSDK2UIResources,
                value: "Pairing with reader…",
                comment: "The message displayed to the user when the app is in the process of pairing with a reader."
            )
        }
    }
}

// MARK: - Pay Screen Strings
extension ReaderSDK2UIStrings {
    enum Pay {
        static var totalAmountHeader: String {
            return NSLocalizedString(
                "ReaderSDK2UI_PayScreen_TotalAmountHeader",
                tableName: nil,
                bundle: .readerSDK2UIResources,
                value: "TOTAL",
                comment: "The text displayed above the total amount on the Pay screen."
            )
        }

        static var promptWithInputMethods_swipe_chip_contactless: String {
            return NSLocalizedString(
                "ReaderSDK2UI_PayScreen_Prompt_Swipe_Chip_Contactless",
                tableName: nil,
                bundle: .readerSDK2UIResources,
                value: "Swipe, Insert, or Tap to Pay",
                comment: "The prompt displayed to the user when the available card input methods are 'swipe', 'chip', and 'contactless'."
            )
        }

        static var promptWithInputMethods_swipe_chip: String {
            return NSLocalizedString(
                "ReaderSDK2UI_PayScreen_Prompt_Swipe_Chip",
                tableName: nil,
                bundle: .readerSDK2UIResources,
                value: "Swipe or Insert to Pay",
                comment: "The prompt displayed to the user when the only available card input methods are 'swipe' and 'chip'."
            )
        }

        static var promptWithInputMethods_chip_contactless: String {
            return NSLocalizedString(
                "ReaderSDK2UI_PayScreen_Prompt_Chip_Contactless",
                tableName: nil,
                bundle: .readerSDK2UIResources,
                value: "Insert or Tap to Pay",
                comment: "The prompt displayed to the user when the only available card input methods are 'chip' and 'contactless'."
            )
        }

        static var promptWithInputMethods_swipe: String {
            return NSLocalizedString(
                "ReaderSDK2UI_PayScreen_Prompt_Swipe",
                tableName: nil,
                bundle: .readerSDK2UIResources,
                value: "Swipe to Pay",
                comment: "The prompt displayed to the user when the only available card input method is 'swipe'."
            )
        }

        static var promptWithInputMethods_chip: String {
            return NSLocalizedString(
                "ReaderSDK2UI_PayScreen_Prompt_Chip",
                tableName: nil,
                bundle: .readerSDK2UIResources,
                value: "Insert to Pay",
                comment: "The prompt displayed to the user when the only available card input method is 'chip'."
            )
        }

        static var promptWithNoReadersConnected: String {
            return NSLocalizedString(
                "ReaderSDK2UI_PayScreen_Prompt_NoReadersConnected",
                tableName: nil,
                bundle: .readerSDK2UIResources,
                value: "No Readers Connected",
                comment: "The prompt displayed to the user when there are no readers connected."
            )
        }

        static var manualCardEntry: String {
            return NSLocalizedString(
                "ReaderSDK2UI_PayScreen_manualCardEntry",
                tableName: nil,
                bundle: .readerSDK2UIResources,
                value: "Enter card details manually",
                comment: "The title for the button for manual card entry."
            )
        }
    }
}
