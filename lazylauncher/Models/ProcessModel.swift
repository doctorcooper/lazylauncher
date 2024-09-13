//
//  ProcessModel.swift
//  genlauncher
//
//  Created by Dmitry Kupriyanov on 18.07.2024.
//

import Foundation

struct ProcessModel: Codable, Identifiable, Hashable {

    var id: UUID
    var name: String
    var shellType: ShellType
    var arguments: [String]
    var successMessage: String?

    var isLoginShell: Bool {
        get {
            return arguments.contains(where: { $0 == "-l" })
        }
        set {
            if newValue {
                guard !arguments.contains(where: { $0 == "-l" }) else {
                    return
                }
                arguments.insert("-l", at: 0)
            } else {
                arguments.removeAll(where: { $0 == "-l" })
            }
        }
    }

    var isCommand: Bool {
        get {
            return arguments.contains(where: { $0 == "-c" })
        }
        set {
            if newValue {
                guard !arguments.contains(where: { $0 == "-c" }) else {
                    return
                }
                arguments.insert("-c", at: 0)
            } else {
                arguments.removeAll(where: { $0 == "-c" })
            }
        }
    }

    var isInteractive: Bool {
        get {
            return arguments.contains(where: { $0 == "-i" })
        }
        set {
            if newValue {
                guard !arguments.contains(where: { $0 == "-i" }) else {
                    return
                }
                arguments.insert("-i", at: 0)
            } else {
                arguments.removeAll(where: { $0 == "-i" })
            }
        }
    }

    var launchCommand: String {
        get {
            return arguments.last ?? ""
        }
        set {
            arguments.removeLast()
            arguments.append(newValue)
        }
    }

    init(id: UUID = UUID(), name: String, shellType: ShellType, arguments: [String], successMessage: String? = nil) {
        self.id = id
        self.name = name
        self.shellType = shellType
        self.arguments = arguments
        self.successMessage = successMessage
    }

}

extension ProcessModel {

    static func stub() -> Self {
        return .init(
            name: "I am test action",
            shellType: .zsh,
            arguments: [
                "-l", // Login shell
                "-i",
                "-c", // Evaluate input from argument
                "echo Hello, World!"
            ],
            successMessage: "Success!"
        )
    }

}
