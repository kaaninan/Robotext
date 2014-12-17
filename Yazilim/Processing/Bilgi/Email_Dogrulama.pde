import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;

public class Auth extends Authenticator {

  public Auth() {
    super();
  }

  public PasswordAuthentication getPasswordAuthentication() {
    String username, password;
    username = "robotext.afl@gmail.com";
    password = "raspberry_12";
    System.out.println("Dogrulaniyor. . ");
    return new PasswordAuthentication(username, password);
  }
}
