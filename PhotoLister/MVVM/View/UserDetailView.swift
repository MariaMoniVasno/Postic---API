//
//  UserDetailView.swift
//  PhotoLister
//
//  Created by Trident on 02/11/22.
//

import SwiftUI

struct UserDetailView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.viewController) private var viewControllerHolder: UIViewController?
    var id : Int
    var userDetail : UserDetailModel
    var userViewModel = UserViewModel()
    @Binding var userThumbnailImgArr : [UIImage]
    @Binding var userPostImgArr : [UIImage]
    @Binding var randomNumberArr : [Int]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading,spacing:five) {
                userDetailView
                UserPostList(userDetail: userDetail, id:id,userThumbnailImgArr:$userThumbnailImgArr,userPostImgArr:$userPostImgArr, randomNumberArr: $randomNumberArr)
                Spacer()
            } // VStack
        } // ScrollView
        .frame(width:UIScreen.main.bounds.width)
        .background(Color.BrandExtraLightBlue.Base)
        .navigationBarTitle(userDetail.name, displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:backBtn)
    }
    
    // Custom Back Button Left side
    var backBtn : some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: ChevronBackwardSysImg)
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color.BrandBlack.Base)
                Text(Back)
                    .foregroundColor(Color.BrandBlack.Base)
                    .font(.custom(InterRegular, size: textSize(textStyle: .subheadline)))
            } // HStack
        } // Button
        .padding(.leading,-ten)
    }
    
    var userDetailView : some View{
        VStack(alignment: .leading,spacing:ten) {
            userImageName
            TextAndImgaeView(labelText: userDetail.email, imageStr: EnvelopeSysImg, fontText: InterRegular,imageColor: Color.BrandLightBlue.Base)
            TextAndImgaeView(labelText: userDetail.phone, imageStr: PhoneSysImg, fontText: InterRegular)
            TextAndImgaeView(labelText: userDetail.address.suite + comma + userDetail.address.street + comma + userDetail.address.city + comma + userDetail.address.zipcode, imageStr: HouseSysImg, fontText: InterRegular)
            TextAndImgaeView(labelText: userDetail.website, imageStr: NetworkSysImg, fontText: InterRegular,lblColor:Color.BrandBlue.Base)
                .onTapGesture {
                    if UIApplication.shared.canOpenURL(URL(string: (userDetail.website))!) {
                        UIApplication.shared.open(URL(string: (userDetail.website))!)
                    }
                }
            HStack{
                Text(CompanyStr)
                    .frame(height: 40)
                    .foregroundColor(Color.BrandBlack.Base)
                    .font(.custom(InterBold, size: textSize(textStyle: .body)))
                    .padding(.leading,twenty)
                Spacer()
            } // HStack
            TextAndImgaeView(labelText: userDetail.company.name + "(" + userDetail.company.catchPhrase + ")"  , imageStr: BuildingColumnsSysImg, fontText: InterRegular)
        } // VStack
        .padding()
        .background(Color.BrandWhite.Base)
        .padding(EdgeInsets(top: five, leading: zero, bottom: five, trailing: zero))
    }
    
    var userImageName : some View{
        HStack(spacing:five){
            if userThumbnailImgArr.count > 0 && userThumbnailImgArr.count - 1 >= randomNumberArr[id-1]{
                if let userThumbNail =  userThumbnailImgArr[randomNumberArr[id-1]]{
                    Image(uiImage: userThumbNail)
                        .shadow(radius: ten)
                        .frame(width: fifty, height: fifty)
                        .clipShape(Circle())
                }}else{
                    ProgressView()
                }
            Text(userDetail.name)
                .foregroundColor(Color.BrandBlue.Base)
            Spacer()
        } // HStack
        .frame(width:UIScreen.main.bounds.width)
        .foregroundColor(Color.BrandBlack.Base)
        .font(.custom(InterBold, size: textSize(textStyle: .title3)))
        .padding(.leading,twenty)
    }
    
    struct UserPostList : View{
        @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
        @Environment(\.viewController) private var viewControllerHolder: UIViewController?
        @State var userPostModel = [UserPostModel]()
        var userViewModel = UserViewModel()
        var userDetail : UserDetailModel
        var id : Int
        @Binding var userThumbnailImgArr : [UIImage]
        @Binding var userPostImgArr : [UIImage]
        @Binding var randomNumberArr : [Int]
        @State var randomNumberPostArr = [Int]()
        
        var body: some View{
            LazyVStack {
                ForEach(0..<userPostModel.count,id: \.self) { index in
                    NavigationLink(destination: UserPostView(id:index+1,userPost : userPostModel[index],userDetail:userDetail,userThumbnailImgArr:$userThumbnailImgArr,userPostImgArr:$userPostImgArr, randomNumberArr: $randomNumberArr, randomNumberPostArr: $randomNumberPostArr, userId: id)){
                        VStack(alignment: .leading,spacing:five) {
                            UserPostImageName(userPostModel: userPostModel[index], userPostImgArr: $userPostImgArr,randomNumberArr: $randomNumberPostArr,id:index)
                        } // VStack
                        .background(Color.BrandWhite.Base)
                        .padding(.top,five)
                    } // NavigationLink
                } // Foreach
            } // LazyVStack
            .padding(.top,five)
            .background(Color.BrandExtraLightBlue.Base)
            .onAppear() {
                if InternetConnectionManager.isConnectedToNetwork(){
                    userViewModel.getUserPost(id:id, completion: { (userPost) in
                        userPostModel = userPost
                        randomNumberPostArr = userViewModel.makeList(30)
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
}

//struct UserDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserDetailView(id: 0)
//    }
//}
