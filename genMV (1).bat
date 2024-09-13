@ECHO OFF

setlocal enabledelayedexpansion

set /p nombre_machines=Entrez le nombre de machines à créer :
set /p chemin_iso=Entrez le chemin complet de l'image ISO d'installation Debian :

for /L %%i in (1,1,%nombre_machines%) do (
    set /p nom=Nom de la machine %%i :
    set /p user=Nom d'utilisateur pour la machine %%i :
    set /p cpu=Nombre de CPU pour la machine %%i :
    set /p mdp=Mot de passe pour la machine %%i :

    "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" createvm --name "%nom%" --ostype "Debian_64" --register --basefolder "C:\Users\RT2-FA\VirtualBox VMs"
    "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" modifyvm "%nom%" --memory 4096 --cpus %cpu% --nic1 nat --boot1 net
    "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" createhd --filename "C:\Users\RT2-FA\VirtualBox VMs\%nom%\%nom%_DISK.vdi" --size 687195 --format VDI
    "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" storagectl "%nom%" --name "IDE Controller" --add ide
    "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" storageattach "%nom%" --storagectl "IDE Controller" --port 1 --device 0 --type dvdd --medium "%chemin_iso%"
    "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" unattended install "%nom%" --iso="%chemin_iso%" --user="%user%" --full-user-name="%user%" --password "%mdp%" --install-additions --time-zone=UTC+1
    "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" setextradata "%nom%" date "%date%"
    "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" setextradata "%nom%" heure "%time%"
    "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" setextradata "%nom%" Utilisateur "%user%"
    "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" setextradata "%nom%" Cpu "%cpu%"
    "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" setextradata "%nom%" Memoire "4096"
)

pause

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
