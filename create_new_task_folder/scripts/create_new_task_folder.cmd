@echo off

REM TODO: isolate all input parameters in some configuration file or at least at the top of this script. Otherwise it is hard to substitute

REM Purpose: create convenient folder with task log file and task link - e.g. in JIRA. This folder is for other useful task material and links.

REM this is environment specific folder where template files with appropriate task structure are stored
set template_folder="TODO_PROVIDE_PATH\create_new_task_folder\task_template"

cd "TODO_PROVIDE_PATH_TO\_tasks_physical_storage"

REM TODO: create those tasks in alphabetical order. And refactor this - do not copypaste just map to freely change the order without any reindexing
echo Please enter task prefix
echo 1 - TODO_PROVIDE_FREQUENTLY_USED_TASK_CODE_1
echo 2 - TODO_PROVIDE_FREQUENTLY_USED_TASK_CODE_2
echo 3 - TODO_PROVIDE_FREQUENTLY_USED_TASK_CODE_3
echo Type any other prefix if not presented in the list
set /p task_prefix_user_input=

REM this is default 
set task_prefix=%task_prefix_user_input%

IF %task_prefix_user_input% EQU 1 ( set task_prefix=TODO_PROVIDE_FREQUENTLY_USED_TASK_CODE_1)
IF %task_prefix_user_input% EQU 2 ( set task_prefix=TODO_PROVIDE_FREQUENTLY_USED_TASK_CODE_2)
IF %task_prefix_user_input% EQU 3 ( set task_prefix=TODO_PROVIDE_FREQUENTLY_USED_TASK_CODE_3)

echo Your choice is %task_prefix%

set /p task_number=Please provide task NUMBER: 
set /p task_short_description=Please_enter_task_short_description and user _ instead of spaces:

set task_short_code=%task_prefix%-%task_number%
set task_long_code=%task_prefix%-%task_number%_%task_short_description%

REM create task folder. Create explicitly task folder.
REM Do not copy root folder from template as it is dangerous if case several instances of this script are running.
REM Several instances potentially could use the same folder (not yet renamed from template name) in such scenario.
mkdir %task_long_code%
cd %task_long_code%

REM copy content of template folder into current task folder
REM xcopy copies not only files (comparing to simple copy), but entire subfolder structure ( "/E" for including copying of empty folders )
xcopy /E %template_folder%

REM TODO: refactor this. Use single expression for replacements and do not create copypaste variables
Setlocal enabledelayedexpansion
Set "Pattern1=#task_short_code#"
Set "Replace1=%task_short_code%"

Set "Pattern2=#task_long_code#"
Set "Replace2=%task_long_code%"

Set "Pattern3=#task_prefix#"
Set "Replace3=%task_prefix%"

REM recursive loop for all files in current directory and all subdirectories
REM if in future you need to substitute in folder names then implement looping through folder also
REM the purpose of this is just to rename substitution variables from template into actual variable values
For /R %%# in (*.*) Do (
    Set "File=%%~nx#"
    
    REM does not rename the folders - only renames the files
    REM seems it does not rename files where there is no change from substitutions.
    REM So I assume we can omit condition 'rename only if filename was changed'

    REM TODO: calculate file name once and only after this do renaming. Do not do renaming several times
    REM also such approach with sequential renaming has bug - it will not do the second replacement if first one has already occurred. It will just not be able to find the file - so refactor and fix this please
    Ren "%%#" "!File:%Pattern1%=%Replace1%!"
    Ren "%%#" "!File:%Pattern2%=%Replace2%!"
    Ren "%%#" "!File:%Pattern3%=%Replace3%!"
)

REM if in future you will need to also change content of files to substitute then use sample below
REM adjust this sample to your needs by providing correct filename and correct encdoing (it can be important)
REM powershell -Command "(gc myFile.txt) -replace 'foo', 'bar' | Out-File -encoding ASCII myFile.txt"


REM do not use template for URL's as replacement in text does not applied immediately to url files in Windows.
REM There is some kind of delay. So it is more reliable to print this link directly in code rather than copy from template and adjust file content with variable replacements
set task_link="%task_short_code%_in_task_tracking_system".url
echo [InternetShortcut]>>%task_link%
echo URL=https://TODO_PROVIDE_HERE_URL_TO_YOUR_TASK_TRACKING_SYSTEM/%task_short_code%>>%task_link%

REM create shortcut in task_logical_storage (usually relates to task tracking system task status) pointing to task_physical_storage
set path_to_task_shortCut="TODO_PROVIDE_PATH\tasks\@new\%task_long_code%.lnk"
powershell "$s=(New-Object -COM WScript.Shell).CreateShortcut('%path_to_task_shortCut%');$s.TargetPath='%cd%';$s.Save()"

explorer "%cd%"

