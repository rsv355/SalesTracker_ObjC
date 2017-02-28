//
//  App_Constant.h
//  SalesTracker
//
//  Created by Masum Chauhan on 08/11/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#ifndef App_Constant_h
#define App_Constant_h

#define DEVICE_TYPE @"IOS"


/*   USER PROFILE ROLE ID   */

#define MARKETER_ROLE_ID @"9"

#define AAS_ROLE_ID @"7"

#define HOS_ROLE_ID @"6"

#define BM_ROLE_ID @"5"

#define RM_ROLE_ID @"4"

/*   USER PROFILE POSITION NAME   */

#define MARKETER_POSITION_NAME @"Marketer"

#define AAS_POSITION_NAME @"AAS"

#define HOS_POSITION_NAME @"HOS"

#define BM_POSITION_NAME @"BM"

#define RM_POSITION_NAME @"RM"


/*   USER PROFILE POSITION NAME   */



/* MARKETER PROFILE ARRAY */

#define NAME_ARRAY @{@"" : @""}
#define MARKETER_DASHBOARD_ARRAY @[@{@"Title" : @"Agents", @"Icon_Name" : @"ic_agent.png", @"Identifier" : @"AGENT", @"Colour_Status" : @"0"}, @{@"Title" : @"Contacts", @"Icon_Name" : @"ic_pick_contact.png", @"Identifier" : @"CONTACTS", @"Colour_Status" : @"1"}, @{@"Title" : @"Action Logs", @"Icon_Name" : @"ic_action_log.png", @"Identifier" : @"ACTION_LOG_LIST", @"Colour_Status" : @"1"}, @{@"Title" : @"Sales Visit Plan", @"Icon_Name" : @"ic_plan.png", @"Identifier" : @"SALES_VISIT_PLAN", @"Colour_Status" : @"0"},  @{@"Title" : @"Events", @"Icon_Name" : @"ic_action_event.png", @"Identifier" : @"EVENT", @"Colour_Status" : @"0"}, @{@"Title" : @"Communication", @"Icon_Name" : @"ic_communication_chat.png", @"Identifier" : @"COMMUNICATION", @"Colour_Status" : @"1"}]

#define AAS_DASHBOARD_ARRAY @[@{@"Title" : @"Agents", @"Icon_Name" : @"ic_agent.png", @"Identifier" : @"AGENT", @"Colour_Status" : @"0"}, @{@"Title" : @"Contacts", @"Icon_Name" : @"ic_pick_contact.png", @"Identifier" : @"CONTACTS", @"Colour_Status" : @"1"}, @{@"Title" : @"Action Logs", @"Icon_Name" : @"ic_action_log.png", @"Identifier" : @"ACTION_LOG_LIST", @"Colour_Status" : @"1"}, @{@"Title" : @"Sales Visit Plan", @"Icon_Name" : @"ic_plan.png", @"Identifier" : @"SALES_VISIT_PLAN", @"Colour_Status" : @"0"},  @{@"Title" : @"Events", @"Icon_Name" : @"ic_action_event.png", @"Identifier" : @"EVENT", @"Colour_Status" : @"0"}, @{@"Title" : @"Communication", @"Icon_Name" : @"ic_communication_chat.png", @"Identifier" : @"COMMUNICATION", @"Colour_Status" : @"1"}]

#define HOS_DASHBOARD_ARRAY @[@{@"Title" : @"Agents", @"Icon_Name" : @"ic_agent.png", @"Identifier" : @"AGENT", @"Colour_Status" : @"0"}, @{@"Title" : @"Contacts", @"Icon_Name" : @"ic_pick_contact.png", @"Identifier" : @"CONTACTS", @"Colour_Status" : @"1"}, @{@"Title" : @"Action Logs", @"Icon_Name" : @"ic_action_log.png", @"Identifier" : @"ACTION_LOG_LIST", @"Colour_Status" : @"1"}, @{@"Title" : @"Sales Visit Plan", @"Icon_Name" : @"ic_plan.png", @"Identifier" : @"SALES_VISIT_PLAN", @"Colour_Status" : @"0"}, @{@"Title" : @"Employees", @"Icon_Name" : @"ic_employee.png", @"Identifier" : @"EMPLOYEE", @"Colour_Status" : @"0"},  @{@"Title" : @"Events", @"Icon_Name" : @"ic_action_event.png", @"Identifier" : @"EVENT", @"Colour_Status" : @"1"}, @{@"Title" : @"Communication", @"Icon_Name" : @"ic_communication_chat.png", @"Identifier" : @"COMMUNICATION", @"Colour_Status" : @"1"}]

