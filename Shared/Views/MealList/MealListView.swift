//
//  MealListView.swift
//  VegMeal
//
//  Created by Travis Gerrard on 9/23/20.
//

import SwiftUI
import KingfisherSwiftUI
import struct Kingfisher.DownsamplingImageProcessor

struct MealListView: View {
    @EnvironmentObject var networkingController: ApolloNetworkingController
    @EnvironmentObject var mealListController: MealListApolloController
    
    @AppStorage("isLogged") var isLogged = false
    @AppStorage("userid") var userid = ""
    
    @Namespace private var ns_grid // ids to match grid elements with modal
    @Namespace private var ns_favorites // ids to match favorite icons with modal
    
    @State private var shake = false
    @State private var blur: Bool = false
    
    // Tap flags
    @State var mealDoubleTap: String? = nil
    @State private var mealTap: String? = nil
    @State private var mealIndex: Int? = nil
    @State private var favoriteTap: String? = nil
    
    // Views are matched at insertion, but onAppear we broke the match
    // in order to animate immediately after view insertion
    // These flags control the match/unmatch
    @State private var flyFromGridToFavorite: Bool = false
    @State private var flyFromGridToModal: Bool = false
    @State var flyFromFavoriteToModal: Bool = false
    
    // Determine if geometry matches occur
    var matchGridToModal: Bool { !flyFromGridToModal && mealTap != nil }
    var matchFavoriteToModal: Bool { !flyFromGridToModal && favoriteTap != nil }
    func matchGridToFavorite(_ id: String) -> Bool { mealDoubleTap == id && !flyFromGridToFavorite }
    let c = GridItem(.adaptive(minimum: 200, maximum: 400), spacing: 20)
    
    static let tag: String? = "MealListView"

    
    //MARK: Functions
    
