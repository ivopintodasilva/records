// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum L10n {
  public enum AddRecord {
    public enum Actions {
      /// Cancel
      public static let cancel = L10n.tr("Localizable", "addRecord.actions.cancel", fallback: "Cancel")
      /// Try Again
      public static let retry = L10n.tr("Localizable", "addRecord.actions.retry", fallback: "Try Again")
    }
    public enum Failed {
      public enum Lookup {
        /// Could not find a record for this barcode. Try again or scan a different barcode.
        public static let message = L10n.tr("Localizable", "addRecord.failed.lookup.message", fallback: "Could not find a record for this barcode. Try again or scan a different barcode.")
        /// Not Found
        public static let title = L10n.tr("Localizable", "addRecord.failed.lookup.title", fallback: "Not Found")
      }
      public enum Scan {
        /// Could not read the barcode. Please try again.
        public static let message = L10n.tr("Localizable", "addRecord.failed.scan.message", fallback: "Could not read the barcode. Please try again.")
        /// Scan Failed
        public static let title = L10n.tr("Localizable", "addRecord.failed.scan.title", fallback: "Scan Failed")
      }
      public enum Unsupported {
        /// Barcode scanning is not supported on this device.
        public static let message = L10n.tr("Localizable", "addRecord.failed.unsupported.message", fallback: "Barcode scanning is not supported on this device.")
        /// Scanner Unavailable
        public static let title = L10n.tr("Localizable", "addRecord.failed.unsupported.title", fallback: "Scanner Unavailable")
      }
    }
    public enum Lookup {
      /// Looking up record…
      public static let loading = L10n.tr("Localizable", "addRecord.lookup.loading", fallback: "Looking up record…")
    }
    public enum Scanner {
      /// Point your camera at a barcode
      public static let instruction = L10n.tr("Localizable", "addRecord.scanner.instruction", fallback: "Point your camera at a barcode")
    }
  }
  public enum Collection {
    public enum Actions {
      /// Add record
      public static let addRecord = L10n.tr("Localizable", "collection.actions.addRecord", fallback: "Add record")
      /// Close search
      public static let closeSearch = L10n.tr("Localizable", "collection.actions.closeSearch", fallback: "Close search")
    }
    public enum Navigation {
      /// Collection
      public static let title = L10n.tr("Localizable", "collection.navigation.title", fallback: "Collection")
    }
    public enum Search {
      /// Search
      public static let placeholder = L10n.tr("Localizable", "collection.search.placeholder", fallback: "Search")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
