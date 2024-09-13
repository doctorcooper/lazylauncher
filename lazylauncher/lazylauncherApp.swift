//
//  genlauncherApp.swift
//  genlauncher
//
//  Created by Dmitry Kupriyanov on 16.07.2024.
//

import SwiftUI
import UserNotifications

@main
struct lazylauncherApp: App {

    // MARK: - Private properties

    private let notificationCenter = UNUserNotificationCenter.current()
    @NSApplicationDelegateAdaptor(AppDelegate.self) 
    private var appDelegate

    @ObservedObject
    private var repository = Repository()

    // MARK: - Init

    init() {
        checkRunningInstances()
    }

    // MARK: - Body

    var body: some Scene {
        Menu()
            .environmentObject(repository)
        WindowGroup("Log") {
            LogsViewerView()
        }.handlesExternalEvents(matching: Set(arrayLiteral: "LogsWindow"))
    }

}

// MARK: - Private methods

private extension lazylauncherApp {

    func checkRunningInstances() {
        let bundleIdentifier = Bundle.main.bundleIdentifier

        if NSWorkspace.shared.runningApplications.filter({ $0.bundleIdentifier == bundleIdentifier }).count > 1 {
            Log.d("App already running.")
            showError()
            exit(0)
        }
    }

    func showError() {
          let alert = NSAlert()
          alert.messageText = "Seems like another instance of app already running."
          alert.alertStyle = .warning
          alert.runModal()
      }

}

class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationWillFinishLaunching(_ notification: Notification) {
        UNUserNotificationCenter.current().delegate = self
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions
        ) -> Void) {
        completionHandler([.banner, .sound])
    }
}
