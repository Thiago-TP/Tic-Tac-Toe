#########################################################################################
#	This file imports all functions and sprites necessary for the running of new_main.s #
#########################################################################################
.data
    .include "../new_sprites/CHAR_TABLE.data"
    .include "../new_sprites/SQUARE.data"
    .include "../new_sprites/CURSOR.data"
    .include "../new_sprites/O_SYMBOL.data"
    .include "../new_sprites/X_SYMBOL.data"

    .include "../new_sprites/bowserzin.data"
    .include "../new_sprites/mariozin.data"

.text
    .include "../new_functions/BLACK_SCREEN.s"
    .include "../new_functions/CHOOSE_DIFFICULTY.s"
    .include "../new_functions/CHOOSE_SYMBOL.s"
    .include "../new_functions/INITIALIZE_BOARD.s"
    .include "../new_functions/INITIALIZE_VARIABLES.s"
    .include "../new_functions/PRINT_BOARD.s"
    .include "../new_functions/PRINT_CHAR.s"
    .include "../new_functions/PRINT_STRING.s"
    .include "../new_functions/PRINT_SYMBOL_SCREEN.s"
    .include "../new_functions/PRINT.s"
