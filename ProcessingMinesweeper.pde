class MinesweeperGame {
  public static final int BOMB = -1;
  public static final int COVERED = -3;
  public static final int COVERED_AND_FLAGGED = -2;
  public static final int EMPTY = 0;
  private GameSettings gameSettings;
  private int[][] map;
  private int[][] coverMap;
  public MinesweeperGame(GameSettings gameSettings) {
    this.gameSettings = gameSettings;
    final int W = gameSettings.getWidth();
    final int H = gameSettings.getHeight();
    map = new int[W][H];
    for (int x = 0; x < W; x++) { // Clear Map
      for (int y = 0; y < H; y++) {
        map[x][y] = EMPTY;
      }
    }
    coverMap = new int[W][H];
    for (int x = 0; x < W; x++) { // Clear cover Map
      for (int y = 0; y < H; y++) {
        coverMap[x][y] = COVERED;
      }
    }
    int randX, randY;
    for (int i = 0; i < gameSettings.getMines(); i++) { // Hiding Bombs
      randX = floor(random(W));
      randY = floor(random(H));
      if (map[randX][randY] == EMPTY) {
        map[randX][randY] = BOMB;
      } else {
        i--;
      }
    }
    for (int x = 0; x < W; x++) { // Generating Numbers
      for (int y = 0; y < H; y++) {
        if (map[x][y] != BOMB) continue;
        for (int x1 = -1; x1 <= 1; x1++) { // Loop all around the bomb
          for (int y1 = -1; y1 <= 1; y1++) {
            if (x+x1 < 0 || x+x1 >= W || y+y1 < 0 || y+y1 >= H) continue; // if the suroundings are out of the map
            if (map[x+x1][y+y1] >= 0) { // if it isnt a bomb increase counter
              map[x+x1][y+y1]++;
            }
          }
        }
      }
    }
  }
  public int[][] getCompiledMap() {
    int[][] compiledMap = map.clone();
    for (int x = 0; x < getWidth(); x++) {
      for (int y = 0; y < getHeight(); y++) {
        if (coverMap[x][y] == COVERED || coverMap[x][y] == COVERED_AND_FLAGGED) compiledMap[x][y] = coverMap[x][y];
      }
    }
    return compiledMap;
  }
  public int getWidth() {
    return gameSettings.getWidth();
  }
  public int getHeight() {
    return gameSettings.getHeight();
  }
}

public class GameSettings {
  //public static final BEGINNER = new GameSettings(9, 9, 10);
  private int width, height, mines;
  public GameSettings(int width, int height, int mines) {
    this.width = max(3, width);
    this.height = max(3, height);
    this.mines = min(max(1, mines), width*height);
  }
  public int getWidth() { return width; }
  public int getHeight() { return height; }
  public int getMines() { return mines; }
}

void colorForNumber(int i) {
  switch (i) {
    case 1:
      fill(0, 0, 255);
      break;
    case 2:
      fill(0, 129, 0);
      break;
    case 3:
      fill(255, 19, 0);
      break;
    case 4:
      fill(0, 0, 131);
      break;
    case 5:
      fill(129, 5, 0);
      break;
    case 6:
      fill(42, 148, 148);
      break;
    case 7:
      fill(0, 0, 0);
      break;
    case 8:
      fill(128, 128, 128);
      break;
    default:
      break;
  }
}

void renderGame(MinesweeperGame game) {
  final int GRID_SIZE = 20;
  int[][] map = game.getCompiledMap();
  textSize(15);
  textAlign(CENTER);
  for (int x = 0; x < game.getWidth(); x++) {
    for (int y = 0; y < game.getHeight(); y++) {
      if (map[x][y] == MinesweeperGame.BOMB) fill(255, 0, 0);
      else if (map[x][y] == MinesweeperGame.COVERED) fill(128);
      else if (map[x][y] == MinesweeperGame.COVERED_AND_FLAGGED) fill(0, 128, 0);
      else fill(255);
      rect(x*GRID_SIZE, y*GRID_SIZE, GRID_SIZE, GRID_SIZE);
      if (map[x][y] > 0) {
        colorForNumber(map[x][y]);
        text(Integer.toString(map[x][y]), x*GRID_SIZE, y*GRID_SIZE, GRID_SIZE, GRID_SIZE);
      }
    }
  }
}

MinesweeperGame game;
void setup() {
  size(400, 400);
  background(255);
  stroke(0);
  game = new MinesweeperGame(new GameSettings(9, 9, 10));
  renderGame(game);
}

void draw() {
}

void mousePressed() {
  game = new MinesweeperGame(new GameSettings(9, 9, 10));
  renderGame(game);
}
