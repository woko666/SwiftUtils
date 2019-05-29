import Foundation

public extension URL {
    var queryDictionary: [String: String] {
        var queryStrings = [String: String]()
        
        guard let query = URLComponents(string: self.absoluteString)?.query else { return queryStrings }        
        
        for pair in query.components(separatedBy: "&") {
            
            let key = pair.components(separatedBy: "=")[0]
            
            let value = pair
                .components(separatedBy:"=")[1]
                .replacingOccurrences(of: "+", with: " ")
                .removingPercentEncoding ?? ""
            
            queryStrings[key] = value
        }
        return queryStrings
    }
    
    func readFile() -> Data? {
        if let data = NSData(contentsOfFile: self.path) {
            return data as Data
        }
        return nil
    }
    
    var fileSize: Int? {
        get {
            let attr = try? FileManager.default.attributesOfItem(atPath: self.path)
            if let attr = attr, let fileSize = attr[FileAttributeKey.size] as? UInt64 {
                return Int(fileSize)
            }
            return nil
        }
    }
    
    func readFirst(_ toRead:Int) -> Data? {
        if let file = try? FileHandle(forReadingFrom: self) {
            let data = file.readData(ofLength: toRead)
            return data
        }
        return nil
    }
    
    func readLast(_ toRead:Int) -> Data? {
        if let file = try? FileHandle(forReadingFrom: self) {
            let length = file.seekToEndOfFile()
            if length >= toRead {
                file.seek(toFileOffset: length.advanced(by: -toRead))
                return file.readDataToEndOfFile()
            }
        }
        return nil
    }
}
