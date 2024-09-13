//
//  WindowOpener.swift
//  lazylauncher
//
//  Created by Dmitry Kupriyanov on 26.08.2024.
//

import Foundation
import AppKit

enum WindowOpener: String {

    case LogsWindow

    func open() {
        if let url = URL(string: "lazylauncher://\(self.rawValue)") {
            NSWorkspace.shared.open(url)
        }
    }
    
}
