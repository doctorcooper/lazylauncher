//
//  SettingsItemViewModel.swift
//  lazylauncher
//
//  Created by Dmitry Kupriyanov on 26.08.2024.
//

import Combine
import Foundation

final class SettingsItemViewModel: ObservableObject {

    private(set) var model: ProcessModel

    let id: UUID

    @Published
    var name: String {
        didSet {
            model.name = name
        }
    }

    @Published
    var shellType: ShellType {
        didSet {
            model.shellType = shellType
        }
    }

    @Published
    var isLogin: Bool {
        didSet {
            model.isLoginShell = isLogin
        }
    }

    @Published
    var isInteractive: Bool {
        didSet {
            model.isInteractive = isInteractive
        }
    }

    @Published
    var isCommandMode: Bool {
        didSet {
            model.isCommand = isCommandMode
        }
    }

    @Published
    var launchCommand: String {
        didSet {
            model.launchCommand = launchCommand
        }
    }

    @Published
    var successMessage: String {
        didSet {
            model.successMessage = successMessage.isEmpty ? nil : successMessage
        }
    }

    @Published var deleteButtonIsHidden: Bool = false

    init(model: ProcessModel) {
        self.model = model
        self.id = model.id

        self.shellType = model.shellType
        self.name = model.name
        self.isLogin = model.isLoginShell
        self.isInteractive = model.isInteractive
        self.isCommandMode = model.isCommand
        self.launchCommand = model.launchCommand
        self.successMessage = model.successMessage ?? ""
    }

}

extension SettingsItemViewModel: Hashable, Identifiable {

    static func == (lhs: SettingsItemViewModel, rhs: SettingsItemViewModel) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

}
