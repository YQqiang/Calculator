//
//  CalculatorModel.swift
//  Calculator
//
//  Created by sungrow on 2019/12/16.
//  Copyright © 2019 sungrow. All rights reserved.
//

import Foundation
import Combine

class CalculatorModel: ObservableObject {
    let objectWillChange = PassthroughSubject<Void, Never>()

    var brain: CalculatorBrain = .left("0") {
        willSet {
            objectWillChange.send()
        }
    }
}
