//
//  UIConstants.swift
//  FrieghtSystem
//
//  Created by Susena on 12/04/17.
//  Copyright © 2017 Hakunamatata solution (P) Ltd. All rights reserved.
//

//TODO:
import UIKit

class UIConstants: NSObject {
    
    static let appVersionNo = "v1.0"
    static let themeColor = UIColor(hex: "9999FF").withAlphaComponent(1)
    
//     "yyyy-MM-dd'T'HH:mm:ssZ"
//    2017-08-08 05:19:05 +0000
//    "yyyy-MM-dd HH:mm:ssZ"
    
    //MARK:- Api Hit Flag -
    
    struct ChatCellConstant {
        //Incoming Cell Constant
        static let bubbleViewLeadingValue: CGFloat = 71.0
        static let bubbleViewTrailingValue: CGFloat = 36.0
        static let bubbleViewTopValue: CGFloat = 25.0
        static let bubbleViewBottomValue: CGFloat = 5.0
        
        static let msgLblLeadingValue: CGFloat = 12.0
        static let msgLblTrailingValue: CGFloat = 18.0
        static let msgLblTopValue: CGFloat = 8.0
        static let msgLblBottomValue: CGFloat = 13.0
        
        static let timeLblBottomValue: CGFloat = 7.0
        static let timeLblHeightValue: CGFloat = 14.0
        
        static let minimumBubbleViewWidth: CGFloat = 77.0
        static let minimumBubbleViewHeight: CGFloat = 42.0

    
        //Outgoing Cell Constant
        static let bubbleViewLeadingValue1: CGFloat = 36.0
        static let bubbleViewTrailingValue1: CGFloat = 71.0
        static let bubbleViewTopValue1: CGFloat = 25.0
        static let bubbleViewBottomValue1: CGFloat = 5.0
        
        static let msgLblLeadingValue1: CGFloat = 18.0
        static let msgLblTrailingValue1: CGFloat = 12.0
        static let msgLblTopValue1: CGFloat = 8.0
        static let msgLblBottomValue1: CGFloat = 13.0
        
        static let timeLblBottomValue1: CGFloat = 7.0
        static let timeLblHeightValue1: CGFloat = 14.0
        
        static let minimumBubbleViewWidth1: CGFloat = 77.0
        static let minimumBubbleViewHeight1: CGFloat = 42.0
        
        //Incoming ImageCell Constant
        static let bubbleViewLeadingValue_img: CGFloat = 71.0
        static let bubbleViewTrailingValue_img: CGFloat = 36.0
        static let bubbleViewTopValue_img: CGFloat = 25.0
        static let bubbleViewBottomValue_img: CGFloat = 5.0
        
        static let groupImgViewLeadingValue_img: CGFloat = 5.0
        static let groupImgViewTrailingValue_img: CGFloat = 5.0
        static let groupImgViewTopValue_img: CGFloat = 5.0
        
        static let captionMsgLblLeadingValue_img: CGFloat = 11.0
        static let captionMsgLblTrailingValue_img: CGFloat = 18.0
        static let captionMsgLblTopValue_img: CGFloat = 8.0
        static let captionMsgLblBottomValue_img: CGFloat = 14.5
        
        static let timeLblBottomValue_img: CGFloat = 9.0
        static let timeLblHeightValue_img: CGFloat = 14.0
        
        //Outgoing ImageCell Constant
        static let bubbleViewLeadingValue_img1: CGFloat = 36.0
        static let bubbleViewTrailingValue_img1: CGFloat = 71.0
        static let bubbleViewTopValue_img1: CGFloat = 25.0
        static let bubbleViewBottomValue_img1: CGFloat = 5.0
        
        static let groupImgViewLeadingValue_img1: CGFloat = 5.0
        static let groupImgViewTrailingValue_img1: CGFloat = 5.0
        static let groupImgViewTopValue_img1: CGFloat = 5.0
        
        static let captionMsgLblLeadingValue_img1: CGFloat = 11.0
        static let captionMsgLblTrailingValue_img1: CGFloat = 18.0
        static let captionMsgLblTopValue_img1: CGFloat = 8.0
        static let captionMsgLblBottomValue_img1: CGFloat = 14.5
        
        static let timeLblBottomValue_img1: CGFloat = 9.0
        static let timeLblHeightValue_img1: CGFloat = 14.0
        
    }
    
    struct ServerApiHitFlag {
        
        //User Account
        static let submitLoginDetails: Bool = false
       
        //Feed
        static let getFeedList: Bool = false
        static let getFeedDetails: Bool = false
        static let postFeed: Bool = false
        static let postFeedComment: Bool = false
        
        //Event
        static let getEventList: Bool = false
        
        //Home Group
        static let getInfoList: Bool = false
        static let getLocationlist: Bool = false
        static let getTeamList: Bool = false

        //Club Indo
        static let getClubInfo:Bool = false
    }
    
    struct UserDefault {
        
        static let userInfo = "LoggedUserInfo"
        
        
    }
    
    
    //MARK:- User Accounts 
    
    
    //MARK:- ContactViewController
    
    struct ContactViewControllerStringConstant {
        
        static let coachButtonText = "+ Add Emergency"
        static let athleteButtonText = "+ Add Parent and Emergency"

        static let coachLabelText = "You can add 2 emergency Contact."
        static let athleteLabelText = "You can add 2 Parents contact and 2 emergency Contact."
    }
    
}

enum UserType: String {

