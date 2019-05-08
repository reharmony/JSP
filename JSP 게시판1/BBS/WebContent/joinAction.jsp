<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8");  %>
<jsp:useBean id="user" class="user.User" scope="page" />
<jsp:setProperty name="user" property="userID" />
<jsp:setProperty name="user" property="userPassword" />
<jsp:setProperty name="user" property="userName" />
<jsp:setProperty name="user" property="userGender" />
<jsp:setProperty name="user" property="userEmail" />
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>JSP 게시판 웹사이트</title>
</head>
<body>
	<%	
		String userID = null;
		if (session.getAttribute("userID") != null) { // 로그인 중일 경우 
			userID = (String) session.getAttribute("userID"); // userID라는 변수에 로그인 중인 아이디 할당
		}
		if (userID != null) { // 이미 로그인 되어있는 경우 회원가입 페이지에 들어갈 수 없도록 함
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('이미 로그인이 되어 있습니다.')");
			script.println("location.href = 'main.jsp'");
			script.println("</script>");
		}
		if (user.getUserID() == null || user.getUserPassword() == null || user.getUserName() == null
			|| user.getUserGender() == null || user.getUserEmail() == null) { // 누락된 항목 있음
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('모든 항목을 입력해주세요.')");
			script.println("history.back()"); // 이전 페이지로 복귀
			script.println("</script>");
		} else { // 모든 항목 입력됨
			UserDAO userDAO = new UserDAO();
			int result = userDAO.join(user);
			if (result == -1) { // 아이디 중복
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('이미 존재하는 아이디입니다.')");
				script.println("history.back()"); // 이전 페이지로 복귀
				script.println("</script>");
			}
			else { // 회원가입 성공시
				session.setAttribute("userID", user.getUserID()); // 세션 유지
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("location.href = 'main.jsp'"); // 메인 페이지로 이동
				script.println("</script>");
			}
		}
		
	%>
</body>
</html>