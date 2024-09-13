//
//  Menu.swift
//  genlauncher
//
//  Created by Dmitry Kupriyanov on 16.07.2024.
//

import SwiftUI
import Foundation
import UserNotifications

struct Menu: Scene {

    // MARK: - Constants

    private enum Constants {
        static let notificationIsRestrictedText = "Notifications isn't allowed. Open the system settings and check"
        static let notificationsCheckStateButtonText = "Click to refresh state"
        static let settingsItemTitle = "Settings"
        static let quitItemTitle = "Quit"
    }

    // MARK: - Private properties

    @State
    private var isLoading: Bool = false

    @State
    private var isNotificationApproved = false

    @EnvironmentObject 
    private var repository: Repository

    // MARK: - Body

    var body: some Scene {
        Settings {
            SettingsView()
        }
        MenuBarExtra {
            ForEach(repository.items, id: \.self) { item in
                makeButton(from: item)
            }
            .disabled(isLoading)

            if !isNotificationApproved {
                Divider()
                Text(Constants.notificationIsRestrictedText)
                Button(Constants.notificationsCheckStateButtonText) {
                    Task {
                       isNotificationApproved = await NotificationManager.shared.asyncRegisterForNotification()
                    }
                }
            }

            Divider()

            SettingsLink {
                Text(Constants.settingsItemTitle)
            }

            Divider()

            Button(Constants.quitItemTitle) {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut("q")
        } label: {
            ZStack {
                Image(systemName: "repeat.circle.fill")
                    .bold()
                    .font(.largeTitle)
                    .isHidden(!isLoading)
                Image(systemName: "gearshape")
                    .bold()
                    .font(.largeTitle)
                    .isHidden(isLoading)
            }
            .onAppear {
                Task {
                   isNotificationApproved = await NotificationManager.shared.asyncRegisterForNotification()
                }
            }
        }
    }

    @ViewBuilder
    private func makeButton(from model: ProcessModel) -> some View {
        Button(model.name) {
            Task {
                isLoading = true
                let returnCode = await ProcessLauncher.asyncRun(process: model)
                isLoading = false
                NotificationManager.shared.showNotification(code: returnCode, successMessage: model.successMessage)
                if returnCode != 0 {
                    WindowOpener.LogsWindow.open()
                }
            }

            /* Legacy way
            isLoading = true
            ProcessLauncher.run(process: model) { returnCode in
                isLoading = false
                NotificationManager.shared.showNotification(code: returnCode, successMessage: model.successMessage)
            }
             */
        }
    }

}
