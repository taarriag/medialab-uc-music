import ddf.minim.*;

public class SongItem{
  
  public String videoPath;
  public String songPath;
  public String artist;
  public String song;
  
  //Constructor del SongItem. Si la extensión de videoPath es un .mov (u otra de video)
  //se debe reproducir un video, si no se debe mostrar una imagen (por fuera inicialmente).
  public SongItem(String song, String artist,String songPath,String videoPath)
  {
    this.songPath = songPath;
    this.videoPath = videoPath;
    this.artist = artist;
    this.song = song;
  }
 
  

}
