import de.bezier.guido.*;
private static final int NUM_ROWS= 5;
private static final int NUM_COLS= 5;//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
   
    // make the manager
    Interactive.make( this );
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int r = 0; r < NUM_ROWS; r+=1){
      for(int c = 0; c <NUM_COLS; c+=1){
        buttons[r][c] = new MSButton(r,c);
      }
    }
    setMines();
}
public void setMines()
{
    while (mines.size() < (NUM_ROWS * NUM_COLS) / 5) {
        int r = (int) (Math.random() * NUM_ROWS);
        int c = (int) (Math.random() * NUM_COLS);
        MSButton button = buttons[r][c];
        if (!mines.contains(button)) {
            mines.add(button);
        }
    }
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
    for (int row = 0; row < NUM_ROWS; row++) {
        for (int col = 0; col < NUM_COLS; col++) {
            if (!mines.contains(buttons[row][col]) && !buttons[row][col].clicked) {
                return false;
            }
        }
    }
    return true;
}
public void displayLosingMessage()
{
    for (int i = 0; i < mines.size(); i++) {
        mines.get(i).setLabel("X");
    }
    textSize(32);
    fill(255,0,0);
    text("LOSS", 200,200);
    break;
}
public void displayWinningMessage()
{
    for (int row = 0; row < NUM_ROWS; row++) {
        for (int col = 0; col < NUM_COLS; col++) {
            buttons[row][col].setLabel("WIN");
        }
    }
    textSize(32);
    fill(255,255,0);
    text("WIN", 200,200);
    break;
}
public boolean isValid(int r, int c)
{
    if(r < NUM_ROWS && r >= 0 && c < NUM_COLS && c >= 0){
      return true;
     }  
    return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for(int r = row-1;r<=row+1;r++){
      for(int c = col-1; c<=col+1;c++){
        if(isValid(r,c) && mines.contains(buttons[r][c])){
          numMines++;
  //if(mines.contains(buttons[row][col])){
  //  numMines--;
  //}
        }
      }
    }
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
   
    public MSButton ( int row, int col )
    {
         width = 400/NUM_COLS;
         height = 400/NUM_ROWS;
        myRow = row;
        myCol = col;
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed ()
    {
        clicked = true;
        if(mouseButton == RIGHT){
          flagged = !flagged;
          if(flagged == false){
            clicked = false;
          }
        }
        else if(mines.contains(this)){
          displayLosingMessage();
        }
        else if(countMines(myRow, myCol) >= 0){
          setLabel(countMines(myRow, myCol));
        }
        else{
          for (int i = -1; i <= 1; i++) {
                    for (int j = -1; j <= 1; j++) {
                        int newRow = myRow + i;
                        int newCol = myCol + j;
                        if (isValid(newRow, newCol) && !buttons[newRow][newCol].clicked) {
                            buttons[newRow][newCol].mousePressed();
                        }
                    }
                }
        }
    }
    public void draw ()
    {    
        if (flagged)
            fill(0);
         else if( clicked && mines.contains(this) )
             fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
