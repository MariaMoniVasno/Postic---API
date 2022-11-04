//
//  HomeView.swift
//  PhotoLister
//
//  Created by Trident on 02/11/22.
//

import SwiftUI
import UIKit

struct HomeView: View {
    var userViewModel = UserViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing:zero){
                ZStack {
                    Color.BrandBlue.Base
                        .edgesIgnoringSafeArea(.top)
                    VStack(spacing:zero){
                        DividerView
                            .frame(height:one)
                        TabBarView()
                    } // VStack
                } // ZStack
            } // VStack
            .background(Color.BrandExtraLightGray.Base)
            .navigationBarTitle(EmptyStr, displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading:
                                    HStack{
                StaticImage(imageName: LogoImage,widthSize : 35,heightSize: 35)
                Text(Postic)
                    .foregroundColor(Color.BrandWhite.Base)
                    .font(.custom(InterBold, size: textSize(textStyle: .title2)))
                    .padding(.leading,twenty)
                Spacer()
            } // HStack
                                ,trailing: HStack (spacing:twenty){
                NavigationbarIcon(imageName: BellSysImg)
                NavigationbarIcon(imageName: MagnifyingGlassSysImg)
                NavigationbarIcon(imageName: MCircleFillSysImg)
            } // HStack
                                    .background(Color.BrandBlue.Base))
        } // NavigationView
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    var DividerView : some View{
        VStack(spacing:zero){
            Divider()
        } // VStack
        .frame(height:five)
        .background(Color.BrandBlue.Base)
    }
    
    struct UserView : View{
        @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
        @Environment(\.viewController) private var viewControllerHolder: UIViewController?
        @State var userListModel = [UserDetailModel]()
        @State var userPhotoModel = [UserPhotoModel]()
        @State var userThumbnailImgArr = [UIImage]()
        @State var userPostImgArr = [UIImage]()
        @State var randomNumberArr = [Int]()
        var userViewModel = UserViewModel()
        
        var body: some View{
            ScrollView {
                VStack(alignment: .leading,spacing:zero) {
                    ScrolLableView()
                    if userListModel.count == 0{
                        HStack{
                            Spacer()
                            ProgressView()
                            Spacer()
                        } // HStack
                    }else{
                        LazyVStack {
                            ForEach(0..<userListModel.count,id: \.self) { index in
                                NavigationLink(destination: UserDetailView(id:index+1,userDetail : userListModel[index], userThumbnailImgArr: $userThumbnailImgArr,userPostImgArr:$userPostImgArr, randomNumberArr: $randomNumberArr)){
                                    VStack(alignment: .leading,spacing:zero) {
                                        UserListView(userDetail: userListModel[index], userThumbnailImgArr: $userThumbnailImgArr, randomNumberArr: $randomNumberArr,id:index)
                                    } // VStack
                                    .background(Color.BrandWhite.Base)
                                    .padding(.top,one)
                                } // NavigationLink
                            } // Foreach
                        } // LazyVStack
                        .padding(.top,five)
                        .background(Color.BrandExtraLightBlue.Base)
                        .frame(width:UIScreen.main.bounds.width)
                    } // else
                } // ScrollView
            } // VStack
            .onAppear() {
                if InternetConnectionManager.isConnectedToNetwork(){
                    userViewModel.getWholeUsersList(completion: { (userList) in
                        userListModel = userList
                    })
                    userViewModel.getUserPhoto(completion: { (comments) in
                        userPhotoModel = comments
                        randomNumberArr = userViewModel.makeList(30)
                        for index in 0..<userPhotoModel.count{
                            if let profileImage = userPhotoModel[index].thumbnailURL {
                                ImageCache.getImages(imageURL: profileImage) { (downloadedImage) in
                                    userThumbnailImgArr.append(downloadedImage)
                                }
                            }
                            if let profileImage = userPhotoModel[index].url {
                                ImageCache.getImages(imageURL: profileImage) { (downloadedImage) in
                                    userPostImgArr.append(downloadedImage)
                                }
                            }
                        }
                    })
                }else{
                    // Check the network
                    DispatchQueue.main.async {
                        self.viewControllerHolder?.dismiss(animated: true, completion: nil)
                        self.viewControllerHolder?.present(style: .overCurrentContext, transitionStyle: .crossDissolve) {
                            DefaultAlertViewWithSingleButton(alertTitleMessage: Warning,alertMessage: NoNetworkCoverageOfflineMode,alertPrimaryDismissTxt: OK)
                        }
                    }
                }
            }
        }
        
    }
        
    struct StaticImage : View{
        var imageName = EmptyStr
        var backgrdColor = Color.BrandWhite.Base
        var widthSize = twenty
        var heightSize = twentyFive
        
        var body: some View{
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: widthSize, height: heightSize)
                .foregroundColor(backgrdColor)
                .background(Color.BrandBlue.Base)
        }
        
    }
    
    struct TabBarView : View{
        @Environment(\.colorScheme) var colorScheme
        
        init() {
            UITabBar.appearance().isTranslucent = true
            UITabBar.appearance().tintColor = UIColor(Color.BrandBlue.Base)
            UITabBar.appearance().unselectedItemTintColor = UIColor(Color.BrandWhite.Base)
            UITabBar.appearance().barTintColor = UIColor(Color.BrandBlue.Base)
            UITabBar.appearance().backgroundColor = UIColor(Color.BrandBlue.Base)
        }
        
        var body: some View{
            TabView {
                UserView()//(userListModel:$userListModel)
                    .tabItem {
                        Label(Home, systemImage: HouseCircleSysImg)
                    }
                TabBarEmptyView(titleStr: User)
                    .tabItem {
                        Label(User, systemImage: PersonTwoSysImg)
                        Text(User)
                    }
                TabBarEmptyView(titleStr: Create)
                    .tabItem {
                        Label(Create, systemImage: PlusCircleSysImg)
                        Text(Create)
                    }
                TabBarEmptyView(titleStr: Account)
                    .tabItem {
                        Label(Account, systemImage: LineThreeHorizontalSysImg)
                        Text(Account)
                    }
            }
        }
    }
    
    struct TabBarEmptyView : View{
        var titleStr = EmptyStr
        var body: some View{
            Text(titleStr)
        }
    }
    
    struct LabelView: View {
        @State var label: String
        
        var body: some View {
            ZStack {
                Button(action: {
                }) {
                    Text(label)
                        .padding()
                        .foregroundColor(Color.BrandGray.Base)
                } // Button
                .font(.custom(InterRegular, size: textSize(textStyle: .subheadline)))
                .background(Color.BrandWhite.Base) // If you have this
                .frame(height:thirty)
                .cornerRadius(five)
                .overlay(
                    RoundedRectangle(cornerRadius: fifteen)
                        .stroke(lineWidth: one)
                        .stroke(Color.BrandExtraLightGray.Base)
                )
            }
        }
    }
    
    struct ScrolLableView: View {
        @State var homeOptionsArray = [All,MostRecent,Favourites,History,Trash]
        var body: some View {
            VStack {
                Divider()
                ScrollView(.horizontal) {
                    HStack(spacing: ten) {
                        ForEach(homeOptionsArray,id:\.self) { item in
                            LabelView(label: item)
                        }
                    }.padding()
                } // ScrollView
            } // VStack
        }
    }
    
}



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
