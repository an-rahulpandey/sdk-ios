//
//  Strings.swift
//  ReaderSDK2-SampleApp
//
//  Created by James Smith on 8/5/19.
//

import Foundation

/// A namespace for localized string constants
enum Strings {}

// MARK: - Start Screen strings
extension Strings {
    enum Start {
        static var title: String {
            return NSLocalizedString(
                "ReaderSDKSample_Start_Title",
                tableName: nil,
                bundle: .r2SampleAppResources,
                value: "Reader SDK Sample App",
                comment: "The title displayed on the start screen."
            )
        }

        static var loginButtonTitle: String {
            return NSLocalizedString(
                "ReaderSDKSample_Start_LoginButtonTitle",
                tableName: nil,
                bundle: .r2SampleAppResources,
                value: "Log In",
                comment: "The title of the login button displayed on the start screen."
            )
        }
    }
}

// MARK: - Authorization strings
extension Strings {
    enum Authorization {
        static var inProgress: String {
            return NSLocalizedString(
                "ReaderSDKSample_Authorization_InProgressMessage",
                tableName: nil,
                bundle: .r2SampleAppResources,
                value: "Authorizing...",
                comment: "The message displayed while authorization is in progress."
            )
        }

        static var errorTitle: String {
            return NSLocalizedString(
                "ReaderSDKSample_Authorization_ErrorTitle",
                tableName: nil,
                bundle: .r2SampleAppResources,
                value: "Authorization Error",
                comment: "The title displayed when an authorization error occurs."
            )
        }

        static var errorDismissButtonTitle: String {
            return NSLocalizedString(
                "ReaderSDKSample_Authorization_ErrorDismissButtonTitle",
                tableName: nil,
                bundle: .r2SampleAppResources,
                value: "Dismiss",
                comment: "The title of button used to dismiss an authorization error."
            )
        }
    }
}

// MARK: - Permissions strings
extension Strings {
    enum Permissions {
        static var title: String {
            return NSLocalizedString(
                "ReaderSDKSample_Permissions_Title",
                tableName: nil,
                bundle: .r2SampleAppResources,
                value: "Enable Permissions",
                comment: "The title of the screen which requires users to grant access to system permissions."
            )
        }

        static var locationServicesPrompt: String {
            return NSLocalizedString(
                "ReaderSDKSample_Permissions_LocationServices",
                tableName: nil,
                bundle: .r2SampleAppResources,
                value: "Enable Location Services",
                comment: "A message that prompts the user to grant access to the device's location."
            )
        }

        static var microphonePrompt: String {
            return NSLocalizedString(
                "ReaderSDKSample_Permissions_MicrophonePrompt",
                tableName: nil,
                bundle: .r2SampleAppResources,
                value: "Enable Microphone",
                comment: "A message that prompts the user to grant access to the device's microphone."
            )
        }

        static var bluetoothPrompt: String {
            return NSLocalizedString(
                "ReaderSDKSample_Permissions_BluetoothPrompt",
                tableName: nil,
                bundle: .r2SampleAppResources,
                value: "Enable Bluetooth",
                comment: "A message that prompts the user to grant access to Bluetooth."
            )
        }

        static var doneButtonTitle: String {
            return NSLocalizedString(
                "ReaderSDKSample_Permissions_DoneButtonTitle",
                tableName: nil,
                bundle: .r2SampleAppResources,
                value: "Start Taking Payments",
                comment: "The title of the button on the permissions screen which, when pressed, progresses the user to the order entry screen where they can start taking payments. This button only becomes enabled once the user has granted access to all required system permissions."
            )
        }
    }
}


// MARK: - Tab Bar strings
extension Strings {
    enum TabBar {
        static var keypad: String {
            return NSLocalizedString(
                "ReaderSDKSample_TabBar_KeypadTitle",
                tableName: nil,
                bundle: .r2SampleAppResources,
                value: "Keypad",
                comment: "The name of the keypad tab."
            )
        }

        static var settings: String {
            return NSLocalizedString(
                "ReaderSDKSample_TabBar_SettingsTitle",
                tableName: nil,
                bundle: .r2SampleAppResources,
                value: "Settings",
                comment: "The name of the settings tab."
            )
        }

