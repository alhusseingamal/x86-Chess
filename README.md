# x86-Chess
A No-turn Speed Chess Game implemented in x86 Assembly, supporting in-game chatting as well as separate Chat module.  

The game is a replication of a game called [Chezz](https://play.google.com/store/apps/details?id=com.quickbytegames.chezz&hl=en&gl=US&pli=1) available on the app store.

Two players can player either on the same device, or on different devices connected over over a network, through either a wired or wireless connection.  

## Keys:
The first player uses:  
the arrow keys to navigate:
- `↑`: Move up  
- `↓`: Move down  
- `←`: Move left  
- `→`: Move right  
- 'Enter': Pick and move pieces  

The second player uses:  
- `W`: Move up  
- `S`: Move down  
- `A`: Move left  
- `D`: Move right  
- 'Q': Pick and move pieces

### At the start of the game, each player is prompted to enter his name.

![Initial Screen](https://github.com/alhusseingamal/x86-Chess/blob/main/screenshots/initial%20screen.jpeg)

### A player can send/receive a game invitation as well as a chat invitation:  
- `F1`: To send/accept a chat invitation  
- `F2`: To send/accept a game invitation  
- `ESC`: To Exit the game or exit the whole app.

![Menu](https://github.com/alhusseingamal/x86-Chess/blob/main/screenshots/menu.jpeg)

## GamePlay:

### The known initial chess setup
![Initial Setup](https://github.com/alhusseingamal/x86-Chess/blob/main/screenshots/initial%20setup.jpeg)

### Midgame with the pieces eliminated from each player, in addition to the game timer shown to the left.
![Initial Setup](https://github.com/alhusseingamal/x86-Chess/blob/main/screenshots/game.jpeg)
