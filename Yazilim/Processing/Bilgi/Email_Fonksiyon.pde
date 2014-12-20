import java.util.Properties;
import java.io.*;
import java.util.*;
import javax.mail.*;
import javax.mail.Flags.Flag;
import javax.mail.internet.*;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.activation.*;

BodyPart messageBodyPart;

void checkMail() {
  try {

    IMAPFolder folder = null;
    Store store = null;
    String subject = null;
    Flag flag = null;
    try 
    {
      Properties props = System.getProperties();
      props.setProperty("mail.store.protocol", "imaps");
      props.put("mail.imaps.host", "imap.gmail.com");

      // Create authentication object
      Auth auth = new Auth();

      // Make a session
      Session session = Session.getDefaultInstance(props, auth);
      store = session.getStore("imaps");

      store.connect();

      folder = (IMAPFolder) store.getFolder("Inbox"); 

      if (!folder.isOpen())
        folder.open(Folder.READ_WRITE);

      Message[] messages = folder.getMessages();
      System.out.println("No of Messages : " + folder.getMessageCount());
      System.out.println("No of Unread Messages : " + folder.getUnreadMessageCount());
      System.out.println(messages.length);

      for (int i=0; i < 10;i++)
        //for (int i=0; i < messages.length;i++) 
      {

        System.out.println("*****************************************************************************");
        System.out.println("MESSAGE " + (i + 1) + ":");
        Message msg =  messages[i];
        //System.out.println(msg.getMessageNumber());
        //Object String;
        //System.out.println(folder.getUID(msg)

        subject = msg.getSubject();

        System.out.println("Subject: " + subject);
        System.out.println("From: " + msg.getFrom()[0]);
        System.out.println("To: "+msg.getAllRecipients()[0]);
        System.out.println("Date: "+msg.getReceivedDate());
        System.out.println("Size: "+msg.getSize());
        System.out.println(msg.getFlags());
        System.out.println("Body: \n"+ msg.getContent());
        System.out.println(msg.getContentType());
      }
    }
    finally 
    {
      if (folder != null && folder.isOpen()) { 
        folder.close(true);
      }
      if (store != null) { 
        store.close();
      }
    }
  }


  // This error handling isn't very good
  catch (Exception e) {
    System.out.println("Failed to connect to the store");
    e.printStackTrace();
  }
}







void sendMail() {
  
  try {

    Properties props = new Properties();

    props.put("mail.smtp.host", "smtp.gmail.com");
    props.put("mail.smtp.socketFactory.port", "465");
    props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
    props.put("mail.smtp.auth", "true");
    props.put("mail.smtp.port", "465");

    // Create authentication object
    Auth auth = new Auth();

    Session session = Session.getDefaultInstance(props, auth);

    try {
      
      println("Mail Düzenleniyor");

      Message message = new MimeMessage(session);
      message.setFrom(new InternetAddress("robotext.afl@gmail.com"));
      message.setRecipients(Message.RecipientType.TO, InternetAddress.parse("kaaninan99@gmail.com"));
      message.setSubject("Robotext Güvenlik Sistemi - Uyarı");
      
      
      MimeMultipart multipart = new MimeMultipart("related");
      
      // EK 1
      messageBodyPart = new MimeBodyPart();
      messageBodyPart.setContent( htmlText, "text/html; charset=utf-8" );
      multipart.addBodyPart(messageBodyPart);

      // EK 2
      
      int toplam = resim_no;
      
      for(int i = resim_baslangic; i < toplam ; i++){
        messageBodyPart = new MimeBodyPart();
        String filename = "/home/pi/guvenlik"+i+".jpg";
        DataSource source = new FileDataSource(filename);
        messageBodyPart.setDataHandler(new DataHandler(source));
        messageBodyPart.setFileName(filename);
        messageBodyPart.setHeader("Content-ID","resim"+resim_no);
        multipart.addBodyPart(messageBodyPart);
      };

      // Herşeyi Koy
      message.setContent(multipart);
      
      Transport.send(message);

      System.out.println("Mail Gonderildi");
    } 

    finally 
    {
      //session.close();
    }
  }
  catch (MessagingException e) 
  {
    throw new RuntimeException(e);
  }
}

