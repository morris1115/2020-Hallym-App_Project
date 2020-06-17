package crawler;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutionException;

import org.jsoup.nodes.Document;

import com.google.cloud.Timestamp;
import com.google.cloud.firestore.DocumentSnapshot;
import com.google.cloud.firestore.QuerySnapshot;
import com.google.cloud.firestore.WriteBatch;
import com.google.firebase.cloud.FirestoreClient;
import com.google.firebase.messaging.BatchResponse;
import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;

import model.Notice;

public abstract class Crawler implements Runnable {
	
	protected ArrayList<DocumentSnapshot> mfUsers;
	
	public Crawler(ArrayList<DocumentSnapshot> users) {
		mfUsers = users;
	}
	
	protected abstract String getTitle();
	protected abstract Document getPage(int page) throws IOException;
	
	protected abstract boolean isEmptyRow(String noticeUrl);
	protected abstract String getNoticeUrl(Document document, int row);
	protected abstract String getLeading(Document document, int row);
	protected abstract String getTitle(Document document, int row);
	protected abstract String getWriter(Document document, int row);
	protected abstract Timestamp getDate(Document document, int row);
	
	@Override
	public void run() {
		
		boolean touchEndPage = false;
		boolean foundExistence = false;
		
		ArrayList<Notice> notices = new ArrayList<>();
		
		for (int page = 1 ; !foundExistence && !touchEndPage ; ++page) {
			
			boolean touchEndRow = false;
			
			try {
				Document document = getPage(page);
				
				for (int row = 1 ; !touchEndRow && !touchEndPage ; ++row) {
					String title = getTitle(document, row);
					String writer = getWriter(document, row);
					String leading = getLeading(document, row);
					String noticeUrl = getNoticeUrl(document, row);
					
					if (isEmptyRow(noticeUrl)) {
						touchEndRow = true;
						break;
					} else {
						try {
							QuerySnapshot querySnapshot = FirestoreClient.getFirestore().collection(getClass().getSimpleName()).whereEqualTo("url", noticeUrl).get().get();
							
							if (querySnapshot.isEmpty()) {
								Timestamp date = getDate(document, row);
								notices.add(new Notice(noticeUrl, leading, title, writer, date));
							} else {
								foundExistence = true;
								break;
							}
						} catch (InterruptedException e) {
							e.printStackTrace();
						} catch (ExecutionException e) {
							e.printStackTrace();
						}
					}
					
					if (leading.equals("1")) {
						touchEndPage = true;
					}
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		
		if (notices.size() > 0) {
			WriteBatch batch = FirestoreClient.getFirestore().batch();
			for (Notice notice : notices) {
				batch.create(FirestoreClient.getFirestore().collection(getClass().getSimpleName()).document(), notice.toMap());
				
				if (batch.getMutationsSize() == 500) {
					try {
						batch.commit().get();
						batch = FirestoreClient.getFirestore().batch();
					} catch (InterruptedException e) {
						e.printStackTrace();
					} catch (ExecutionException e) {
						e.printStackTrace();
					}
				}
			}
			
			if (batch.getMutationsSize() > 0) {
				try {
					batch.commit().get();
				} catch (InterruptedException e) {
					e.printStackTrace();
				} catch (ExecutionException e) {
					e.printStackTrace();
				}
			}
			
			ArrayList<DocumentSnapshot> users = new ArrayList<>(mfUsers);
			for (int begin = 0 ; begin < users.size() ; begin += 500) {
				
				List<DocumentSnapshot> subUsers = users.subList(
						begin,
						(begin + 500 > users.size()) ?
								users.size() :
								begin + 500);
				
				ArrayList<Message> messages = new ArrayList<>();
				for (DocumentSnapshot user : subUsers) {
					
					switch (notices.size()) {
						case 1:
							messages.add(Message
									.builder()
									.setToken(user.getString("fcmToken"))
									.setNotification(Notification
											.builder()
											.setTitle(notices.get(0).getTitle())
											.build())
									.build());
							break;
							
						default:
							messages.add(Message
									.builder()
									.setToken(user.getString("fcmToken"))
									.setNotification(Notification
											.builder()
											.setTitle(notices.size() + "개의 새 공지가 있습니다")
											.build())
									.build());
					}
				}
				
				try {
					BatchResponse batchResponse = FirebaseMessaging.getInstance().sendAll(messages, false);
					
					System.out.println(getTitle() + " : " + batchResponse.getSuccessCount() + "명에게 " + notices.size() + "개 공지 전송 완료");
				} catch (FirebaseMessagingException e) {
					e.printStackTrace();
				}
			}
		} else {
//			System.out.println(getClass().getSimpleName() + " : " + "EMPTY");
		}
	}
}
