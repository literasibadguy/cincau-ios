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
    let pricing: Int
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text(title)
                Text(description).foregroundStyle(.secondary)
            }.font(karrik_font(.normal, font_size: 1))
            Spacer()
            Text(String(pricing)).foregroundStyle(.foreground).font(karrik_font(.normal, font_size: 1))
        }
    }
    

}

struct DonateView: View {
    var body: some View {
        NavigationView {
            VStack {
                SupportDamus
                
                List {
                    TipItem(title: "Insane Tip", description: "Thank you. Have a good day", pricing: 10)
                    TipItem(title: "Generous Tip", description: "Thank you. Have a good day", pricing: 20)
                    TipItem(title: "Insane Tip", description: "Thank you. Have a good day", pricing: 5)
                    TipItem(title: "Insane Tip", description: "Thank you. Have a good day", pricing: 9)
                }
                
                Spacer()
            }.padding()
        }.navigationTitle("Support")
    }
    

}

    var SupportDamus: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 20)
                .fill(.black)
            
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text(verbatim:"🧋")
                    Text("Support Cincau", comment: "Text calling for the user to support Damus through zaps")
                        .font(karrik_font(.title, font_size: 1))
                        .foregroundColor(.white)
                }
                
                Text("Help this humble Developer to create more apps and fun works", comment: "Text indicating the goal of developing Damus which the user can help with.")
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(.white).font(karrik_font(.normal, font_size: 1))
                
//                HStack{
//                    Spacer()
//                    
//                    VStack {
//                        HStack {
//                            Text("Amount Setting")
//                                .font(.title)
//                                .foregroundColor(.yellow)
//                                .frame(width: 120)
//                        }
//                        
//                        Text("Zap", comment: "Text underneath the number of sats indicating that it's the amount used for zaps.")
//                            .foregroundColor(.white)
//                    }
//                    Spacer()
//                    
//                    Text(verbatim: "+")
//                        .font(.title)
//                        .foregroundColor(.white)
//                    Spacer()
//                    
//                    VStack {
//                        HStack {
//                            Text("Tip Msats")
//                                .font(.title)
//                                .foregroundColor(.yellow)
//                                .frame(width: 120)
//                        }
//                        
//                        Text(verbatim:"💜")
//                            .foregroundColor(.white)
//                    }
//                    Spacer()
//                }
                
            }
            .padding(25)
        }
        .frame(height: 250)
    }


#Preview {
    DonateView()
}
