//
//  RatingControll.swift
//  myPlaces
//
//  Created by Роман on 05.12.2020.
//

import UIKit

@IBDesignable class RatingControll: UIStackView {
    
    //MARK: Propierties
    
    var raiting = 0{
        didSet{
            updateButtonSelectionState()
        }
    }
    private var ratingButton = [UIButton]()
    @IBInspectable var startSize: CGSize = CGSize(width: 44.0, height: 44.0){
        didSet{
            setupButton()
        }
    }
    @IBInspectable var starCount: Int = 5{
        didSet{
            setupButton()
        }
    }
    
    
    
    
    //MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    // MARK: Button active
    
    @objc func ratingButtonTapped(button: UIButton){
        guard let index = ratingButton.firstIndex(of: button) else {return}
        
        // Calculater the rating of the button taped
        let selectedRating = index + 1
        
        if selectedRating == raiting {
            raiting = 0
        } else {
            raiting = selectedRating
        }
    }
    
    // MARK: Privet methods
    
    private func setupButton(){
        
        for button in ratingButton {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        
        ratingButton.removeAll()
        
        //Load button image
        let bundel = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar",
                                 in: bundel,
                                 compatibleWith: self.traitCollection)
        
        let emptyStar = UIImage(named: "emptyStar",
                                in: bundel,
                                compatibleWith: self.traitCollection)
        
        let highlightedStar = UIImage(named: "highlightedStar",
                                      in: bundel,
                                      compatibleWith: self.traitCollection)
        
        
        for _ in 0..<starCount {
            
            let button = UIButton()
            // Set the button image
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
            
            
            // Add constrais
            button.translatesAutoresizingMaskIntoConstraints = true
            button.heightAnchor.constraint(equalToConstant: startSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: startSize.width).isActive = true
            
            // setup the button action
            
            button.addTarget(self, action: #selector(ratingButtonTapped(button:)), for: .touchUpInside)
            // add the stack button to the viwe
            
            addArrangedSubview(button)
            // add new buttons to ratingButtonTapped
            
            ratingButton.append(button)
        }
        updateButtonSelectionState()
    }
    
    func updateButtonSelectionState(){
        for (index, button) in ratingButton.enumerated() {
            button.isSelected = index < raiting
        }
        
    }
    
}
