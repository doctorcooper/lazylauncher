//
//  SettingsItemView.swift
//  genlauncher
//
//  Created by Dmitry Kupriyanov on 24.07.2024.
//

import SwiftUI

struct SettingsItemView: View {

    // MARK: - Constants

    private enum Constants {
        static let itemNameText = "Item name"
        static let shellText = "Shell"
        static let launchCommandText = "Launch Command"
        static let successMessageText = "Success message"
    }

    // MARK: - Private properties

    @ObservedObject
    private var viewModel: SettingsItemViewModel
    private var deleteAction: Closure<UUID>?

    // MARK: - Body

    var body: some View {
        HStack {
            VStack {
                HStack {
                    Text(Constants.itemNameText)
                    TextField(Constants.itemNameText, text: $viewModel.name)
                        .textFieldStyle(.roundedBorder)
                }
                HStack {
                    Picker(Constants.shellText, selection: $viewModel.shellType) {
                        pickerContent()
                    }
                    .pickerStyle(.radioGroup)

                    Divider()
                    
                    Toggle("-l", isOn: $viewModel.isLogin)
                    Toggle("-i", isOn: $viewModel.isInteractive)
                    Toggle("-c", isOn: $viewModel.isCommandMode)

                    Divider()

                    TextField(Constants.launchCommandText, text: $viewModel.launchCommand)
                        .textFieldStyle(.roundedBorder)
                }
                HStack {
                    Text(Constants.successMessageText)
                    TextField(Constants.successMessageText, text: $viewModel.successMessage)
                        .textFieldStyle(.roundedBorder)
                }
            }
            if !viewModel.deleteButtonIsHidden {
                VStack {
                    Button { [weak viewModel] in
                        deleteAction?(viewModel?.id ?? UUID())
                    } label: {
                        Image(systemName: "minus")
                            .frame(width: 20, height: 20)
                    }
                    Spacer()
                }
            }
        }
        .padding()
    }

    // MARK: - Init

    init(viewModel: SettingsItemViewModel, deleteAction: @escaping Closure<UUID>) {
        self._viewModel = .init(wrappedValue: viewModel)
        self.deleteAction = deleteAction
    }

    // MARK: - Private methods

    @ViewBuilder
    private func pickerContent() -> some View {
        ForEach(ShellType.allCases, id: \.self) {
            Text($0.url.lastPathComponent)
        }
    }

}

#Preview {
    SettingsItemView(viewModel: .init(model: .stub()), deleteAction: { _ in })
}
