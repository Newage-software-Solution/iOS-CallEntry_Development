//
//  APIConstants.swift
//  FrieghtSystem
//
//  Created by Susena on 12/04/17.
//  Copyright © 2017 Hakunamatata solution (P) Ltd. All rights reserved.
//

import UIKit

class APIConstants: NSObject {
    
    enum urlContstant : String {
       
        //User Accounts
        case login                        = "login"
        case signUp                       = "signup"
        case forgotPassword               = "forgotpassword"
        case changePassword               = "changepassword"
        
        // Side Menu
        case getProfileInfo               = "profileinfo"       // Get
        case updateProfileInfo            = "profileinfo?profileid="       //  Update
        case getSettingsInfo              = "settingsinfo"      // Get
        case updateSettingsInfo           = "settingsinfo?userid="      // Update
        case getClubInfo                  = "clubinfo"          // Get
        case deactivateAccount            = "deactivateaccount" // Get

        //Home Group
        
        case getLocationList              = "location/list"
        case getTeamList                  = "team/list?locationid="
        case getInfoList                  = "info/list" //?type=&teamid=&clubid=    // Get - type - All, Team, Club
        
        case getFeedList                  = "feed/list" //?type=&teamid=&clubid=    // Get - type - All, Team, Club
        case getFeedDetail                = "feed?feedid=" // Get Update
        case postTeamFeed                 = "feed"
        
        case getEventList                  = "event/list" //?type=&teamid=&clubid=    // Get - type - All, Team, Club
        
        case getChatHistory                = "chathistory?userid=&chatid="    // Get -
        case sendChatMessage               = "sendmessage?userid=&chatid="

        //Poll
        case getPollList                  = "poll/list"
        case getPollDetail                = "poll?pollid=" // Respond and Get
        
        //Abscence Request
        case getAbscenceRequestList       = "abscencerequest/list"
        case getAbscenceRequestDetail     = "abscencerequest?abscencerequestid="
        case addAbscenceRequest           = "abscencerequest"  // Add

        //Injury Report
        case getInjuryReportList          = "injuryreport/list"
        case getInjuryReportDetail        = "injuryreport?injuryreportid="
        case createNewInjuryReport        = "injuryreport"  // Add
        case mailInjuryReport             = "injuryreport/sendmail?injuryreportid="
        
        //Calendar
        case filterEvents                  = "event/filter"
        case getEventDetail                = "event?eventid="
        case addTeamTraining               = "event"
        case getAthleteList                = "athlete/list"
        case getAttendanceList             = "event/attendance/list?eventid="
        case recordAttendance              = "event/attendance?eventid="
        
        //Document
        case getDocumentList              = "document/list"
        case getDocumentDetail            = "document?documentid="
        
        //Music
        case getMusicList                 = "music/list"
    }
    

    
    // Stage Server
    let baseUrl = "http://www.outlawsedge.com/" //1.0
    
    // Live Server
    //  let baseUrl =
 
    
    
    func getBaseUrl(urlString : urlContstant) -> String{
        
        return "\(baseUrl)"
    }
    
    func getUrl(urlString : urlContstant) -> String{
        return "\(baseUrl)\(urlString.rawValue)"
    }
    
}


