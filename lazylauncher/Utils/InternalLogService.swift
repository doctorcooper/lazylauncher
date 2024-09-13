//
//  InternalLogService.swift
//  lazylauncher
//
//  Created by Dmitry Kupriyanov on 26.08.2024.
//

import Foundation

final class InternalLogService {

    private(set) var lastOutput = ""

    static let shared = InternalLogService()

    private init() {}

    func clear() {
        lastOutput = ""
    }

    func append(_ message: String) {
        let temp = lastOutput
        lastOutput = temp + "\n" + message
    }

}
