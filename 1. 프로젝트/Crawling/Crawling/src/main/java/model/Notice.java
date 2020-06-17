package model;

import java.util.HashMap;
import java.util.Map;

import com.google.cloud.Timestamp;

public class Notice {
	
	String url;
	String title;
	String writer;
	String leading;
	
	Timestamp date;
	
	public Notice(String url, String leading, String title, String writer, Timestamp date) {
		this.url = url;
		this.title = title;
		this.writer = writer;
		this.leading = leading;
		
		this.date = date;
	}

	public Map<String, Object> toMap() {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("url", this.url);
		map.put("title", this.title);
		map.put("writer", this.writer);
		map.put("leading", this.leading);
		
		map.put("date", this.date);
		
		return map;
	}

	public String getTitle() {
		return this.title;
	}
}
