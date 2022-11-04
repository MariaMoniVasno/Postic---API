//
//  UserPostView.swift
//  PhotoLister
//
//  Created by Trident on 02/11/22.
//

import SwiftUI

struct UserPostView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.viewController) private var viewControllerHolder: UIViewController?
    var id : Int
    var userPost : UserPostModel
    var userDetail : UserDetailModel
    var userViewModel = UserViewModel()
    @State var navigationTitleNameStr = EmptyStr
    @Binding var userThumbnailImgArr : [UIImage]
    @Binding var userPostImgArr : [UIImage]
    @Binding var randomNumberArr : [Int]
    @Binding var randomNumberPostArr : [Int]
    var userId : Int
    
    var body: some View {
        ScrollView {
            VStack(spacing:zero){
                userImageName
                    .background(Color.BrandWhite.Base)
                UserPostImageName(userPostModel: userPost, userPostImgArr: $userPostImgArr,navigationTitleNameStr:navigationTitleNameStr,randomNumberArr:$randomNumberPostArr,id: id-1,lblColor:Color.BrandGray.Base,lblFontSize:UIFont.TextStyle.subheadline,fontText:InterRegular)
                UserPostCommentsList(id:id, userThumbnailImgArr: $userThumbnailImgArr, randomNumberArr: $randomNumberPostArr)
            } // VStack
        } // ScrollView
        .padding(.top,ten)
        .onAppear(){
            navigationTitleNameStr = userDetail.name + " - " + Posts
        }
        .frame(width:UIScreen.main.bounds.width)
        .background(Color.BrandExtraLightBlue.Base)
        .navigationBarTitle(navigationTitleNameStr, displayMode: .inline)
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
    
    var userImageName : some View{
        HStack(spacing:five){
            if userThumbnailImgArr.count > 0 && userThumbnailImgArr.count - 1 >= randomNumberArr[userId-1]{
                if let userThumbNail =  userThumbnailImgArr[randomNumberArr[userId-1]]{
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
        .padding(EdgeInsets(top: five, leading: twenty, bottom: zero, trailing: zero))
    }
    
    
    struct UserPostCommentsList : View{
        @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
        @Environment(\.viewController) private var viewControllerHolder: UIViewController?
        @State var userPostComments = [UserPostCommentsModel]()
        @State var lastApiCallTimeStr = EmptyStr
        @StateObject var updaterViewModel = UpdaterViewModel()
        var userViewModel = UserViewModel()
        var id : Int
        @Binding var userThumbnailImgArr : [UIImage]
        @Binding var randomNumberArr : [Int]
        
        var body: some View{
            LazyVStack {
                HStack{
                    Text("\(Comments) (\(userPostComments.count))")
                        .frame(height: 40)
                        .foregroundColor(Color.BrandBlack.Base)
                        .font(.custom(InterRegular, size: textSize(textStyle: .body)))
                        .padding(.leading,twenty)
                    Spacer()
                    HStack{
                        Text("\(updaterViewModel.timeStr)")
                            .frame(height: 15)
                            .foregroundColor(Color.BrandBlack.Base)
                            .font(.custom(InterItalic, size: textSize(textStyle: .caption1)))
                            .padding(.leading,twenty)
                        Image(systemName: ArrowTriangleTwoCirclePathSysImg)
                            .aspectRatio(contentMode: .fit)
                            .frame(width:20,height: 20)
                            .foregroundColor(Color.BrandBlack.Base)
                            .onTapGesture {
                                if InternetConnectionManager.isConnectedToNetwork(){
                                    getPostCommentsApi()
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
                    } // HStack
                    .padding(.trailing,twenty)
                } // HStack
                CommentsList(userPostComments:$userPostComments,userThumbnailImgArr:$userThumbnailImgArr, randomNumberArr: $randomNumberArr, id: id)
            } // LazyVStack
            .padding(.top,five)
            .background(Color.BrandExtraLightBlue.Base)
            .frame(width:UIScreen.main.bounds.width)
            .frame(width:UIScreen.main.bounds.width)
            .onAppear() {
                getPostCommentsApi()
            }
        }
        
        struct CommentsList : View{
            @Binding var userPostComments : [UserPostCommentsModel]
            @Binding var userThumbnailImgArr : [UIImage]
            @Binding var randomNumberArr : [Int]
            var id : Int
            
            var body: some View{
                ForEach(0..<userPostComments.count,id: \.self) { index in
                    VStack(alignment: .leading,spacing:ten) {
                        UserCommentListView(userPostComment: userPostComments[index],userThumbnailImgArr:$userThumbnailImgArr,randomNumberArr:$randomNumberArr, id: index)
                    } // VStack
                    .background(Color.BrandWhite.Base)
                    .padding(.top,five)
                } // Foreach
            }
        }
        
        func getPostCommentsApi(){
            if InternetConnectionManager.isConnectedToNetwork(){
                userViewModel.getUserPostComments(id:id,completion: { (comments) in
                    userPostComments = comments
                    DispatchQueue.main.async {
                        UserDefaultsStore.saveRefreshDate = Date()
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
    
    struct UserCommentListView : View{
        var userPostComment : UserPostCommentsModel
        @Binding var userThumbnailImgArr : [UIImage]
        @Binding var randomNumberArr : [Int]
        var id : Int
        
        var body: some View{
            VStack(alignment: .leading,spacing:ten) {
                userImageName
                TextAndImgaeView(labelText: userPostComment.email, imageStr: EnvelopeSysImg, fontText: InterItalic,imageColor: Color.BrandLightBlue.Base,lblFontSize:UIFont.TextStyle.footnote)
                HStack {
                    VStack{
                        Image(systemName: MessageSysImg)
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(Color.BrandLightBlue.Base)
                        Spacer()
                    } // VStack
                    Text(userPostComment.body)
                        .foregroundColor(Color.BrandGray.Base)
                        .font(.custom(InterRegular, size: textSize(textStyle: .subheadline)))
                    Spacer()
                } // HStack
                .padding(.leading,25)
            } // VStack
            .padding()
            .frame(width:UIScreen.main.bounds.width)
        }
        
        var userImageName : some View{
            HStack(spacing:five){
                if userThumbnailImgArr.count > 0 && userThumbnailImgArr.count - 1 >= randomNumberArr[id]{
                    if let userThumbNail =  userThumbnailImgArr[randomNumberArr[id]]{
                        Image(uiImage: userThumbNail)
                            .shadow(radius: ten)
                            .frame(width: forty, height: forty)
                            .clipShape(Circle())
                    }}else{
                        ProgressView()
                    }
                Text(userPostComment.name)
                    .foregroundColor(Color.BrandBlack.Base)
                    .font(.custom(InterBold, size: textSize(textStyle: .body)))
                Spacer()
            } // HStack
            .frame(width:UIScreen.main.bounds.width)
            .padding(.leading,twenty)
        }
    }
    
    
}



//struct UserPostView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserPostView(id:0)
//    }
//}

