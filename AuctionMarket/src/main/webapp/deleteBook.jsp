<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ include file="dbconn.jsp"%>
<%
	String bookId=request.getParameter("id");

	String sql="SELECT * FROM book WHERE b_id=?";
	pstmt=conn.prepareStatement(sql);
	rs=pstmt.executeQuery();
	
	if (rs.next()) {
		sql="DELETE FROM book WHERE b_id=?";
		pstmt=conn.prepareStatement(sql);
	 	pstmt.setString(1, bookId);
	 	pstmt.executeQuery();
	} else
		out.println("일치하는 도서가 없습니다");
	
	if (rs!=null)
		rs.close();
	if (pstmt!=null)
		pstmt.close();
	if (conn!=null)
		conn.close();
	
	response.sendRedirect("editBook.jsp?edit=delete");
%>