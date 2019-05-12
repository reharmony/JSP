<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8");  %>
<jsp:useBean id="bbs" class="bbs.Bbs" scope="page" /> <!-- 하나의 게시글 인스턴스 -->
<jsp:setProperty name="bbs" property="bbsTitle" />
<jsp:setProperty name="bbs" property="bbsContent" />
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
		if (userID == null) { // 글쓰기 버튼 클릭시 로그아웃 상태인 경우 로그인 페이지로 이동
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인이 필요합니다..')"); // 안내 메세지
			script.println("location.href = 'login.jsp'"); // 로그인 페이지로 이동
			script.println("</script>");
		} else {
			if (bbs.getBbsTitle() == null || bbs.getBbsContent() == null) { // 누락된 항목이 있는 경우
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('모든 항목을 입력해주세요.')");
					script.println("history.back()"); // 이전 페이지로 복귀
					script.println("</script>");
				} else { // 모든 항목이 입력된 경우
					BbsDAO bbsDAO = new BbsDAO();
					int result = bbsDAO.write(bbs.getBbsTitle(), userID, bbs.getBbsContent());
					if (result == -1) { // 데이터베이스 오류 발생시
						PrintWriter script = response.getWriter();
						script.println("<script>");
						script.println("alert('글쓰기에 실패했습니다.')");
						script.println("history.back()"); // 이전 페이지로 복귀
						script.println("</script>");
					}
					else { // 정상적으로 게시글 입력 성공시
						PrintWriter script = response.getWriter();
						script.println("<script>");
						script.println("location.href = 'bbs.jsp'"); // 게시판 페이지로 이동
						script.println("</script>");
					}
				}
		}
		
		
	%>
</body>
</html>