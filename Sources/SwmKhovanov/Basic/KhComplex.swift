//
//  KhComplex.swift
//  SwiftyHomology
//
//  Created by Taketo Sano on 2019/10/10.
//

import SwmCore
import SwmKnots
import SwmHomology

public struct KhovanovComplex<R: Ring>: ChainComplexType {
    public typealias Index = Int
    public typealias BaseModule = IndexedModule<
        Cube.Coords,
        LinearCombination<R, MultiTensorGenerator<KhovanovAlgebraGenerator>>
    >
    public typealias Object = ModuleStructure<BaseModule>
    public typealias Differential = ChainMap<Self, Self>
    
    public let type: KhovanovAlgebra<R>
    public let link: Link
    public let cube: KhovanovCube<R>
    public let chainComplex: ChainComplex1<BaseModule>
    public let normalized: Bool
    
    private init(_ type: KhovanovAlgebra<R>, _ link: Link, _ cube: KhovanovCube<R>, _ chainComplex: ChainComplex1<BaseModule>, _ normalized: Bool) {
        self.type = type
        self.link = link
        self.cube = cube
        self.chainComplex = chainComplex
        self.normalized = normalized
    }
    
    public init(type: KhovanovAlgebra<R> = .Khovanov, link: Link, normalized: Bool = true) {
        let n⁻ = link.crossingNumber⁻
        let cube = KhovanovCube(type: type, link: link)
        let chainComplex = cube.asChainComplex().shifted(normalized ? -n⁻ : 0)
        self.init(type, link, cube, chainComplex, normalized)
    }
    
    public subscript(i: Int) -> ModuleStructure<BaseModule> {
        chainComplex[i]
    }
    
    public var support: [Int] {
        degreeRange.toArray()
    }
    
    public var differential: Differential {
        ChainMap( chainComplex.differential )
    }
    
    public func shifted(_ shift: Int) -> KhovanovComplex<R> {
        .init(type, link, cube, chainComplex.shifted(shift), normalized)
    }
    
    public var degreeRange: ClosedRange<Int> {
        let (n, n⁺, n⁻) = (link.crossingNumber, link.crossingNumber⁺, link.crossingNumber⁻)
        return normalized ? (-n⁻ ... n⁺) : (0 ... n)
    }
    
    public var qDegreeRange: ClosedRange<Int> {
        let (qmin, qmax) = (cube.minQdegree, cube.maxQdegree)
        return qmin + qDegreeShift ... qmax + qDegreeShift
    }
    
    private var qDegreeShift: Int {
        let (n⁺, n⁻) = (link.crossingNumber⁺, link.crossingNumber⁻)
        return normalized ? n⁺ - 2 * n⁻ : 0
    }
    
    public func qDegree(of z: BaseModule) -> Int {
        z.elements.map { (v, z) -> Int in
            qDegree(of: z, at: v)
        }.min() ?? 0
    }

    public func qDegree(of z: BaseModule.BaseModule, at v: Cube.Coords) -> Int {
        z.elements.map { (x, r) in
            qDegree(of: x, at: v) + r.degree
        }.min() ?? 0
    }

    public func qDegree(of x: BaseModule.BaseModule.Generator, at v: Cube.Coords) -> Int {
        v.weight + x.degree + x.factors.count + qDegreeShift
    }

    internal var asBigraded: ChainComplex2<BaseModule> {
        let (h, t) = (type.h, type.t)
        assert(h.isZero || h.degree == -2)
        assert(t.isZero || t.degree == -4)
        
        return chainComplex.asBigraded {
            summand in qDegree(of: summand.generator)
        }
    }
}
