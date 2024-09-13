//
//  SettingsView.swift
//  genlauncher
//
//  Created by Dmitry Kupriyanov on 24.07.2024.
//

import SwiftUI

struct SettingsView: View {

    // MARK: - Constants

    private enum Constants {
        static let windowTitle = "Settings"
        static let saveButtonTitle = "Save"
        static let showLogsButtonText = "Show last logged run"
    }

    // MARK: - Private properties

    @EnvironmentObject
    private var repository: Repository

    @State
    private var items: [SettingsItemViewModel] = []

    @State
    private var showLogsButtonIsHidden = true

    // MARK: - Body
    
    var body: some View {
        VStack {
            List {
                ForEach(items) { model in
                    SettingsItemView(viewModel: model, deleteAction: { id in
                        delete(with: id)
                    })
                    .onChange(of: items.count) { oldValue, newValue in
                        model.deleteButtonIsHidden = newValue == 1
                    }
                }
            }
            Spacer()
            makeFooter()
            .padding()
        }
        .frame(
          minWidth: 700,
          idealWidth: 1000,
          maxWidth: .infinity,
          minHeight: 400,
          idealHeight: 800,
          maxHeight: .infinity)
        .navigationTitle(Constants.windowTitle)
        .onAppear {
            Log.d("Settings did appear")
            loadFromRepository()
        }
        .onReceive(NotificationCenter.default.publisher(for: NSWindow.willCloseNotification)) { newValue in
            if let window = newValue.object as? NSWindow,
               window.title == Constants.windowTitle {
                Log.d("closed settings")
                showLogsButtonIsHidden = InternalLogService.shared.lastOutput.isEmpty
                loadFromRepository()
            }
        }
    }

}

// MARK: - Private methods

private extension SettingsView {

    @ViewBuilder
    func makeFooter() -> some View {
        HStack {
            Spacer()
            Button {
                addNew()
                // Do scroll
            } label: {
                Image(systemName: "plus")
            }
            Button(Constants.saveButtonTitle) {
                save()
            }
            Spacer()
            if !showLogsButtonIsHidden {
                Button {
                    WindowOpener.LogsWindow.open()
                } label: {
                    Text(Constants.showLogsButtonText)
                }
            }
        }
    }

    func loadFromRepository() {
        items = repository.items.map { .init(model: $0) }
    }

    func delete(with id: UUID) {
        if let index = items.firstIndex(where: { $0.id == id }) {
            items.remove(at: index)
        }
    }

    func addNew() {
        items.append(.init(model: .stub()))
    }

    func save() {
        let models = items.map { $0.model }
        repository.items = models
        repository.save()
    }

}

#Preview {
    SettingsView().environmentObject(Repository())
}
