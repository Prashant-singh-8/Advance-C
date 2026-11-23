




# ASCII Farming Simulator

A complete, playable farming game for the terminal, written in **pure C99**
(standard library + POSIX `termios` for raw keyboard input and ANSI colours).

## Build & run

```sh
make          # builds ./farm  (needs any C compiler: gcc, clang, cc)
./farm        # or: make run
```

Works on Linux, macOS and Windows via WSL. The terminal must be at least
**80 x 28** characters and support ANSI colours (almost all do).
Compiles with zero warnings under `-std=c99 -Wall -Wextra -pedantic`.

## Goal

Reach **$10,000** or **farming level 10** within **84 days** (3 years) to become
a Master Farmer. After winning you may keep playing until day 84.

## Controls

| Key | Action |
|-----|--------|
| `W A S D` / arrows | Move (also turns you to face a tile) |
| `X` | Till grass into soil (hoe) |
| `P` | Plant the selected seed |
| `R` | Water a crop |
| `H` | Harvest a ripe crop / clear a dead one |
| `F` | Fertilize (+1 growth day) |
| `E` | Interact: door (sleep), market, chest, pond (refill can), tree (chop); otherwise uses the current tool |
| `T` | Cycle tool |
| `1`-`6` / `G` | Select seed |
| `B` | Open shop (stand next to `$`) |
| `C` | Open chest (stand next to `C`) |
| `I` | Inventory & crop guide |
| `N` | Sleep / end the day |
| `Esc` | Pause menu (save, load, help, quit) |
| `Q` | Quit to main menu |
| `?` | Help |

Your original key list reused `W`, `S` and `H` for two jobs each, so **Water is `R`**
and **Shop is `B`**. Actions apply to the tile you are *facing* (highlighted).

## Systems

- **Map**: 80x40 world with scrolling camera: farmhouse, fenced field with 3 gates,
  pond, forest, market, storage yard with chest, paths, wandering chickens.
- **Crops**: wheat, carrot, potato, tomato, corn, pumpkin; each has its own growth time,
  prices, level requirement and seasons. Tomato and corn keep producing after harvest.
  Stages: `s` seedling, `y` sprout, `Y` growing, `F` ripe, `x` dead.
- **Watering**: crops grow one day per night only if watered; 3 dry days kills them.
  Rain, storms and snow water everything for free (and fill your can).
- **Time**: 06:00 to 02:00 each day; every action costs minutes. Night dims the map.
  Collapse at 02:00 and a neighbour carries you home for a fee.
- **Energy**: every action costs energy; sleep in your own bed to fully recover.
  Energy tonics are sold at the market.
- **Weather and seasons**: season-dependent forecast one day ahead; seasons change every
  7 days; unripe crops unsuited to the new season die.
- **Economy**: daily price fluctuation (85-125%), harvest fairs (+25%), wood selling,
  bigger watering cans, fertilizer.
- **Progression**: XP from harvesting, levels unlock seeds and raise max energy,
  bonus-yield chance grows with level.
- **Random events**: crows, traveller gifts, harvest fair, neighbour seed gifts, storms.
- **Save/load**: autosave every night, manual save/load from the pause menu
  (`farm_save.dat`), "Continue" on the title screen.

## Architecture

```
src/
  types.h      shared enums/structs: Tile, Farm, Player, Inventory, Weather, GameState
  crop.c/.h    crop data table, growth stages (add a crop = add one table row)
  farm.c/.h    map generation, tile actions, nightly growth, rain/storm/frost/crows
  player.c/.h  movement, facing, level and energy formulas
  inventory.c  backpack/chest bookkeeping + chest menu
  shop.c/.h    market buy/sell logic and menu
  save.c/.h    binary save with magic/version/size header
  ui.c/.h      ALL terminal I/O: raw input, buffered ANSI rendering, popups, menus
  game.c/.h    coordinator: clock, sleeping, weather, events, actions, main loop
  main.c       title menu and program entry
```

Data flow: `main` -> `game_run` loop -> `ui_get_key` -> `game_handle_key` -> action
functions -> `farm_*` / `player_*` / `inv_*` -> `ui_render_game`.
Only `ui.c` touches the terminal; `farm`, `crop`, `player` and `inventory` logic has no I/O.
`GameState` contains no pointers, so saving is a single `fwrite`.
