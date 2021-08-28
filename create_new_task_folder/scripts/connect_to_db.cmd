set user_name=%1
set user_password=%2
set database_host=%3
set database_name=%3

REM TODO: implement your custom connect to DB script here which is based on DB IDE you typically use
REM for example if you use Pl/SQL Developer then you may need to implement something like this:
REM ----
REM c:
REM cd "c:\Program Files\PLSQL Developer"
REM start plsqldev.exe userid=%user_name%/%user_password%@//%database_host%/%database_name%
REM ----
