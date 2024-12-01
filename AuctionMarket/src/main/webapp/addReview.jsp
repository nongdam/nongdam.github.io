<%@ page pageEncoding="UTF-8"%>
<%@ page import="dao.ReviewRepository"%>
<%@ page import="dto.Review"%>

<%
    String bookId = request.getParameter("bookId");
    String userName = request.getParameter("userName");
    String content = request.getParameter("content");

    // 디버깅 코드
    out.println("DEBUG: bookId = " + bookId);
    out.println("DEBUG: userName = " + userName);
    out.println("DEBUG: content = " + content);

    if (bookId != null && userName != null && content != null) {
        Review review = new Review(bookId, userName, content);
        ReviewRepository reviewDAO = ReviewRepository.getInstance();
        reviewDAO.addReview(review);

        response.sendRedirect("book.jsp?id=" + bookId); // 도서 상세 페이지로 리다이렉션
    } else {
        out.println("DEBUG: 댓글 데이터가 유효하지 않습니다.");
    }
%>