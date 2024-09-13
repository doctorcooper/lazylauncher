//
//  LogvViewerView.swift
//  lazylauncher
//
//  Created by Dmitry Kupriyanov on 26.08.2024.
//

import SwiftUI

struct LogsViewerView: View {

    private var text: String {
        return InternalLogService.shared.lastOutput
    }

    var body: some View {
        VStack {
            TextEditor(text: .constant(text))
            Spacer()
            Button("Ok") {
                NSApplication.shared.keyWindow?.close()
            }
            Spacer()
        }
        .padding()
            .frame(
              minWidth: 700,
              idealWidth: 1000,
              maxWidth: .infinity,
              minHeight: 400,
              idealHeight: 800,
              maxHeight: .infinity)
            .navigationTitle("Log")
    }

}

#Preview {
    LogsViewerView()
}
