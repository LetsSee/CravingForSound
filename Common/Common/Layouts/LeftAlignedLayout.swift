//
//  LeftAlignedLayout.swift
//  Common
//
//  Created by Rodion on 08/10/2019.
//  Copyright © 2019 LetsSee. All rights reserved.
//

import UIKit

public final class LeftAlignedLayout: UICollectionViewFlowLayout {
    private let itemSpacing: CGFloat
    private let leftInset: CGFloat
    
    public init(itemSpacing: CGFloat, leftInset: CGFloat, lineSpacing: CGFloat) {
        self.itemSpacing = itemSpacing
        self.leftInset = leftInset
        super.init()
        self.minimumLineSpacing = lineSpacing
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.itemSpacing = 3
        self.leftInset = 0
        super.init(coder: aDecoder)
        self.minimumLineSpacing = standardOffset
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let originalAttributes = super.layoutAttributesForElements(in: rect)
        return originalAttributes?.map {
            $0.representedElementKind == nil ? layoutAttributesForItem(at: $0.indexPath)! : $0
        }
    }
    
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let originalAttributes = super.layoutAttributesForItem(at: indexPath)
        let copiedAttributes = originalAttributes?.copy() as? UICollectionViewLayoutAttributes
        guard let currentItemAttributes = copiedAttributes, collectionView != nil else { return nil }
        
        guard  indexPath.item != 0 else {
            currentItemAttributes.frame.origin.x = leftInset
            return currentItemAttributes
        }
        
        let indexPath = IndexPath(item: indexPath.item - 1, section: indexPath.section)
        if let previousFrame = layoutAttributesForItem(at: indexPath)?.frame {
            let y = previousFrame.origin.y
            let x = previousFrame.origin.x
            let width = previousFrame.width
            let height = previousFrame.height
            
            let itemRect = CGRect(x: -.infinity, y: y, width: .infinity, height: height)
            if currentItemAttributes.frame.intersects(itemRect) {
                currentItemAttributes.frame.origin.x = x + width + itemSpacing
            } else {
                currentItemAttributes.frame.origin.x = leftInset
            }
        }
        
        return currentItemAttributes
    }
}
