//
//  Encodable+Extension.swift
//  Let's Git it!
//
//  Created by 강희영 on 2022/02/22.
//

import Foundation

extension Encodable {
    /// Object to Dictionary
    /// cf) Dictionary to Object: JSONDecoder().decode(Object.self, from: dictionary)
    var asDictionary: [String: Any]? {
        guard let object = try? JSONEncoder().encode(self),
              let dictinoary = try? JSONSerialization.jsonObject(with: object, options: [])
                as? [String: Any] else { return nil }
        return dictinoary
    }
}
