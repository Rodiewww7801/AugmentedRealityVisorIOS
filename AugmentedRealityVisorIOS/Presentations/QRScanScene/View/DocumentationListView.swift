//
//  DocumentationListView.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 09.05.2022.
//

import SwiftUI

struct DocumentationListView: View {
    //@ObservedObject var viewModel: DocumentationListViewModel
    @State var isLoading: Bool = false
    @State var pdfIsShown: Bool = false
    @State var pdfData: Data?
    var documentations: [DocumentationModel] = []
    var firebaseManager = FirebaseManager._shared
    @Environment(\.openURL) var openURL
    
    var body: some View {
        
        ZStack {
            VStack {
                if documentations.isEmpty {
                    VStack {
                        Spacer()
                        
                        Text("Documentation is empty")
                            .font(.system(size: 18))
                            .foregroundColor(.gray.opacity(0.5))
                        
                        Spacer()
                    }.frame(maxHeight: .infinity)
                    
                } else {
                    List {
                        ForEach(documentations) { document in
                            Button(action: {
                                
                                if document.link.contains(".pdf") {
                                    isLoading = true
                                    firebaseManager.downloadPDFFromFirabase(relativePath: document.link, completion: { url in
                                        if let data = try? Data(contentsOf: url) {
                                            self.pdfData = data
                                            self.pdfIsShown.toggle()
                                        }
                                       
                                        isLoading = false
                                    })
                                    
                                } else if let url = URL(string: document.link) {
                                    openURL(url)
                                }
                            }, label: {
                                HStack {
                                    Text("\(document.name)")
                                        .font(.system(size: 14))
                                    Spacer()
                                }
                            })
                        }
                    }
                }
            }
            
            if pdfIsShown, let pdfData = pdfData {
                PDFKitRepresentedView(pdfData, singlePage: false)
            }
            
            if isLoading {
                LoadingView()
            }
        }
    }
}


