<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %> <!-- 라이브러리 import -->
<%@ page import="bbs.BbsDAO" %> <!-- 파일 import -->
<%@ page import="bbs.Bbs" %> <!-- 파일 import -->
<%@ page import="java.util.ArrayList" %> <!-- 게시판 목록을 출력하기 위해 필요함 -->
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewprt" content="width=device-width" initial-scale="1"> 
<link rel="stylesheet" href="css/bootstrap.css">
<title>JSP 게시판 웹사이트</title>
<style type="text/css"> 
	a, a:hover { /* 하이퍼텍스트 글자, 거기에 마우스 올렸을 때 */
		color: #000000; /* 글자색 검은색 */
		text-decoration: none; /* 효과 없음 (밑줄 제거) */
	}
	
	td a:visited { /* 이미 본 게시글 */
		color: #999; /* 색상 변경 */
		text-decoration: none; /* 밑줄 제거 */
	}
</style>
</head>
<body>
	<% // html 안에 java구문 사용할때 쓰는건가?
		String userID = null;
		if (session.getAttribute("userID") != null) { // 로그인 중일 경우 
			userID = (String) session.getAttribute("userID"); // userID라는 변수에 로그인 중인 아이디 할당
		}
		int pageNumber = 1; // 기본 페이지 번호 1
		if (request.getParameter("pageNumber") != null) { // 페이지 번호  값이 존재할 경우(2페이지 이상으로 넘어갔을 경우)
			pageNumber = Integer.parseInt(request.getParameter("pageNumber")); // 그 값을 정수형으로 가져와서 pageNumber 변수에 할당
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
			<!-- striped: 행이 번갈아가면서 줄무늬, algin: 정렬방식, border: 테두리선  -->
			<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">	
				<thead> <!-- 테이블 상단 속성 설정 -->
					<tr> <!-- 열 설정 -->
						<th style="background-color: #eeeeee; text-align: center;">번호</th>
						<th style="background-color: #eeeeee; text-align: center;">제목</th>
						<th style="background-color: #eeeeee; text-align: center;">작성자</th>
						<th style="background-color: #eeeeee; text-align: center;">작성일</th>
					</tr>
				</thead> 				
				<tbody> <!-- 테이블 몸체 속성 설정 -->
					<% /* 게시판 글 목록에 실제 출력될 내용 */
						BbsDAO bbsDAO = new BbsDAO();
						ArrayList<Bbs> list = bbsDAO.getList(pageNumber); /* 현재 페이지 번호에 해당하는 게시글 목록 가져오기 */
						for(int i = 0; i < list.size(); i++) { /* for문으로 게시글 하나씩 표시 */
					%>
					<tr>
						<td><%= list.get(i).getBbsID() %></td> <!-- 게시글 번호 -->					 
						<td><a href="view.jsp?bbsID=<%= list.get(i).getBbsID() %>"><%= list.get(i).getBbsTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>") %></a></td> <!-- 게시글제목 (하이퍼링크) -->
						<td><%= list.get(i).getUserID() %></td> <!-- 작성자 아이디 -->
						<!-- 작성 일시: 날짜 표시 형식 YYYY-MM-DD HH시 MM분 -->
						<td><%= list.get(i).getBbsDate().substring(0,11) + list.get(i).getBbsDate().substring(11,13) + "시 " + list.get(i).getBbsDate().substring(14,16) + "분" %></td> 
					</tr>
					<%
						}
					%>
				</tbody>
			</table>	
			<% 
				if(pageNumber != 1) { // 현재 페이지가 1페이지가 아니라면	
			%>
				<a href="bbs.jsp?pageNumber=<%= pageNumber - 1 %>" class="btn btn-success btn-arraw-left">이전</a> <!--이전 버튼 생성  -->
			<%
				} if(bbsDAO.nextPage(pageNumber +1)) { // 다음 페이지가 존재한다면
			%>
				<a href="bbs.jsp?pageNumber=<%= pageNumber + 1 %>" class="btn btn-success btn-arraw-left">다음</a> <!--다음 버튼 생성  -->
			<%
				}
			%>
			<a href="write.jsp" class="btn btn-primary pull-right">글쓰기</a> <!-- 버튼 오른쪽 고정 -->
		</div>
	</div>
	<script src="https://code.jquery.com/jquery-3.3.1.min.js"></script> <!-- 제이쿼리 폼-->
	<script src="js/bootstrap.js"></script> <!-- 부트스트랩 폼-->
</body>
</html>