//
//  DefualtAlertView.swift
//  PhotoLister
//
//  Created by Trident on 02/11/22.
//

import Foundation
import SwiftUI

/*
 DefaultAlertView --> Default SwiftUI AlertView (No customization)
 Parameters : alertPrimaryMessage --> Title
 alertSecondaryMessage --> SubTitle
 alertDismissTxt --> Dismiss Text i.e., OK
 viewControllerHolder --> Which presents the view over on the screen
 */

struct DefaultAlertViewWithSingleButton: View {
    @State private var isLoading = true
    @State var alertTitleMessage : String
    @State var alertMessage : String
    @State var alertPrimaryDismissTxt : String
    
    var body: some View {
        Text(EmptyStr)
            .modifier(AlertWithSingleButton(isPresented: $isLoading, alertTitleMsg: $alertTitleMessage, alertMsg: $alertMessage, alertPrimaryDismissTxt: $alertPrimaryDismissTxt))
    }
    struct AlertWithSingleButton: ViewModifier {
        @Binding var isPresented: Bool
        @Binding var alertTitleMsg : String
        @Binding var alertMsg : String
        @Binding var alertPrimaryDismissTxt : String
        
        @Environment(\.viewController) private var viewControllerHolder: UIViewController?
        
        func body(content: Content) -> some View {
            content
                .alert(isPresented: $isPresented) {
                    Alert(title: Text(alertTitleMsg)
                          , message: Text(alertMsg),
                          dismissButton: .default (Text(alertPrimaryDismissTxt)) {
                            isPresented = true
                            self.viewControllerHolder?.dismiss(animated: true, completion: nil)
                          })
                }
        }
    }
}
