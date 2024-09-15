# Automatisation de la création de machines virtuelles 

NOM_VM="Debian1"  
DISK=65536   
RAM=4096     

# Vérification de l'exixtance de la VM
VM_EXISTANTE=$(VBoxManage list vms | grep "\"$NOM_VM\"")

if [ -n "$VM_EXISTANTE" ]; then
    echo "Une machine virtuelle nommée '$NOM_VM' existe déjà. Suppression en cours..."
    
    # Arrêt de la VM
    VBoxManage controlvm "$NOM_VM" poweroff 2>/dev/null
    
    # Suppression de la VM
    VBoxManage unregistervm "$NOM_VM" --delete
    echo "La machine existante '$NOM_VM' a été supprimée avec succès!"
fi

# Création d'une nouvelle VM
VBoxManage createvm --name "$NOM_VM" --ostype "Debian_64" --register

VBoxManage modifyvm "$NOM_VM" --memory $RAM --acpi on --boot1 net

VBoxManage createhd --filename "$HOME/VirtualBox VMs/$NOM_VM/$NOM_VM.vdi" --size $DISK

VBoxManage storagectl "$NOM_VM" --name "SATA Controller" --add sata --controller IntelAHCI

VBoxManage storageattach "$NOM_VM" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$HOME/VirtualBox VMs/$VM_NAME/$VM_NAME.vdi"

VBoxManage modifyvm "$NOM_VM" --nic1 nat

VBoxManage modifyvm "$NOM_VM" --boot1 net --nicbootprio1 1

# Pause pour vérifier la création de la VM dans le GUI de VirtualBox
echo "Vérifiez dans VirtualBox que la machine '$NOM_VM' a bien été créée."
read -p "Appuyez sur Entrée pour continuer..."

echo "La nouvelle machine virtuelle '$NOM_VM' a été créée avec succès et est prête à l'emploi."

# Monter l'image iso pour extraire les fichiers pour PXE

mount -o loop ~/Downloads/debian-12.7.0-amd64-netinst.iso /mnt

# configuration du serveur tftp interne à virtualbox 

# Répertoire TFTP
TFTP="/srv/tftpboot"
sudo mkdir -p "$TFTP_DIR/pxelinux.cfg"

# Copier les fichiers nécessaires à partir de l'ISO montée
cp /mnt/install.amd/vmlinuz "$TFTP/"
cp /mnt/install.amd/initrd.gz "$TFTP/"
cp /mnt/pxelinux.0 "$TFTP_DIR/" 

# Création du fichier de configuration PXE
sudo bash -c 'cat > "$TFTP_DIR/pxelinux.cfg/default" <<EOF
DEFAULT install
LABEL install
    KERNEL vmlinuz
    APPEND initrd=initrd.gz
EOF'

# Démontage de l'ISO
sudo umount /mnt/debian-iso

# Configuration des ports TFTP dans VirtualBox
VBoxManage modifyvm "$NOM_VM" --natpf1 "TFTP,tftp,*,69,*,69"

# Démarrer la VM
VBoxManage startvm "$NOM_VM" --type headless


# Choisir au moins une action
if [ $# -lt 1 ]; then
  echo "Usage: $0 <action> [NOM_VM]"
  echo "Actions:"
  echo "  L  - Lister les machines"
  echo "  N  - Ajouter une nouvelle machine"
  echo "  S  - Supprimer une machine"
  echo "  D  - Démarrer une machine"
  echo "  A  - Arrêter une machine"
  exit 1
fi 

# Action à effectuer
ACTION=$1
NOM_VM=$2

case $ACTION in
  I)
    # Liste des VM
    VBoxManage list vms
    ;;
  
  N)
    # Ajout d'une nouvelle machine
    if [ -z "$NOM_VM" ]; then
      echo "Nom de la machine necessaire pour l'ajout."
      exit 1
    fi
    VBoxManage createvm --name "$NOM_VM" --ostype "Debian_64" --register
    VBoxManage modifyvm "$NOM_VM" --memory $RAM --acpi on --boot1 net
    VBoxManage createhd --filename "$HOME/VirtualBox VMs/$VM_NAME/$VM_NAME.vdi" --size $DISK_SIZE
    VBoxManage storagectl "$NOM_VM" --name "SATA Controller" --add sata --controller IntelAHCI
    VBoxManage storageattach "$NOM_VM" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$HOME/VirtualBox VMs/$VM_NAME/$VM_NAME.vdi"
    VBoxManage modifyvm "$NOM_VM" --nic1 nat
    VBoxManage modifyvm "$NOM_VM" --boot1 net
    ;;
  
  S)
    # Supprimer une machine
    if [ -z "$NOM_VM" ]; then
      echo "Nom de la machine est necessaire pour la suppression."
      exit 1
    fi
    VBoxManage unregistervm "$NOM_VM" --delete
    ;;
  
  D)
    # Démarrer une machine
    if [ -z "$NOM_VM" ]; then
      echo "Nom de la machine necessaire pour le démarrage."
      exit 1
    fi
    VBoxManage startvm "$NOM_VM" --type headless
    ;;
  
  A)
    # Arrêter une machine
    if [ -z "$NOM_VM" ]; then
      echo "Nom de la machine requis pour l'arrêt."
      exit 1
    fi
    VBoxManage controlvm "$NOM_VM" acpipowerbutton
    ;;
  
  *)
    echo "Action non reconnue : $ACTION"
    echo "Utilisation : $0 <action> [nom_VM]"
    exit 1
    ;;
esac
