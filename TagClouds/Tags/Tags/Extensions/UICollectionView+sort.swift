//
//  UICollectionView+sort.swift
//  TagCloud
//
//  Created by Никита Комаров on 01.04.2022.
//

import Foundation
import UIKit
import SnapKit

// MARK: - Кастомизация UICollectionView
fileprivate class RowInformation {
    var spacing: CGFloat
    var width: CGFloat                  = 0.0
    var cells: [UICollectionViewCell]   = [] {
        didSet {
            width = cells.reduce(0.0, { $0 + $1.intrinsicContentSize.width })
            if !cells.isEmpty {
                width += CGFloat(cells.count - 1) * spacing
            }
        }
    }
    
    init(spacing: CGFloat) {
        self.spacing = spacing
    }
}

extension UICollectionView {
    func getOptimalCells(_ cells: [UICollectionViewCell], maxWidth: CGFloat) -> [UICollectionViewCell] {
        var rows: [RowInformation] = []
        let spacing = 8.0
        
        var cellsCopy = cells
        
        //cellsCopy.sort(by: { $0.intrinsicContentSize.width >= $1.intrinsicContentSize.width })
        
        cellsCopy.forEach { (cell) in
            var isAdded: Bool = false
            for row in rows {
                if row.width + cell.intrinsicContentSize.width + CGFloat(spacing) < maxWidth {
                    row.cells.append(cell)
                    isAdded = true
                    break
                }
            }
            if !isAdded {
                let newRow = RowInformation(spacing: CGFloat(spacing))
                newRow.cells.append(cell)
                rows.append(newRow)
            }
        }
        
        cellsCopy = rows.reduce(into: [UICollectionViewCell](), { (cells, row) in
            cells.append(contentsOf: row.cells)
        })
        
        return cellsCopy
    }
}
