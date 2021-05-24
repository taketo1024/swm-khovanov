//
//  RasmussenInvariant.swift
//  SwiftyHomology
//
//  Created by Taketo Sano on 2019/05/31.
//

import SwmCore
import SwmKnots
import SwmHomology

public func RasmussenInvariant(_ L: Link) -> Int {
    RasmussenInvariant(L, 𝐐.self)
}

public func RasmussenInvariant<F: Field>(_ L: Link, _ type: F.Type) -> Int {
    if L.components.count == 0 {
        return 0
    }

    let (n⁺, n⁻) = (L.crossingNumber⁺, L.crossingNumber⁻)
    let qShift = n⁺ - 2 * n⁻

    let C = KhovanovComplex<F>(type: .Lee, link: L)
    let z = C.canonicalCycles.0
    let d = C.differential[-1]

    let range = C[0].generators.map{ $0.qDegree }.closureRange!
    let min = range.lowerBound

    for j in range where (j - min).isEven {
        let FC0 = C[ 0].filter{ summand in summand.generator.qDegree < j }
        let FC1 = C[-1].filter{ summand in summand.generator.qDegree < j }

        let A = d.asMatrix(from: FC1, to: FC0)
        let b = FC0.vectorize(z)

        let E = A.eliminate(form: .Diagonal)
        if let x = E.invert(b) {
            assert(A * x == b)
        } else {
            return j + qShift - 1
        }
    }

    fatalError()
}
