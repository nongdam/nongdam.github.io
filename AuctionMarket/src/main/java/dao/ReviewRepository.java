package dao;

import java.sql.*;
import java.util.ArrayList;
import java.sql.DriverManager;
import dto.Review;

public class ReviewRepository {
    private static ReviewRepository instance = new ReviewRepository();
    private Connection conn;

    private ReviewRepository() {
        try {
            // MySQL 드라이버 로드
            Class.forName("com.mysql.cj.jdbc.Driver");
            // 데이터베이스 연결 초기화
            String url="jdbc:mysql://localhost:3306/BookMarketDB";
    		String user="root";
    		String password="1234";
    		
    		Class.forName("com.mysql.jdbc.Driver");
    		conn=DriverManager.getConnection(url, user, password);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static ReviewRepository getInstance() {
        return instance;
    }

    public ArrayList<Review> getReviewsByBookId(String bookId) {
        ArrayList<Review> reviews = new ArrayList<>();
        String sql = "SELECT * FROM review WHERE book_id = ? ORDER BY created_at DESC";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, bookId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Review review = new Review(
                    rs.getInt("review_id"),
                    rs.getString("book_id"),
                    rs.getString("user_name"),
                    rs.getString("content"),
                    rs.getTimestamp("created_at")
                );
                reviews.add(review);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reviews;
    }
    
    public void addReview(Review review) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
        	String url="jdbc:mysql://localhost:3306/BookMarketDB";
    		String user="root";
    		String password="1234";
        	// 데이터베이스 연결
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(url, user, password);

            // SQL 실행
            String sql = "INSERT INTO review (book_id, user_name, content) VALUES (?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, review.getBookId());
            pstmt.setString(2, review.getUserName());
            pstmt.setString(3, review.getContent());
            
            int rowsInserted = pstmt.executeUpdate(); // 삽입된 행 수 반환
            System.out.println("DEBUG: Rows inserted = " + rowsInserted);
            
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // 리소스 정리
            if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
            if (conn != null) try { conn.close(); } catch (Exception e) {}
        }
    }
}
