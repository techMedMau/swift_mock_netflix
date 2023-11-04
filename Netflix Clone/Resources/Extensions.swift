//
//  Extensions.swift
//  Netflix Clone
//
//  Created by Maureen Chang on 2023/11/3.
//

import Foundation

extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
