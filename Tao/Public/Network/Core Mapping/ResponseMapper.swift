//
//  ResponseMapper.swift
//  toytt
//
//  Created by user on 2018/7/23.
//  Copyright © 2018年 allbut. All rights reserved.
//

import Foundation

protocol ParsedItem {
    
}

protocol ResponseMapperProtocol {
    associatedtype Item
    static func process(object: AnyObject?) throws -> Item
}

internal enum ResponseMapperError: Error {
    case invalid
    case missingAttribute
}

class ResponseMapper<A: ParsedItem> {
    static func process(object: Any?, parse: (([String: Any]) -> A?)) throws -> A {
        guard let json = object as? [String: Any] else { throw ResponseMapperError.invalid }
        
        if let item = parse(json) {
            return item
        } else {
            print("[ERROR] Mapper failure (\(self)). Missing attribute.")
            throw ResponseMapperError.missingAttribute
        }
    }
}

final class ArrayResponseMapper<A: ParsedItem> {
    static func process(object: Any?, mapper: ((Any?) throws -> A)) throws -> [A] {
        guard let json = object as? [[String: Any]] else { throw ResponseMapperError.invalid }
        
        var items = [A]()
        for jsonNode in json {
            let item = try mapper(jsonNode)
            items.append(item)
        }
        return items
    }
}
