//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Vitaly on 30.08.2023.
//

import Foundation
import UIKit

extension UIPageControl {
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: 180, height: 60)
    }
    
}


final class OnboardingViewController: UIPageViewController {
    
    private lazy var pages: [UIViewController] = {
        // первый экран
        let first = setUPPage(imageName: "Onboarding1", text: L10n.Onbording.Screen1.text)
        // второй экран
        let second = setUPPage(imageName: "Onboarding2",
                               text: L10n.Onbording.Screen2.text
        )
        return [first, second]
    }()
    
    private func setUPPage(imageName: String, text: String) -> UIViewController {
        let viewController = UIViewController()
        let backgroundImageView = UIImageView(image: UIImage(named: imageName))
        backgroundImageView.contentMode =  .scaleAspectFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.addSubview(backgroundImageView)
        NSLayoutConstraint.activate([
            backgroundImageView.centerYAnchor.constraint(equalTo: viewController.view.centerYAnchor),
            backgroundImageView.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor)
        ])
        
        let labelText = UILabel()
        labelText.text = text
        
        labelText.numberOfLines = 0
        labelText.textAlignment = .center
        labelText.font = YFonts.fontYPBold32
        viewController.view.addSubview(labelText)
        labelText.translatesAutoresizingMaskIntoConstraints = false
        labelText.textColor = .ypBlackDay
        
        NSLayoutConstraint.activate([
            labelText.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
            labelText.topAnchor.constraint(equalTo: viewController.view.topAnchor, constant: 432),
            labelText.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor, constant: 16),
            labelText.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor, constant: -16)
        ])
        
        return viewController
    }
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        
        pageControl.currentPageIndicatorTintColor = .ypBlackDay
        pageControl.pageIndicatorTintColor = .ypGray
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    private lazy var buttonOnboardinComplete: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(L10n.Onbording.Button.text, for: .normal)
        button.setTitleColor(.ypWhiteDay, for: .normal)
        button.titleLabel?.font = YFonts.fontYPMedium16
        button.addTarget(self, action: #selector(buttonOnboardinCompleteTapped), for: .touchUpInside)
        
        button.backgroundColor = .ypBlackDay
        button.layer.cornerRadius = 16
        
        return button
    }()
    
    
    @objc func buttonOnboardinCompleteTapped() {
        // первый экран на tabBar
        guard let application = UIApplication.shared.delegate as? AppDelegate else { return }
        
        application.isCompleteOnbording = true
        
        let window = UIApplication.shared.windows.first
        window?.rootViewController = application.getTabBarViewController()
        window?.makeKeyAndVisible()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }
        
        view.addSubview(buttonOnboardinComplete)
        NSLayoutConstraint.activate([
            buttonOnboardinComplete.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonOnboardinComplete.heightAnchor.constraint(equalToConstant: 60),
            buttonOnboardinComplete.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -84),
            buttonOnboardinComplete.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonOnboardinComplete.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        view.addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: buttonOnboardinComplete.topAnchor, constant: -24),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
    }
}

// MARK: - UIPageViewControllerDataSource
extension OnboardingViewController: UIPageViewControllerDataSource {
    // предыдущий экран
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else {
            return nil
        }
        
        return pages[nextIndex]
    }
}
// MARK: - UIPageViewControllerDelegate
extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
    
}
