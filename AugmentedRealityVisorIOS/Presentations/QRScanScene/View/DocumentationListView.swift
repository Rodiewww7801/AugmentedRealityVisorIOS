//
//  DocumentationListView.swift
//  AugmentedRealityVisorIOS
//
//  Created by Rodion Hladchenko on 09.05.2022.
//

import SwiftUI

struct DocumentationListView: View {
    //@ObservedObject var viewModel: DocumentationListViewModel
    var documentations: [DocumentationModel] = []
    @Environment(\.openURL) var openURL
    
    var body: some View {
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
                            if let url = URL(string: document.link) {
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
    }
}


