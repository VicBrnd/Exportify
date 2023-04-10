//
//  ViewController.swift
//  Exportify
//
//  Created by Victor Bernardoni on 09/04/2023.
//

import Cocoa
import SQLite3
import UniformTypeIdentifiers
import AppKit

class ViewController: NSViewController {
    
    func isGoogleChromeRunning() -> Bool {
        let chromeAppIdentifier = "com.google.Chrome"
        let apps = NSRunningApplication.runningApplications(withBundleIdentifier: chromeAppIdentifier)
        return !apps.isEmpty
    }
    
    @IBOutlet weak var exportButton: NSButton! // IBOutlet for the NSButton

    // Export Variable
    let dbName = "\(NSHomeDirectory())/Library/Application Support/Google/Chrome/Default/History"
    let tableName = "urls"
    let csvName = "History.csv"
    let jsonName = "History.json"

    
    // Export Button
    @IBAction func exportButtonClicked(_ sender: NSButton) {
        if isGoogleChromeRunning() {
            showErrorAlert()
        } else {
            let formatAlert = NSAlert()
            formatAlert.messageText = "Choose Export Format"
            formatAlert.informativeText = "Please select the format you would like to export the browsing history to:"
            formatAlert.addButton(withTitle: "CSV")
            formatAlert.addButton(withTitle: "JSON")
            formatAlert.addButton(withTitle: "Cancel")
            
            formatAlert.beginSheetModal(for: self.view.window!) { (response) in
                if response == .alertFirstButtonReturn {
                    self.showSavePanel(defaultFileName: "History.csv", allowedFileTypes: ["csv"], exportFunction: self.exportDBToCSV)
                } else if response == .alertSecondButtonReturn {
                    self.showSavePanel(defaultFileName: "History.json", allowedFileTypes: ["json"], exportFunction: self.exportDBToJSON)
                }
            }
        }
    }

    func showSavePanel(defaultFileName: String, allowedFileTypes: [String], exportFunction: @escaping (String, String, URL) -> Void) {
        let savePanel = NSSavePanel()
        savePanel.allowedFileTypes = allowedFileTypes
        savePanel.nameFieldStringValue = defaultFileName
        
        savePanel.beginSheetModal(for: self.view.window!) { response in
            if response == .OK, let url = savePanel.url {
                exportFunction(self.dbName, self.tableName, url)
            }
        }
    }





    func exportDBToJSON(dbPath: String, tableName: String, jsonURL: URL) {
        var db: OpaquePointer?
        if sqlite3_open(dbPath, &db) == SQLITE_OK {
            let query = "SELECT strftime('%Y-%m-%d %H:%M:%S', last_visit_time/1000000-11644473600 + 7200, 'unixepoch') AS 'Visit Date', title AS Title, url AS Url, visit_count AS 'Visit Count', typed_count AS 'Typed Count' FROM \(tableName);"
            
            var stmt: OpaquePointer?
            if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
                var browsingHistoryData: [[String: Any]] = []
                
                while sqlite3_step(stmt) == SQLITE_ROW {
                    let columns = sqlite3_column_count(stmt)
                    var rowData: [String: Any] = [:]
                    for i in 0..<columns {
                        if let columnName = sqlite3_column_name(stmt, i),
                           let value = sqlite3_column_text(stmt, i) {
                            let key = String(cString: columnName)
                            let str = String(cString: value)
                            rowData[key] = str
                        }
                    }
                    browsingHistoryData.append(rowData)
                }
                
                do {
                    // Serialize the browsing history data as JSON
                    let jsonData = try JSONSerialization.data(withJSONObject: browsingHistoryData, options: .prettyPrinted)
                    
                    // Write the JSON data to the specified URL
                    try jsonData.write(to: jsonURL)
                    
                    print("JSON file successfully saved")
                    showAlert(filePath: jsonURL.path)
                } catch {
                    print("Error writing/sorting JSON file: \(error)")
                }
            } else {
                print("Error preparing statement: \(String(cString: sqlite3_errmsg(db)))")
            }
            
            sqlite3_finalize(stmt)
        } else {
            print("Error opening database: \(String(cString: sqlite3_errmsg(db)))")
        }
        