    var body: some View {
        if isLogged {
            ZStack{
                VStack {
                    NavigationView {
                        List {
                            Section(header: Text("To Make")) {
                                ForEach(self.mealListController.mealList) { item in
                                    
                                    HStack {
                                        Button(action: {
                                        }) {
                                            Circle()
                                                .strokeBorder(Color.black.opacity(0.6),lineWidth: 1)
                                                .frame(width: 32, height: 32)
                                                .padding(.trailing, 3)
                                        }
                                        .gesture(DragGesture(minimumDistance: 0.0, coordinateSpace: .global)
                                                    .onChanged { _ in
                                                    }
                                                    .onEnded { _ in
                                                        self.mealListController.completeMealListItem(id: item.id)
                                                    }
                                        )
                                        
                                        HStack {
                                            KFImage(parse(object: item.meal),
                                                    options: [
                                                        .transition(.fade(0.2)),
                                                        .processor(
                                                            DownsamplingImageProcessor(size: CGSize(width: 50, height: 50))
                                                        ),
                                                        .cacheOriginalImage
                                                    ])
                                                .placeholder {
                                                    Image("009-eggplant")
                                                        .resizable()
                                                        .frame(width: 50, height: 50)
                                                        .padding(10)
                                                }
                                                .resizable()
                                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 50, height: 50)
                                            Divider().background(Color.black).padding(0)
                                            VStack(alignment: .leading) {
                                                Text("\(item.meal.name ?? "No name")").font(.body)
                                                    .fontWeight(.bold)
                                                    .minimumScaleFactor(0.5)
                                                Text("\(item.meal.description ?? "No description")").font(.caption)
                                            }
                                        }
                                        .onTapGesture(count: 1) { openModal(item, fromGrid: true) }
                                        .matchedGeometryEffect(id: item.id, in: ns_grid, isSource: true)
                                        
                                        
                                        
                                        
                                        Spacer()
                                        Button(action: {
                                        }) {
                                            Image(systemName: "trash")
                                                .font(.system(size: 17, weight: .bold))
                                                .foregroundColor(.white)
                                                .padding(.all, 10)
                                                .background(Color.black.opacity(0.6))
                                                .clipShape(Circle())
                                        }
                                        .gesture(TapGesture()
                                                    .onEnded {
                                                        self.mealListController.deleteMealListItem(id: item.id)
                                                    }
                                        )
                                    }
                                    
                                    
                                }
                            }
                            Section(header: Text("Made")) {
                                ForEach(self.mealListController.completedMealList) { item in
                                    
                                    HStack {
                                        Button(action: {
                                        }) {
                                            Circle()
                                                .frame(width: 32, height: 32)
                                                .foregroundColor(.gray)
                                                .padding(.trailing, 3)
                                        }
                                        .gesture(DragGesture(minimumDistance: 0.0, coordinateSpace: .global)
                                                    .onChanged { _ in
                                                    }
                                                    .onEnded { _ in
                                                        self.mealListController.completeMealListItem(id: item.id)
                                                    }
                                        )
                                        
                                        HStack {
                                            KFImage(parse(object: item.meal),
                                                    options: [
                                                        .transition(.fade(0.2)),
                                                        .processor(
                                                            DownsamplingImageProcessor(size: CGSize(width: 50, height: 50))
                                                        ),
                                                        .cacheOriginalImage
                                                    ])
                                                .placeholder {
                                                    
                                                    Image("009-eggplant")
                                                        .resizable()
                                                        .frame(width: 50, height: 50)
                                                        .padding(10)
                                                    
                                                }
                                                .resizable()
                                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 50, height: 50)
                                            Divider().background(Color.black).padding(0)
                                            VStack(alignment: .leading) {
                                                Text("\(item.meal.name ?? "No name")").font(.body)
                                                    .fontWeight(.bold)
                                                    .minimumScaleFactor(0.5)
                                                Text("\(item.dateCompleted)").font(.caption)
                                            }
                                            .foregroundColor(.gray)
                                            
                                        }
                                        .onTapGesture(count: 1) { openModal(item, fromGrid: true) }
                                        .matchedGeometryEffect(id: item.id, in: ns_grid, isSource: true)
                                        
                                        
                                        
                                        
                                        Spacer()
                                        Button(action: {
                                        }) {
                                            Image(systemName: "trash")
                                                .font(.system(size: 17, weight: .bold))
                                                .foregroundColor(.white)
                                                .padding(.all, 10)
                                                .background(Color.black.opacity(0.6))
                                                .clipShape(Circle())
                                        }
                                        .gesture(TapGesture()
                                                    .onEnded {
                                                        self.mealListController.deleteMealListItem(id: item.id)
                                                    }
                                        )
                                    }
                                    
                                    
                                }
                            }
                        }
                        .navigationBarTitle("Meal Planner")
                        .onAppear {
                            self.mealListController.getMealList(userId: userid)
                        }
                    }.zIndex(1.0)
                }
                VStack {
                    HStack {
                        if self.mealListController.mealListQueryRunning {
                            ProgressView().padding(.leading).padding(.all, 10)
                        } else {
                            Button(action: {
                                self.mealListController.getMealList(userId: userid)
                            }) {
                                Image(systemName: "arrow.triangle.2.circlepath")
                                    .font(.system(size: 17, weight: .bold))
                                    .padding(.all, 10)
                                    .clipShape(Circle())
                            }
                            .padding(.leading)
                        }
                        
                        
                        Spacer()
                        
                    }
                    Spacer()
                }.zIndex(1.1)
                
                //-------------------------------------------------------
                // Backdrop blurred view (zIndex = 3)
                //-------------------------------------------------------
                BlurViewTwo(active: blur, onTap: dismissModal)
                    .zIndex(3)
                
                //-------------------------------------------------------
                // Modal View (zIndex = 4)
                //-------------------------------------------------------
                if mealTap != nil && mealIndex != nil || favoriteTap != nil {
                    ModalView(
                        id: mealTap ?? favoriteTap!,
                        meal: self.$networkingController.meals[mealIndex!],
                        pct: flyFromGridToModal ? 1 : 0,
                        flyingFromGrid: mealTap != nil,
                        userId: isLogged ? userid : nil,
                        onClose: dismissModal)
                        .matchedGeometryEffect(id: matchGridToModal ? mealTap! : "0", in: ns_grid, isSource: false)
                        .matchedGeometryEffect(id: matchFavoriteToModal ? favoriteTap! : "0", in: ns_favorites, isSource: false)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .onAppear { withAnimation(.fly) { flyFromGridToModal = true } }
                        .onDisappear { flyFromGridToModal = false }
                        .transition(AnyTransition.asymmetric(insertion: .identity, removal: .move(edge: .bottom)))
                        .zIndex(4)
                }
            }
        } else {
            LoginInCreateAccountPromt()
        }
        
    }
    
    func dismissModal() {
        withAnimation(.basic) {
            mealTap = nil
            mealIndex = nil
            favoriteTap = nil
            blur = false
        }
    }
    
    func openModal(_ item: MealListItem, fromGrid: Bool) {
        
        if fromGrid {
            mealTap = item.id
            // mealIndex needs to be of networkingController since this is where it will be updated. ID comes from click though..
            mealIndex = self.networkingController.meals.firstIndex(where: {$0.id == item.meal.id})
            
        } else {
            favoriteTap = item.id
        }
        
        withAnimation(.basic) {
            blur = true
        }
    }
}

struct MealListView_Previews: PreviewProvider {
    static var previews: some View {
        MealListView()
            .environmentObject(ApolloNetworkingController())
            .environmentObject(GroceryListApolloController())
            .environmentObject(MealListApolloController())
            .environmentObject(MealLogApolloController())
    }
    
    
}
