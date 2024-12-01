package dto;

import java.sql.Timestamp;

public class Review {
    private int reviewId;
    private String bookId;
    private String userName;
    private String content;
    private Timestamp createdAt;

    public Review(int reviewId, String bookId, String userName, String content, Timestamp createdAt) {
        this.reviewId = reviewId;
        this.bookId = bookId;
        this.userName = userName;
        this.content = content;
        this.createdAt = createdAt;
    }

    public Review(String bookId, String userName, String content) {
        this.bookId = bookId;
        this.userName = userName;
        this.content = content;
    }

    public int getReviewId() { 
    	return reviewId; 
    }
    
    public String getBookId() { 
    	return bookId; 
    }
    
    public String getUserName() { 
    	return userName; 
    }
    
    public String getContent() { 
    	return content; 
    }
    
    public Timestamp getCreatedAt() { 
    	return createdAt; 
    }
}