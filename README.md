# Chaos Dash

Global Game Jam 2024 Submission

Make Me Laught !

## Idée

Un platformer multi party game bordélique.

## Fonctionnalitées

- [ ] Pas implémenté mais prévu
- [ ] **Pas implémenté, priorité forte**
- [ ] *Pas implémenté, pas sûr*
- [X] Implémenté

### Personnage

- [X] Personnage joueur
  - [X] Collisions
    - [X] Désactivé entre joueurs
  - [X] LoseConditions
    - [X] Stocks
    - [X] Health
  - [X] WinConditions
    - [X] Score
  - [X] State Machine
    - [X] Idle
    - [X] Course
    - [X] JumpSquat
    - [X] InAir
      - [X] FastFall
    - [X] Attaque :
      - [X] Projectile
        - [X] Inflige un point de dégats
        - [X] Stun/FreeFall le joueur
        - [ ] Qui peut se faire sauter dessus
        - [ ] Doit stocker le tireur pour lui donner un point quand il tue un adversaire.
    - [X] FreeFall : le personnage tombe jusqu'à mourir ou toucher le sol puis est stun.
    - [X] Stun : le joueur n'a pas le controle de son personnage.
      - [X] StunLocking impossible
    - [X] Death
    - [X] Parade : dans le sens de se parader, pas une parry
    - [ ] Wait
      - [ ] Personnage statique et non affecté par la physique. Sert pour les cinématiques.
    - [X] OutOfGame : Mode FreeCam lorsque le perso est éliminé
  - [X] Physique
    - [X] Friction
    - [X] Drift Aerien
    - [X] FastFall

### Multi-Joueur

- [X] Local Split-Screen 2 to infinity (in theory)
  - [X] Refactor to have only one main handler
- [ ] Button Remaping and dynamic action creations for players
  - [X] On Game Start : check if every player has actions, if not, prompt for the missing ones
  - [ ] On settings tab

### Polish

- [ ] SceneHandler, doing transition between scenes

- [ ] Animations
  - [ ] Spawn des joueurs au début du niveau
    - [ ] Spawn in 1 par 1
    - [ ] 3, 2, 1, GO !
  - [X] Mort d'un joueur
  - [ ] Respawn d'un joueur
  - [ ] Victoire d'un joueur
  - [ ] Défaite d'un joueur
  - [ ] Effet de caméra montrant le niveau
- [ ] Clarté
  - [ ] Ajout d'un sprite de modifier plutot que d'un texte d'ambiance
  - [ ] Ajout d'effet visuels pour certains modifiers
    - [ ] Vent
- [ ] Ajustement du Gameplay
  - [ ] Ajustement de la physique de base
  - [ ] Ajustement des probabilités de chaque chaos modifiers
  - [ ] Activation/Désactivation de stages randoms
  - [ ] Ecran de selection des stages

### Création de Stage

- [X] TileSet
  - [X] Sol
  - [X] Plateforme
  - [X] Plateforme traversable?
  - [X] Bloc 1x1
  - [X] Drapeau de fin de niveau
  - [X] Zone de Mort
  - [X] Spawnpoint
  - [X] Objectif
  - [ ] *Checkpoint*
    - [ ] Sera probablement implémenter pour test

### Stages

- [ ] Niveaux tutoriel par type de niveau
  - [X] Tutoriel course
- [ ] Au moins 10 niveaux de type course
- [ ] Au moins 10 niveaux de type arene
- [ ] *Au moins 10 niveaux de type ???*

### Chaos Modifiers

- [X] Gestionaire de Chaos
  - [X] Sélectionne aléatoirement un Modifier
  - [X] Sélectionne aléatoirement la magnitude du Modifier
  - [X] Annonce que le Chaos arrive 3 secondes avant
  - [ ] Refacto du systeme de modifiers
    - [ ] Permettre de swap des modifiers in n out
      - [ ] Reset les modifiers entre les stages
    - [ ] Permettre d'avoir un historique des modifiers

Listes des modifiers :

- [ ] Slow-Mo
- [X] Friction +-
- [X] Vitesse Maximale de Course +-
- [X] Vent Droite/Gauche
  - [X] Vent moins fort si le joueur est au sol
- [X] Gravité +-
  - [ ] Gravité doit etre <= 0 pour que les joueurs ne puisse pas s'envoler sans pouvoir retomber
- [X] Inversion des positions des joueurs
- [X] Inversion des momentums des joueurs
- [ ] *Attaque melange les controles des joueurs touchés au lieu de les stun*
  - [ ] ça n'a pas l'air si fun que ça...
- [ ] Floor is presque lava (si sur le sol + de x temps : dégats + stun)
- [ ] Effets de caméra varié : shader de flou, wavy, ascii art...
- [ ] Pluie de météores
- [ ] Pluie d'ennemis
- [ ] Bruitages rigolos

## Bugs

- [X] WorldHandler.ChaosTradeOffer() crash if there is only one player (oob access to array prob)
  - edge case handled : added a check if there is only one player available for the swap to return
- [X] Direction is conserved after respawn, even if no input is pressed
  - Flushing v_direction on death resolved the issue.
- [X] Life UI not updated after respawning
  - No signal was connected to handle this case
- [X] Character sometimes appear behind the world
  - [X] Added z-index
- [X] Dying does not update to the right portrait
  - Dying updated score, which triggered another portrait change. The score update ui callback now check the old and new score to determine if it should put the cool portrait or not