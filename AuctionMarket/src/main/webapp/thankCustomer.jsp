<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.net.URLDecoder" %>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="./resources/css/bootstrap.min.css" />
<meta charset="UTF-8">
<title>주문 완료</title>
</head>
<body>
<%
	String shipping_cartId="";
	String shipping_name="";
	String Shipping_shippingDate="";
	String Shipping_country="";
	String Shipping_zipCode="";
	String Shipping_addressName="";
	
	Cookie[] cookies=request.getCookies();
	
	if(cookies!=null){
		for(int i=0;i<cookies.length;i++){
			Cookie thisCookie=cookies[i];
			String n=thisCookie.getName();
			if(n.equals("shipping_cartId"))
				shipping_cartId=URLDecoder.decode((thisCookie.getValue()),"utf-8");
			if(n.equals("Shipping_shippingDate"))
				Shipping_shippingDate=URLDecoder.decode((thisCookie.getValue()),"utf-8");
		}
	}
%>

<div class="container py-4">
   <%@ include file="menu.jsp"%>    
   
    <div class="p-5 mb-4 bg-body-tertiary rounded-3">
      <div class="container-fluid py-5">
        <h1 class="display-5 fw-bold">주문 완료</h1>
        <p class="col-md-8 fs-4">Order Completed</p>      
      </div>
    </div>

    <div class="row align-items-md-stretch">
    	<h2 class="alert alert-danger">주문해주셔서 감사합니다.</h2>
    	<p> 주문은<% out.println(Shipping_shippingDate); %>에 배송될 예정입니다!
    	<p> 주문번호 :<% out.println(shipping_cartId); %>
 	</div> 	
	<%@ include file="footer.jsp"%>   
 </div>
</body>
</html>
<%
for(int i=0;i<cookies.length;i++){
	Cookie thisCookie=cookies[i];
	String n=thisCookie.getName();
	if(n.equals("shipping_cartId"))
		thisCookie.setMaxAge(0);
	if(n.equals("shipping_name"))
		thisCookie.setMaxAge(0);
	if(n.equals("Shipping_shippingDate"))
		thisCookie.setMaxAge(0);
	if(n.equals("Shipping_country"))
		thisCookie.setMaxAge(0);
	if(n.equals("Shipping_zipCode"))
		thisCookie.setMaxAge(0);
	if(n.equals("Shipping_addressName"))
		thisCookie.setMaxAge(0);
	
	response.addCookie(thisCookie);
}
%>