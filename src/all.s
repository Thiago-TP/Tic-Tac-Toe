#####################################################################################
#	This file imports all functions and sprites necessary for the running of main.s #
#####################################################################################
.data
    .include "../sprites/CHAR_TABLE.data"

    .include "../sprites/tiles/CURSOR.data"
    .include "../sprites/tiles/SMALL_CURSOR.data"
    .include "../sprites/tiles/SMALL_CURSOR_HUSK.data"
    .include "../sprites/tiles/O_SYMBOL.data"
    .include "../sprites/tiles/X_SYMBOL.data"
    .include "../sprites/tiles/SQUARE.data"

    .include "../sprites/shells/GREEN_SHELL.data"
    .include "../sprites/shells/RED_SHELL.data"
    .include "../sprites/shells/SPIKY_SHELL.data"

    .include "../sprites/decorations/BOWSER.data"
    .include "../sprites/decorations/MARIO.data"
    .include "../sprites/decorations/PEACH.data"
    .include "../sprites/decorations/SMALL_BOWSER.data"
    .include "../sprites/decorations/SMALL_MARIO.data"

.text
    .include "../functions/AIs/EASY_AI.s"
    .include "../functions/AIs/MEDIUM_AI.s"
    .include "../functions/AIs/HARD_AI.s"
    .include "../functions/AIs/MAKE_OR_BLOCK_TRIPLE.s"

    .include "../functions/misc/INITIALIZE_BOARD.s"
    .include "../functions/misc/INITIALIZE_VARIABLES.s"
    .include "../functions/misc/CHECK_END.s"

    .include "../functions/prints/BLACK_SCREEN.s"
    .include "../functions/prints/MARK_SQUARE.s"
    .include "../functions/prints/PRINT_BOARD_SCREEN.s"
    .include "../functions/prints/PRINT_CHAR.s"
    .include "../functions/prints/PRINT_DIFFICULTY_SCREEN.s"
    .include "../functions/prints/PRINT_END_SCREEN.s"
    .include "../functions/prints/PRINT_STRING.s"
    .include "../functions/prints/PRINT_SYMBOL_SCREEN.s"
    .include "../functions/prints/PRINT.s"
    .include "../functions/prints/RETURN_BACKGROUND.s"
    .include "../functions/prints/STASH_BACKGROUND.s"
    .include "../functions/prints/SHOW_SCORES.s"

    .include "../functions/turns_and_choices/CHOOSE_DIFFICULTY.s"
    .include "../functions/turns_and_choices/CHOOSE_SYMBOL.s"
    .include "../functions/turns_and_choices/PLAYER_TURN.s"
    .include "../functions/turns_and_choices/PC_TURN.s"
    .include "../functions/turns_and_choices/END_SCREEN.s"
