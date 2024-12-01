<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="dto.Book"%>
<%@ page import="dao.BookRepository"%>

<jsp:useBean id="bookDAO" class="dao.BookRepository" scope="session" />

<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>도서 상세 정보</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="./resources/css/review.css" />
</head>
<body>
<div class="container py-4">
    <%@ include file="menu.jsp" %>

    <div class="p-5 mb-4 bg-body-tertiary rounded-3">
        <div class="container-fluid py-5">
            <h1 class="display-5 fw-bold">도서정보</h1>
        </div>
    </div>

    <%
        String id = request.getParameter("id");

        if (id == null || id.isEmpty()) {
            out.println("<div class='alert alert-danger'>도서 ID가 전달되지 않았습니다.</div>");
            return;
        }

        // 도서 정보 가져오기
        BookRepository dao = BookRepository.getInstance();
        Book book = dao.getBookById(id);

        // DB 연결 정보
        String dbUrl = "jdbc:mysql://localhost:3306/BookMarketDB";
        String dbUser = "root";
        String dbPassword = "1234";

        // 댓글 작성 처리
        String userName = request.getParameter("userName");
        String content = request.getParameter("content");

        if (userName != null && content != null && !userName.isEmpty() && !content.isEmpty()) {
            try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
                 PreparedStatement pstmt = conn.prepareStatement(
                     "INSERT INTO review (book_id, user_name, content) VALUES (?, ?, ?)")) {

                pstmt.setString(1, id);
                pstmt.setString(2, userName);
                pstmt.setString(3, content);
                pstmt.executeUpdate();

                // 댓글 작성 후 리다이렉트
                response.sendRedirect("book.jsp?id=" + id);
                return;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // 댓글 조회 처리
        ArrayList<String> reviews = new ArrayList<>();
    try (Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
         PreparedStatement pstmt = conn.prepareStatement(
             "SELECT review_id, user_name, content, created_at FROM review WHERE book_id = ? ORDER BY created_at DESC")) {

        pstmt.setString(1, id);
        try (ResultSet rs = pstmt.executeQuery()) {
        	while (rs.next()) {
        	    String review = String.format(
        	        "%s (작성일: %s)&&%s&&%d", // 작성자와 날짜 && 내용 && reviewId
        	        rs.getString("user_name"),
        	        rs.getTimestamp("created_at"),
        	        rs.getString("content"),
        	        rs.getInt("review_id")
        	    );
        	    reviews.add(review);
        	}

        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    %>

    <!-- 도서 정보 -->
    <div class="row align-items-md-stretch">
        <div class="col-md-5">
            <img src="./resources/images/<%= book.getFilename() %>" class="img-fluid rounded" />
        </div>
        <div class="col-md-7">
            <h3><b><%= book.getName() %></b></h3>
            <p><%= book.getDescription() %></p>
            <p><b>도서코드:</b> <span class="badge text-bg-danger"><%= book.getBookId() %></span></p>
            <p><b>저자:</b> <%= book.getAuthor() %></p>
            <p><b>출판사:</b> <%= book.getPublisher() %></p>
            <p><b>출판일:</b> <%= book.getReleaseDate() %></p>
            <p><b>분류:</b> <%= book.getCategory() %></p>
            <p><b>재고수:</b> <%= book.getUnitsInStock() %></p>
            <h4><%= book.getUnitPrice() %>원</h4>
            <form name="addForm" action="./addCart.jsp?id=<%= book.getBookId() %>" method="post">
                <a href="#" class="btn btn-info" onclick="addToCart()">도서주문 &raquo;</a>
                <a href="./cart.jsp" class="btn btn-warning">장바구니 &raquo;</a>
                <a href="./books.jsp" class="btn btn-secondary">도서목록 &raquo;</a>
            </form>
        </div>
    </div>

    <div class="section-divider"></div><br>

    <!-- 댓글 작성 -->
    <div class="mb-4">
        <h4>댓글 작성</h4>
        <form method="post" action="book.jsp?id=<%= id %>">
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

    <div class="section-divider"></div>

    <!-- 댓글 출력 -->
<div>
    <h4>댓글 리뷰</h4>
    <% if (reviews.isEmpty()) { %>
        <p class="text-muted">댓글이 없습니다. 첫 댓글을 작성해보세요!</p>
    <% } else { %>
        <% for (String review : reviews) { %>
            <div class="review-box">
                <div class="d-flex justify-content-between align-items-center mb-2">
                    <!-- 작성자와 작성일 -->
                    <div>
                        <%= review.split("&&")[0] %> <!-- 작성자와 날짜 -->
                    </div>
                    <!-- 삭제 버튼 -->
                    <a href="deleteReview.jsp?reviewId=<%= review.split("&&")[2] %>&bookId=<%= id %>" 
                       class="btn btn-danger btn-sm">삭제</a>
                </div>
                <hr>
                <p><%= review.split("&&")[1] %></p>
            </div>
        <% } %>
    <% } %>
</div>



    <jsp:include page="footer.jsp" />
</div>
</body>
</html>