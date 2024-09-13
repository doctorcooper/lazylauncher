//
//  ShellType.swift
//  genlauncher
//
//  Created by Dmitry Kupriyanov on 18.07.2024.
//

import Foundation

enum ShellType: Codable, CaseIterable {

    case zsh
    case bash

    var url: URL {
        switch self {
        case .zsh:
            return URL(fileURLWithPath: "/bin/zsh")
        case .bash:
            return URL(fileURLWithPath: "/bin/bash")
        }
    }

}
