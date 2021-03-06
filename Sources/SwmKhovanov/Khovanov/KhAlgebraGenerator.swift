//
//  KhovanovAlgebraGenerator.swift
//  
//
//  Created by Taketo Sano on 2021/05/08.
//

import SwmCore
import SwmHomology

public enum KhovanovAlgebraGenerator: Int8, LinearCombinationGenerator, Codable {
    case I = 0
    case X = 1

    public var degree: Int {
        (self == .I) ? 0 : -2
    }
    
    public static func <(e1: Self, e2: Self) -> Bool {
        e1.degree < e2.degree
    }

    public var description: String {
        (self == .I) ? "1" : "X"
    }
}
