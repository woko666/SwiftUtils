import Foundation

public extension JSONEncoder {
    static func encodeString<T: Encodable>(_ value: T, options opt: JSONSerialization.ReadingOptions = []) -> String {
        let data = try? JSONEncoder().encode(value)
        
        if let data = data {
            return String(data: data, encoding: .utf8)!
        }
        return ""
    }
}

public extension JSONDecoder {
    static func decodeData<T: Decodable>(_ type: T.Type, from:Data) -> T? {
        return try? JSONDecoder().decode(type,from:from)
    }
    
    static func decodeString<T: Decodable>(_ type: T.Type, from:String) -> T? {
        return try? JSONDecoder().decode(type,from:from.utf8Encoded)
    }
}