        sqlite3_close(db)
    }

    // Export Csv
    func exportDBToCSV(dbPath: String, tableName: String, csvURL: URL) {
        var db: OpaquePointer?
        if sqlite3_open(dbPath, &db) == SQLITE_OK {
            let query = "SELECT strftime('%Y-%m-%d %H:%M:%S', last_visit_time/1000000-11644473600 + 7200, 'unixepoch') AS 'Visit Date', title AS Title, url AS Url, visit_count AS 'Visit Count', typed_count AS 'Typed Count' FROM \(tableName);"
            
            var stmt: OpaquePointer?
            if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
                var csvData = "Visit Date,Title,Url,Visit Count,Typed Count\n"
                
                while sqlite3_step(stmt) == SQLITE_ROW {
                    let columns = sqlite3_column_count(stmt)
                    for i in 0..<columns {
                        if let value = sqlite3_column_text(stmt, i) {
                            let str = String(cString: value)
                            csvData += "\"\(str.replacingOccurrences(of: "\"", with: "\"\""))\","
                        } else {
                            csvData += ","
                        }
                    }
                    csvData.removeLast()
                    csvData += "\n"
                }
                
                do {
                    // Write the CSV data to a temporary file first
                    let tempFileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("temp.csv")
                    try csvData.write(to: tempFileURL, atomically: true, encoding: .utf8)
                    
                    // Sort the CSV file by Visit Date in reverse order
                    let sortProcess = Process()
                    sortProcess.executableURL = URL(fileURLWithPath: "/usr/bin/sort")
                    sortProcess.arguments = ["-r", "-t,", "-k1", tempFileURL.path]
                    
                    let sortPipe = Pipe()
                    sortProcess.standardOutput = sortPipe
                    
                    try sortProcess.run()
                    
                    // Write the sorted CSV data to the final output file
                    let fileHandle = sortPipe.fileHandleForReading
                    let sortedCSVData = String(decoding: fileHandle.readDataToEndOfFile(), as: UTF8.self)
                    try sortedCSVData.write(to: csvURL, atomically: true, encoding: .utf8)
                    
                    // Remove the temporary file
                    try FileManager.default.removeItem(at: tempFileURL)
                    
                    print("CSV file successfully saved")
                    showAlert(filePath: csvURL.path)
                } catch {
                    print("Error writing/sorting CSV file: \(error)")
                }
            } else {
                print("Error preparing statement: \(String(cString: sqlite3_errmsg(db)))")
            }
            
            sqlite3_finalize(stmt)
        } else {
            print("Error opening database: \(String(cString: sqlite3_errmsg(db)))")
        }
        
        sqlite3_close(db)
    }
    
    // Confetti Alert
    func showAlert(filePath: String) {
        let alert = NSAlert()
        alert.messageText = "Exportify"
        alert.informativeText = "The file has been successfully saved at:\n\(filePath)"
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        // Add confetti effect
        if let contentView = alert.window.contentView {
            let confettiView = createConfettiView()
            contentView.addSubview(confettiView, positioned: .below, relativeTo: contentView)
            NSLayoutConstraint.activate([
                confettiView.topAnchor.constraint(equalTo: contentView.topAnchor),
                confettiView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                confettiView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                confettiView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            ])
        }
        
        alert.beginSheetModal(for: self.view.window!) { _ in }
    }
    
    func createConfettiView() -> NSView {
        let confettiView = ConfettiView()
        confettiView.translatesAutoresizingMaskIntoConstraints = false
        return confettiView
    }
    
    // Confetti Error Alert
    func showErrorAlert() {
        let alert = NSAlert()
        alert.messageText = "Error"
        alert.informativeText = "Please close Google Chrome before exporting the browsing history."
        alert.alertStyle = .warning
        alert.addButton(withTitle: "OK")
        
        // Add confetti effect
        let confettiErrorView = createConfettiErrorView()
        alert.window.contentView?.addSubview(confettiErrorView, positioned: .below, relativeTo: alert.window.contentView)
        confettiErrorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            confettiErrorView.topAnchor.constraint(equalTo: alert.window.contentView!.topAnchor),
            confettiErrorView.bottomAnchor.constraint(equalTo: alert.window.contentView!.bottomAnchor),
            confettiErrorView.leadingAnchor.constraint(equalTo: alert.window.contentView!.leadingAnchor),
            confettiErrorView.trailingAnchor.constraint(equalTo: alert.window.contentView!.trailingAnchor)
        ])
        
        alert.beginSheetModal(for: self.view.window!, completionHandler: nil)
    }

    func createConfettiErrorView() -> ConfettiErrorView {
        let confettiErrorView = ConfettiErrorView()
        confettiErrorView.translatesAutoresizingMaskIntoConstraints = false
        return confettiErrorView
    }

    
    
    // Window Background
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Convert HSLA values to NSColor
        let startColor = NSColor(hue: 18.0/360.0, saturation: 0.76, brightness: 0.85, alpha: 1)
        let endColor = NSColor(hue: 203.0/360.0, saturation: 0.69, brightness: 0.84, alpha: 1)

        // Add the gradient background view
        let gradientBackgroundView = GradientBackgroundView(frame: view.bounds,
        startColor: startColor,
        endColor: endColor)
        gradientBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gradientBackgroundView, positioned: .below, relativeTo: view.subviews.first)

        // Constraints to make the gradient background view fill the entire view
        NSLayoutConstraint.activate([
            gradientBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            gradientBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            gradientBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gradientBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    // Window Position
    override func viewDidAppear() {
        super.viewDidAppear()
        
        if let window = self.view.window {
            let screenFrame = window.screen?.frame ?? NSScreen.main!.frame
            let windowFrame = window.frame
            let x = (screenFrame.width - windowFrame.width) / 2
            let y = (screenFrame.height - windowFrame.height) / 2
            window.setFrameOrigin(NSPoint(x: x, y: y))
        }
    }

}

// Window Position
class MainWindowController: NSWindowController {
    
    override func windowDidLoad() {
        super.windowDidLoad()

        if let window = self.window {
            let screenFrame = window.screen?.frame ?? NSScreen.main!.frame
            let windowFrame = window.frame
            let x = (screenFrame.width - windowFrame.width) / 2
            let y = (screenFrame.height - windowFrame.height) / 2
            window.setFrameOrigin(NSPoint(x: x, y: y))
        }
    }
}


