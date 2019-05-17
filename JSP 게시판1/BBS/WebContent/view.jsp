<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %> <!-- 라이브러리 import -->
<%@ page import="bbs.Bbs" %> <!-- 라이브러리 import -->
<%@ page import="bbs.BbsDAO" %> <!-- 라이브러리 import -->
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewprt" content="width=device-width" initial-scale="1"> 
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css"> <!-- 커스텀 css 설정파일 참조  -->
<title>JSP 게시판 웹사이트</title>
</head>
<body>
	<% // html 안에 java구문 사용할때 쓰는건가?
		String userID = null;
		if (session.getAttribute("userID") != null) { // 로그인 중일 경우 
			userID = (String) session.getAttribute("userID"); // userID라는 변수에 로그인 중인 아이디 할당
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
		Bbs bbs = new BbsDAO().getBbs(bbsID); // 게시글 번호를 bbs 변수에 할당
	%>
	<nav class="navbar navbar-default">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed"
				data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
				aria-expanded="false">
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
			<a class="navbar-brand" href="main.jsp">JSP 게시판 웹 사이트</a>
		</div>
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="main.jsp">메인</a></li> 
				<li class="active"><a href="main.jsp">게시판</a></li> <!-- class="active"로 게시판 페이지 활성화 표시 -->				
			</ul>
			<%
				if(userID == null) { // 로그인 전일 경우 메뉴
			%> 
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">접속하기<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="login.jsp">로그인</a></li>
						<li><a href="join.jsp">회원가입</a></li>
					</ul>
				</li>
			</ul>
			<%
				} else { // 로그인한 경우 메뉴
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">회원관리<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="logoutAction.jsp">로그아웃</a></li>
					</ul>
				</li>
			</ul>
			<%
				}
			%>
		</div>
	</nav>
	<!-- 게시판 디자인 -->
	<div class="container"> <!-- 내용을 담을 수 있는 공간(컨테이너 생성) -->
		<div class="row"> <!-- 행 설정 -->
			<!-- striped: 행이 번갈아가면서 줄무늬, align: 정렬방식, border: 테두리선  -->
			<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">	
				<thead> <!-- 테이블 상단 속성 설정 -->
					<tr> <!-- 열 설정 -->
						<th colspan="3" style="background-color: #eeeeee; text-align: center;">게시판 글 보기</th>
					</tr>
				</thead> 				
				<tbody> <!-- 테이블 몸체 속성 설정 -->
					<tr>
						<td style="width: 20%;">글 제목</td> <!-- 글 제목 스타일 설정 -->
						<td colspan="2"><%= bbs.getBbsTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>") %></td> <!-- 글 제목 불러오기 -->						
					</tr>				
					<tr>
						<td>작성자</td> 
						<td colspan="2"><%= bbs.getUserID() %></td> <!-- 작성자 아이디 불러오기 -->						
					</tr>				
					<tr>
						<td>작성일자</td> 
						<td colspan="2"><%= bbs.getBbsDate().substring(0,11) + bbs.getBbsDate().substring(11,13) + "시 " + bbs.getBbsDate().substring(14,16) + "분" %></td>						
					</tr>				
					<tr>
						<td>내용</td> 
						<td colspan="2" style="min-height: 200px; text-align: left;"><%= bbs.getBbsContent().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>") %></td> <!-- 글 내용 불러오기 -->						
					</tr>				
				</tbody>
			</table>
			<a href="bbs.jsp" class="btn btn-primary">목록</a>
			<%
				if(userID != null && userID.equals(bbs.getUserID())) { // 현재 로그인된 사용자가 글 작성자와 동일하다면
			%>
				<a href="update.jsp?bbsID=<%= bbsID %>" class="btn btn-primary">수정</a> <!-- 수정버튼 누르면 update.jsp 파일 실행 -->
				<a onclick="return confirm('정말로 삭제하시겠습니까?')" href="deleteAction.jsp?bbsID=<%= bbsID %>" class="btn btn-primary">삭제</a> <!-- 삭제버튼 누르면 deleteAction.jsp 파일 실행 -->
			<%
				}
			%>
			<input type="submit" class="btn btn-primary pull-right" value="글쓰기"> <!-- 버튼 오른쪽 고정 -->
		</div>
	</div>
	<script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>