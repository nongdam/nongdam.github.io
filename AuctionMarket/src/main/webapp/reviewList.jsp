<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>

<%
    String dbUrl = "jdbc:mysql://localhost:3306/bookmarket";
    String dbUser = "root"; // MySQL 사용자명
    String dbPassword = "1234"; // MySQL 비밀번호

    String bookId = request.getParameter("id");
    ArrayList<String> reviews = new ArrayList<>();

    // 댓글 작성 처리
    String userName = request.getParameter("user_name");
    String content = request.getParameter("content");
    if (userName != null && content != null && !userName.isEmpty() && !content.isEmpty()) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            // 데이터베이스 연결
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

            // 댓글 삽입
            String insertSql = "INSERT INTO review (book_id, user_name, content) VALUES (?, ?, ?)";
            pstmt = conn.prepareStatement(insertSql);
            pstmt.setString(1, bookId);
            pstmt.setString(2, userName);
            pstmt.setString(3, content);
            pstmt.executeUpdate();

            // 리디렉션 (새로 고침)
            response.sendRedirect("book.jsp?id=" + bookId);
            return;

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
            if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
        }
    }

    // 댓글 조회 처리
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

        // 댓글 조회
        String selectSql = "SELECT user_name, content, created_at FROM review WHERE book_id = ? ORDER BY created_at DESC";
        pstmt = conn.prepareStatement(selectSql);
        pstmt.setString(1, bookId);
        rs = pstmt.executeQuery();

        while (rs.next()) {
            String review = String.format(
                "<strong>%s</strong>: %s <span class='text-muted'>(작성일: %s)</span>",
                rs.getString("user_name"),
                rs.getString("content"),
                rs.getTimestamp("created_at")
            );
            reviews.add(review);
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
        if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
    }
%>

<!-- 댓글 작성 폼 -->
<div class="mb-4">
    <h4>댓글 작성</h4>
    <form method="post" action="addReview.jsp">
    <input type="hidden" name="bookId" value="ISBN1234">
    <div class="mb-3">
        <label for="userName" class="form-label">사용자 이름</label>
        <input type="text" class="form-control" id="userName" name="userName" required>
    </div>
    <div class="mb-3">
        <label for="content" class="form-label">내용</label>
        <textarea class="form-control" id="content" name="content" rows="3" required></textarea>
    </div>
    <button type="submit" class="btn btn-primary">댓글 작성</button>
</form>
</div>

<!-- 댓글 출력 -->
<div>
    <h4>댓글 리뷰</h4>
    <%
        if (reviews.isEmpty()) {
    %>
        <p class="text-muted">댓글이 없습니다. 첫 댓글을 작성해보세요!</p>
    <%
        } else {
            for (String review : reviews) {
    %>
        <div class="border p-3 mb-2">
            <%= review %>
        </div>
    <%
            }
        }
    %>
</div>
