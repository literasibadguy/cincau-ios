//
//  DonateView.swift
//  bestok
//
//  Created by Firas Rafislam on 28/12/2023.
//

import SwiftUI
import StoreKit

fileprivate struct TipItem: View {
    
    let title: String
    let description: String
    let pricing: String
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text(title)
                Text(description).foregroundStyle(.secondary)
                Text(String(pricing)).foregroundStyle(.foreground).font(karrik_font(.normal, font_size: 1))
            }.font(karrik_font(.normal, font_size: 1))
            Spacer()
            
        }
    }
    

}

struct DonateView: View {
    
    @StateObject var viewModel: DonateStoreViewModel = DonateStoreViewModel()
    @State var isPurchased: Bool = false
    @State var errorTitle: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                SupportCincau
                
                
                List {
                    switch viewModel.state {
                    case .loading:
                        ProgressView()
                    case .store(let products):
                        ForEach(viewModel.donations) { product in
                            TipItem(title: product.displayName, description: product.description, pricing: product.displayPrice).onTapGesture {
                                Task {
                                    await buy(product)
                                }
                            }
                        }
                    case .error:
                        Text("Something happened error")
                    }
                    
                    
                }
                
                Spacer()
            }.padding()
        }.navigationTitle("Support")
    }
    
    private func buy(_ product: Product) async {
        do {
            if try await viewModel.purchase(product) != nil {
                withAnimation {
                    isPurchased = true
                }
            }
        } catch StoreError.failedVerification {
            errorTitle = "Your purchase could not be verified by the App Store"
        } catch {
            print("Failed purchase for \(product.id): \(error)")
        }
    }
}

    var SupportCincau: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 20)
                .fill(.black)
            
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text(verbatim:"🧋")
                    Text("Support Cincau", comment: "Text calling for the user to support Cincau through app store")
                        .font(karrik_font(.title, font_size: 1))
                        .foregroundColor(.white)
                }
                

                
                Text("Help this humble Developer to create more apps and fun works", comment: "Text indicating the goal of developing Damus which the user can help with.")
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(.white).font(karrik_font(.normal, font_size: 1))
                

                
            }
            .padding(25)
        }
        .frame(height: 200)
    }


#Preview {
    DonateView()
}
