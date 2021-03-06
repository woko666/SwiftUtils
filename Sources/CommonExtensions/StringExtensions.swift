import Foundation

// regex
public extension String
{
    var diacriticsStripped: String {
        return folding(options: .diacriticInsensitive, locale: .current)
    }
    
    var nfc:String {
        return (self as NSString).precomposedStringWithCanonicalMapping
    }
    
    var nfd:String {
        return (self as NSString).decomposedStringWithCanonicalMapping
    }
    
    var asciiEscaped:String {
        return self.unicodeScalars.map { $0.escaped(asASCII: true).replacingOccurrences(of: "{", with: "").replacingOccurrences(of: "}", with: "") }.reduce("",+)
    }
    
    func isMatch(_ regex: String, options: NSRegularExpression.Options = .caseInsensitive) -> Bool
    {
        return getMatches(regex, options:options).count > 0
    }
    
    func getMatches(_ regex: String, options: NSRegularExpression.Options = .caseInsensitive) -> [String]
    {
        do {
            let regex = try NSRegularExpression(pattern: regex, options: options)
            let results = regex.matches(in: self, range: NSRange(self.startIndex..., in: self))
            return results.map {
                String(self[Range($0.range, in: self)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
        }
        return []
    }
    
    func getCapturedGroups(_ pattern: String) -> [String] {
        var results = [String]()
        
        var regex: NSRegularExpression
        do {
            regex = try NSRegularExpression(pattern: pattern, options: [])
        } catch {
            return results
        }
        let matches = regex.matches(in: self, options: [], range: NSRange(location:0, length: self.count))
        
        guard let match = matches.first else { return results }
        
        let lastRangeIndex = match.numberOfRanges
        guard lastRangeIndex >= 1 else { return results }
        
        for i in 0..<lastRangeIndex {
            let capturedGroupIndex = match.range(at: i)
            if capturedGroupIndex.location != NSNotFound && capturedGroupIndex.location + capturedGroupIndex.length <= self.length {
                // the range is valid
                let matchedString = (self as NSString).substring(with: capturedGroupIndex)
                results.append(matchedString)
            }
        }
        
        return results
    }
}

// data encoding
public extension Character {
    var ascii: UInt32? {
        return String(self).unicodeScalars.filter{$0.isASCII}.first?.value
    }
}

public extension String {
    
    var urlEncodedQuery:String {
        get {
            return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? self
        }
    }
    
    var urlEncodedUser:String {
        get {
            return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlUserAllowed) ?? self
        }
    }
    
    var urlEncodedPassword:String {
        get {
            return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPasswordAllowed) ?? self
        }
    }
    
    var urlEncodedHost:String {
        get {
            return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed) ?? self
        }
    }
    
    var urlEncodedPath:String {
        get {
            return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed) ?? self
        }
    }
    
    var urlEncodedStrong:String {
        get {
            return self.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn:"/")) ?? self
        }
    }
    
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
    
    /*var md5:String {
        let messageData = data(using:.utf8)!
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        
        _ = digestData.withUnsafeMutableBytes {digestBytes in
            messageData.withUnsafeBytes {messageBytes in
                CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }
        
        return digestData.map { String(format: "%02hhx", $0) }.joined()
    }*/
    
    func trimWhitespaces() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    }
    
    func notEmptyOrNil() -> String? {
        return self.count > 0 ? self : nil
    }
    
    var length: Int {
        return self.count
    }
    
    func sub (_ i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< min(toIndex, length)]
    }
    
    func substring(fromIndex: Int, length: Int) -> String {
        let start = min(fromIndex, self.length)
        let end = min(self.length, start + length)
        return self[start ..< end]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
    func indexOf(_ substring: String) -> Int? {
        var index = 0
        
        let firstSubstringChar = substring.first
        let length = self.count
        let substringLength = substring.count
        // Loop through parent string looing for the first character of the substring
        for char in self {
            if index + substringLength > length {
                return nil
            }
            if firstSubstringChar == char {
                // Create a start and end index to ultimately creata range
                let startOfFoundCharacter = self.index(startIndex, offsetBy: index)
                let lengthOfFoundCharacter = self.index(startIndex, offsetBy: (substringLength + index))
                let range = startOfFoundCharacter..<lengthOfFoundCharacter
                
                if String(self[range]) == substring {
                    return index
                }
            }
            index += 1
        }
        return nil
    }
    
    func removeAll(characters: String) -> String {
        return String(self.filter { !characters.contains($0) })
    }
    
    func replaceAllRegex(pattern: String, with replacement: String) -> String {
        return self.replacingOccurrences(of: pattern, with: replacement, options: .regularExpression, range: nil)
    }
    
    func removeAllRepeated(characters: String) -> String {
        var lastChar: Character?
        return self.filter { char in
            let shouldRemove = characters.contains(char) && lastChar == char
            lastChar = char
            return !shouldRemove
        }
    }
}

public extension String {
    func appendLineToURL(_ fileURL: URL) {
        _ = try? (self + "\n").appendToURL(fileURL: fileURL)
    }
    
    func appendToURL(fileURL: URL) throws {
        let data = self.data(using: String.Encoding.utf8)!
        try data.append(fileURL: fileURL)
    }
    
    func appendToDocsFile(_ name:String) {
        let dir: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last! as URL
        let url = dir.appendingPathComponent(name)
        appendLineToURL(url)
    }
}

public extension String {
    
    func stringFromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func dataFromBase64() -> Data? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        return data
    }
    
    func toBase64() -> String {
        return self.utf8Encoded.base64EncodedString()
    }
    
    static func fromResource(_ name:String, ext:String) -> String? {
        if let filepath = Bundle.main.path(forResource: name, ofType: ext) {
            return try? String(contentsOfFile: filepath, encoding: .utf8)
        }
        return nil
    }
}
