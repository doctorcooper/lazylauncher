//
//  Repository.swift
//  genlauncher
//
//  Created by Dmitry Kupriyanov on 26.07.2024.
//

import Combine
import Foundation
import SwiftUI

final class Repository: ObservableObject {

    @Published
    var items: [ProcessModel] = .init()

    @AppStorage("settings")
    var settings: [ProcessModel] = [.stub()]

    init() {
        items = settings
    }

    func save() {
        settings = self.items
    }

}

extension Array: RawRepresentable where Element: Codable {

    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else { return nil }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }

}
