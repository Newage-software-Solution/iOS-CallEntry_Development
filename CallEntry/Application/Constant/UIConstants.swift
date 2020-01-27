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
    
    static let allowedUsers = ["admin", "siva"] //manager, salesman
    static let usersPassword = ["admin", "fsl123"] //manager, salesman
    
        
//     "yyyy-MM-dd'T'HH:mm:ssZ"
//    2017-08-08 05:19:05 +0000
//    "yyyy-MM-dd HH:mm:ssZ"
    
    //MARK:- Api Hit Flag -
    struct ServerApiHitFlag {
        
        //User Account
        static let submitLoginDetails: Bool = true
        static let forgotPassword: Bool = true
        static let changePassword: Bool = true
        static let logout: Bool = true

        //Common
        static let masterData: Bool = true
        static let portData: Bool = true

        //Dashboard
        static let salesManList: Bool = true

        //Summary
        static let updateSummary: Bool = true

        //Call Entry
        static let callEntryList: Bool = true
        static let newCallEntry: Bool = true
        static let updateCallEntry: Bool = true
        static let preCallPlannerList: Bool = true

        //Customer
        static let shipmentList: Bool = true
        static let customerList: Bool = true
        static let newCustomer: Bool = true
        static let updateCustomer: Bool = true

        //Potential Business
        static let selectPotentialBusinessList: Bool = false
        static let updatePotentialBusiness: Bool = true
        static let newPotentialBusiness: Bool = true

    }
    
    struct UserDefaultKey {
        
        static let userInfo = "LoggedUserInfo"
        static let rememberedUserInfo = "RememberedUserInfo"
        static let today = "Today"
        static let highScore = "HighScore"
        static let date = "Date"
        static let lastmodifiedDate = "lastmodified"

    }
    
}

enum DateFormatString: String {
    case serverFormat = "dd/MM/yy"
}

enum UserType: String {

    case salesManager
    case salesMan
}

enum StoryBoardID: String {
    
    case userAccount = "UserAccount"
    case sideMenu = "SideMenu"
    case callEntry = "CallEntry"
    case summary = "Summary"
    case customer = "Customer"
    case potentialBusiness = "PotentialBusiness"
    case dashboard = "Dashboard"
    case salesmeet = "Salesmeet"
}

enum ViewControllerID: String {
    
    //UserAccount
    case loginViewController = "LoginViewControllerID"
    case profileViewController = "ProfileViewControllerID"
    case forgorPasswordViewController = "ForgotPasswordViewControllerID"
    case changePasswordViewController = "ChangePasswordViewControllerID"
    
    //SideMenu
    
    //CallEntry
    case callEntryDetailViewController = "CallEntryDetailViewControllerID"
    case newCallEntryViewController = "NewCallEntryViewControllerID"
    case preCallPlannerListViewController = "PreCallPlannerListViewControllerID"
    case callHistoryListViewController = "CallHistoryListViewControllerID"
    
    //Summary
    case newSummaryViewController = "NewSummaryViewControllerID"

    //Customer
    case customerListViewController = "CustomerListViewControllerID"
    case newCustomerViewController = "NewCustomerViewControllerID"
    case customerDetailViewController = "CustomerDetailViewControllerID"
    
    //Salesmeet
    case salesmeetItemsViewController = "SalesmeetItemsViewControllerID"
    case SalesmeetDetailViewController = "SalesmeetDetailViewControllerID"
    case listViewController = "ListViewControllerID"

    //Potential Business
    case newPotentialBusinessViewController = "NewPotentialBusinessViewControllerID"
    case potentialBusinessDetailViewController = "PotentialBusinessDetailViewControllerID"
    case selectPotentialBusinessViewController = "SelectPotentialBusinessViewControllerID"

    //Dashboard
    case dashboardViewController = "DashboardViewControllerID"
    case filterViewController = "FilterViewControllerID"
    case showAllCallListViewController = "ShowAllCallListViewControllerID"
    case shipmentHistoryListViewController = "ShipmentHistoryListViewControllerID"

