<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.sql.*" %>
<%
    String reviewId = request.getParameter("reviewId");
    String bookId = request.getParameter("bookId");

    if (reviewId != null && !reviewId.isEmpty()) {
        try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/BookMarketDB", "root", "1234");
             PreparedStatement pstmt = conn.prepareStatement("DELETE FROM review WHERE review_id = ?")) {

            pstmt.setInt(1, Integer.parseInt(reviewId));
            int rowsDeleted = pstmt.executeUpdate();

            if (rowsDeleted > 0) {
                out.println("<p>댓글이 성공적으로 삭제되었습니다.</p>");
            } else {
                out.println("<p>댓글 삭제에 실패했습니다.</p>");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<p>댓글 삭제 중 오류 발생: " + e.getMessage() + "</p>");
        }
    } else {
        out.println("<p>잘못된 요청입니다. 댓글 ID가 없습니다.</p>");
    }

    // 삭제 후 도서 상세 페이지로 리다이렉션
    response.sendRedirect("book.jsp?id=" + bookId);
%>