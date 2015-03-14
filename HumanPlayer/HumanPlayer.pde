import codeanticode.gsvideo.*;
import hypermedia.net.*;
import jmcvideo.*;
import processing.opengl.*;
import gifAnimation.*;
import fullscreen.*;

FullScreen fs;  //Im writing code from an external editor

UDP udpCamera;
UDP udpController;
byte gridW = 16;
byte gridH = 12;
byte[][] points = new byte[gridW][gridH];

//List of songs/videos
//ArrayList songItems;
SongItem[] songItems;

int[] songIndex = new int[2];

//Movies
PImage vsImage;
GSMovie[] movies = new GSMovie[2];

int[] movieX = new int[2];
int[] movieY = new int[2];
TextLabel[] artistLabels = new TextLabel[2];
TextLabel[] songLabels = new TextLabel[2];
Rectangle divisorRect;

//Timer
int countdownTimer = -1;
int prevSeconds;
int timerToVs = -1;
int leftSide;
int rightSide;
int offset;
TextLabel countdownLabel;

//Indice del elemento siendo arrastrado. Si es mayor o igual a 0 tomamos ese elemento del arreglo 
//y lo arrastramos.
int locked = -1; 
int bdifx;
int bdify;
 
//Used for reading 
Minim minim;
AudioPlayer groove;

//Fonts
PFont visitorFont;
PFont ssf4Font;

//Animación gif del tutorial
Gif tutorialGif;

//Visualizacion de la música
//Visualizador visualizador;

//Estado de la aplicación
int state;

//File loading
java.io.File dataFolder;

//Filters to select mp3 and video files.
java.io.FilenameFilter mp3Filter = new java.io.FilenameFilter()
{
  public boolean accept(File dir, String name) {
    return name.toLowerCase().endsWith(".mp3");
  }
};

java.io.FilenameFilter visualFilter = new java.io.FilenameFilter()
{
  public boolean accept(File dir, String name) { 
    return name.toLowerCase().endsWith(".mov") || name.toLowerCase().endsWith(".mp4");
  }
};