    //RootViewController
    case navigationController = "NavigationControllerID"
    case joinCallViewController = "JoinCallViewControllerID"
}


enum CollectionViewCellID: String {
    
    //Module Name
    case collectionViewCell = "CollectionViewCellID"
   
}

enum CollectionReusableViewCellID: String {
    
    //Module Name
    case collectionViewReusableCell = "CollectionViewReusableCellID"
}

enum TableViewCellID: String {
    
    //Dashboard Name
    case dashboardLineChartTableViewCell = "DashboardLineChartTableViewCellID"
    case dashboardTableViewCell = "DashboardTableViewCellID"

    //Call Entry
    case followUpListTableViewCell = "FollowUpListTableViewCellID"
    case callHistoryTableViewCell = "CallHistoryTableViewCellID"
    case customerListTableViewCell = "CustomerListTableViewCellID"
    
    //Customer
    case customerInfoTableViewCell = "CustomerInfoTableViewCellID"
    //Summary
    case summaryFooterTableViewCell = "SummaryFooterTableViewCellID"
}

enum UserDefaultKey : String {
    case authenticationToken = "authToken"
}

enum AvenirFont: String {
    case avenirRoman = "Avenir-Roman"
}

enum NotificationCenterKey: String {
    case sideMenuOptions = "SideMenuAction"
}

enum DashboardListSegment: String {
    case none = "None"
    case lineChart = "LINE CHART"
    case overDueCalls = "OVERDUE CALLS"
    case todayCalls = "TODAY'S CALLS"
    case upcomingCalls = "UPCOMING CALLS"
}

