//
//  Array.swift
//  LastFmSearch
//
//  Created by Vishwas Mukund on 9/15/19.
//  Copyright © 2019 Vishwas Mukund. All rights reserved.
//

import UIKit

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
