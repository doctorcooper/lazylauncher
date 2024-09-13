//
//  View+Ext.swift
//  genlauncher
//
//  Created by Dmitry Kupriyanov on 18.07.2024.
//

import SwiftUI

extension View {

    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }

}
