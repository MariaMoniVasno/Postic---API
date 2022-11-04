//
//  SwiftUIViewExtensions.swift
//  PhotoLister
//
//  Created by Trident on 04/11/22.
//

import SwiftUI

struct TextAndImgaeView : View{
    var labelText = EmptyStr
    var imageStr = PhotoOnRectangleAngledSysImg
    var fontText = InterRegular
    var imageColor = Color.BrandLightBlue.Base
    var lblColor = Color.BrandBlack.Base
    var lblFontSize =  UIFont.TextStyle.subheadline
    
    var body: some View{
        HStack {
            Image(systemName: imageStr)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(imageColor)
            Text(labelText)
                .foregroundColor(lblColor)
                .font(.custom(fontText, size: textSize(textStyle: lblFontSize)))
            Spacer()
        } // HStack
        .padding(.leading,25)
    }
}


struct UserListView : View{
    var userDetail : UserDetailModel
    @Binding var userThumbnailImgArr : [UIImage]
    @Binding var randomNumberArr : [Int]
    var id : Int
    
    var body: some View{
        VStack(alignment: .leading,spacing:ten) {
            userImageName
            TextAndImgaeView(labelText: userDetail.email, imageStr: EnvelopeSysImg, fontText: InterRegular,imageColor: Color.BrandLightBlue.Base)
            TextAndImgaeView(labelText: userDetail.phone, imageStr: PhoneSysImg, fontText: InterRegular)
            TextAndImgaeView(labelText: userDetail.website, imageStr: NetworkSysImg, fontText: InterRegular,lblColor:Color.BrandBlue.Base)
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
}

struct NavigationbarIcon : View{
    var imageName = EmptyStr
    var backgrdColor = Color.BrandWhite.Base
    var widthSize = twenty
    var heightSize = twentyFive
    
    var body: some View{
        Image(systemName: imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: widthSize, height: heightSize)
            .foregroundColor(backgrdColor)
            .background(Color.BrandBlue.Base)
    }
}


struct UserPostImageName :  View{
    var userPostModel : UserPostModel
    @Binding var userPostImgArr : [UIImage]
    var navigationTitleNameStr = EmptyStr
    @Binding var randomNumberArr : [Int]
    var id : Int
    var lblColor = Color.BrandBlack.Base
    var lblFontSize =  UIFont.TextStyle.body
    var fontText = InterBold
    
    var body: some View{
        VStack(spacing:ten){
            HStack{
                Spacer()
                Text(ViewPost)
                    .frame(height: navigationTitleNameStr.contains(Posts) ? zero : forty)
                    .foregroundColor(navigationTitleNameStr.contains(Posts) ? Color.BrandWhite.Base : Color.BrandBlack.Base)
                    .font(.custom(InterItalic, size: textSize(textStyle: .footnote)))
                    .padding(.trailing,twenty)
            } // HStack
            HStack{
                Text(userPostModel.title)
                    .frame(alignment: .leading)
                    .lineLimit(nil)
                    .foregroundColor(lblColor)
                    .font(.custom(fontText, size:  textSize(textStyle: lblFontSize)))
                    .padding(.leading,twenty)
                Spacer()
            } // HStack
            .frame(width:UIScreen.main.bounds.width)
            if userPostImgArr.count > 0 && userPostImgArr.count - 1 >= randomNumberArr[id]{
                if let userPost =  userPostImgArr[randomNumberArr[id]]{
                    Image(uiImage: userPost)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:UIScreen.main.bounds.width-40)
                }}else{
                    ProgressView()
                }
        } // VStack
        .frame(width:UIScreen.main.bounds.width)
        .foregroundColor(Color.BrandBlack.Base)
        .font(.custom(InterBold, size: textSize(textStyle: .title2)))
        .background(Color.BrandWhite.Base)
        .padding(.bottom,ten)
    }
}