        static var readers: String {
            return NSLocalizedString(
                "ReaderSDKSample_TabBar_ReadersTitle",
                tableName: nil,
                bundle: .r2SampleAppResources,
                value: "Readers",
                comment: "The name of the readers tab."
            )
        }
    }
}

// MARK: - Order Entry strings
extension Strings {
    enum OrderEntry {
        static var chargeButtonTitle: String {
            return NSLocalizedString(
                "ReaderSDKSample_OrderEntry_ChargeButtonTitle",
                tableName: nil,
                bundle: .r2SampleAppResources,
                value: "Charge",
                comment: "The title of the button used to charge the customer."
            )
        }

        static var clearAmountKeyboardShortcutName: String {
            return NSLocalizedString(
                "ReaderSDKSample_OrderEntry_ClearAmountKeyboardShortcutName",
                tableName: nil,
                bundle: .r2SampleAppResources,
                value: "Clear",
                comment: "The title of the keyboard shortcut used to reset the amount entered to 0."
            )
        }

        static var clearAmountKeypadButton: String {
            return NSLocalizedString(
                "ReaderSDKSample_OrderEntry_ClearAmountKeypadButton",
                tableName: nil,
                bundle: .r2SampleAppResources,
                value: "C",
                comment: "The character displayed on the keypad button which is used to reset the amount entered to 0."
            )
        }

        static var customAmountItemName: String {
            return NSLocalizedString(
                "ReaderSDKSample_OrderEntry_CustomAmountItemName",
                tableName: nil,
                bundle: .r2SampleAppResources,
                value: "Custom Amount",
                comment: "The name of a cart item with an amount that is manually entered using the keypad."
            )
        }

        static var totalAmountDescriptionPrefix: String {
            return NSLocalizedString(
                "ReaderSDKSample_OrderEntry_Total",
                tableName: nil,
                bundle: .r2SampleAppResources,
                value: "Total:",
                comment: "A string that is used to prefix the total amount in the current cart. For example: 'Total: $10.50'"
            )
        }

        static var noSaleTitle: String {
            return NSLocalizedString(
                "ReaderSDKSample_OrderEntry_NoSale",
                tableName: nil,
                bundle: .r2SampleAppResources,
                value: "No Sale",
                comment: "The title displayed in the cart when the total amount is 0."
            )
        }

        static var cartTitle: String {
            return NSLocalizedString(
                "ReaderSDKSample_OrderEntry_Cart",
                tableName: nil,
                bundle: .r2SampleAppResources,
                value: "Cart",
                comment: "The title displayed in the cart when the total amount is greater than 0."
            )
        }

        static var emptyCartMessage: String {
            return NSLocalizedString(
                "ReaderSDKSample_OrderEntry_EmptyCart",
                tableName: nil,
                bundle: .r2SampleAppResources,
                value: "The cart is empty.",
                comment: "The message displayed in the cart when the total amount is 0."
            )
        }

        static var cartTotal: String {
            return NSLocalizedString(
                "ReaderSDKSample_OrderEntry_CartTotal",
                tableName: nil,
                bundle: .r2SampleAppResources,
                value: "Total",
                comment: "The title of the line item displayed at the bottom of the cart."
            )
        }
    }
}


// MARK: - Transaction Complete Screen strings
extension Strings {
    enum TransactionComplete {
        static var title: String {
            return NSLocalizedString(
                "ReaderSDKSample_TransactionComplete_Title",
                tableName: nil,
                bundle: .r2SampleAppResources,
                value: "Transaction Complete",
                comment: "The title of the screen that is displayed after a successful transaction."
            )
        }

        static var newTransactionButtonTitle: String {
            return NSLocalizedString(
                "ReaderSDKSample_TransactionComplete_NewTransactionButtonTitle",
                tableName: nil,
                bundle: .r2SampleAppResources,
                value: "New Transaction",
                comment: "The title of the button used to start a new transaction."
            )
        }

        static var viewReceiptButtonTitle: String {
            return NSLocalizedString(
                "ReaderSDKSample_TransactionComplete_ViewReceiptButtonTitle",
                tableName: nil,
                bundle: .r2SampleAppResources,
                value: "View Receipt",
                comment: "The title of the button used to view the receipt after a successful transaction."
            )
        }
    }
}

