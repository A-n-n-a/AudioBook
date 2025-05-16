//
//  HTMLTextView.swift
//  AudioBook
//
//  Created by Anna on 5/16/25.
//

import SwiftUI

struct HTMLTextView: UIViewRepresentable {
    let htmlContent: String
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.showsVerticalScrollIndicator = false
        textView.backgroundColor = UIColor(red: 254/255, green: 249/255, blue: 244/255, alpha: 1)
        textView.textContainerInset = UIEdgeInsets(top: 60, left: 0, bottom: 40, right: 0)
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        guard let data = htmlContent.data(using: .utf8) else {
            uiView.attributedText = NSAttributedString(string: htmlContent)
            return
        }
        
        if let attributedString = try? NSAttributedString(
            data: data,
            options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ],
            documentAttributes: nil
        ) {
            uiView.attributedText = attributedString
        } else {
            uiView.attributedText = NSAttributedString(string: htmlContent)
        }
    }
}
