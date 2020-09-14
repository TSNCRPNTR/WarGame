//Maybe use for sorting?
//USE FOR SHUFFLING and sorting?
import java.util.Collections;

int test = -1;



//**************** SETTING UP THE BACKGROUND/DRAWING SETTINGS/MAKING THE DECK/SHUFFLING IT ****************//

void setup() {
  //Background setup
  size(1500, 750);
  //Makes deck
  createMainDeck();
  //Debug
  print(mainDeck.size());
  //Shuffles main deck
  Collections.shuffle(mainDeck);
  textAlign(CENTER);
  deal();
}

//**************** MAKING THE INITIAL CLASS ****************//

//Making the draggable card variables :3
float easex = 1450;
float easey = 675;
float easing = 0.05;

public class Card {
  //setting properties
  String val;
  int pts;
  boolean faceUp;
  String cardSuit;
  color cardColor;
  String suitIcon;
  String team;

  //Take parameters, make a card.
  Card(String value, int points, boolean fUp, String suit, color col, String icon, String cardTeam) {
    val = value;
    pts = points;
    faceUp = fUp;
    cardSuit = suit;
    cardColor = col;
    suitIcon = icon;
    team = cardTeam;
  }
}

public class Deck {
  String title;
}

//**************** MAKE DECK ARRAY ****************//

void createMainDeck() {
  //Make an array for the deck
  //Set some helper arrays
  String [] cardValue = {"2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"};
  String [] cardIcon = {"♠", "♥", "◆", "♣"};
  color [] cardColor = {color(0), color(255, 0, 0), color(255, 0, 0), color(0)};
  String [] cardSuit = {"Spades", "Heart", "Diamond", "Clubs"};

  //Yeah we looping, keep scrolling
  for (int i = 0; i<4; i++) {        //Suit Loop
    for (int k = 0; k<13; k++) {        //Value Loop
      Card tempCard = new Card(cardValue[k], k, false, cardSuit[i], cardColor[i], cardIcon[i], null);
      //mainDeck = (Card[])  append(mainDeck, tempCard);
      mainDeck.add(tempCard);
    }
  }
}

//Empty array w/ no cards
//Card[] mainDeck = {}; <<-- dumb baby array, can't even add or remove elements from a given temp var location (i think)

//BETTER STRONGER (a little slower) BUT WITH EASIER ADDITION AND REMOVAL SO IT KINDA EVENS OUT
//THE CHAD ARRAYLIST
ArrayList<Card> mainDeck = new ArrayList<Card>();
ArrayList<Card> p1Draw = new ArrayList<Card>();
ArrayList<Card> p1Disco = new ArrayList<Card>();
ArrayList<Card> p2Draw = new ArrayList<Card>();
ArrayList<Card> p2Disco = new ArrayList<Card>();
ArrayList<Card> combat = new ArrayList<Card>();
ArrayList<Card> holding = new ArrayList<Card>();

//**************** MAIN FUNCTIONS ****************//

//Keeps updating the whole time
void draw() {
  //Refreshes background each frame
  background(175, 220, 175);

  //Draws the remaining cards in each deck (including combat?)
  //As in it makes them show up on screen, not draws into hand
  if(endCheck()||test != -1){
  drawDecks();

  //Checks to see if p2 (comp) needs to go
  p2TurnStart();

  //Checks to see if card can be dragged
  dragCheck();

  //Checks to see if the button can be placed
  buttonCheck();
  } else {
    if(p1Disco.size()>p2Disco.size()||test == 1){
      fill(0, 0, 255);
      textSize(30);
      textAlign(CENTER);
      text("YOU WIN",750,375);
    } else if (p1Disco.size()>p2Disco.size()||test == 2){
      fill(255, 0, 0);
      textSize(30);
      textAlign(CENTER);
      text("YOU LOSE",750,375);
    }
  }
}

void keyReleased() {
  //Deals the deck with 'q' key
  if (key == 'q') {
    debugLength();
    test = 1;
  }
}

//Checks to see where ya click. If you click on a button's x and y range, you activate the button.
boolean dragging = false;
void mouseClicked() {
  //The deck. Sets a drag var to true
  if (mouseX > 1350 && mouseY > 575) {
    easex = 1450;
    easey = 675;
    dragging = true;
    //the center, only activates if drag is true (you dragging a card)
  } else if (mouseX > 600 && mouseX < 900 && mouseY > 375 && mouseY < 575 && dragging == true) {
    dragging = false;
    Card temp = p1Draw.get(0);
    combat.add(temp);
    p1Draw.remove(0);
    debugLength();
  } else if (mouseX > 900 && mouseX < 1000 && mouseY > 300 && mouseY < 350 && buttonThere == true) {
    if (flipCard) {
      resolve();
      flipCard = false;
    } else {
      flipCard = true;
      print(combat.get(0).val + " of " +combat.get(0).cardSuit + " vs: ");
      print(combat.get(1).val + " of " +combat.get(1).cardSuit);
    }
  }
}

//**************** SUPPLEMENTAL FUNCTIONS ****************//

