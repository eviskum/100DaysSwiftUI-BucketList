//
//  BioAuthentication.swift
//  BucketList
//
//  Created by Esben Viskum on 14/05/2021.
//

import Foundation
import LocalAuthentication

func authenticate(successfulAuthentication: (() -> Void)?, failedAuthentication: (() -> Void)?) {
    let context = LAContext()
    var error: NSError?
    
    print("We are running authentication")
    
    // Check if bio authentication is possible
    if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
        let reason = "We need to unlock your Pin data"
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
            // Authentication complete
            DispatchQueue.main.async {
                if success {
                    // Successful authentication
                    if let successfulAuthentication = successfulAuthentication {
                        successfulAuthentication()
                    }
                } else {
                    // Failed authentication
                    if let failedAuthentication = failedAuthentication {
                        failedAuthentication()
                    }
                }
            }
        }
    } else {
        // No bio authentication
    }
}
