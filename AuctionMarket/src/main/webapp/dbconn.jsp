<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	Connection conn=null;

	try{
		String url="jdbc:mysql://localhost:3306/BookMarketDB";
		String user="root";
		String password="1234";
		
		Class.forName("com.mysql.jdbc.Driver");
		conn=DriverManager.getConnection(url, user, password);
	} catch(SQLException ex){
		out.println("데이터베이스 연결이 실패했습니다.<br>");
		out.println("SQLExeption: " + ex.getMessage());
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

</body>
</html>