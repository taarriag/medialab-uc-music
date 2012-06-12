import codeanticode.gsvideo.*;

ArrayList songItems;

GSMovie movie1;
GSMovie movie2;
GSMovie cameraMovie;

Minim minim;
AudioPlayer groove;

PFont font;

String[] songTitles = new String[2];
String[] songArtists = new String[2]; 

//Filtros para elegir mp3, archivos de video y archivos de imagen
java.io.FilenameFilter mp3Filter = new java.io.FilenameFilter()
{
  public boolean accept(File dir, String name) {
    return name.toLowerCase().endsWith(".mp3");
  }
};

java.io.FilenameFilter visualFilter = new java.io.FilenameFilter()
{
  public boolean accept(File dir, String name) {
    return name.toLowerCase().endsWith(".mov") || name.toLowerCase().endsWith(".png")
           name.toLowerCase().endsWith(".jpg") || name.toLowerCase().endsWith(".jpeg");
  }
};

void setup()
{  
  size(640, 480);
  background(3);
  
  minim = new Minim(this);

  //Cargar todos los items de musica y videos o imagenes que se mostrarán
  java.io.File dataFolder = new java.io.File(dataPath(""));

  String[] mp3Filenames = dataFolder.list(mp3Filter);
  String[] visualFilenames = dataFolder.list(visualFilter);
  println(filenames);
  
  AudioMetaData meta;
  
  //Cargamos las canciones en la lista de canciones
  for(int i=0; i< mp3Filenames.length;i++) {
    player = minim.loadFile(mp3Filenames[i]);
    meta = groove.getMetaData();
    
    String filenameWithoutExtension = mp3Filenames[i].substring(0, mp3Filenames[i].length - 4);
    
    //Buscamos si existe algún archivo visual (.mov,etc.) con la misma extensión
    for(int j=0; j < visualFilenames.length; j++){
      if(visualFilenames[j].startsWith(filenameWithoutExtension)
      {
        songItems.add(new SongItem(meta.title(),meta.author(),mp3Filenames[i],visualFilenames[j]));
        break;
      }
    }
  }


  movie1 = new GSMovie(this, ((SongItem)songItems.get(0)).videoPath);
  movie2 = new GSMovie(this, "station.mov");

  movie1.loop();
  movie2.loop();

  font = loadFont("VisitorTT2-BRK--48.vlw");
}

void stop()
{
  player.close();
  minim.stop();
  
  super.stop();
  
}

void setSongs(String songPath1, String songPath2)
{
}

void movieEvent(GSMovie movie) {
  movie.read();
}

void draw() {
  //TODO: dibujar todos los videos
  image(movie1, width/4 - movie1.width/2, height/2 - movie1.height/2 );
  image(movie2, width*3/4 - movie2.width/2, height/2 - movie2.height/2 );

  //Dibujamos el texto del programa
  textFont(font, 42);
  fill(#00CB0A);
  textAlign(CENTER);
  text("Choose your destiny...", width/2, 80);
}

