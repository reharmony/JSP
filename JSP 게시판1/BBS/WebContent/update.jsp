<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %> <!-- 라이브러리 import -->
<%@ page import="bbs.Bbs" %> <!-- 파일 import -->
<%@ page import="bbs.BbsDAO" %> <!-- 파일 import -->
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
		if (userID == null) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인이 필요합니다.')"); // 안내 메세지
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
		}		
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
		</div>
	</nav>
	<!-- 게시판 디자인 -->
	<div class="container"> <!-- 내용을 담을 수 있는 공간(컨테이너 생성) -->
		<div class="row"> <!-- 행 설정 -->
			<form method="post" action="updateAction.jsp?bbsID=<%= bbsID %>"> <!-- method:전송방식, post:전송내용숨김, action:form내용 전송할 페이지 -->
				<!-- striped: 행이 번갈아가면서 줄무늬, align: 정렬방식, border: 테두리선  -->
				<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">	
					<thead> <!-- 테이블 상단 속성 설정 -->
						<tr> <!-- 열 설정 -->
							<th colspan="2" style="background-color: #eeeeee; text-align: center;">게시판 글 수정 양식</th>
						</tr>
					</thead> 				
					<tbody> <!-- 테이블 몸체 속성 설정 -->
						<tr> <!-- value 값에 기존 글 제목 표시 -->
							<td><input type="text" class="form-control" placeholder="글 제목" name="bbsTitle" maxlength="50" value="<%= bbs.getBbsTitle() %>"></td> 
						</tr>
						<tr>
							<!-- textarea: 많은 양의 텍스트 입력시 사용, value 값에 기존 글 내용 표시 -->
							<td><textarea class="form-control" placeholder="글 내용" name="bbsContent" maxlength="2048" style="height: 350px;"><%= bbs.getBbsContent() %></textarea></td>
						</tr>
					</tbody>
				</table>	
				<input type="submit" class="btn btn-primary pull-right" value="글수정"><!-- 버튼 오른쪽 고정 -->
			</form>			
		</div>
	</div>
	<script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>