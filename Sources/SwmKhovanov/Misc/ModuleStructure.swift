//
//  File.swift
//  
//
//  Created by Taketo Sano on 2021/09/14.
//

import SwmCore
import SwmHomology

extension ModuleStructure {
    public static func formDirectSum<Index: Hashable>(indices: [Index], objects: [Self]) -> ModuleStructure<IndexedModule<Index, BaseModule>> {
        typealias S = ModuleStructure<IndexedModule<Index, BaseModule>>
        typealias R = BaseModule.BaseRing
        
        let indexer = indices.makeIndexer()
        
        let ranks = [0] + objects.map { $0.rank }.accumulate()
        let generators = zip(indices, objects).flatMap { (index, obj) -> [IndexedModule<Index, BaseModule>] in
            obj.generators.map { x in IndexedModule(index: index, value: x) }
        }
        
        let vectorizer: S.Vectorizer = { z in
            var v: [ColEntry<R>] = []
            
            for (index, x) in z.elements {
                guard let k = indexer(index),
                      let w = objects[k].vectorEntries(x)
                else {
                    return nil
                }
                
                let shift = ranks[k]
                v.append(contentsOf: w.map{ (i, a) in
                    (i + shift, a)
                })
            }
            
            return v
        }
        
        return S(
            generators: generators,
            vectorizer: vectorizer
        )
    }
}
