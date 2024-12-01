<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="dto.Book"%>
<%@ page import="dao.BookRepository"%>
<%@ page import="com.oreilly.servlet.*"%>
<%@ page import="com.oreilly.servlet.multipart.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%@ include file="dbconn.jsp"%>

<%
	request.setCharacterEncoding("UTF-8");

	String filename="";
	String realFolder="E:\\Web_dev\\eclipse-workspace\\.metadata\\.plugins\\org.eclipse.wst.server.core\\tmp0\\wtpwebapps\\NewBookMarket\\resources\\images";
	int maxSize=5 * 1024 * 1024;
	String encType="utf-8";

	MultipartRequest multi = new MultipartRequest(request, realFolder, maxSize, encType, new DefaultFileRenamePolicy());

	String bookId = request.getParameter("bookId");
	String name = request.getParameter("name");
	String unitPrice = request.getParameter("unitPrice");
	String author = request.getParameter("author");
	String publisher = request.getParameter("publisher");
	String releaseDate = request.getParameter("releaseDate");	
	String description = request.getParameter("description");	
	String category = request.getParameter("category");
	String unitsInStock = request.getParameter("unitsInStock");
	String condition = request.getParameter("condition");

	Enumeration files=multi.getFileNames();
	String fname = (String) files.nextElement();
	String fileName = multi.getFilesystemName(fname);
	
	Integer price;

	if (unitPrice.isEmpty())
		price = 0;
	else
		price = Integer.valueOf(unitPrice);

	long stock;

	if (unitsInStock.isEmpty())
		stock = 0;
	else
		stock = Long.valueOf(unitsInStock);
	
	PreparedStatement pstmt=null;
	
	String sql="iNSERT INTO book VALUES(?,?,?,?,?,?,?,?,?,?,?)";
	
	pstmt=conn.prepareStatement(sql);
	pstmt.setString(1,bookId);
	pstmt.setString(2,name);
	pstmt.setInt(3,price);
	pstmt.setString(4,author);
	pstmt.setString(5,description);
	pstmt.setString(6,publisher);
	pstmt.setString(7,category);
	pstmt.setLong(8,stock);
	pstmt.setString(9,releaseDate);
	pstmt.setString(10,condition);
	pstmt.setString(11,fileName);
	pstmt.execute();

	if(pstmt!=null)
		pstmt.close();
	if(conn!=null)
		conn.close();
	
	response.sendRedirect("books.jsp");

%>