struct Agenda {
    static let day1 = "\tAgenda:\t Welcome Note and Opening\n" +
        "\tPresenter:\t Manish Malik\n" +
        "\tTiming\t: 9:00 AM - 9:15 AM\n\n" +
        "\tAgenda:\t FSL Future Vision\n" +
        "\tPresenter:\t Jonathan Phillips\n" +
        "\tTiming:\t 9:15 AM - 9:30 AM\n\n" +
        "\tAgenda:\t Logex - Updates and Vision\n" +
        "\tPresenter:\t Manu Raj Bhalla\n" +
        "\tTiming:\t 9:30 AM - 10:00 AM\n\n" +
        "\tAgenda:\t Frescon and Automation\n" +
        "\tPresenter:\t Nishant Chawla\n" +
        "\tTiming:\t 10:00 AM - 11:00 AM\n\n" +
        "\tTEA BREAK\n" +
        "\tTiming:\t 11:00 AM - 11:20 AM\n\n" +
        "\tAgenda:\t Customer Service Initiatives\n" +
        "\tPresenter:\t CS Team\n" +
        "\tTiming:\t 11:20 AM - 12:00 PM\n\n" +
        "\tAgenda:\t Building the Culture\n" +
        "\tPresenter:\t Pooja Dogra\n" +
        "\tTiming:\t 12:00 PM - 01:00 PM\n\n" +
        "\tLUNCH BREAK\n" +
        "\tTiming:\t 01:00 PM - 01:45 PM\n\n" +
        "\tAgenda:\t China & Hong Kong - India Way Forward\n" +
        "\tPresenter:\t George Zhao & Pancham Kumar Rajdeo\n" +
        "\tTiming:\t 01:45 PM - 02:30 PM\n\n" +
        "\tAgenda:\t Bangladesh Vision\n" +
        "\tPresenter:\t Kazi Anjum\n" +
        "\tTiming:\t 02:30 PM - 03:00 PM\n\n" +
        "\tAgenda:\t Ocean Pricing Initiatives\n" +
        "\tPresenter:\t Pricing Team\n" +
        "\tTiming:\t 03:00 PM - 03:30 PM\n\n" +
        "\tTEA BREAK\n" +
        "\tTiming:\t 03:30 PM - 03:45 PM\n\n" +
        "\tAgenda:\t Customs Brokerage Update & Vision\n" +
        "\tPresenter:\t Amit Dasgupta / Satish Jadhav & Subeer Oberoi\n" +
        "\tTiming:\t 03:45 PM - 04:15 PM\n\n" +
        "\tAgenda:\t UK - India Way Forward\n" +
        "\tPresenter:\t Swapan Saha\n" +
        "\tTiming:\t 04:15 PM - 04:45 PM\n\n" +
        "\tAgenda:\t Proceed to Baga Beach\n" +
        "\tTiming:\t 07:15 PM\n\n" +
        "\tAgenda:\t Cocktail Snacks and Dinner at St. Anthony's, Baga Beach\n" +
    "\tTiming:\t 08:00 PM Onwards\n\n"
    static let day2 = "\tAgenda:\t Town Hall\n" +
        "\tPresenter:\t Open House\n" +
        "\tTiming\t: 9:00 AM - 10:20 AM\n\n" +
        "\tAgenda:\t Regional Presentations\n" +
        "\tPresenter:\t West Region\n" +
        "\tTiming:\t 10:20 AM - 11:00 AM\n\n" +
        "\tAgenda:\t Regional Presentations\n" +
        "\tPresenter:\t North & East Regions\n" +
        "\tTiming:\t 11:00 AM - 11:40 AM\n\n" +
        "\tTEA BREAK\n" +
        "\tTiming:\t 11:40 AM - 12:00 PM\n\n" +
        "\tAgenda:\t Regional Presentations\n" +
        "\tPresenter:\t South Region\n" +
        "\tTiming:\t 12:00 PM - 12:40 PM\n\n" +
        "\tAgenda:\t HR Initiatives and Way Forward\n" +
        "\tPresenter:\t Sahana Puthran & Swaranjeet Singh\n" +
        "\tTiming:\t 12:40 PM - 01:00 PM\n\n" +
        "\tLUNCH BREAK\n" +
        "\tTiming:\t 01:00 PM - 01:45 PM\n\n" +
        "\tAgenda:\t Legal (General Average)\n" +
        "\tPresenter:\t Navin K\n" +
        "\tTiming:\t 01:45 PM - 02:15 PM\n\n" +
        "\tAgenda:\t India - Sri Lanka Way Forward\n" +
        "\tPresenter:\t Chameen T & Diluka Mendis\n" +
        "\tTiming:\t 02:15 PM - 02:45 PM\n\n" +
        "\tAgenda:\t Sales Awards\n" +
        "\tTiming:\t 02:45 PM - 03:15 PM\n\n" +
        "\tAgenda:\t Closing - ISM 2019\n" +
        "\tPresenter:\t Jonathan Phillips\n" +
        "\tTiming:\t 03:15 PM - 03:30 PM\n\n" +
        "\tTEA BREAK\n" +
        "\tTiming:\t 03:30 PM - 03:45 PM\n\n" +
        "\tAgenda:\t Group Photograph\n" +
        "\tTiming:\t 03:45 - 04:00 PM\n\n" +
        "\tAgenda:\t Team Building Games & Activity\n" +
        "\tPresenter:\t Pooja Dogra & Team\n" +
        "\tTiming:\t  04:00 - 05:30 PM\n\n" +
        "\tAgenda:\t Gala Dinner\n" +
    "\tTiming:\t 07:30 PM Onwards\n\n"
}

struct Travel {
    static let arrival = "Flight No : " + "SG 8171"+"\n"
        + "Date : " + " 28-FEB-19"+"\n"
        + "ETD : " + "11:25"+"\n"
        + "ETA : " + "14:05"
    static let departure = "Flight No : " + "6E 332 \n"
        + "Date : " + "03-MAR-19 \n"
        + "ETD : " + "14:10"
}

