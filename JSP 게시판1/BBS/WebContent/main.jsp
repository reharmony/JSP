<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %> <!-- 라이브러리 import -->
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewprt" content="width=device-width" initial-scale="1"> 
<link rel="stylesheet" href="css/bootstrap.css"> <!-- 부트스트랩 css 설정파일 참조 -->
<link rel="stylesheet" href="css/custom.css"> <!-- 커스텀 css 설정파일 참조  -->
<link rel="stylesheet" href="css/custom.css"> <!-- 커스텀 css 설정파일 참조  -->
<title>JSP 게시판 웹사이트</title>
</head>
<body>
	<% // html 안에 jsp구문 사용할때 <% 사용
		String userID = null;
		if (session.getAttribute("userID") != null) { // 로그인 중일 경우 
			userID = (String) session.getAttribute("userID"); // userID라는 변수에 로그인 중인 아이디 할당
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
				<li class="active"><a href="main.jsp">메인</a></li> <!-- class="active"로 메인 페이지 활성화 -->
				<li><a href="bbs.jsp">게시판</a></li>				
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
	<div class="container">
		<div class="jumbotron"> <!-- 부트스트랩에서 웹사이트 소개 페이지 구성할 때 쓰는 요소 -->
			<h1>웹 사이트 소개</h1>
			<p> 대충 웹사이트를 소개한다는 내용 </p>
			<p> <a class="btn btn-primary btn-pull" href="소개페이지 링크" role="button">자세히 알아보기</a></p>
		</div>
	</div>
	<div class="containter">
		<div id="myCarousel" class="carousel slide" data-ride="carousel"> <!-- 슬라이드 형태로 구현 -->
			<ol class="carousel-indicators"> <!-- 중앙 하단에 보이는 동그라미를 리스트 형태로 배치 -->
				<!-- data-slide-to: 슬라이드 순서 , active: 현재 보이는 이미지라는 표시-->
				<li data-target="#myCarousel" data-slide-to="0" class="active"></li>
				<li data-target="#myCarousel" data-slide-to="1"></li>
				<li data-target="#myCarousel" data-slide-to="2"></li>
			</ol>
			<div class="carousel-inner" align="center"> <!-- 이미지 실제로 배치하는 영역 -->
				<div class="item active"> <!-- item active 이미지만 표시됨 -->
					<img src="images/1.jpg">
				</div>
				<div class="item">
					<img src="images/2.jpg">
				</div>
				<div class="item">
					<img src="images/3.jpg">
				</div>
			</div>
			<!-- 이전 이미지 버튼 -->
			<a class="left carousel-control" href="#myCarousel" data-slide="prev">
				<span class="glyphicon glyphicon-chevron-left"></span> <!-- 왼쪽에 배치 -->
			</a>
			<!-- 다음 이미지 버튼 -->
			<a class="right carousel-control" href="#myCarousel" data-slide="next">
				<span class="glyphicon glyphicon-chevron-right"></span> <!-- 오른쪽에 배치 -->
			</a>
		</div>
	</div>
	<script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>