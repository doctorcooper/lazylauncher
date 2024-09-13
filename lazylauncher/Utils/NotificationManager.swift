//
//  NotificationManager.swift
//  lazylauncher
//
//  Created by Dmitry Kupriyanov on 23.08.2024.
//

import Foundation
import UserNotifications

@MainActor
final class NotificationManager {
    
    private let notificationCenter = UNUserNotificationCenter.current()
    
    private init() {}
    
    static let shared = NotificationManager()
    
    func asyncRegisterForNotification() async -> Bool {
        do {
            let success = try await notificationCenter.requestAuthorization(options: [.alert, .sound])
            Log.i("Notification is allowed!")
            return success
        }
        catch {
            Log.i("Notification is not allowed!")
            Log.e(error.localizedDescription)
            return false
        }
    }
    
    func showNotification(code: Int32, successMessage: String? = nil) -> Void {
        let content = UNMutableNotificationContent()
        content.title = code == 0 ? (successMessage ?? "Command run successful!") : "Something wrong. See logs"
        content.subtitle = "Code: \(code)"
        content.sound = UNNotificationSound.default
        
        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        
        // add our notification request
        notificationCenter.add(request)
    }

}
