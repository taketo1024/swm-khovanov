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
        
        let N = ranks.last ?? 0
        let vectorizer: S.Vectorizer = { z in
            var valid = true
            let vec = AnySizeVector<R>(size: N) { setEntry in
                for (index, x) in z.elements {
                    guard let i = indexer(index),
                          let v = objects[i].vectorize(x)
                    else {
                        valid = false
                        break
                    }
                    
                    let shift = ranks[i]
                    v.nonZeroColEntries.forEach { (i, a) in
                        setEntry(i + shift, a)
                    }
                }
            }
            return valid ? vec : nil
        }
        
        return S(
            generators: generators,
            vectorizer: vectorizer
        )
    }
}
