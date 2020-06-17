package crawler;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutionException;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;

import com.google.cloud.Timestamp;
import com.google.cloud.firestore.DocumentSnapshot;
import com.google.cloud.firestore.FieldPath;
import com.google.cloud.firestore.Query.Direction;
import com.google.cloud.firestore.QuerySnapshot;
import com.google.cloud.firestore.WriteBatch;
import com.google.firebase.cloud.FirestoreClient;
import com.google.firebase.messaging.BatchResponse;
import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;

import model.Notice;

public class CrawlerCollegeSW extends Crawler {

	public CrawlerCollegeSW(ArrayList<DocumentSnapshot> users) {
		super(users);
	}
	
	@Override
	protected Document getPage(int page) throws IOException {
		return Jsoup
				.connect("https://hlsw.hallym.ac.kr/index.php?mt=page&mp=5_2&mm=oxbbs&oxid=2&key=&val=&subcmd=&CAT_ID=0&artpp=15&cpage=" + page)
				.get();
	}
	
	@Override
	protected String getNoticeUrl(Document document, int row) {
		return "https://hlsw.hallym.ac.kr/" + document.select("#bbsWrap > form:nth-child(2) > table > tbody > tr:nth-child(" + row + ") > td.tit > a").attr("href").trim();
	}
	
	@Override
	protected String getLeading(Document document, int row) {
		return document.select("#bbsWrap > form:nth-child(2) > table > tbody > tr:nth-child(" + row + ") > td:nth-child(1)").text().trim();
	}

	@Override
	protected String getTitle(Document document, int row) {
		return document.select("#bbsWrap > form:nth-child(2) > table > tbody > tr:nth-child(" + row + ") > td.tit > a").attr("title").trim();
	}

	@Override
	protected String getWriter(Document document, int row) {
		return document.select("#bbsWrap > form:nth-child(2) > table > tbody > tr:nth-child(" + row + ") > td:nth-child(3)").text().trim();
	}

	@Override
	protected Timestamp getDate(Document document, int row) {
		String date =  document.select("#bbsWrap > form:nth-child(2) > table > tbody > tr:nth-child(" + row + ") > td:nth-child(4)").text().trim();
		
		try {
			return Timestamp.of(new SimpleDateFormat("yyyy-MM-dd").parse(date));
		} catch (ParseException e) {
			return null;
		}
	}
	
	@Override
	protected boolean isEmptyRow(String noticeUrl) {
		return noticeUrl.equals("https://hlsw.hallym.ac.kr/");
	}

	@Override
	protected String getTitle() {
		return "소프트웨어 융합대학 사업단";
	}
}