struct OrganisationInformation {
    static let about = "We are glad to host our upcoming Sales Meet 2019 at Goa. " +
        "Look forward for an enthusiastic participation and hope to make this meeting another success story. " +
    "\n\nParticipating Countries:\n1. India\n2. Sri Lanka\n3. Bangladesh\n4. China\n5. United Kingdom "
    static let indiaSalesmeet2018 = "India Sales Meet 2018:\n\n " +
        "\tCelebrating 30 years of service Excellence, Freight Systems (India) Pvt. Ltd. held its biggest event of the year - Annual Sales Meet (2017 – 18) at The Lalit, Jaipur.  It was marvelous to see the All India Sales team & CS Managers together at an exhilarating event with close to 90 co -workers from different parts of the country and Sales & Country heads from, China, USA, Bangladesh, Colombo & Nepal attending the event.  The event was hosted by our CEO - Manish Malik with an objective to encourage “Sales Champions to perform to the best and to recognize the talent of co-workers who make up this strong & diverse entity FSL.” It was a two-day packed agenda with emphasis laid on fun based learning along with customer initiatives with case studies.\n\n" +
        "\tThe Celebration of 30 years was graced by a powerful and motivating speech of Mr.  David Phillips the founder and Managing Director of Freight Systems. Mr. Phillips truly a strong mentor, reminded the young generation that change is inevitable and it’s time to show renewed vigor. Mr. Phillips further said “People are our strength and we believe in nurturing Team Work.”\n\n" +
        "\tMr. Jon Phillips COO of Freight Systems in his key note address to attendees of the Annual Meet highlighted achievements of FSL over the years and mentioned it to be an interesting year on all fronts.  He also highlighted some of FSL’s new technology initiatives that will help FSL to differentiate from competition.\n\n" +
        "\tThe Gala Evening celebrations were kicked off by a cake cutting ceremony by the promoters and the India core management team, followed by excellent cocktails and dinner.”\n\n" +
        "\tThe event brought together the entire FSL Sales Teams & CS Managers for the glittering awards ceremony acknowledging the star performers of respective regions for the year 2017.”\n\n" +
        "\tThe highlight of the evening was the spectacular dance performances by FSL’s talented teams from different regions who also competed for the best dance performance.”\n\n" +
        "\tAnnual Sales Meet was very informative and appreciated by all the members of Freight Systems Family.”\n\n" +
    "\tFSL look forward to hosting more such events in the coming year across the nation as well as across the FSL World to celebrate the victories, strategize on the challenges, dwell on new opportunities, recognize key performers and encourage team work and camaraderie.”\n\n\n\n"
    
    static let indiaSalesmeet2017 = "India Sales Meet 2017:\n\n " +
        "\tDate: 2nd & 3rd March 2017\n " +
        "\tVenue: Goa\n\n" +
        "\tAnnual Sales Meet is the Flagship event of Freight Systems India.\n\n " +
        "\tOur very First offsite meet was hosted at Double Tree – Hilton at Goa in March 2017 under the strong leadership of – Manish Malik.\n\n " +
        "\tThe 2 days session was designed to inspire and empower participants to dream bigger, perform better, be more innovative ,think differently and attain the lifestyle they desire and deserve. The main goal of hosting this event  in India was to groom our  Sales force to make them successful by transforming their lives making them more confident by applying the right strategies, skills and tools.\n\n " +
    "\tOver 84 Sales & Customer Service Professionals came from different parts of India and we also had Sales heads joining in from Nepal & Srilanka.\n\n "
}

struct NeedAssistance {
    static let travelCoordinatorContact = "North Region:\nName: Manish Gulati\nMobile: 9873422252 \n\n" +
        "West Region:\nName: Tarun Kapoor\nMobile: 9820396546 \n\n" +
        "South Region:\nName: Mohamed Riaz\nMobile: 9500112666 \n\n" +
    "International:\nName: Swaranjeet Singh\nMobile: 9911558848 \n\n"
    static let hotelCoordinatorContact = "Name: Swaranjeet Singh\nMobile: 9911558848 \n\n" +
    "Name: Rakesh Prasad\nMobile: 9811800387 \n\n"
    static let eventCoordinatorContact = "Name: Manish Malik\nMobile: 9899109718 \n\n" +
        "Name: Jitendra Vijan\nMobile: 9867521501 \n\n" +
        "Name: Shiny Varghese\nMobile: 9967514669 \n\n" +
        "Name: Vinod Alex\nMobile: 9962548130 \n\n" +
        "Name: Manish Gulati\nMobile: 9873422252 \n\n" +
        "Name: Sahana Puthran\nMobile: 9920054432 \n\n" +
        "Name: Rakesh Prasad\nMobile: 9811800387 \n\n" +
    "Name: Swaranjeet Singh\nMobile: 9911558848 \n\n"
    static let emailHelpdesk = "If you need assistance, Kindly write a mail to swaranjeet.indel@freightsystems.com"
}

