# Guide d'utilisation du Script de Création Automatisée de Machines Virtuelles sous VirtualBox

## Auteurs
- Auteur : [LAWSON-CHROCO Darly; Claude Carmella Nguimbi]
- Date : [ 15/09/2024]

## Résumé
Ce document présente un script automatisé pour créer et configurer plusieurs machines virtuelles sous VirtualBox. Il permet de définir le nombre de machines, les noms d'utilisateurs et les services associés, et est compatible avec les systèmes **Windows** et **Linux**. Ce rapport aborde également les limites du script et les problèmes rencontrés.

## 1. Introduction
Ce guide explique l'utilisation d'un script automatisé pour la création et la gestion de machines virtuelles (VM) sous VirtualBox. Le script permet de créer plusieurs VM à la fois, avec des paramètres personnalisés tels que le nom, le nombre de CPU, le nom d'utilisateur et le service rattaché. Ce script est compatible avec les environnements **Windows** et **Linux**.

## 2. Utilisation du Script

### 2.1. Prérequis
- **VirtualBox** installé sur le système (Windows ou Linux).
- Une **image ISO** de Debian stable téléchargée localement.

### 2.2. Lancement du Script sous Windows
1. Ouvrez une fenêtre **cmd** en mode administrateur.
2. Exécutez le script batch avec la commande suivante :

   ```bash
   genMv.bat

### 2.3. Suivez les instructions affichées :

- Le script vous demandera d'entrer le **nombre de machines** que vous souhaitez créer.
- Spécifiez le **chemin complet de l'image ISO** d'installation Debian.
- Pour chaque machine :
  - Entrez un **nom pour la machine virtuelle**.
  - Fournissez un **nom d'utilisateur** et un **service** associé.
  - Indiquez le **nombre de CPU** et le **mot de passe** pour l'utilisateur.

Le script créera les machines, les associera aux utilisateurs spécifiés et lancera une installation automatisée de Debian.

---

### 2.4. Lancement du Script sous Linux

1. Ouvrez un terminal.
2. Rendez le fichier exécutable avec la commande suivante :

   ```bash
   chmod +x genMV.sh

### 2.5. Guide d'utilisation

Le script est composé de plusieurs options listés comme suit:

- L : Lister les machines virtuelles existantes.
- N : Créer une ou plusieurs nouvelles machines virtuelles.
- S : Supprimer une machine virtuelle existante.
- D : Démarrer une machine virtuelle.
- A : Arrêter une machine virtuelle.

Une fois le script lancé on choisit la lettre correpondant à la tache qu'on veut effectuer (Attention saisir la commande en majiscule)

### 3. Limites et problèmes rencontrés au cours du projet: 

- Le chemin d'accès aux images ISO doit être fourni manuellement pour chaque exécution du script.
- Le script ne prend en charge que la configuration réseau via NAT par défaut, ce qui peut poser problème dans des scénarios réseau plus complexes.
- Sous Linux, certaines configurations spécifiques peuvent varier selon la distribution utilisée (ex : installation préalable de VirtualBox).
- Erreur de chemin d'accès ISO : Si le chemin de l'image ISO est incorrect ou inaccessible, l'installation échouera.
- Paramètres réseau : Les machines virtuelles sont par défaut connectées au réseau via NAT, mais ce mode peut poser problème pour des configurations réseau plus avancées.


### 4. Conclusion

Ce script offre une solution rapide pour créer et configurer plusieurs machines virtuelles sous VirtualBox, avec une installation non surveillée de Debian. Compatible à la fois sous Windows et Linux, il simplifie l'automatisation de la création de VM. Cependant, il reste limité pour des environnements plus complexes et peut nécessiter des améliorations pour supporter d'autres systèmes d'exploitation ou topologies réseau.



