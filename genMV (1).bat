@ECHO OFF

set memory=4096
set size=687195

ECHO L. Liste des VM
ECHO N. Ajouter une nouvelle VM
ECHO S. Supprimer une VM
ECHO D. Demarrer une VM
ECHO A. Arreter une VM

set /p choix= Choix de l'option ?
if "%choix%"=="L" goto L
if "%choix%"=="N" goto N
if "%choix%"=="S" goto S
if "%choix%"=="D" goto D
if "%choix%"=="A" goto A
pause
GOTO end

:L
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" list vms
echo 1. Observer une VM
echo 2. Exit
CHOICE /C 12 /M "Choix de l'option:"
if errorlevel 2 goto end
if errorlevel 1 goto Observer

:Observer
set /p name=Nom de la VM ?
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" getextradata "%name%"
pause
goto end

:N
set /p nom=Nom de la VM ?
set /p user=Username ?
set /p cpu=Nombre de CPU ?
set /p mdp=Mot de passe ?
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" createvm --name "%nom%" --ostype "Debian11" --register --basefolder "C:\Users\RT2-FA\VirtualBox VMs"
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" modifyvm "%nom%" --memory %memory%
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" modifyvm "%nom%" --cpus %cpu%
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" createhd --filename "C:\Users\RT2-FA\VirtualBox VMs\%nom%\%nom%_DISK.vdi" --size %size% --format VDI
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" unattended install "%nom%" --iso="C:\Users\RT2-FA\VirtualBox VMs" --user="%user%" --full-user-name="%user%" --password "%mdp%" --install-additions --time-zone=UTC+1
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm "%nom%" setcredentials "%user%" "%mdp%" "DOMTEST"
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" setextradata "%nom%" date "%date%"
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" setextradata "%nom%" heure "%time%"
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" setextradata "%nom%" Utilisateur "%user%"
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" setextradata "%nom%" Cpu "%cpu%"
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" setextradata "%nom%" Memoire "%memory%"
pause
goto end

:S
set /p nom=Nom de la VM ?
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" unregistervm --delete "%nom%"
pause
goto end

:D
set /p nom=Nom de la VM ?
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" startvm "%nom%" --type headless
pause
goto end

:A
set /p nom=Nom de la VM ?
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm "%nom%" poweroff
pause
goto end

:end
