//
//  Contact.swift
//  KVODelegate
//
//  Created by Ian Gregory on 17-03-2017.
//  Copyright © 2017 ThatsJustCheesy. All rights reserved.
//

import Foundation
import KVODelegate

@objcMembers class Contact: NSObject, KVONotificationDelegator {
    
    dynamic var firstName = "", lastName = "", title = ""
    
    dynamic var fullName: String {
        get {
            return title + " " + firstName + " " + lastName
        }
        set {
            let spaceLoc1 = newValue.range(of: " ")!.lowerBound,
                spaceLoc2 = newValue.range(of: " ", options: [], range: spaceLoc1..<newValue.endIndex)!.lowerBound
            
            title = String(newValue[..<spaceLoc1])
            firstName = String(newValue[spaceLoc1..<spaceLoc2])
            lastName = String(newValue[newValue.index(after: spaceLoc2)...])
        }
    }
    dynamic var titleAndLastName: String {
        get {
            return title + " " + lastName
        }
        set {
            let spaceLoc = newValue.range(of: " ")!.lowerBound
            
            title = String(newValue[..<spaceLoc])
            lastName = String(newValue[newValue.index(after: spaceLoc)...])
        }
    }
    
    class func configKVONotificationDelegate(_ delegate: KVONotificationDelegate) {
        delegate.key(#keyPath(firstName), dependsUponKeyPath: #keyPath(fullName))
        delegate.key(#keyPath(fullName), dependsUponKeyPaths: [#keyPath(firstName), #keyPath(lastName), #keyPath(title)])
        delegate.key(#keyPath(title), dependsUponKeyPaths: [#keyPath(fullName), #keyPath(titleAndLastName)])
        delegate.key(#keyPath(lastName), dependsUponKeyPath: #keyPath(fullName))
    }
    
    // Should be picked up by -[KVONotificationDelegate keyPathsForValuesAffectingValueForKey:]
    class func keyPathsForValuesAffectingTitleAndLastName() -> NSSet {
        return NSSet(objects: #keyPath(title), #keyPath(lastName))
    }
    class func keyPathsForValuesAffectingLastName() -> NSSet {
        return NSSet(object: #keyPath(titleAndLastName))
    }
    
    // Forcing the user to manually override is kinda clumsy, but it's the only way in Swift
    override class func keyPathsForValuesAffectingValue(forKey key: String) -> Set<String> {
        return KVONotificationDelegate(forClass: self).keyPathsForValuesAffectingValue(forKey: key)
    }
    
}
