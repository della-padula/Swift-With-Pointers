//
//  ViewController.swift
//  Swift-With-Pointers
//
//  Created by denny on 2020/10/25.
//

import UIKit
import SnapKit

struct SampleModel {
    var name: String
    var personalCode: Int64
    
    func memoryLayoutText() -> String {
        var debugText = ""
        debugText.append("SampleModel >> s: \(MemoryLayout<SampleModel>.size) / a: \(MemoryLayout<SampleModel>.alignment) / stride: \(MemoryLayout<SampleModel>.stride)\n")
        return debugText
    }
}

struct EmptyStruct { }
class EmptyClass { }

class ViewController: UIViewController {
    private var textView: UITextView = UITextView()
    private var debugText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainLayout()
        memoryLayout()
        unsafeRawPointers()
    }
    
    private func setupMainLayout() {
        view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(44)
            make.bottom.equalToSuperview().offset(-44)
        }
        
        textView.textAlignment = .center
        textView.font = .systemFont(ofSize: 18)
        textView.textColor = .black
    }
    
    private func memoryLayout() {
        debugText.removeAll()
        debugText.append("Int >> s: \(MemoryLayout<Int>.size) / a: \(MemoryLayout<Int>.alignment) / stride: \(MemoryLayout<Int>.stride)\n")
        debugText.append("Int8 >> s: \(MemoryLayout<Int8>.size) / a: \(MemoryLayout<Int8>.alignment) / stride: \(MemoryLayout<Int8>.stride)\n")
        debugText.append("Int16 >> s: \(MemoryLayout<Int16>.size) / a: \(MemoryLayout<Int16>.alignment) / stride: \(MemoryLayout<Int16>.stride)\n")
        debugText.append("Int64 >> s: \(MemoryLayout<Int64>.size) / a: \(MemoryLayout<Int64>.alignment) / stride: \(MemoryLayout<Int64>.stride)\n\n")
        debugText.append("Bool >> s: \(MemoryLayout<Bool>.size) / a: \(MemoryLayout<Bool>.alignment) / stride: \(MemoryLayout<Bool>.stride)\n")
        debugText.append("Float >> s: \(MemoryLayout<Float>.size) / a: \(MemoryLayout<Float>.alignment) / stride: \(MemoryLayout<Float>.stride)\n")
        debugText.append("Double >> s: \(MemoryLayout<Double>.size) / a: \(MemoryLayout<Double>.alignment) / stride: \(MemoryLayout<Double>.stride)\n")
        debugText.append("String >> s: \(MemoryLayout<String>.size) / a: \(MemoryLayout<String>.alignment) / stride: \(MemoryLayout<String>.stride)\n\n")
        
        debugText.append("EmptyClass >> s: \(MemoryLayout<EmptyClass>.size) / a: \(MemoryLayout<EmptyClass>.alignment) / stride: \(MemoryLayout<EmptyClass>.stride)\n")
        debugText.append("EmptyStruct >> s: \(MemoryLayout<EmptyStruct>.size) / a: \(MemoryLayout<EmptyStruct>.alignment) / stride: \(MemoryLayout<EmptyStruct>.stride)\n\n")
        
        let model1 = SampleModel(name: "Test", personalCode: 12345678910)
        debugText.append(model1.memoryLayoutText())
        
        let model2 = SampleModel(name: "TestTest", personalCode:987654321)
        debugText.append(model2.memoryLayoutText())
        
        textView.text = debugText
    }
    
    private func unsafeRawPointers() {
        // 1
        let count = 2
        let stride = MemoryLayout<Int>.stride
        let alignment = MemoryLayout<Int>.alignment
        let byteCount = stride * count
        
        // 2
        do {
            debugText.append("\nUnsafe Raw Pointers\n")
            
            // 3
            let pointer = UnsafeMutableRawPointer.allocate(
                byteCount: byteCount,
                alignment: alignment)
            // 4
            defer {
                pointer.deallocate()
            }
            
            // 5
            pointer.storeBytes(of: 42, as: Int.self)
            pointer.advanced(by: stride).storeBytes(of: 6, as: Int.self)
            pointer.load(as: Int.self)
            pointer.advanced(by: stride).load(as: Int.self)
            
            // 6
            let bufferPointer = UnsafeRawBufferPointer(start: pointer, count: byteCount)
            for (index, byte) in bufferPointer.enumerated() {
                debugText.append("byte \(index): \(byte)\n")
            }
            
            textView.text = debugText
        }
        
    }
}