    case athlete
    case parent
    case coach
    case receptionist
}

enum StoryBoardID: String {
    
    case userAccount = "UserAccounts"
    case sideMenu = "SideMenu"
    case home = "Home"
    case notification = "Notification"
    case music = "Music"
    case document = "Document"
    case poll   =   "Poll"
    case walkThrough = "WalkThrough"
    case event = "Events"
    case calendar = "Calendar"
    case injuryReport = "InjuryReport"
    case abscenceRequest = "Abscence"
    case menuOption = "MenuOptions"
    case feed = "Feeds"
    case chat = "Chat"
}

enum ViewControllerID: String {
    
    //Walkthrough
    case walkThroughtViewController = "WalkthroughViewControllerID"
    case pageViewController =  "PageViewControllerID"
    
    //RootViewController
    case navigationController = "NavigationControllerID"
   
    //Poll
    case pollListViewController = "PollListViewControllerID"
    case pollDetailViewController = "PollDetailViewControllerID"
    case pollResultViewController = "PollResultViewControllerID"

    //Calendar
    case monthlyCalendarViewCntroller = "MonthlyCalendarListViewControllerID"
    case weeklyCalendarListViewController = "WeeklyCalendarListViewControllerID"

    //Notification
    case notificationListViewController = "NotificationListViewControllerID"
    
    //InjuryReport
    case injuryReportListViewController = "InjuryReportListViewControllerID"

    //Abscence Request
    case abscenceRequestListViewController = "AbscenceRequestListViewControllerID"

    //Events
    case eventListViewController = "EventListViewControllerID"

    //Chat
    case chatListViewController = "ChatListViewControllerID"

    //Home Group
    case groupViewController  = "GroupViewControllerID"
    case infoListViewController = "InfoListViewControllerID"
    case tabBarController = "TabBarControllerID"

    //Document
    case documentListViewController = "DocumentListViewControllerID"

    //Music
    case musicListViewController = "MusicListViewControllerID"
    
    //SideMenu
    case myProfileViewController = "MyProfileViewControllerID"
    case deactivateAccountViewController = "DeactivateAccountViewControllerID"
    
    //AboutTheApp
    case aboutTheAppViewController = "AboutTheAppViewControllerID"
    case staticAboutTheAppViewController = "StaticAboutTheAppViewControllerID"
    
    //Feeds
    case feedListViewController = "FeedListViewControllerID"
    case feedDetailViewController = "FeedDetailViewControllerID"
    case enlargeImageViewController = "EnlargeImageViewControllerID"
    
    //user accounts 
    case loginViewController = "LoginViewControllerID"
    case signupViewCntroller = "SignUpViewControllerID"
    case contactViewControllerID = "ContactViewControllerID"
    case profileViewController = "ProfileViewControllerID"
    case aggrementViewController = "AggrementViewControllerID"
    case signUpSuccessViewController = "SignUpSuccessViewControllerID"
}



enum CollectionViewCellID: String {
    
    //Walkthrough
    case walkthroughCell = "WalkthroughCollectionViewCellID"
    
    //Home
    case homeGroupCell = "HomeGroupCollectionViewCellID"
    
    //Injury
    case cellCollectionTag = "CellCollectionTag"
    
    //Chat
    case msgReceivedCell = "MsgReceivedCollectionViewCellID"
    case msgSendCell = "MsgSendCollectionViewCellID"
    case imageReceivedCell = "ImageReceivedCollectionViewCellID"
    case imageSendCell = "ImageSendCollectionViewCellID"
}

enum CollectionReusableViewCellID: String {

    
    //Chat
    case sectionDateView = "SectionDateHeaderReusableViewID"
    
}

enum TableViewCellID: String {
    
    //Feeds
    case msgFeedCell = "MsgFeedTableViewCellID"
    case videoFeedCell = "VideoFeedTableViewCellID"
    case imageFeedCell = "ImageFeedTableViewCellID"

    case feedCommentCell = "FeedCommentTableViewCellID"
    
    case eventListCell = "EventListTableViewCellID"
    
    //Info List
    case atheleteContactInfo = "CellAtheletContactInfo"
    case coachContactInfo = "CellCoachContactInfo"
    
    //Injury
    case cellTableTag = "CellTableTag"
    
    //UserAccounts
    case cellAgreementContent = "CellAgreementContent"
    
    //SideMenu
    
    //AboutTheApp
    case cellAboutTheAppDetail = "CellAboutTheAppDetail"

}

enum PushNotificationID: String {
    case event = "Event_Detail"
    
}

enum UserDefaultKey : String {
    case authenticationToken = "authToken"
}

enum AvenirFont: String {
    case avenirBlack = "Avenir-Black"
    case avenirBlackOblique = "Avenir-BlackOblique"
    case avenirBook = "Avenir-Book"
    case avenirBookOblique = "Avenir-BookOblique"
    case avenirLight = "Avenir-Light"
    case avenirLightOblique = "Avenir-LightOblique"
    case avenirMedium = "Avenir-Medium"
    case avenirMediumOblique = "Avenir-MediumOblique"
    case avenirOblique = "Avenir-Oblique"
    case avenirRoman = "Avenir-Roman"
}

enum NotificationCenterKey: String {
    case sideMenuOptions = "SideMenuAction"
}


enum defaultImage: String {
    
    case image = "default_imgReview"
}

enum AboutUsURL: String {
    
    case url = "www.subbiesforhire.com.au/how-it-works/"
}

