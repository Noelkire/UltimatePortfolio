//
//  Binding-OnChange.swift
//  UltimatePortfolio
//
//  Created by Erik Leon on 11/18/21.
//

import Foundation
import SwiftUI

extension Binding {
    func onChange(_ handler: @escaping () -> Void) -> Binding<Value> {
        Binding(get: { self.wrappedValue }, set: { newValue in
            self.wrappedValue = newValue
            handler()
        })
    }
}
