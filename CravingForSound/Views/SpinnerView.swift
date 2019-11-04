//
//  SpinnerView.swift
//  CravingForSound
//
//  Created by Rodion on 04.11.2019.
//  Copyright © 2019 LetsSee. All rights reserved.
//

import UIKit
import Common
import RxSwift
import RxCocoa

final class SpinnerView: UIView {
    
    private let activityIndicator = UIActivityIndicatorView(style: .white)
    private let height: CGFloat = 60
    
    // MARK: - Init & setup
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        backgroundColor = .systemGray
        addSubview(activityIndicator)
        activityIndicator.startAnimating()
        clipsToBounds = true
        layer.cornerRadius = standardRowHeight / 2
    }
    
    private func setupConstraints() {
        activityIndicator.snp.makeConstraints {
            $0.center.equalTo(self.snp.center)
        }
    }
    
     // MARK: - Appearance

    func setHidden(_ hide: Bool, animated: Bool = true) {
        if hide {
            if isHidden { return }
            alpha = 1
            
            UIView.animate(withDuration: animated ? normalDuration : 0, animations: {
                self.alpha = 0
            }, completion: { _ in
                self.isHidden = true
                self.activityIndicator.stopAnimating()
            })
        } else {
            if !isHidden { return }
            activityIndicator.startAnimating()
            alpha = 0
            isHidden = false
            
            UIView.animate(withDuration: animated ? normalDuration : 0, animations: {
                self.alpha = 1
            })
        }
    }

}

extension UIViewController {
    
    func addSpinner(_ spinner: SpinnerView, in customView: UIView? = nil, customTopOffset: CGFloat = 0 ) {
        guard let parentView = customView ?? view else { return }
        parentView.addSubview(spinner)
        
        spinner.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide).inset(customTopOffset + standardOffset)
            maker.centerX.equalToSuperview()
            maker.width.height.equalTo(standardRowHeight)
        }
        spinner.isHidden = true
    }
    
}

extension Reactive where Base: SpinnerView {
    
    var isVisible: Binder<Bool> {
        return Binder(base) { view, value in
            view.setHidden(!value, animated: true)
        }
    }
    
}
