<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="bbs.Bbs" %> <!-- 이 파일에선 빈즈를 사용하지 않음  -->
<%@ page import="bbs.BbsDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8");  %>
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
		} 
		int bbsID = 0;
		if (request.getParameter("bbsID") != null) { // bbs.BbsDAO에서 값이 정상적으로 넘어온 경우
			bbsID = Integer.parseInt(request.getParameter("bbsID")); // 해당 게시글번호를 bbsID 변수에 할당
		}
		if (bbsID == 0) { // bbs.BbsDAO에서 값이 정상적으로 넘어오지 않은 경우
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 글입니다.')"); // 안내 메세지
			script.println("location.href = 'bbs.jsp'"); // 게시판 페이지로 이동
			script.println("</script>");
		}
		Bbs bbs = new BbsDAO().getBbs(bbsID); 
		if (!userID.equals(bbs.getUserID())) { // 현재 로그인된 사용자와(세션) 작성자의 아이디가 동일한지 확인
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('작성자만 수정할 수 있습니다.')"); // 안내 메세지
			script.println("location.href = 'bbs.jsp'"); // 게시판 페이지로 이동
			script.println("</script>");
		} else { // 로그인 상태에 문제가 없는경우 -> update.jsp에서 넘어온 제목과 글 내용을 체크
			if (request.getParameter("bbsTitle") == null || request.getParameter("bbsContent") == null // null 값인 항목이 있는 경우
					|| request.getParameter("bbsTitle").equals("") || request.getParameter("bbsContent").equals("")) { // 공백인 항목이 있는 경우
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('모든 항목을 입력해주세요.')");
					script.println("history.back()"); // 이전 페이지로 복귀
					script.println("</script>");
				} else { // 모든 항목이 정상적으로 입력된 경우
					BbsDAO bbsDAO = new BbsDAO();
					int result = bbsDAO.update(bbsID, request.getParameter("bbsTitle"), request.getParameter("bbsContent"));
					if (result == -1) { // 데이터베이스 오류 발생시
						PrintWriter script = response.getWriter();
						script.println("<script>");
						script.println("alert('글 수정에 실패했습니다.')");
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