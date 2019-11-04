//
//  ToastView.swift
//  CravingForSound
//
//  Created by Rodion on 04.11.2019.
//  Copyright © 2019 LetsSee. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxKeyboard
import Common

class ToastView: UIView {

    private let disposeBag = DisposeBag()
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setupConstraints()
        setupRx()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureUI()
        setupConstraints()
        setupRx()
    }
    
    private func configureUI() {
        backgroundColor = .systemGray
        layer.cornerRadius =  standardRowHeight / 2
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15)
        addSubview(label)
    }
    
    private func setupConstraints() {
        let topOffset: CGFloat = 15
        let sideOffset: CGFloat = 30
        label.snp.makeConstraints { maker in
            maker.top.equalToSuperview().offset(topOffset)
            maker.right.equalToSuperview().inset(sideOffset)
            maker.bottom.equalToSuperview().inset(topOffset)
            maker.left.equalToSuperview().offset(sideOffset)
        }
    }
    
    private func setupRx() {
        RxKeyboard.instance.visibleHeight
            .map { max(0, $0 - self.safeAreaInsets.bottom) }
            .drive(onNext: { [unowned self] height in
                self.transform.ty = -height
            }).disposed(by: disposeBag)
    }
    
    func hide() {
        removeFromSuperview()
    }
    
    fileprivate func set(message: String) {
        label.text = message
    }
    
}

extension UIViewController {
    
    @discardableResult
    func showToastView(with message: String = R.string.common.networkError(),
                       in customView: UIView? = nil,
                       autoDismiss: Bool = true) -> ToastView {
        let toast = ToastView()
        toast.set(message: message)
        guard let parentView = customView ?? view else { return toast }
        parentView.addSubview(toast)
        toast.snp.makeConstraints {
            $0.height.equalTo(standardRowHeight)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(parentView.safeAreaInsets).inset(doubleOffset)
        }
        
        if autoDismiss {
            DispatchQueue.main.asyncAfter(delay: 3) {
                UIView.animate(withDuration: normalDuration, animations: {
                    toast.alpha = 0
                }, completion: { _ in
                    toast.removeFromSuperview()
                })
            }
        }
        
        return toast
    }
    
}
