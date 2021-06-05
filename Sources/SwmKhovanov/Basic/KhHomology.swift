//
//  KhComplex.swift
//  SwiftyHomology
//
//  Created by Taketo Sano on 2019/10/10.
//

import SwmCore
import SwmKnots
import SwmHomology

public struct KhovanovHomology<R: HomologyCalculatable>: GradedModuleStructureType {
    public typealias BaseGrid = ModuleGrid2<KhovanovComplex<R>.BaseModule>
    public typealias BaseModule = BaseGrid.BaseModule
    public typealias Index  = BaseGrid.Index
    public typealias Object = BaseGrid.Object
    
    public let grid: BaseGrid
    public let chainComplex: KhovanovComplex<R>
    
    private init(_ grid: BaseGrid, _ chainComplex: KhovanovComplex<R>) {
        self.grid = grid
        self.chainComplex = chainComplex
    }

    public init (_ L: Link, normalized: Bool = true, options: HomologyCalculatorOptions = []) {
        let C = KhovanovComplex<R>(link: L, normalized: normalized)
        let H = C.asBigraded.homology(options: options)
        self.init(H, C)
    }
    
    public subscript(i: Index) -> BaseGrid.Object {
        grid[i]
    }

    public func shifted(_ shift: Index) -> Self {
        .init(grid.shifted(shift), chainComplex)
    }
    
    // Σ_{i, j} (-1)^i q^j rank(H[i, j])
    public var gradedEulerCharacteristic: LaurentPolynomial<𝐙, _q> {
        let (r1, r2) = (chainComplex.degreeRange, chainComplex.qDegreeRange)

        typealias P = LaurentPolynomial<𝐙, _q>
        let q = P.indeterminate

        return (r1 * r2).sum { (i, j) -> P in
            P((-1).pow(i) * self[i, j].rank) * q.pow(j)
        }
    }
    
    public func printTable() {
        let (r1, r2) = (chainComplex.degreeRange, chainComplex.qDegreeRange)
        let qMin = r2.lowerBound
        grid.printTable(r1, r2.filter{ j in (j - qMin).isEven})
    }
}
