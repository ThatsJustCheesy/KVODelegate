//
//  PersonB.swift
//  KVODelegate
//
//  Created by Ian Gregory on 17-03-2017.
//  Copyright © 2017 ThatsJustCheesy. All rights reserved.
//

import Foundation
import KVODelegate

class PersonB: NSObject, KVONotificationDelegator {
    
    dynamic var firstName = "", lastName = "", address = "", postalCode = ""
    
    dynamic var fullName: String {
        get {
            return firstName + " " + lastName
        }
        set {
            let spaceLoc = newValue.range(of: " ")!
            firstName = newValue.substring(to: spaceLoc.lowerBound)
            lastName = newValue.substring(from: newValue.index(after: spaceLoc.lowerBound))
        }
    }
    
    dynamic var creditCardNumbers: [Int] = []
    
    class func configKVONotificationDelegate(_ delegate: KVONotificationDelegate) {
        delegate.key("fullName", dependsUponKeyPaths: ["firstName", "lastName"])
        delegate.key("firstName", dependsUponKeyPath: "fullName")
        delegate.key("lastName", dependsUponKeyPath: "fullName")
    }
    
    // Forcing the user to manually override is kinda clumsy, but it's the only way in Swift
    override class func keyPathsForValuesAffectingValue(forKey key: String) -> Set<String> {
        return KVONotificationDelegate(forClass: self).keyPathsForValuesAffectingValue(forKey: key)
    }
    
}
