package HanAlarm;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import java.util.function.Consumer;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.cloud.firestore.DocumentSnapshot;
import com.google.cloud.firestore.EventListener;
import com.google.cloud.firestore.FirestoreException;
import com.google.cloud.firestore.QuerySnapshot;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.cloud.FirestoreClient;

import crawler.Crawler;
import crawler.CrawlerCollegeSW;
import crawler.CrawlerCollegeSW2;
import crawler.CrawlerUniversityWhole;

public class App implements EventListener<QuerySnapshot> {
	
	private static final String SERVICE_ACCOUNT_KEY_PATH = "./han-alarm-7cb3a-firebase-adminsdk-b7mw6-09f46fe29c.json";
	
	private ArrayList<DocumentSnapshot> mUsers = null;
	
	private App() {
		
	}
	
	private void execute() throws IOException {
		/*
		 * 	Initialize Firebase
		 */
		InputStream serviceAccount = new FileInputStream(SERVICE_ACCOUNT_KEY_PATH);
		GoogleCredentials credentials = GoogleCredentials.fromStream(serviceAccount);
		
		FirebaseOptions options = new FirebaseOptions.Builder()
		    .setCredentials(credentials)
		    .build();
		
		FirebaseApp.initializeApp(options);
		
		/*
		 * 
		 */
		FirestoreClient.getFirestore().collection("users").addSnapshotListener(this);
	}

	@Override
	public void onEvent(QuerySnapshot querySnapshot, FirestoreException error) {
		
		if (mUsers != null) {
			mUsers.clear();
			mUsers.addAll(querySnapshot.getDocuments());
		} else {
			mUsers = new ArrayList<>(querySnapshot.getDocuments());
			
			ArrayList<Crawler> crawlers = new ArrayList<>(Arrays.asList(
					new CrawlerUniversityWhole(mUsers),
					new CrawlerCollegeSW(mUsers),
					new CrawlerCollegeSW2(mUsers)
			));
			
			ScheduledExecutorService threadPool = Executors.newScheduledThreadPool(crawlers.size());
			crawlers.forEach(new Consumer<Crawler>() {
				@Override
				public void accept(Crawler crawler) {
					threadPool.scheduleAtFixedRate(crawler, 0, 10, TimeUnit.SECONDS);
				}
			});
		}
	}
	
	public static void main(final String argvs[]) {
		try {
			new App().execute();
			System.in.read();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

}
