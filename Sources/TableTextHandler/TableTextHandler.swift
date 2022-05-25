//
//  main.swift
//  SwiftReadTableFile
//
//  Created by Runhua Huang on 2022/5/25.
//

import Foundation

class TableTextHandler {
    
    typealias Table = [[String]]
    typealias List = [String]
    
    var bundlePath: String
    var filePath: String
    var fileExtension: String
    private let currentPath: String = #file.split(separator: "/").map(String.init).dropLast().joined(separator: "/")
    
    init(bundlePath: String, filePath: String, fileExtension: String) {
        self.bundlePath = bundlePath
        self.filePath = filePath
        self.fileExtension = fileExtension
    }
    
    private func getBundleURL() -> URL {
        let currentDirectoryURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        let bundleURL = URL(fileURLWithPath: "TableFileBundle.bundle", relativeTo: currentDirectoryURL)
        return bundleURL
    }
    
    private func readContents() -> String? {
        if let bundle = Bundle(url: getBundleURL()) {
            if let path = bundle.path(forResource: self.filePath, ofType: self.fileExtension) {
                if let contents = try? String(contentsOfFile: path) {
                    return contents
                }
            } else {
                print("No file Found")
            }
        }
        return nil
    }
    
    private func convertStringToList() -> Table {
        if let contents = readContents() {
            let contentList = contents.split(separator: "\n").map(String.init).map { content in
                content.split(separator: " ").map(String.init)
            }
            return contentList
        } else {
            print("No contents found in filePath: \(self.filePath) with fileExtension: \(self.fileExtension)")
        }
        return []
    }
    
    public func loadData() -> Table {
        return convertStringToList()
    }
    
    public func getColumnData(at column: Int) -> List {
        let data = loadData()
        return data.map { $0[column] }
    }
    
    public func getColumnData(from start: Int, to end: Int) -> Table {
        let data = loadData()
        if start > end {
            return data.map { $0[end...start] }.map(Array.init).map{ $0.reversed() }
        }
        return data.map { $0[start...end] }.map(Array.init)
    }
    
    public func mergeTable(lhs: Table, rhs: Table) -> Table {
        var mergedTable: Table = []
        for (var lh,rh) in zip(lhs, rhs) {
            lh.append(contentsOf: rh)
            mergedTable.append(lh)
        }
        return mergedTable
    }
    
    public func mergeList(lhs: List, rhs: List) -> Table {
        var mergedTable: Table = []
        for (lh,rh) in zip(lhs, rhs) {
            mergedTable.append([lh, rh])
        }
        return mergedTable
    }
    
    public func mergeTableList(table: Table, list: List) -> Table {
        var mergedTable: Table = []
        for (var t, l) in zip(table, list) {
            t.append(l)
            mergedTable.append(t)
        }
        return mergedTable
    }
    
    public func mergeListTable(list: List, table: Table) -> Table {
        var mergedTable: Table = []
        for (l, var t) in zip(list, table) {
            t.insert(l, at: 0)
            mergedTable.append(t)
        }
        return mergedTable
    }
    
    public func writeTable(table: Table, to path: String) {
        let saveFileURL = URL(fileURLWithPath: "/"+[self.currentPath, path].joined(separator: "/"))
        do {
            try table.map { $0.joined(separator: " ") }.joined(separator: "\n").write(to: saveFileURL, atomically: true, encoding: .utf8)
        } catch {
            print("Can't write table to path: \(saveFileURL), error: \(error)")
        }
    }
}