#define BM_DASHBOARD_ARRAY  @[@{@"Title" : @"Agents", @"Icon_Name" : @"ic_agent.png", @"Identifier" : @"AGENT", @"Colour_Status" : @"0"}, @{@"Title" : @"Contacts", @"Icon_Name" : @"ic_pick_contact.png", @"Identifier" : @"CONTACTS", @"Colour_Status" : @"1"}, @{@"Title" : @"Action Logs", @"Icon_Name" : @"ic_action_log.png", @"Identifier" : @"ACTION_LOG_LIST", @"Colour_Status" : @"1"}, @{@"Title" : @"Sales Visit Plan", @"Icon_Name" : @"ic_plan.png", @"Identifier" : @"SALES_VISIT_PLAN", @"Colour_Status" : @"0"}, @{@"Title" : @"Charts", @"Icon_Name" : @"ic_editor_insert_chart.png", @"Identifier" : @"CHARTS", @"Colour_Status" : @"0"}, @{@"Title" : @"Employees", @"Icon_Name" : @"ic_employee.png", @"Identifier" : @"EMPLOYEE", @"Colour_Status" : @"1"},  @{@"Title" : @"Events", @"Icon_Name" : @"ic_action_event.png", @"Identifier" : @"EVENT", @"Colour_Status" : @"1"}, @{@"Title" : @"Communication", @"Icon_Name" : @"ic_communication_chat.png", @"Identifier" : @"COMMUNICATION", @"Colour_Status" : @"0"}]


#define RM_DASHBOARD_ARRAY @[ @{@"Title" : @"Contacts", @"Icon_Name" : @"ic_pick_contact.png", @"Identifier" : @"CONTACTS", @"Colour_Status" : @"0"}, @{@"Title" : @"Action Logs", @"Icon_Name" : @"ic_action_log.png", @"Identifier" : @"ACTION_LOG_LIST", @"Colour_Status" : @"1"}, @{@"Title" : @"Sales Visit Plan", @"Icon_Name" : @"ic_plan.png", @"Identifier" : @"SALES_VISIT_PLAN", @"Colour_Status" : @"1"}, @{@"Title" : @"Charts", @"Icon_Name" : @"ic_editor_insert_chart.png", @"Identifier" : @"CHARTS", @"Colour_Status" : @"0"}, @{@"Title" : @"Employees", @"Icon_Name" : @"ic_employee.png", @"Identifier" : @"EMPLOYEE", @"Colour_Status" : @"0"},  @{@"Title" : @"Events", @"Icon_Name" : @"ic_action_event.png", @"Identifier" : @"EVENT", @"Colour_Status" : @"1"}, @{@"Title" : @"Communication", @"Icon_Name" : @"ic_communication_chat.png", @"Identifier" : @"COMMUNICATION", @"Colour_Status" : @"1"}]


/*  ACTION LOG CONSTANT  */

#define C @"COMPLETED"

#define P @"PENDING"

#define R @"REJECTED"

#define PR @"PROCESSING"

#define OD @"OVERDUE"

#define DT @"DUETODAY"

#define OG @"ONGOING"

#define A @"APPROVAL"


/*  ACTION LOG CONSTANT  */

#define WEBVIEW_TYPE_URL @"URL"

#define WEBVIEW_TYPE_FILEPATH @"FILE"


/*   SALES VISIT PLAN FILTER ARRAY      */


#define HOS_FILTER_ARRAY @[@{@"title" : @"Select Marketer" , @"tag" : MARKETER_ROLE_ID}, @{@"title" : @"Select AAS" , @"tag" : AAS_ROLE_ID}]

#define BM_FILTER_ARRAY @[@{@"title" : @"Select Marketer" , @"tag" : MARKETER_ROLE_ID}, @{@"title" : @"Select AAS" , @"tag" : AAS_ROLE_ID}, @{@"title" : @"Select HOS" , @"tag" : HOS_ROLE_ID}]

#define RM_FILTER_ARRAY @[@{@"title" : @"Select Region" , @"tag" : @"-1"},@{@"title" : @"Select Branch" , @"tag" : @"0"}, @{@"title" : @"Select Marketer" , @"tag" : MARKETER_ROLE_ID}, @{@"title" : @"Select AAS" , @"tag" : AAS_ROLE_ID}, @{@"title" : @"Select HOS" , @"tag" : HOS_ROLE_ID}]
 


//#define HOS_FILTER_ARRAY @[@{@"title" : @"Select Marketer" , @"tag" : MARKETER_ROLE_ID}]
//
//#define BM_FILTER_ARRAY @[@{@"title" : @"Select Marketer" , @"tag" : MARKETER_ROLE_ID}, @{@"title" : @"Select HOS" , @"tag" : HOS_ROLE_ID}]
//
//#define RM_FILTER_ARRAY @[@{@"title" : @"Select Branch" , @"tag" : @"0"}, @{@"title" : @"Select Marketer" , @"tag" : MARKETER_ROLE_ID}, @{@"title" : @"Select HOS" , @"tag" : HOS_ROLE_ID}]


#endif /* App_Constant_h */