void setup()
{  
  size(720, 480);
  
  //fs = new FullScreen(this);
  frameRate(29);
  //fs.enter();  
  
  //Cargamos la imagen de versus y pintamos el fondo.
  vsImage = loadImage(VERSUS_PATH);
  background(#000000);
  
  //Cargamos las fonts.
  visitorFont = loadFont("VisitorTT2-BRK--48.vlw");
  ssf4Font = loadFont("SSF4_ABUKET-48.vlw");

  loadMedia();
      
  this.state = DETECTING_PEOPLE_STATE;
  
  for(int i=0;i<gridW;i++)
    for(int j=0;j<gridH;j++)
      points[i][j] = 0;
  
  
  udpCamera = new UDP(this,PORT_CAMERA);
  udpCamera.setReceiveHandler("detectorReceiveHandler");

  udpController = new UDP(this,PORT_CONTROLLER);
  udpController.setReceiveHandler("controllerReceiveHandler");

  //We load the gif of the tutorial
  tutorialGif = new Gif(this,TUTORIAL_PATH);
  
  //visualizador = new Visualizador(this);
  
}

void detectorReceiveHandler(byte[] message, String ip, int port)
{
  for(int i=0; i < message.length;++i) {
    points[i%gridW][i/gridW] = message[i];
  }
}

void controllerReceiveHandler(byte[] message,String ip, int port)
{
  String command = new String(message);
  String[] splitted = command.split("[\\\\]");
  
  //Debugging
  for(int i=0;i<splitted.length;i++)
    println(splitted[i]);

  int newState = Integer.parseInt(splitted[0]);
  
  if(newState == SET_SONGS_STATE)
  {
    //versusSong1 = splitted[1];
    //versusSong2 = splitted[2];
    versusSong1 = Integer.parseInt(splitted[1]);
    versusSong2 = Integer.parseInt(splitted[2]);  
  }
  else if(newState == INIT_VS_STATE)    
    tutorialGif.loop();

  /*else if(newState == VISUALIZATION_STATE)
    size(720,480,P3D);*/

  state = newState;
}

//private String versusSong1;
//private String versusSong2;

private int versusSong1;
private int versusSong2;

//Draw
void draw() {
  background(#000000);
  
  switch(state)
  {
    case IDLE_STATE:
      break;
    case DETECTING_PEOPLE_STATE:
      //thread("listenPeopleData");size(720,480,P3D);    
      udpCamera.listen(true);
      udpController.listen(true);
      state = IDLE_STATE;
      break;
    case SET_SONGS_STATE:
      //setSongs(versusSong1,versusSong2,DEFAULT_COUNTDOWN_TIME);
      setSongs(versusSong1,versusSong2,DEFAULT_COUNTDOWN_TIME);
      state = VS_STATE;
      break;
    case INIT_VS_STATE:
      tint(255,255);
      image(tutorialGif,(width - tutorialGif.width)/2,0);
      break;
    case VS_STATE:
      drawVersus();
      break;    
    case FADE_VS_STATE:
      drawFadingVersus();
      break;
    case PLAY_SONG_STATE:
      background(0);
      //TODO: Reemplazar por algun draw de algo, una visualización o algo por el estilo.
      playWinningSong();
      break;
  }
}

void keyPressed()
{
   /*if(state== VISUALIZATION_STATE)
     visualizador.keyPressed();*/
}

void listenPeopleData()
{
  println("listening...");
  //udpCamera.listen();
    
}

private void playWinningSong()
{
  
  movies[0].noLoop();
  movies[1].noLoop();
  movies[0].stop();
  movies[1].stop();
  movies[0].dispose();
  movies[1].dispose();
  

  String winnerFile = "";
  if(offset>=0)
    //winnerFile = ((SongItem)songItems.get(songIndex[0])).songPath;
    winnerFile = songItems[songIndex[0]].songPath;
  else 
    //winnerFile = ((SongItem)songItems.get(songIndex[1])).songPath;
    winnerFile = songItems[songIndex[1]].songPath;
  
  String command = CLAMP_PATH+" /PLADD "+ "\""+dataFolder.getAbsolutePath()+"\\"+ winnerFile+"\""+" /PLLAST /PLAY";
  println(command);
  open(command);
  state = IDLE_STATE;
}

//Fading variables
int generalOpacity = 255;
int opacityDelta = 10;

private void drawFadingVersus()
{
  background(0);
  //We tint the movies, the text and the versus symbol until they finally dissapear.
  //Once they've dissapeared, we make a call to winamp to play the winning song.
  //TODO: Finish above (fade effect, show the winning song, play that song.
  //TODO: Implement a control panel to select the song being played.
  //TODO: Implement avatar system in the application
  tint(255,generalOpacity);
  image(movies[0], movieX[0]/* + offset*/, movieY[0],width,height);
  image(movies[1],movieX[1]/* + offset*/,movieY[1],width,height);
  divisorRect.xpos = movieX[0] + width;
  //divisorRect.draw();
  image(vsImage,  width/2 - vsImage.width/2+ (int)random(-3,3), height/2 -vsImage.height/2 + (int)random(-3,3));
  
  countdownLabel.textColor = color(DEFAULT_COUNTDOWN_TEXT_COLOR,generalOpacity);
  countdownLabel.draw();
  
  generalOpacity -= opacityDelta;
  
  if(generalOpacity <= 0)
    state = PLAY_SONG_STATE;
}

private int calculatePeopleDifference()
{
  //We read the amount of people on each side of the area
  for(int i=0;i< gridW/2 - 1;i++)
    for(int j=0;j<gridH;j++)
      leftSide += points[i][j];
      
  for(int i=gridW/2; i<gridW ;i++)
    for(int j=0;j<gridH;j++)
      rightSide += points[i][j];
  
  //return rightSide - leftSide;
  return leftSide - rightSide;
}


private void drawVersus()
{
  //udpCamera.listen();
  
  leftSide = 0;
  rightSide = 0;
  
  offset = calculatePeopleDifference()*(width/2)/ESTIMATED_TOTAL_PEOPLE;
  if(offset!=0) offset = offset/abs(offset);
  
  //offset = 0;
  
  //offset = 0;
  //We draw the movies, the divisor rectangle between them and the vs image.
  //image(movies[0], movieX[0], movieY[0],movies[0].width*(height/movies[0].height),height);
  //image(movies[1], movieX[1], movieY[1],movies[1].width*(height/movies[1].height),height);
  movieX[0] += offset;
  movieX[1] += offset;
  tint(255,255);
  image(movies[0], min(movieX[0],0)/* + offset*/, movieY[0],width,height);
  image(movies[1], max(movieX[1],0)/* + offset*/,movieY[1],width,height);
  divisorRect.xpos = movieX[0] + width;
  //divisorRect.draw();
  image(vsImage,  width/2 - vsImage.width/2+ (int)random(-3,3), height/2 -vsImage.height/2 + (int)random(-3,3));
  
  countdownLabel.label = ""+countdownTimer; 
  countdownLabel.draw();
  
  /*
  textSize(62);
  fill(#00CB0A);
  text(countdownTimer,width/2,height*4/5);
  */
  
  //if(countdownTimer > 0 /*&& second() - prevSeconds >= 1*/)
  if(countdownTimer > 0 && second() - prevSeconds >= 1)
    countdownTimer -= (second()-prevSeconds);  
  prevSeconds = second();  
  
  //We write the name of the songs
  for(int i=0;i<2;i++)
  {
    artistLabels[i].draw();
    songLabels[i].draw();
  }
  
  //Si el contador llegó a 0, debemos cambiar de estado
  if(countdownTimer <= 0)
    this.state = FADE_VS_STATE;
}


void stop()
{
  groove.close();
  minim.stop();
  udpCamera.listen(false);
  udpCamera.close();
  udpController.listen(false);
  udpController.close();
  movies[0].stop();
  movies[1].stop();
  movies[0].dispose();
  movies[1].dispose();
  tutorialGif.stop();
  super.stop();
}

//Methods for loading and setting multimedia being played
private void loadMedia()
{
  minim = new Minim(this);

  //Cargar todos los items de musica y videos o imagenes que se mostrarán
  dataFolder = new java.io.File(dataPath(""));
  
  String[] mp3Filenames = dataFolder.list(mp3Filter);
  String[] visualFilenames = dataFolder.list(visualFilter);
  
  println("Data Folder Path:");
  println(dataFolder.getAbsolutePath());
  println("MP3:");
  println(mp3Filenames);

  println("Videos:");
  println(visualFilenames);

  AudioMetaData meta;

  //songItems = new ArrayList();

  songItems = new SongItem[mp3Filenames.length];

  //Cargamos las canciones en la lista de canciones
  for (int i=0; i< mp3Filenames.length;i++) {
    groove = minim.loadFile(mp3Filenames[i]);
    meta = groove.getMetaData();

    String filenameWithoutExtension = mp3Filenames[i].substring(0, mp3Filenames[i].length() - 4);

    //Buscamos si existe algún archivo visual (.mov,etc.) con la misma extensión
    for (int j=0; j < visualFilenames.length; j++) {
      String visualFilenameWithoutExtension = visualFilenames[j].substring(0,visualFilenames[j].length() - 4);
      //if (visualFilenames[j]/*.startsWith*/.equals(filenameWithoutExtension))
      if (visualFilenameWithoutExtension/*.startsWith*/.equalsIgnoreCase(filenameWithoutExtension))
      {
        //songItems.add(new SongItem(meta.title(), meta.author(), mp3Filenames[i], visualFilenames[j]));
        songItems[i] = new SongItem(meta.title(), meta.author(), mp3Filenames[i], visualFilenames[j]);
        
        break;
      }
    }
  }
}


void setSongs(/*String songPath1*/int song1, /*String songPath2*/int song2, int countdownTimer)
{
  int found = 0;
  //Realizamos una búsqueda de las canciones

  
//  for (int i=0; i<songItems.size();i++)
//  {
//    if (found > 1)
//      break;//

//    if (songPath1/*.startsWith*/.equalsIgnoreCase(((SongItem)songItems.get(i)).songPath))
//    {  
//      songIndex[0] = i;
//      found++;
//    }//

//    if (songPath2/*.startsWith*/.equalsIgnoreCase(((SongItem)songItems.get(i)).songPath))
//    {
//      songIndex[1] = i;
//      found++;
//    }
//  }
  

  songIndex[0] = song1;
  songIndex[1] = song2;
    
    //println("Initializing Versus...");
    
    //movies[0] = new GSMovie(this, ((SongItem)songItems.get(songIndex[0])).videoPath);
    //movies[1] = new GSMovie(this, ((SongItem)songItems.get(songIndex[1])).videoPath);
    
    movies[0] = new GSMovie(this, songItems[songIndex[0]].videoPath);
    movies[1] = new GSMovie(this, songItems[songIndex[1]].videoPath);
    
    println(songIndex[0]);
    //println("Song1: "+ ((SongItem)songItems.get(songIndex[0])).songPath);
    //println("Video1: "+ ((SongItem)songItems.get(songIndex[0])).videoPath);
    
    
    println(songIndex[1]);
    //println("Song2: "+ ((SongItem)songItems.get(songIndex[1])).songPath);
    //println("Video2: "+((SongItem)songItems.get(songIndex[1])).videoPath);

    movies[0].volume(0);
    movies[1].volume(0);
    
    
    movies[0].resize(width,height);
    movies[1].resize(width,height);
   
    movies[0].loop();
    movies[1].loop();

    //movieX[0] = width/2 - movies[0].width*(height/movies[0].height);
    //movieY[0] = 0;
    movieX[0] = width/2 - width;

    movieX[1] = width/2;
    movieY[1] = 0;
    
    divisorRect = new Rectangle(width/2 - 5,0,10,height);
    divisorRect.innerColor = new Color(0,0,0,255);
    divisorRect.outerColor = new Color(0,0,0,255);
   
    //We set up the text labels of the artists and the songs.
    
    //artistLabels[0] = new TextLabel(((SongItem)songItems.get(songIndex[0])).artist , visitorFont, ARTIST_FONT_SIZE, DEFAULT_TEXT_COLOR , 30 , 100);  
    //songLabels[0] = new TextLabel(((SongItem)songItems.get(songIndex[0])).title , visitorFont, SONG_FONT_SIZE, DEFAULT_TEXT_COLOR , 30 , 130);  

    //artistLabels[1] = new TextLabel(((SongItem)songItems.get(songIndex[1])).artist , visitorFont, ARTIST_FONT_SIZE, DEFAULT_TEXT_COLOR , width/2 + 30, 100);
    //songLabels[1] = new TextLabel(((SongItem)songItems.get(songIndex[1])).title , visitorFont, SONG_FONT_SIZE, DEFAULT_TEXT_COLOR , width/2 + 30, 130);  
   
   
    artistLabels[0] = new TextLabel(songItems[songIndex[0]].artist , visitorFont, ARTIST_FONT_SIZE, DEFAULT_TEXT_COLOR , 30 , 100);  
    songLabels[0] = new TextLabel(songItems[songIndex[0]].title , visitorFont, SONG_FONT_SIZE, DEFAULT_TEXT_COLOR , 30 , 130);  

    artistLabels[1] = new TextLabel(songItems[songIndex[1]].artist , visitorFont, ARTIST_FONT_SIZE, DEFAULT_TEXT_COLOR , width/2 + 30, 100);
    songLabels[1] = new TextLabel(songItems[songIndex[1]].title , visitorFont, SONG_FONT_SIZE, DEFAULT_TEXT_COLOR , width/2 + 30, 130);  
   
    //Cargamos la cuenta regresiva.
    this.countdownTimer = countdownTimer;
    this.prevSeconds = second();
    this.countdownLabel = new TextLabel(""+countdownTimer, visitorFont, DEFAULT_COUNTDOWN_TEXT_SIZE, DEFAULT_COUNTDOWN_TEXT_COLOR,width/2 - 15,40/*height*4/5*/);
}


void movieEvent(GSMovie movie) {
  movie.read();
}
