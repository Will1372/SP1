// Jeg har taget inspiration i øl-flaske spillet fra mine helt unge dage, samt kan man også sammenlige det lidt med Space Invaders ( den meget billige version :) )

// variabler
int spillerX, spillerY;
int spillerSize = 40; // kan øges for forhøjet sværhedsgrad
int spillerSpeed = 10; // kan sænkes for forhøjet sværhedsgrad
int enemySpeed = 10; // kan øges for forhøjet sværhedsgrad
int enemySpawnRate = 50; // kan øges for forhøjet sværhedsgrad
int enemySize = 50; // kan øges for forhøjet sværhedsgrad
int lives = 3; // kan sænkes for forhøjet sværhedsgrad
int score = 0;
ArrayList<int[]> enemies = new ArrayList<int[]>(); // en ArrayList
ArrayList<int[]> specials = new ArrayList<int[]>(); // en til ArrayList
int specialSpeed = 5;
int specialSpawnRate = 150;
int specialSize = 30;
int lastScoreUpdate;

void setup(){ // setup metoden, der sætter grundstenene for projektet/spillet
  
  size(800,800);
  frameRate(100); // kan også ændres for at øge hastigheden på enemies (100 er tilstrækkeligt 'svært')
  spillerX = width/2;
  spillerY = height-50;
  lastScoreUpdate = millis();
  
}


void draw(){ // draw metoden, der kalder alle funktionerne
  
  background(125,200,250);
  fill(50,50,50); // farve på spilleren
  rect(spillerX-spillerSize/2,spillerY-spillerSize/2,spillerSize,spillerSize);
  opdaterEnemies();
  opdaterSpecials();
  fill(0);
  textSize(24);
  text("SCORE: "+score,20,20);
  text("LIVES: "+lives,width-80,20);
  tjekCollisions();
  tjekSpecialCollisions();
  tjekGameOver();
  sværhedsGradsStigning();
  
  if (millis()-lastScoreUpdate>=1000){ // hvor ofte scoren skal stige med nedenstående (i millisekunder)
    score += 5;
    lastScoreUpdate = millis();
    
  }
}

 void sværhedsGradsStigning(){ // bare for at gøre spillet lidt mindre kedeligt, så justeres sværhedsgraden på baggrund af ens resterende liv
  
   if (lives == 2 && score > 75){ // bare for at krydre det lidt, så tilføjede jeg også en betingelse omkring at det kun skulle blive sværere hvis ens score var over 75 og nedenstående over 100, da det ellers ville være lidt unfair for spilleren af blive straffet
     
     enemySpawnRate = 40; // default er 50 
     enemySize = 65; // default er 50
    
   } else if(lives == 1 && score > 100){
     
     enemySpawnRate = 30; // default er 50
     enemySize = 70; // default er 50
     
   }else if(lives > 6 && score > 300){ // straf for at være for god!
      
     enemySpawnRate = 25; // default er 50
     enemySize = 60; // default er 50
     
   }
} 

void keyPressed(){ // 'input' tjekker til højre og venstre piltast
  
  if (keyCode == RIGHT && spillerX+spillerSize/2 < width){ // if-statements, relationelle - og boolske operationer
    spillerX += spillerSpeed;
  } else if (keyCode == LEFT && spillerX-spillerSize/2 > 0){ // else-if statements, relationelle - og boolske operationer
    spillerX -= spillerSpeed;
    
  }
} 

void opdaterEnemies(){ // enemies spawn-funktion
  
  if (frameCount%enemySpawnRate == 0){ // lidt modulus også for at regulere spawnraten
    
    int enemyX = (int)random(enemySize/2,width-enemySize/2); // spawner dem et tilfældigt sted på x-aksen
    int enemyY = 0; // spawner altid på 0 på y-aksen
    int[] enemy = {enemyX,enemyY};
    enemies.add(enemy);
    
  }
  
  fill(255,0,0); // farve på enemies
  for (int i = 0; i < enemies.size(); i++){ // for-loop
    int[] enemy = enemies.get(i);
    ellipse(enemy[0], enemy[1], enemySize, enemySize);
    enemy[1] += enemySpeed;
    
    if(enemy[1] > height+enemySize/2){ // validerer om enemies er ude for rækkevidde og skal slettes (altså når den går ud over borders)
      
      enemies.remove(i);
      
    }
  }
}

void opdaterSpecials(){ // specials spawn-funktion
  if(frameCount%specialSpawnRate == 0){ // specials spawnrate
    
    int specialX = (int)random(specialSize/2,width-specialSize/2); // spawner dem et tilfældigt sted på x-aksen
    int specialY = 0; // spawner altid på 0 på y-aksen
    int[] special = {specialX,specialY};
    specials.add(special);
    
  }
  
  fill(0,255,0); // farve på rare special item / powerup / special
  for (int i = 0; i < specials.size(); i++){
    int[] special = specials.get(i);
    ellipse(special[0],special[1],specialSize,specialSize);
    special[1] += specialSpeed;
    
    if(special[1] > height+specialSize/2){ // validerer om rare special item / powerup / special er uden for rækkevidde og skal slettes (altså når den går ud over borders)
      
     specials.remove(i); 
      
    }
  }
} 

void tjekCollisions(){ // validerer om hvorvidt enemies kolliderer med spilleren
  
  for (int i = 0; i < enemies.size(); i++){ // for-loop
    int[] enemy = enemies.get(i);
    float distance = dist(spillerX,spillerY,enemy[0],enemy[1]);
    if (distance < spillerSize/2 + enemySize/2){
      
      lives--; // hvis man vil ændre på antal liv mistet når man bliver ramt af enemies
      score -= 20; // hvis man vil justere på minuspoint på at miste liv / blive ramt af enemies
      enemies.remove(i);
      break;
      
    }
  }
}

void tjekSpecialCollisions(){ // validerer om hvorvidt specials kolliderer med spilleren
  
  for (int i = 0; i < specials.size(); i++){ // for-loop
    int[] special = specials.get(i);
    float distance = dist(spillerX,spillerY,special[0],special[1]);
    if (distance < spillerSize/2 + specialSize/2){
      
      lives++; // hvis man vil justerer på antal liv man får af at opsamle en special
      score += 25; // hvis man dertil vil ændre antal + score man får af at opsamle special
      specials.remove(i);
      break;
      
    }
  }
}

void tjekGameOver(){ // tjekker bare om man er død i spillet og skriver ens score til sidst
    
  if (lives <= 0){
    textSize(22); 
    fill(255,50,0);
    textAlign(CENTER,CENTER);
    text("GAME OVER!!! DIN ENDELIGE (ELENDIGE) SCORE: " + score,width/2,height/2);
    noLoop();
    
  }
}
