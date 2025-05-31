#include "state.h"

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "snake_utils.h"

/* Helper function definitions */
static void set_board_at(game_state_t *state, unsigned int row, unsigned int col, char ch);
static bool is_tail(char c);
static bool is_head(char c);
static bool is_snake(char c);
static char body_to_tail(char c);
static char head_to_body(char c);
static unsigned int get_next_row(unsigned int cur_row, char c);
static unsigned int get_next_col(unsigned int cur_col, char c);
static void find_head(game_state_t *state, unsigned int snum);
static char next_square(game_state_t *state, unsigned int snum);
static void update_tail(game_state_t *state, unsigned int snum);
static void update_head(game_state_t *state, unsigned int snum);
static bool inRange(char c, char * range); 

/* Task 1 */
game_state_t *create_default_state() {
  // TODO: Implement this function.
  game_state_t * default_state = malloc(sizeof(game_state_t));
  if(!default_state){
    fprintf(stderr, "malloc default_state fail\n");
    exit(1);
  }
    
  default_state->num_rows = 18;
  // Fix the boad filed
  size_t row = 18;
  size_t column = 20;

  // 分配指针数组
  char **strs = malloc(sizeof(char*) * row);
  // Abort： 因为要对每个字符串单独进行free操作，不能分配一整块内存
  // 分配一整块内存，包含 18 个字符串，每个 20 个字节, 最后加一个以存放'/0', 再后面一个存放换行符
  // char *block = malloc(sizeof(char) * row * (column + 2));

  for(size_t i = 0; i < row; i++){
    strs[i] = malloc(sizeof(char) * (column + 2));  // +1 for '\n' and +1 for '\0'
  }
  strcpy(strs[0], "####################\n");
  strcpy(strs[row - 1], "####################\n");
  
  for(size_t i = 1; i < row - 1; i++){
    strcpy(strs[i], "#                  #\n");
  };
  strcpy(strs[2], "# d>D    *         #\n");
  default_state->board = strs;

  snake_t * default_snake = malloc(sizeof(snake_t));
  if(!default_snake){
    fprintf(stderr, "malloc default_snake fail\n");
    exit(1);
  }
  default_state->num_snakes = 1;
  default_snake->tail_row = 2;
  default_snake->tail_col = 2;
  default_snake->head_col = 4;
  default_snake->head_row = 2;
  default_snake->live = true;

  default_state->snakes = malloc(sizeof(snake_t));
    if(!default_state->snakes){
    fprintf(stderr, "malloc snake array fail\n");
    exit(1);
  }
  default_state->snakes[0] = *default_snake;
  free(default_snake);
  return default_state;
}

/* Task 2 */
void free_state(game_state_t *state) {
  // TODO: Implement this function.
  free(state->snakes);
  if (state->board) {
    for(size_t i = 0; i < state->num_rows; i++){
      free(state->board[i]);
    }
    free(state->board);     // 释放指针数组
  }
  free(state);
  return;
}

/* Task 3 */
void print_board(game_state_t *state, FILE *fp) {
  // TODO: Implement this function.
  char **board = state->board;
  for(int i = 0; i < state->num_rows; i++){
    fprintf(fp, "%s", board[i]);
  }
}

/*
  Saves the current state into filename. Does not modify the state object.
  (already implemented for you).
*/
void save_board(game_state_t *state, char *filename) {
  FILE *f = fopen(filename, "w");
  print_board(state, f);
  fclose(f);
}

/* Task 4.1 */

/*
  Helper function to get a character from the board
  (already implemented for you).
*/
char get_board_at(game_state_t *state, unsigned int row, unsigned int col) { return state->board[row][col]; }

/*
  Helper function to set a character on the board
  (already implemented for you).
*/
static void set_board_at(game_state_t *state, unsigned int row, unsigned int col, char ch) {
  state->board[row][col] = ch;
}

/*
  Returns true if c is part of the snake's tail.
  The snake consists of these characters: "wasd"
  Returns false otherwise.
*/
static bool is_tail(char c) {
  // TODO: Implement this function.
  return inRange(c, "wasd");
}

/*
  Returns true if c is part of the snake's head.
  The snake consists of these characters: "WASDx"
  Returns false otherwise.
*/
static bool is_head(char c) {
  // TODO: Implement this function.
  return inRange(c, "WASDx");
}

/*
  Returns true if c is part of the snake.
  The snake consists of these characters: "wasd^<v>WASDx"
*/
static bool is_snake(char c) {
  // TODO: Implement this function.
  return inRange(c, "wasd^<v>WASDx");
}

// Returns true if c is in the range
// static bool inRange(char c, char * range){
//   for(int i = 0; i < strlen(range); i++){
//     if(c == range[i])
//       return true;
//   }
//   return false;
// }
static bool inRange(char c, char *range) {
    if (range == NULL) return false;
    while (*range != '\0') {
        if (c == *range) return true;
        range++;
    }
    return false;
}

