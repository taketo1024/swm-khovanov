//
//  RasmussenInvariant.swift
//  SwiftyHomology
//
//  Created by Taketo Sano on 2019/05/31.
//

import SwmCore
import SwmMatrixTools
import SwmKnots

public func RasmussenInvariant(_ L: Link) -> Int {
    RasmussenInvariant(L, 𝐐.self)
}

public func RasmussenInvariant<F>(_ L: Link, _ type: F.Type) -> Int where F: ComputationalField {
    if L.components.count == 0 {
        return 0
    }

    typealias CKh = KhovanovComplex<F>

    let C = CKh(type: .Lee, link: L)
    let q = C.qDegree(of:)
    let z = C.canonicalCycles.0
    let d = C.differential[-1]

    let range = C[0].generators.map{ q($0) }.closureRange!
    let min = range.lowerBound

    for j in range where (j - min).isEven {
        let FC0 = C[ 0].filter{ summand in q(summand.generator) < j }
        let FC1 = C[-1].filter{ summand in q(summand.generator) < j }
        
        let p = ModuleEnd<CKh.BaseModule> { z in
            z.filterTerms { (v, z) in C.qDegree(of: z, at: v) < j }
        }
        
        typealias M = F.ComputationalSparseMatrix<anySize, anySize>
        
        let A = (p ∘ d).asMatrix(from: FC1, to: FC0, ofType: M.self)
        let b = FC0.vectorize(p(z))!.convert(to: M.self)

        let E = A.LUfactorize()
        if let x = E.solve(b) {
            assert(A * x == b)
        } else {
            return j - 1
        }
    }

    fatalError()
}
