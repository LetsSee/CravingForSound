//
//  DispatchQueue.swift
//  Common
//
//  Created by Искандер Фоатов on 10/07/2019.
//  Copyright © 2019 LetsSee. All rights reserved.
//

import Foundation

extension DispatchQueue {
    
	public func asyncAfter(delay: TimeInterval, execute: @escaping () -> Void) {
		let time = DispatchTime.now() + delay
		self.asyncAfter(deadline: time, execute: execute)
	}
    
}
