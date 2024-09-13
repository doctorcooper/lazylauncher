//
//  ProcessLauncher.swift
//  genlauncher
//
//  Created by Dmitry Kupriyanov on 18.07.2024.
//

import Foundation

struct ProcessLauncher {

    static func run(execPath: URL, args: [String], completion: @escaping ((_ returnCode: Int32) -> Void)) {
        let process = Process()
        let pipe = Pipe()
        let errPipe = Pipe()

        var storage = Data()
        var errorStorage = Data()

        process.executableURL = execPath
        process.arguments = args
        /*
        [
            "-l", // Login shell
            "-i",
            "-c", // Evaluate input from argument
            "( export LANG=en_US.UTF-8 && cd ~/Projects/surf/burgerking && make project )"
        ]
         */
        process.standardOutput = pipe
        process.standardError = errPipe

        let group = DispatchGroup()

        InternalLogService.shared.clear()

        group.enter()
        pipe.fileHandleForReading.readabilityHandler = { stdOutFileHandle in
            let stdOutPartialData = stdOutFileHandle.availableData
            if stdOutPartialData.isEmpty  {
                Log.d("EOF on stdin")
                pipe.fileHandleForReading.readabilityHandler = nil
                group.leave()
            } else {
                storage.append(stdOutPartialData)
            }
        }

        group.enter()
        errPipe.fileHandleForReading.readabilityHandler = { stdErrFileHandle in
            let stdErrPartialData = stdErrFileHandle.availableData

            if stdErrPartialData.isEmpty  {
                Log.d("EOF on stderr")
                errPipe.fileHandleForReading.readabilityHandler = nil
                group.leave()
            } else {
                errorStorage.append(stdErrPartialData)
            }
        }

        try! process.run()

        process.terminationHandler = { handler in
            completion(handler.terminationStatus)
            group.notify(queue: .global()) {
                if !storage.isEmpty {

                    let message = String(data: storage, encoding: .utf8)!
                    InternalLogService.shared.append(message)
                    Log.i("\(Date())\nOUTPUT:\n\(message)")
                }
                if !errorStorage.isEmpty {
                    let message = String(data: errorStorage, encoding: .utf8)!
                    InternalLogService.shared.append(message)
                    Log.e("\(Date())\nERROR:\n\(message)")
                }
            }
        }
    }

    static func run(process: ProcessModel, completion: @escaping ((_ returnCode: Int32) -> Void)) {
        run(execPath: process.shellType.url, args: process.arguments, completion: completion)
    }

    static func asyncRun(process: ProcessModel) async -> Int32 {
        await withCheckedContinuation { continuation in
            run(process: process) { returnCode in
                continuation.resume(returning: returnCode)
            }
        }
    }

}
