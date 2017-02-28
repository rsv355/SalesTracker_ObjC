//
//  SalesTracker_AppURL.h
//  SalesTracker
//
//  Created by Masum Chauhan on 22/09/16.
//  Copyright © 2016 Webmyne Systems Pvt Ltd. All rights reserved.
//

#ifndef SalesTracker_AppURL_h

#define SalesTracker_AppURL_h

//ATTACHMENT - http://demo.webmynehost.com/amgsales/sites/default/files/communication/download.pdf


#define BASE_URL @"http://insurance4all.com.my/salestracker/services/"

//#define BASE_URL @"http://demo.webmynehost.com/amgsale_live/services/"

#define USER_LOGIN @"login_post.php?format=json&"

#define USER_LOGOUT @"logout.php?format=json&"

#define UPDATE_PROFILE @"update_profile.php"

#define AGENT_LIST @"agent_list.php?format=json&"

#define ADD_AGENT @"add_agent.php"

#define UPDATE_AGENT @"update_agent.php"

#define DELETE_AGENT @"delete_agent.php"

#define TIER_LIST @"tier_list.php?format=json"

#define BRANCH_LIST @"branch.php?format=json"

#define ACTIONLOG_LIST @"fetch_action.php?format=json&"

#define ADD_ACTIONLOG @"add_action.php"

#define EDIT_ACTIONLOG @"edit_action.php"

#define CHANGE_ACTION_LOG @"aap_rej_status.php?format=json&"

#define ACTION_LOG_PATH @"http://insurance4all.com.my//salestracker/sites/default/files/userfile/"

#define FETCH_REMARK @"display_remark.php?format=json&"

#define ADD_REMARK @"update_action.php"

#define REOPEN_ACTION @"/reopen_remark.php?format=json&"

#define FETCH_DEPARTMENT @"department.php?format=json"

#define FETCH_INCAHRGE @"departmentpic.php?format=json"

#define BRANCH_CONTACT @"branch_list.php?format=json&"

#define DEPARTMENT_CONTACT @"contact_department_list.php?format=json"



/* EVNET AND COMMUNICATION */

#define FETCH_COMMUNCATION @"fetch_communication.php?format=json"

#define FETCH_EVENTS @"fetch_events.php?format=json"

#define FETCH_REGION @"region.php?format=json"

#define FETCH_BRANCHES @"branch.php?format=json&"

#define FETCH_POSITION @"position.php?format=json"

#define ADD_EVENT @"add_event.php?format=json"

#define UPDATE_EVENT @"update_event.php?format=json"

#define DELETE_EVENT @"delete_event.php?format=json"


/*  PHASE 2 - SALES VISIT PLAN  */

#define FETCH_PLAN @"fetch_visit_paln.php?format=json"

#define UPDATE_PLAN @"update_remark.php?format=json"

#define UPDATE_PLAN_STATUS @"update_box.php?format=json"

#define DELETE_PLAN @"delete_plan.php?format=json"

#define FETCH_AGENTLIST_PLAN @"fetch_agent_list.php?format=json&"

#define ADD_PLAN @"add_plan.php?format=json"

#define FETCH_MAPPING @"mapping.php?format=json"

#define ADD_MAPPING @"add_mapping.php?format=json"

#define DELETE_MAPPING @"delete_mapping.php?format=json"


#define FETCH_RECRUITMENT @"recruitment.php?format=json"

#define ADD_RECRUITMENT @"add_recuriment.php?format=json"

#define DELETE_RECRUITMENT @"delete_recruiment.php?format=json"

#define GET_DAY_REMARK @"%@fetch_if_no.php?format=json&user_id=%@&Date=%@"

#define ADD_DAY_REMARK @"add_plan_remakr.php?format=json"


/*   EMPLOYEE   */

#define FETCH_EMPLOYEE @"fetch_emp.php?format=json&"

#define DELETE_EMPLOYEE @"delete_emp.php?format=json"

#define ADD_EMPLOYEE @"add_emp.php?format=json"

#define  UPDATE_EMPLOYEE @"update_emp.php?format=json"

#define EMPLOYEE_LIST @"fetch_emp.php?format=json&"


/*  CHARTS  */

#define BRANCH_CHART_URL @"%@graph.php?month=%@&year=%@&user_id=%@&region_id=%@"

#define DEPARTMENT_CHART_URL @"%@graph_department.php?month=%@&year=%@"

#define DEPARTMENT_SLA_CHART_URL @"%@graph_dept_sla.php?month=%@&year=%@&userid=%@"

#define SVP_CHART_URL @"%@graph_sales_visit.php?year=%@&month=%@&region=%@&branch=%@&userid=%@"


/*  FTP CONSTANS  */

/*
 
 #define FTP_URL @"ftp://ws-srv-php/drupal/amgsales2/sites/default/files/userfile/"
 #define FTP_USERNAME @"projects"
 #define FTP_PASSWORD @"projects"
 
 #define FTP_URL @"ftp://insurance4all.com.my//public_html/salestracker/userfile/"
 #define FTP_USERNAME @"insura11"
 #define FTP_PASSWORD @"yIfv50Kx78"
 
*/

#define FTP_URL @"ftp://ftp.insurance4all.com.my"

#define FTP_USERNAME @"iosimage@insurance4all.com.my"

#define FTP_PASSWORD @"3Hht3H]Ry7Ba"



//#define FILE_DOWNLOAD_BASE_URL @"http://demo.webmynehost.com/amgsales/sites/default/files/"

#define FILE_DOWNLOAD_BASE_URL @"http://insurance4all.com.my/salestracker/sites/default/files/"

#define COMMUNICATION_DOWNLOAD_URL @"communication/"

#endif /* SalesTracker_AppURL_h */
