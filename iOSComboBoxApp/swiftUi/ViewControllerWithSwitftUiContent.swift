//
//  ViewControllerWithSwitftUiContent.swift
//  iOSComboBoxApp
//
//  Created by Robert Andrzejczyk on 31/07/2025.
//

import UIKit
import SwiftUI

class CountryComboBox: iOSComboBox {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    private func setUp() {
        comboBoxDataSource = self
        comboBoxDelegate = self
        register(cellClass: CountryCell.self)
        borderStyle = .roundedRect
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.gray.cgColor
        layer.cornerRadius = 8.0
    }
}

extension CountryComboBox: iOSComboBoxDataSource, iOSComboBoxDelegate {
    
    func comboBox(_ comboBox: iOSComboBox, cellProvider: UITableViewCellProvider, forRowAt index: Int) -> UITableViewCell {
        let cell: CountryCell = cellProvider.dequeCell(atRow: index)
        let (flag, countrName) = CountryData[index]
        cell.configure(with: flag, countryName: countrName)
        cell.accessibilityTraits = [.button]
        return cell
    }
    
    func numberOfItems(in comboBox: iOSComboBox) -> Int {
        CountryData.count
    }
    
    func comboBox(_ comboBox: iOSComboBox, objectValueForItemAt index: Int) -> Any? {
        CountryData[index].countryName
    }
    
    func comboBox(_ comboBox: iOSComboBox, heightForRowAt index: Int) -> CGFloat {
        30.0
    }
}

struct CountryComboBoxWrapper: UIViewRepresentable {

    func makeUIView(context: Context) -> CountryComboBox {
        CountryComboBox()
    }

    func updateUIView(_ uiView: CountryComboBox, context: Context) {
    }
}

struct MySwiftUIView: View {
    
    let closeHandler: ()->Void
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Hello from SwiftUI!")
                .padding()
                .background(Color.yellow)
            CountryComboBoxWrapper()
                .padding()
                .frame(width: 200, height: 45)
            Spacer()
                .background(Color.blue)
            Spacer()
                .background(Color.red)
            Button("Close") {
                closeHandler()
            }
        }
    }
}

class ViewControllerWithSwitftUiContent: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the SwiftUI view
        let swiftUIView = MySwiftUIView{ [weak self] in
            self?.dismiss(animated: true)
        }
        
        // Wrap it in a hosting controller
        let hostingController = UIHostingController(rootView: swiftUIView)
        
        // Add as a child VC
        addChild(hostingController)
        view.addSubview(hostingController.view)
        
        // Set constraints or frame
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        // Finish adding child
        hostingController.didMove(toParent: self)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
