import Foundation

public extension Data {
    func appendTo(fileURL: URL) -> Bool {
        do {
            if let fileHandle = try? FileHandle(forWritingTo: fileURL) {
                defer {
                    fileHandle.closeFile()
                }
                fileHandle.seekToEndOfFile()
                fileHandle.write(self)
            }
            else {
                try write(to: fileURL, options: .atomic)
            }
            return true
        } catch {
            return false
        }
    }
    
    init(arr:[UInt8]) {
        self.init()
        self.append(contentsOf: arr)
    }
    
    func append(fileURL: URL) throws {
        if let fileHandle = FileHandle(forWritingAtPath: fileURL.path) {
            defer {
                fileHandle.closeFile()
            }
            fileHandle.seekToEndOfFile()
            fileHandle.write(self)
        }
        else {
            try write(to: fileURL, options: .atomic)
        }
    }
    
    func toHex() -> String {
        return map { String(format: "%02hhX", $0) }.joined()
    }
    
    func toHex(from:Int, to:Int) -> String {
        return self.subdata(in: from..<to).toHex()
    }
    
    func toArrayUInt8() -> [UInt8] {
        return [UInt8](self)        
    }
    
    static func fromArrayUInt8(_ arr:[UInt8]) -> Data {
        var data = Data()
        data.append(contentsOf: arr)
        return data
    }
}

public extension Int {
    func to(_ val:Int) -> [Int] {
        if val <= self {
            return []
        }
        return Array(stride(from: self, to: val, by: 1))
    }
}
