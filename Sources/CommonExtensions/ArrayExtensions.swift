import Foundation

public extension Array {
    
    func filterDuplicates(_ includeElement: @escaping(_ lhs:Element, _ rhs:Element) -> Bool) -> [Element]{
        var results = [Element]()
        
        forEach { (element) in
            let existingElements = results.filter {
                return includeElement(element, $0)
            }
            if existingElements.count == 0 {
                results.append(element)
            }
        }
        
        return results
    }
}

public extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        
        return result
    }
    
    func equalsTo(_ other:[Element]) -> Bool {
        guard self.count == other.count else { return false }
        
        for i in 0..<self.count {
            if self[i] != other[i] {
                return false
            }
        }
        return true
    }
    
    @discardableResult mutating func remove(element: Element) -> Bool {
        if let index = self.index(of: element) {
            self.remove(at: index)
            return true
        }
        return false
    }
    
    @discardableResult mutating func removeFirst(where: (Element) throws -> Bool) rethrows -> Bool {
        if let index = try self.firstIndex(where: `where`) {
            self.remove(at: index)
            return true
        }
        return false
    }
    
    @discardableResult mutating func appendIfNotExists(_ element: Element) -> Bool {
        if !self.contains(element) {
            self.append(element)
            return true
        }
        return false
    }
    
    @discardableResult mutating func appendIfNotExists(_ element: Element?) -> Bool {
        guard let element = element else { return false }
        return appendIfNotExists(element)
    }
}

public extension Array where Element:Hashable {
    func toDictionaryKeys<Val: Any>(value: Val) -> [Element:Val] {
        var dict = [Element:Val]()
        for element in self {
            dict[element] = value
        }
        return dict
    }
}
