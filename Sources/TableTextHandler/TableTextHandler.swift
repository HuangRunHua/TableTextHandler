//
//  main.swift
//  SwiftReadTableFile
//
//  Created by Runhua Huang on 2022/5/25.
//

import Foundation

/// A framework that can handle table-style data stored in a text File.
public class TableTextHandler {
    
    public typealias Table = [[String]]
    public typealias List = [String]
    
    /// The added Bundle Path.
    public var bundlePath: String
    /// The target file name.
    public var filePath: String
    private var fileExtension: String = "txt"
    private let currentPath: String = #file.split(separator: "/").map(String.init).dropLast().joined(separator: "/")
    
    
    /// Initializing a TableTextHandler class.
    /// - Parameters:
    ///   - bundlePath: The added Bundle Path.
    ///   - filePath: The target file name.
    public init(bundlePath: String, filePath: String) {
        self.bundlePath = bundlePath
        self.filePath = filePath
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
    
    /// Load text data and save all data to a Table.
    /// - Returns: Function return a Table that stores all text data.
    public func loadData() -> Table {
        return convertStringToList()
    }
    
    /// Read a single column data from original text file.
    /// - Parameter column: The index of the wanted data.
    /// - Returns: Return a List that stores a single column data from original text file.
    public func getColumnData(at column: Int) -> List {
        let data = loadData()
        return data.map { $0[column] }
    }
    
    
    /// Read multiply columns data from original text file.
    /// - Parameters:
    ///   - start: The start index of the wanted data, starting from 0.
    ///   - end: The end index of the wanted data.
    /// - Returns: Return a Table that stores multiply columns data from original text file. For example, if start is 0 and end is 2, then the returned Table will cover columns 0 and column 1.
    /// - Note: The start Index can greater than end Index.
    public func getColumnData(from start: Int, to end: Int) -> Table {
        let data = loadData()
        if start > end {
            return data.map { $0[end...start] }.map(Array.init).map{ $0.reversed() }
        }
        return data.map { $0[start...end] }.map(Array.init)
    }
    
    /// Merge two Tables to a single Table.
    /// - Parameters:
    ///   - lhs: Left Table, this will be the start of the merged Table.
    ///   - rhs: Right Table, this will be the end of the merged Table.
    /// - Returns: Merged Table.
    ///  ```swift
    ///  let lhs = [["1", "2"], ["3", "4"]]
    ///  let rhs = [["5", "6"], ["7", "8"]]
    ///  let mergedTable = mergeTable(lhs: lhs, rhs: rhs)
    ///  // mergedTable = [["1", "2", "5", "6"], ["3", "4", "7", "8"]]
    ///  ```
    public func mergeTable(lhs: Table, rhs: Table) -> Table {
        var mergedTable: Table = []
        for (var lh,rh) in zip(lhs, rhs) {
            lh.append(contentsOf: rh)
            mergedTable.append(lh)
        }
        return mergedTable
    }
    
    /// Merge two List to a single Table.
    /// - Parameters:
    ///   - lhs: Left List, this will be the start of the merged Table.
    ///   - rhs: Right List, this will be the end of the merged Table.
    /// - Returns: Merged Table.
    ///  ```swift
    ///  let lhs = ["1", "2"]
    ///  let rhs = ["5", "6"]
    ///  let mergedTable = mergeList(lhs: lhs, rhs: rhs)
    ///  // mergedTable = [["1", "5"], ["2", "6"]]
    ///  ```
    public func mergeList(lhs: List, rhs: List) -> Table {
        var mergedTable: Table = []
        for (lh,rh) in zip(lhs, rhs) {
            mergedTable.append([lh, rh])
        }
        return mergedTable
    }
    
    /// Merge a Table with a List to a single Table.
    /// - Parameters:
    ///   - table: Left Table, this will be the start of the merged Table.
    ///   - list: Right List, this will be the end of the merged Table.
    /// - Returns: Merged Table.
    /// ```swift
    /// let table = [["1", "2"], ["3", "4"]]
    /// let list = ["5", "6"]
    /// let mergedTableList = mergeTableList(table: table, list: list)
    /// // mergedTableList = [["1", "2", "5"], ["3", "4", "6"]]
    /// ```
    public func mergeTableList(table: Table, list: List) -> Table {
        var mergedTable: Table = []
        for (var t, l) in zip(table, list) {
            t.append(l)
            mergedTable.append(t)
        }
        return mergedTable
    }
    
    /// Merge a List with a Table to a single Table.
    /// - Parameters:
    ///   - list: Left List, this will be the start of the merged Table.
    ///   - table: Right Table, this will be the end of the merged Table.
    /// - Returns: Merged Table.
    /// ```swift
    /// let table = [["1", "2"], ["3", "4"]]
    /// let list = ["5", "6"]
    /// let mergedListTable = mergeListTable(list: list, table: table)
    /// // mergedListTable = [["5", "1", "2"], ["6", "3", "4"]]
    /// ```
    public func mergeListTable(list: List, table: Table) -> Table {
        var mergedTable: Table = []
        for (l, var t) in zip(list, table) {
            t.insert(l, at: 0)
            mergedTable.append(t)
        }
        return mergedTable
    }
    
    /// Write a Table to a txt file with custom file name.
    /// - Parameters:
    ///   - table: The Table that wanted to store in file.
    ///   - path: Target file name with file extension. For example, `target.txt` is greate.
    public func writeTable(table: Table, to path: String) {
        let saveFileURL = URL(fileURLWithPath: "/"+[self.currentPath, path].joined(separator: "/"))
        do {
            try table.map { $0.joined(separator: " ") }.joined(separator: "\n").write(to: saveFileURL, atomically: true, encoding: .utf8)
        } catch {
            print("Can't write table to path: \(saveFileURL), error: \(error)")
        }
    }
}