//Draws a card at a location (like drawing, not making a smaller deck)
void makeCard(float x, float y, boolean fUp, ArrayList<Card> from, int loc) {
  stroke(0, 0, 0);
  strokeWeight(1);
  if (fUp) {
    fill(255, 255, 255);
  } else {
    fill(106, 106, 106);
  }
  rect(x, y, 100, 140, 7);
  if (fUp) {
    textSize(24);
    fill(0, 0, 0);
    textAlign(CENTER);
    //int card = int(random(from.size()));
    int card = loc;
    if (from.get(card).suitIcon == "♥" || from.get(card).suitIcon == "◆") {
      fill(255, 0, 0);
    }
    text(from.get(card).val + "\n" + from.get(card).suitIcon, x+50, y+50);
  }
} 

//Deals cards out
void deal() {
  for (int i = 51; i > -1; i--) {
    if (i%2 == 0 || i==0) {
      mainDeck.get(i).team = "p1";
      Card temp = mainDeck.get(i);
      p1Draw.add(temp);
      mainDeck.remove(i);
    } else {
      mainDeck.get(i).team = "p2";
      Card temp2 = mainDeck.get(i);
      p2Draw.add(temp2);
      mainDeck.remove(i);
    }
  }
}

//Use check as an all-purpose checker, or use it for checking combat length, p1 length, p2 length all individually (seperate functions)
//Just checks to see if p2 should drop a card
void p2TurnStart() {
  if (combat.size() < 1 && p2Draw.size() > 0) {
    Card temp = p2Draw.get(0);
    combat.add(temp);
    p2Draw.remove(0);
    debugLength();
  }
}

//Does all the final math, comparing cards, and knowing what team to send the discards to
//Can simplify the 5 move code locations to 2, maybe one, but I'm too lazy to do it.
void resolve() {
  Card tempP1 = null;
  Card tempP2 = null;
  if (combat.get(0).team == "p1") {
    tempP1 = combat.get(0);
    tempP2 = combat.get(1);
  } else {
    tempP2 = combat.get(0);
    tempP1 = combat.get(1);
  }
  if (tempP1.pts > tempP2.pts) {
    for (int i = combat.size()-1; i>-1; i--) {
      Card temp = combat.get(i);
      p1Disco.add(temp);
      combat.remove(i);
    }
    for (int i = holding.size()-1; i>-1; i--) {
      Card temp = holding.get(i);
      p1Disco.add(temp);
      holding.remove(i);
    }
  } else if (tempP2.pts > tempP1.pts) {
    for (int i = combat.size()-1; i>-1; i--) {
      Card temp = combat.get(i);
      p2Disco.add(temp);
      combat.remove(i);
    }
    for (int i = holding.size()-1; i>-1; i--) {
      Card temp = holding.get(i);
      p2Disco.add(temp);
      holding.remove(i);
    }
  } else {
    for (int i = combat.size()-1; i>-1; i--) {
      Card temp = combat.get(i);
      holding.add(temp);
      combat.remove(i);
    }
  }
  debugLength();
}


//Does all the dragging math
void dragCheck() {
  if (dragging == true) {
    float targetX = mouseX;
    float dx = targetX - easex;
    easex += dx * easing;

    float targetY = mouseY;
    float dy = targetY - easey;
    easey += dy * easing;
    makeCard(easex-50, easey-70, false, p1Draw, 0);
  }
}

boolean endCheck() {
  if(p1Draw.size() < 1 || p2Draw.size() < 1 && mainDeck.size() == 0){
   return false; 
  } else {
   return true; 
  }
}

//Checks to see if button should be placed (flip/resolve)
boolean buttonThere = false;
void buttonCheck() {
  if (combat.size() > 1) {
    buttonThere = true;
    fill(255, 255, 255);
    rect(900, 300, 100, 50);
    fill(0, 0, 0);
    textSize(12);
    if (flipCard) {
      text("Click to resolve", 950, 330);
    } else {
      text("Click to flip", 950, 330);
    }
  } else {
    buttonThere = false;
  }
}

//Just a placeholder variable, cause returning values sucks (and cause I don't really know how to do it that well :3)
boolean flipCard = false;

//Makes a bunch of cards every frame to complete decks
void drawDecks() {
  for (int i = 0; i < p2Draw.size(); i++) {
    makeCard(i+10, i+10, false, p2Draw, i);
  }
  for (int i = 0; i < p2Disco.size(); i++) {
    makeCard(i+150, i+10, true, p2Disco, i);
  }
  for (int i = 0; i < p1Draw.size(); i++) {
    makeCard(i+1360, i+575, false, p1Draw, i);
  }
  for (int i = 0; i < p1Disco.size(); i++) {
    makeCard(i+1220, i+575, true, p1Disco, i);
  }
  for (int i = 0; i < holding.size(); i++) {
      makeCard(500, 150+i*200, true, holding, i);
    }
  for (int i = 0; i < combat.size(); i++) {
    if (flipCard == true) {
      makeCard(650, 150+i*200, true, combat, i);
    } else {
      makeCard(650, 150+i*200, false, combat, i);
    }
  }
}

//Prints the amount of cards in each deck, used for debugging
void debugLength() {
  print("\n" +"MainDeck: "+mainDeck.size()+" ");
  print("P1Draw: "+p1Draw.size()+" ");
  print("P2Draw: "+p2Draw.size()+" ");
  print("P1Disco: "+p1Disco.size()+" ");
  print("P2Disco: "+p2Disco.size()+" ");
  print("Combat: "+combat.size()+"\n");
}
