<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

	<% int n1=Integer.parseInt(request.getParameter("num"));
	
		int a=10+n1;
	%>
	


	<%!
		
		int sqaure(int n1){
		return n1*n1;
	}
	
	
	%>
	
	<h3>SQUARE IS: <%=sqaure(n1) %></h3>
	<h3>ADDITION IS: <%=a %></h3>


	<%-- <% 
		int n=Integer.parseInt(request.getParameter("num"));
		
		for(int i=0;i<n;i++){
			for(int j=0;j<n;j++){
				out.print("*"+"");
			}
			out.println("<br>");
		}

	%> --%>
</body>
</html>