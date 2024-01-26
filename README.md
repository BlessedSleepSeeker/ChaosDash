# globalgamejam2024

Global Game Jam 2024 Submission

Make Me Laught !

## Idea

> incarne le bouffon à la cour
> faire des pranks
> jeu créateur de rigolade (gang beasts/lethal company style)
> comique de gestes : qwop style
> comique de situation/imprévu : warioware
> comique de mots : speedtyping les blagues de bigard

Un platformer où tout est exagéré :
- slide comme luigi lors de changement de direction

platformer compétitif split screen multi où des events randoms arrivent qui viennent mettre le chaos dans le jeu :

objectif : arriver en premier au bout

## Features

### Platforming 2D de base & sa physique

- Personnage joueur
- Idle
- Course
- Saut
- Attaque : projectile physique qui annule le momentum (sous cooldown) mais qui peut se faire sauter dessus
- friction au sol
- aerial drift
- fast fall

### Stage

- sol
- plateforme
- plateforme traversable?
- bloc?
- ennemi de base
- projectile
- trou

### Bordel

- Annonce du bordel 3 secondes avant qu'il arrive.
- le bordel ne disparait pas et se stack petit à petit.

- slow-mo
- on ice
- vent fort
- pluie d'enemi
- inversion des positions des joueurs
- attaque melange les controles des joueurs touchés au lieu de les stun
- floor is chaud (si sur le sol + de x temps : stun)
- effets de caméra varié : shader de flou, wavy, ascii art...
- bruitages rigolos