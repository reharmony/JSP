<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>JSP 게시판 웹사이트</title>
</head>
<body>
	<%
		session.invalidate(); // 세션 해제		
	%>
	<script>
		location.href = 'main.jsp';  // 메인 페이지로 이동
	</script>
</body>
</html>

