//
//  File.swift
//  genlauncher
//
//  Created by Dmitry Kupriyanov on 18.07.2024.
//

import Foundation
import OSLog

enum Log {

    static func d(_ message: String) {
        Logger().debug("\(message)")
    }

    static func i(_ message: String) {
        Logger().info("\(message)")
    }

    static func e(_ message: String) {
        Logger().error("\(message)")
    }

}
