@echo off

REM Purpose: create convenient folder with task log file and JIRA link. This folder is for other useful task material and links.
REM this is template which you should to support. Do not support in your work folder on corporate computer.
REM Please support this script on your home computer. So that will mean that you are the owner for this code - not the company.
REM There are parameters labeled with $PARAM which you should config before use this script on corporate computer. 

REM as usually this is required to make work folder on non C disk
REM $PARAM
E:

REM $PARAM
cd "E:\tasks\_ticket_physical_storage" 

echo Please enter ticket prefix
echo 1 - todo 1
echo 2 - todo 2
echo Type any other prefix if not presented in the list
set /p ticket_prefix_user_input=

REM this is default 
set ticket_prefix=%ticket_prefix_user_input%

IF %ticket_prefix_user_input% EQU 1 ( set ticket_prefix=TODO1)
IF %ticket_prefix_user_input% EQU 2 ( set ticket_prefix=TODO2)

echo Your choice is %ticket_prefix%

set /p ticket_number=Please provide ticket NUMBER: 
set /p ticket_short_description=Please_enter_ticket_short_description and user _ instead of spaces:

set ticket_short_code=%ticket_prefix%-%ticket_number%
set ticket_long_code=%ticket_prefix%-%ticket_number%_%ticket_short_description%

REM create ticket folder
mkdir %ticket_long_code%
cd %ticket_long_code%

REM printing default content of ticket log file
set ticket_log_file="%ticket_long_code%_log".txt
echo here is your ticket task log >> %ticket_log_file%
echo. >> %ticket_log_file%
echo ------------------------------------------------------------------------------------------------- >> %ticket_log_file%
echo Done >> %ticket_log_file%
echo. >> %ticket_log_file%

set JIRA_link="JIRA_%ticket_short_code%".url
echo [InternetShortcut]>>%JIRA_link%
REM $PARAM
echo URL=https://link_to_jira/browse/%ticket_short_code%>>%JIRA_link%

REM $PARAM
set pathToTicketShortCut="E:\tasks\@new\%ticket_long_code%.lnk"
powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%pathToTicketShortCut%');$s.TargetPath='%cd%';$s.Save()"

explorer "%cd%"
