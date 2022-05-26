//
//  OnboardingViewController.swift
//  MarketList
//
//  Created by UNAM FCA 06 on 24/05/22.
//

import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var slides: [OnboardingSlide] = []
    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
            if currentPage == slides.count - 1{
                nextBtn.setTitle("Get Started", for: .normal)
            } else {
                nextBtn.setTitle("Next", for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        slides = [
            OnboardingSlide(title: "Hola, esto es MarketList", description: "La aplicación que te ayudará a ordenar mejor tu lista de supermercado", image: UIImage(named: "marketList")!),
            OnboardingSlide(title: "Agregar", description: "Puedes agregar nuevos elementos a tu lista, solo presiona el botón +", image: UIImage(named: "agregar")!),
            OnboardingSlide(title: "Editar", description: "Y también puedes editarlos, solo presiona el elemento y podrás editarlo", image: UIImage(named: "editar")!),
            OnboardingSlide(title: "Eliminar", description: "Una vez que hayas adquirido el artículo, podrás eliminarlo deslizando el elemento y presiona el botón rojo", image: UIImage(named: "eliminar")!)
        ]
    }
    
    @IBAction func nextBtnClicked(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: "sesion")
        if currentPage == slides.count - 1{
            let controller = storyboard?.instantiateViewController(identifier: "HomeNC") as! UINavigationController
            controller.modalPresentationStyle = .fullScreen
            controller.modalTransitionStyle = .flipHorizontal
            present(controller, animated: true, completion: nil)
        } else {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        
    }
}

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifier, for: indexPath) as! OnboardingCollectionViewCell
        
        cell.setup(slides[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }
}