// MARK: - Settings strings
extension Strings {
    enum Settings {
        static var generalSectionTitle: String {
            return NSLocalizedString(
                "ReaderSDKSample_Settings_GeneralSection",
                tableName: nil,
                bundle: .r2SampleAppResources,
                value: "General",
                comment: "The title of the table section which displays general settings such as the selected theme."
            )
        }

        static var cardOnFileSectionTitle: String {
            return NSLocalizedString(
                "ReaderSDKSample_Settings_CardOnFileSection",
                tableName: nil,
                bundle: .r2SampleAppResources,
                value: "Card On File",
                comment: "The title of the table section which displays card on file settings such as the cardID."
            )
        }

        static var locationSectionTitle: String {
            return NSLocalizedString(
                "ReaderSDKSample_Settings_LocationSection",
                tableName: nil,
                bundle: .r2SampleAppResources,
                value: "Location",
                comment: "The title of the table section which displays location settings such as the location name."
            )
        }

        static var mockReaderSectionTitle: String {
            return NSLocalizedString(
                "ReaderSDKSample_Settings_MockReaderSection",
                tableName: nil,
                bundle: .r2SampleAppResources,
                value: "Mock Reader",
                comment: "The title of the table section which displays mock reader settings visibility."
            )
        }

        static var cardIDRowTitle: String {
            return NSLocalizedString(
                "ReaderSDKSample_Settings_CardIDRow",
                tableName: nil,
                bundle: .r2SampleAppResources,
                value: "Card ID",
                comment: "The title of the row which displays the cardID to be used for a Card on File payment."
            )
        }

        static var locationRowTitle: String {
            return NSLocalizedString(
                "ReaderSDKSample_Settings_LocationRow",
                tableName: nil,
                bundle: .r2SampleAppResources,
                value: "Location",
                comment: "The title of the row which displays the location of the currently authorized Square merchant."
            )
        }

        static var themeRowTitle: String {
            return NSLocalizedString(
                "ReaderSDKSample_Settings_Theme",
                tableName: nil,
                bundle: .r2SampleAppResources,
                value: "Theme",
                comment: "The title of the row which displays the selected theme."
            )
        }

        static var mockReaderVisibilityRowTitle: String {
            return NSLocalizedString(
                "ReaderSDKSample_Settings_MockReaderVisibility",
                tableName: nil,
                bundle: .r2SampleAppResources,
                value: "Show/hide",
                comment: "The title of the row which displays the visibility choice of the mock reader."
            )
        }

        static var deauthorizeButtonTitle: String {
            return NSLocalizedString(
                "ReaderSDKSample_Settings_DeauthorizeButtonTitle",
                tableName: nil,
                bundle: .r2SampleAppResources,
                value: "Log Out",
                comment: "The title of the button used to deauthorize the currently authorized Square account."
            )
        }

        static var themePickerTitle: String {
            return NSLocalizedString(
                "ReaderSDKSample_Settings_ThemePickerTitle",
                tableName: nil,
                bundle: .r2SampleAppResources,
                value: "Select Theme",
                comment: "The title of the screen which allows the user to change the current theme."
            )
        }

        static var paymentOptionsTitle: String {
            return NSLocalizedString(
                "ReaderSDKSample_Settings_PaymentOptionsTitle",
                tableName: nil,
                bundle: .r2SampleAppResources,
                value: "Payment Options",
                comment: "The title of the screen which allows the user to change the payment options."
            )
        }
    }
}


// MARK: - Theme strings
extension Strings {
    enum Theme {
        static var `default`: String {
            return NSLocalizedString(
                "ReaderSDKSample_DefaultThemeName",
                tableName: nil,
                bundle: .r2SampleAppResources,
                value: "Default",
                comment: "The name of the default theme."
            )
        }

        static var dark: String {
            return NSLocalizedString(
                "ReaderSDKSample_DarkThemeName",
                tableName: nil,
                bundle: .r2SampleAppResources,
                value: "Dark",
                comment: "The name of the dark theme."
            )
        }
    }
}
