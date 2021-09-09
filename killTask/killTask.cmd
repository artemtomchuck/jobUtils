@echo off

REM TODO: create those programs in alphabetical order. And refactor this - do not copypaste just map to freely change the order without any reindexing
echo What program do you want to kill? Please choose one from list or enter with *.exe extension:
echo 1  - WinMerge
echo 2  - TortoiseMerge
echo 3  - TortoiseProc
echo 4  - TortoiseBlame
echo 5  - TortoiseUDiff
echo 6  - Tortoise SVN All Utilites
echo 7  - Skype
echo 8  - Teams
echo 9  - Libre Office All (Writer + Calc)

set /p programsToKill_user_input=

set wildcard_param=/im

REM this is default 
set programsToKill=%programsToKill_user_input%

IF %programsToKill_user_input% EQU 1 ( set programsToKill=WinMergeU.exe)
IF %programsToKill_user_input% EQU 2 ( set programsToKill=TortoiseMerge.exe)
IF %programsToKill_user_input% EQU 3 ( set programsToKill=TortoiseProc.exe)
IF %programsToKill_user_input% EQU 4 ( set programsToKill=TortoiseBlame.exe)
IF %programsToKill_user_input% EQU 5 ( set programsToKill=TortoiseUDiff.exe)
REM TODO: use array here if you want to kill several programs at once. And loop through the items of this array killing one item per iteration
IF %programsToKill_user_input% EQU 6 ( set programsToKill=TortoiseProc.exe %wildcard_param% TortoiseMerge.exe %wildcard_param% TortoiseBlame.exe %wildcard_param% TortoiseUDiff.exe)
IF %programsToKill_user_input% EQU 7 ( set programsToKill=Skype.exe)
IF %programsToKill_user_input% EQU 8 ( set programsToKill=Teams.exe)
IF %programsToKill_user_input% EQU 9 ( set programsToKill=soffice.bin)

set programsToKill=%wildcard_param% %programsToKill%

taskkill /f %programsToKill%