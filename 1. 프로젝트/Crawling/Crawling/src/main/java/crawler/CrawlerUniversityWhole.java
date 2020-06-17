package crawler;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
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
import com.google.firebase.messaging.FirebaseMessaging;

import model.Notice;

public class CrawlerUniversityWhole extends Crawler {

	public CrawlerUniversityWhole(ArrayList<DocumentSnapshot> users) {
		super(users);
	}

	@Override
	protected Document getPage(int page) throws IOException {
		return Jsoup
				.connect("https://www.hallym.ac.kr/hallym_univ/sub05/cP3/sCP1.html?nttId=0&bbsTyCode=BBST00&bbsAttrbCode=BBSA03&authFlag=N&pageIndex=" + page + "&searchType=0&searchWrd=")
				.get();
	}
	
	@Override
	protected String getNoticeUrl(Document document, int row) {
		return document.select("#container > div > div:nth-child(5) > div.tbl-press > div > ul > li:nth-child(" + row + ") > span.col.col-2.dot > span:nth-child(2) > a").attr("href").trim();
	}
	
	@Override
	protected String getLeading(Document document, int row) {
		return document.select("#container > div > div:nth-child(5) > div.tbl-press > div > ul > li:nth-child(" + row + ") > span.col.col-1.tc > span").text().trim();
	}

	@Override
	protected String getTitle(Document document, int row) {
		return document.select("#container > div > div:nth-child(5) > div.tbl-press > div > ul > li:nth-child(" + row + ") > span.col.col-2.dot > span:nth-child(2) > a").text().trim();
	}

	@Override
	protected String getWriter(Document document, int row) {
		return document.select("#container > div > div:nth-child(5) > div.tbl-press > div > ul > li:nth-child(" + row + ") > span.col.col-3.tc > span:nth-child(2)").text().trim();
	}

	@Override
	protected Timestamp getDate(Document document, int row) {
		String date = document.select("#container > div > div:nth-child(5) > div.tbl-press > div > ul > li:nth-child(" + row + ") > span.col.col-5.tc > span:nth-child(2)").text().trim();
		
		try {
			return Timestamp.of(new SimpleDateFormat("yyyy-MM-dd").parse(date));
		} catch (ParseException e) {
			return null;
		}
	}
	
	@Override
	protected boolean isEmptyRow(String noticeUrl) {
		return noticeUrl.isEmpty();
	}

	@Override
	protected String getTitle() {
		return "대학 전체 공지";
	}
}
