#########################################################################################
#	This file imports all functions and sprites necessary for the running of new_main.s #
#########################################################################################
.data
    .include "../new_sprites/CHAR_TABLE.data"

    .include "../new_sprites/CURSOR.data"
    .include "../new_sprites/SMALL_CURSOR.data"
    .include "../new_sprites/SMALL_CURSOR_HUSK.data"

    .include "../new_sprites/O_SYMBOL.data"
    .include "../new_sprites/X_SYMBOL.data"
    .include "../new_sprites/SQUARE.data"

    .include "../new_sprites/GREEN_SHELL.data"
    .include "../new_sprites/RED_SHELL.data"
    .include "../new_sprites/SPIKY_SHELL.data"

    .include "../new_sprites/SMALL_BOWSER.data"
    .include "../new_sprites/SMALL_MARIO.data"

    .include "../new_sprites/BOWSER.data"
    .include "../new_sprites/MARIO.data"
    .include "../new_sprites/PEACH.data"

.text
    .include "../new_functions/BLACK_SCREEN.s"

    .include "../new_functions/CHECK_END.s"

    .include "../new_functions/CHOOSE_DIFFICULTY.s"
    .include "../new_functions/CHOOSE_SYMBOL.s"
    .include "../new_functions/END_SCREEN.s"

    .include "../new_functions/EASY_AI.s"
    .include "../new_functions/MEDIUM_AI.s"
    .include "../new_functions/HARD_AI.s"

    .include "../new_functions/INITIALIZE_BOARD.s"
    .include "../new_functions/INITIALIZE_VARIABLES.s"

    .include "../new_functions/MAKE_OR_BLOCK_TRIPLE.s"

    .include "../new_functions/MARK_SQUARE.s"

    .include "../new_functions/PLAYER_TURN.s"
    .include "../new_functions/PC_TURN.s"

    .include "../new_functions/PRINT_BOARD_SCREEN.s"
    .include "../new_functions/PRINT_CHAR.s"
    .include "../new_functions/PRINT_DIFFICULTY_SCREEN.s"
    .include "../new_functions/PRINT_END_SCREEN.s"
    .include "../new_functions/PRINT_STRING.s"
    .include "../new_functions/PRINT_SYMBOL_SCREEN.s"
    .include "../new_functions/PRINT.s"

    .include "../new_functions/RETURN_BACKGROUND.s"
    .include "../new_functions/STASH_BACKGROUND.s"
    .include "../new_functions/SHOW_SCORES.s"
