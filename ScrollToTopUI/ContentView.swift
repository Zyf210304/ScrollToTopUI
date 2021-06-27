//
//  ContentView.swift
//  ScrollToTopUI
//
//  Created by 张亚飞 on 2021/6/27.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        NavigationView {
            
            Home()
                .navigationTitle("Medium")
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home: View {
    
    @State var scrollViewOffset: CGFloat = 0
    
    //getting start offset and eliminating from current offset so that we will get exact offset....
    @State var startOffset: CGFloat = 0
    
    var body: some View {
        
        //scroll to top function...
        //with the help of scrollview reader...
        
        ScrollViewReader { proxyReader in
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(spacing: 35) {
                    
                    ForEach(1...30, id: \.self) { index in
                        
                        
                        HStack(spacing: 15) {
                            
                            Circle()
                                .fill((index == 1 ? Color.red : Color.gray) .opacity(0.5))
                                .frame(width: 60, height: 60)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.gray.opacity(0.5))
                                    .frame(height: 22)
                                
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.gray.opacity(0.5))
                                    .frame(height: 22)
                                    .padding(.trailing, 80)
                            }
                        }
                    }
                }
                .padding()
                //setting ID
                //so that it can scroll to that position
                .id("SCROLL_TO_TOP")
                //getting scrollView offset...
                .overlay(
                
                    GeometryReader { proxy -> Color in
                    
                    
                        DispatchQueue.main.async {
                            
                            if startOffset == 0 {
                                
                                self.startOffset = proxy.frame(in: .global).minY
                            }
                            
                            let offset =  proxy.frame(in: .global).minY
                            self.scrollViewOffset = offset - startOffset
                            
    //                        print(self.scrollViewOffset)
                        }
                        
                        print(offset)
                        
                        return Color.clear
                    }
                    .frame(width: 0, height: 0, alignment: .top)
                    
                    ,alignment: .top
                
                )
                
            }
            .overlay(
            
                Button(action: {
                
                    withAnimation(.spring()) {
                        
                        proxyReader.scrollTo("SCROLL_TO_TOP", anchor: .top)
                    }
                }, label: {
                    
                    Image(systemName: "arrow.up")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red.opacity(0.9))
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 5, y: 5)
                })
                    .padding(.trailing)
                    .padding(.bottom, getSafeArea().bottom == 0 ? 12 : 0)
                    .opacity(-scrollViewOffset > 450 ? 1 : 0)
                    .animation(.easeInOut)
                
                ,alignment: .bottomTrailing
            )
        }
        
        
        
    }
}


extension View {
    
    func getSafeArea() -> UIEdgeInsets {
        
        return UIApplication.shared.windows.first?.safeAreaInsets ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