/*
  Converts a character in the snake's body ("^<v>")
  to the matching character representing the snake's
  tail ("wasd").
*/
static char body_to_tail(char c) {
  // TODO: Implement this function.
  switch(c){
        case '^': return 'w';
        case '<': return 'a';
        case 'v': return 's';
        case '>': return 'd';
        default: return '?';  
  }
}

/*
  Converts a character in the snake's head ("WASD")
  to the matching character representing the snake's
  body ("^<v>").
*/
static char head_to_body(char c) {
    switch (c) {
        case 'W': return '^';
        case 'A': return '<';
        case 'S': return 'v';
        case 'D': return '>';
        default: return '?';
    }
}

/*
  Returns cur_row + 1 if c is 'v' or 's' or 'S'.
  Returns cur_row - 1 if c is '^' or 'w' or 'W'.
  Returns cur_row otherwise.
*/
static unsigned int get_next_row(unsigned int cur_row, char c) {
  // TODO: Implement this function.
  if(inRange(c, "vsS"))
    return cur_row + 1;
  else if (inRange(c, "^wW"))
  {
    return cur_row - 1;
  }
  return cur_row;
}

static unsigned int get_previous_row(unsigned int cur_row, char c) {
  // TODO: Implement this function.
  if(inRange(c, "vsS"))
    return cur_row - 1;
  else if (inRange(c, "^wW"))
  {
    return cur_row + 1;
  }
  return cur_row;
}

/*
  Returns cur_col + 1 if c is '>' or 'd' or 'D'.
  Returns cur_col - 1 if c is '<' or 'a' or 'A'.
  Returns cur_col otherwise.
*/
static unsigned int get_next_col(unsigned int cur_col, char c) {
  // TODO: Implement this function.
  if(inRange(c, ">dD"))
    return cur_col + 1;
  else if (inRange(c, "<aA"))
  {
    return cur_col - 1;
  }
  return cur_col;
}

static unsigned int get_previous_col(unsigned int cur_col, char c) {
  // TODO: Implement this function.
  if(inRange(c, ">dD"))
    return cur_col - 1;
  else if (inRange(c, "<aA"))
  {
    return cur_col + 1;
  }
  return cur_col;
}
/*
  Task 4.2

  Helper function for update_state. Return the character in the cell the snake is moving into.

  This function should not modify anything.
*/
static char next_square(game_state_t *state, unsigned int snum) {
  // TODO: Implement this function.
  snake_t snake = state->snakes[snum];
  char headChr = get_board_at(state, snake.head_row, snake.head_col);
  unsigned int next_row = get_next_row(snake.head_row, headChr);
  unsigned int next_col = get_next_col(snake.head_col, headChr);
  return get_board_at(state, next_row, next_col);
}

/*
  Task 4.3

  Helper function for update_state. Update the head...

  ...on the board: add a character where the snake is moving

  ...in the snake struct: update the row and col of the head

  Note that this function ignores food, walls, and snake bodies when moving the head.
*/
static void update_head(game_state_t *state, unsigned int snum) {
  // TODO: Implement this function.
  snake_t snake = state->snakes[snum];
  char headChr = get_board_at(state, snake.head_row, snake.head_col);
  unsigned int next_row = get_next_row(snake.head_row, headChr);
  unsigned int next_col = get_next_col(snake.head_col, headChr);
  set_board_at(state, snake.head_row, snake.head_col, head_to_body(headChr));
  set_board_at(state, next_row, next_col, headChr);
  state->snakes[snum].head_row = next_row;
  state->snakes[snum].head_col = next_col;
}

/*
  Task 4.4

  Helper function for update_state. Update the tail...

  ...on the board: blank out the current tail, and change the new
  tail from a body character (^<v>) into a tail character (wasd)

  ...in the snake struct: update the row and col of the tail
*/
static void update_tail(game_state_t *state, unsigned int snum) {
  // TODO: Implement this function.
  snake_t snake = state->snakes[snum];
  char tailChr = get_board_at(state, snake.tail_row, snake.tail_col);
  unsigned int next_row = get_next_row(snake.tail_row, tailChr);
  unsigned int next_col = get_next_col(snake.tail_col, tailChr);
  char nextChr = get_board_at(state, next_row, next_col);
  set_board_at(state, next_row, next_col, body_to_tail(nextChr));
  set_board_at(state, snake.tail_row, snake.tail_col, ' ');
  state->snakes[snum].tail_row = next_row;
  state->snakes[snum].tail_col = next_col;
}

