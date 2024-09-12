@ECHO OFF

:: Configuration de la mémoire et de la taille du disque
set memory=4096
set size=687195

:: Menu principal
ECHO L. Liste des VM
ECHO N. Ajouter une nouvelle VM
ECHO S. Supprimer une VM
ECHO D. Demarrer une VM
ECHO A. Arreter une VM

:: Demander l'option
set /p choix="Choix de l'option ? "
if "%choix%"=="L" goto L
if "%choix%"=="N" goto N
if "%choix%"=="S" goto S
if "%choix%"=="D" goto D
if "%choix%"=="A" goto A
pause
GOTO end

:: Liste des VM
:L
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" list vms
echo 1. Observer une VM
echo 2. Exit
CHOICE /C 12 /M "Choix de l'option:"
if errorlevel 2 goto end
if errorlevel 1 goto Observer

:: Observer les détails d'une VM
:Observer
set /p name="Nom de la VM ? "
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" getextradata "%name%"
pause
goto end

:: Ajouter une nouvelle VM
:N
set /p nom="Nom de la VM ? "
set /p user="Username ? "
set /p cpu="Nombre de CPU ? "
set /p mdp="Mot de passe ? "
set /p iso_path="Veuillez entrer le chemin complet de l'image ISO : "

"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" createvm --name "%nom%" --ostype "Debian_64" --register --basefolder "C:\Users\RT2-FA\VirtualBox VMs"
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" modifyvm "%nom%" --memory %memory% --cpus %cpu%
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" createhd --filename "C:\Users\RT2-FA\VirtualBox VMs\%nom%\%nom%_DISK.vdi" --size %size% --format VDI

:: Installation sans surveillance avec l'ISO spécifié
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" unattended install "%nom%" --iso="%iso_path%" --user="%user%" --full-user-name="%user%" --password "%mdp%" --install-additions --time-zone=UTC+1

:: Configurer le réseau et le démarrage PXE
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" modifyvm "%nom%" --nic1 nat
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" modifyvm "%nom%" --boot1 dvd

:: Ajouter un contrôleur de stockage et attacher l'ISO
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" storagectl "%nom%" --name "IDE Controller" --add ide
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" storageattach "%nom%" --storagectl "IDE Controller" --port 1 --device 0 --type dvdd --medium "%iso_path%"

:: Ajouter des données supplémentaires sur la VM
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" setextradata "%nom%" date "%date%"
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" setextradata "%nom%" heure "%time%"
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" setextradata "%nom%" Utilisateur "%user%"
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" setextradata "%nom%" Cpu "%cpu%"
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" setextradata "%nom%" Memoire "%memory%"
pause
goto end

:: Supprimer une VM
:S
set /p nom="Nom de la VM ? "
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" unregistervm --delete "%nom%"
pause
goto end

:: Démarrer une VM
:D
set /p nom="Nom de la VM ? "
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" startvm "%nom%" --type headless
pause
goto end

:: Arrêter une VM
:A
set /p nom="Nom de la VM ? "
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" controlvm "%nom%" poweroff
pause
goto end

:end

