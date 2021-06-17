//
//  File.swift
//  
//
//  Created by Taketo Sano on 2021/05/07.
//

import SwmCore
import SwmHomology

public protocol Cube {
    associatedtype Vertex
    associatedtype Edge
    typealias Coords = BitSequence
    
    var dim: Int { get }
    subscript(v: Coords) -> Vertex { get }
    func edge(from: Coords, to: Coords) -> Edge
}

extension Cube {
    var startVertex: Vertex {
        self[ Coords.zeros(length: dim) ]
    }
    
    var endVertex: Vertex {
        self[ Coords.ones(length: dim) ]
    }
    
    func edges(from v: Coords) -> [Edge] {
        v.successors.map { w in
            edge(from: v, to: w)
        }
    }
}

public protocol ModuleCube: Cube where Vertex == ModuleStructure<BaseModule>, Edge == ModuleEnd<BaseModule> {
    associatedtype BaseModule: Module
    typealias R = BaseModule.BaseRing
    typealias M = IndexedModule<Coords, BaseModule>
}

extension ModuleCube {
    public func edgeSign(from v: Coords, to w: Coords) -> R {
        zip(v, w).reduce(
            into: 0,
            while: { (_, pair) in pair.0 == pair.1 }
        ) { (res, pair) in
            if pair.0 == 1 { res += 1 }
        }
        .isEven ? .identity : -.identity
    }
    
    public func differential(_ i: Int) -> ModuleEnd<M> {
        ModuleEnd { (z: M) in
            z.elements.sum { (v, x) in
                v.successors.sum { w in
                    let f = edge(from: v, to: w)
                    let y = f(x)
                    return M(index: w, value: y)
                }
            }
        }
    }
    
    public func asChainComplex() -> ChainComplex1<M> {
        ChainComplex1(
            support: Array(0 ... dim),
            grid: { i in
                let n = self.dim
                guard (0 ... n).contains(i) else {
                    return .zeroModule
                }
                
                let vs = Coords.sequences(length: dim, weight: i)
                return ModuleStructure.formDirectSum(
                    indices: vs,
                    objects: vs.map{ self[$0] }
                )
            },
            degree: 1,
            differential: { i in self.differential(i) }
        )
    }
}