/* Task 4.5 */
void update_state(game_state_t *state, int (*add_food)(game_state_t *state)) {
  // TODO: Implement this function.
  for(unsigned int i = 0; i < state->num_snakes; i++){
    switch (next_square(state, i))
    {
      case ' ':
        update_head(state, i);
        update_tail(state, i);
        break;
      case '*':
        update_head(state, i);
        add_food(state);
        break;
      case '#':
          set_board_at(state, state->snakes[i].head_row, state->snakes[i].head_col, 'x');
          state->snakes[i].live = false;
          break;
      default:
        if(is_snake(next_square(state, i))){
          set_board_at(state, state->snakes[i].head_row, state->snakes[i].head_col, 'x');
          state->snakes[i].live = false;
          break;
        }
    }
  }
  
}

/* Task 5.1 */
char *read_line(FILE *fp) {
  // TODO: Implement this function.
  size_t default_size = 30;
  char * buffer = malloc(default_size);
  if (!buffer) return NULL;
  if (!fgets(buffer, (int)default_size, fp)) {
      free(buffer);
      return NULL;
  }

  while(strchr(buffer, '\n') == NULL){
    default_size *= 2;
    buffer = realloc(buffer, default_size);
    if (!buffer) return NULL;
    if(!fgets(buffer + strlen(buffer), (int)(default_size - strlen(buffer)), fp)){
      if (feof(fp)) {
        break;
      } 
      else {
        free(buffer);
        return NULL;
      }
    }
  }
  return buffer;
}

/* Task 5.2 */
game_state_t *load_board(FILE *fp) {
  // TODO: Implement this function.
  game_state_t * state = malloc(sizeof(game_state_t));
  if(state == NULL){
    return NULL;
  }
  state->num_snakes = 0;
  state->snakes = NULL;
  size_t default_rows = 20;
  char ** board = malloc(sizeof(char *) * default_rows);
  int i = 0;
  char * line;
  while ((line = read_line(fp)) != NULL)
  {
    board[i] = line;
    i ++;
    if(i == default_rows){
      default_rows *= 2;
      char ** expand_board = realloc(board, sizeof(char *) * default_rows);
      if(!expand_board){
        for(int k = 0; k < i; k++){
          free(board[k]);
        }
        free(board);
        return NULL;
      }
      board = expand_board;
    }
  }
  state->board = board;
  state->num_rows = (unsigned int)i;
  return state;
}

/*
  Task 6.1

  Helper function for initialize_snakes.
  Given a snake struct with the tail row and col filled in,
  trace through the board to find the head row and col, and
  fill in the head row and col in the struct.
*/
static void find_head(game_state_t *state, unsigned int snum) {
  // TODO: Implement this function.
  unsigned int curr_row = state->snakes[snum].tail_row;
  unsigned int curr_col = state->snakes[snum].tail_col;
  char current = get_board_at(state, curr_row, curr_col);

  while (!is_head(current)) {
    curr_row = get_next_row(curr_row, current);
    curr_col = get_next_col(curr_col, current);
    current = get_board_at(state, curr_row, curr_col);
  }
  
  state->snakes[snum].head_row = curr_row;
  state->snakes[snum].head_col = curr_col;
  return;
}

// arg: snake is a snake_t struct whose filed about tail has not been filled yet.
// this function is to fill these filed
// static void find_tail(game_state_t *state, snake_t *snake){
//     unsigned int curr_row = snake->head_row;
//     unsigned int curr_col = snake->head_col;
//     char curr_chr;

//     while (!is_tail(curr_chr = get_board_at(state, curr_row, curr_col))) {
//         curr_row = get_previous_row(curr_row, curr_chr);
//         curr_col = get_previous_col(curr_col, curr_chr);
//     }

//     snake->tail_row = curr_row;
//     snake->tail_col = curr_col;
// }


// get the previous body part of a snake


/* Task 6.2 */
game_state_t *initialize_snakes(game_state_t *state) {
  // TODO: Implement this function.
  int snake_num = 0;
    for(int i = 0; i < state->num_rows; i++){
    for(int j = 0; j < strlen(state->board[i]); j++){
      if(is_head(state->board[i][j])){
        snake_num += 1;
      }
    }
  }

  snake_t* snakes = malloc(sizeof(snake_t) * (size_t)snake_num);
  state->snakes = snakes;
  state->num_snakes = (unsigned int)snake_num;
  int i = 0;

  for (unsigned int row = 0; row < state->num_rows; row++) {
    for (unsigned int col = 0; col < strlen(state->board[row]); col++) {
      char current = get_board_at(state, row, col);
      if (is_tail(current)) {
        state->snakes[i].tail_row = row;
        state->snakes[i].tail_col = col;
        state->snakes[i].live = true;
        find_head(state, (unsigned int)i);
        i++;
      }
    } 
  }
  return state;
}