struct DressCode {
    static let day1 = "Date: 01-Mar-19\n" + "Conference: Smart Casuals\n" + "Evening: Comfortable Casuals\n"
    static let day2 = "Date: 02-Mar-19\n" + "Conference: Smart Casuals\n" + "Evening: Party Wear\n"
}

struct Stay_Venue {
    static let roomDetails = "Stay: Hyatt Centric, Goa \nRoom Type: "+"No Record found"+"\n\n" + "** Allotment of room will be on arrival"
    static let eventDetails = "Day 1:\nDate: 01-Mar-19\n" +
        "Conference: 09:00 AM to 05:00 PM\n" +
        "Evening Party: 08:00 PM Onwards\n\n" +
        "Day 2:\nDate: 02-Mar-19\n" +
        "Conference: 09:00 AM to 05:00 PM\n" +
    "Gala Night: 07:30 PM Onwards\n"
    static let venueDetails = "Stay: Hyatt Centric, Goa \n\n"+"Day 1:\nDate: 01-Mar-19\n" +
        "Breakfast: Grok Restaurant (Hotel Premises)\n" +
        "Lunch: Jade Vine 1 & 2\n" +
        "Dinner: Cocktail Dinner \n\n" +
        "Day 2:\nDate: 02-Mar-19\n" +
        "Breakfast: Grok Restaurant (Hotel Premises)\n" +
        "Lunch: Jade Vine 1 & 2\n" +
        "Dinner: Gala Night, Jade Vine 1 & 2 \n\n" +
        "Day 3:\nDate: 03-Mar-19\n" +
    "Breakfast: Grok Restaurant (Hotel Premises)\n"
    static let hotelAmenties = "\t•  All rooms have a sofa cum sleeper bed\n" +
        "\t•  Hyatt Plug-Panel\n" +
        "\t•  Swivel flat screen HDTV\n" +
        "\t•  Tea & coffee maker\n" +
        "\t•  Individual control air-conditioning\n" +
        "\t•  Hairdryer\n" +
        "\t•  Iron/ironing board\n" +
        "\t•  Mini-fridge\n" +
        "\t•  In-room safe\n\n" +
        "Pool:\n" +
        "\t•  Outdoor pool and bar\n" +
        "\t•  Time: 8 AM to 7 Pm\n\n" +
        "24/7 Fitness Center:\n" +
        "\t•  24-hour access to cardio machines, freeweights and the latest equipment.\n\n" +
        "Entertainment Zone:\n" +
        "\t•  Play-area with organized games and activities organized daily, for kids and adults\n\n" +
        "Sightseeing:\n" +
        "\t•  Baga Beach – 4 kms \n" +
        "\t•  Candolim Beach– 1.5 kms \n" +
        "\t•  Fort Aguada – 3.9 kms \n" +
        "\t•  Grande Island & Monkey Beach (pick up from Sinquerim Beach) – 4 kms \n" +
        "\t•  Fontainhas – 14 kms \n" +
        "\t•  Old Goa – 22 kms\n\n" +
        "Shopping:\n" +
        "\t•  Candolim Beach Road – 1.5 kms \n" +
        "\t•  Fort Aguada – 3.9 kms \n" +
        "\t•  Panjim Market – 16 kms \n" +
        "\t•  Anjuna Flea Market – 8 kms \n" +
        "\t•  Mapuca Market – 9.3 kms \n" +
        "\t•  Saturday Arpora Night Market – 4.4 kms \n" +
    "\t•  Mall de Goa – 9 kms\n\n\n\n"
    
}


