package bbs;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class BbsDAO {

	private Connection conn;
	private ResultSet rs;
	// MySQL에 접속해 로그인하고 BBS라는 이름의 DB에 접근하는 함수
	public BbsDAO() {
		try {
			String dbURL = "jdbc:mysql://localhost:3306/BBS?useUnicode=true&characterEncoding=UTF-8"; // UTF-8로 인코딩
			String dbID = "root";
			String dbPassword = "1234";
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	// 작성 일시 구하는 함수
	public String getDate() {
		 String SQL = "SELECT NOW()"; // 현재시간 구하는 SQL구문
		 try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); // DB연결 실행 준비상태
			rs = pstmt.executeQuery(); // 실제 실행결과 가져옴
			if (rs.next()) { // 결과가 있을때는 
				return rs.getString(1); // 그 결과값을 그대로 반환
			}
		 } catch (Exception e) {
			 e.printStackTrace();
		 }
		 return ""; // 데이터베이스 오류 
	}
	// 게시글 번호 구하는 함수
	public int getNext() {
		String SQL = "SELECT bbsID FROM BBS ORDER BY bbsID DESC"; // 가장 마지막 게시글 번호 구하는 SQL구문
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); // DB연결 실행 준비상태
			rs = pstmt.executeQuery(); // 실제 실행결과 가져옴
			if (rs.next()) { // 결과가 있을때는 
				return rs.getInt(1) + 1; // 가장 마지막 게시글 번호에 +1한 숫자를 반환
			}
			return 1; // 첫 번째 게시물인 경우
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류 
	}
	// 새로 작성한 글 DB에 등록하는 함수
	public int write(String bbsTitle, String userID, String bbsContent) {
		String SQL = "INSERT INTO BBS VALUES (?, ?, ?, ?, ?, ?)"; 
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); // DB연결 실행 준비상태
			pstmt.setInt(1, getNext()); // 게시글 번호
			pstmt.setString(2, bbsTitle); // 게시글 제목
			pstmt.setString(3, userID); // 작성자 ID
			pstmt.setString(4, getDate()); // 작성 일시
			pstmt.setString(5, bbsContent); // 게시글 내용
			pstmt.setInt(6, 1); // 삭제여부(Available): 삭제시0 / 삭제아닐시1
			return pstmt.executeUpdate(); // INSERT문 실행 성공시 0 이상의 결과를 반환			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류시 -1을 반환 (0미만의 숫자) 
	}
	// Bbs.java파일에서 외부 라이브러리로 ArrayList를 가져옴?
	public ArrayList<Bbs> getList(int pageNumber) {
		// 유효값이 1인(삭제되지 않은) 게시물 중 (페이지수-1) x 10개의 최근 게시물(현재 페이지보다 이전 페이지들의 게시물)을 건너뛰고 가장 최근의 게시물(현재 페이지의 게시물)을 최대 10개까지  불러오기
		String SQL = "SELECT * FROM BBS WHERE bbsAvailable = 1 ORDER BY bbsID DESC LIMIT 10 OFFSET ?"; // LIMIT: 최대 레코드 수, OFFSET: 건너뛸 개수
		ArrayList<Bbs> list = new ArrayList<Bbs>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); // DB연결 실행 준비상태
			pstmt.setInt(1, (pageNumber - 1) * 10); // SQL문에서 ?에 들어가는 내용, 앞의 숫자는 ?의 등장 순서
			rs = pstmt.executeQuery(); // 실제 실행결과 가져옴
			while (rs.next()) { // 하나씩 담기
				Bbs bbs = new Bbs();
				bbs.setBbsID(rs.getInt(1)); // 게시글 번호
				bbs.setBbsTitle(rs.getString(2)); // 게시글 제목
				bbs.setUserID(rs.getString(3)); // 작성자 아이디
				bbs.setBbsDate(rs.getString(4)); // 작성일시
				bbs.setBbsContent(rs.getString(5)); // 게시글 내용
				bbs.setBbsAvailable(rs.getInt(6)); // 유효 체크
				list.add(bbs); // 전부 리스트에 저장
			}			
		} catch (Exception e) {  
			e.printStackTrace();
		}
		return list; // 리스트 반환
	}
	// 다음 페이지 존재 여부 체크하는 함수
	public boolean nextPage(int pageNumber) {
		// 		// 유효값이 1인(삭제되지 않은) 게시물 중 (페이지수-1) x 10개의 최근 게시물(현재 페이지보다 이전 페이지들의 게시물)을 건너뛰고 가장 최근의 게시물(현재 페이지의 게시물)을 최대 10개까지  불러오기
		String SQL = "SELECT * FROM BBS WHERE bbsAvailable = 1 ORDER BY bbsID DESC LIMIT 10 OFFSET ?";

		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); // DB연결 실행 준비상태
			pstmt.setInt(1, (pageNumber - 1) * 10); // ?에 넣을 값: (페이지수-1) x 10개
			rs = pstmt.executeQuery(); // 실제 실행결과 가져옴
			if (rs.next()) { // 결과가 하나라도 존재한다면 true를 반환하여 다음 버튼이 표시 되도록 함
				return true; // 
			}			
		} catch (Exception e) {  
			e.printStackTrace();
		}
		return false; // 게시글 번호가 10의 배수로 나누어 떨어져서 다음페이지로 넘어갈 필요가 없는 경우 false를 반환
	}
	 // 특정 게시글 클릭시 글 내용을 불러오는 함수
	public Bbs getBbs(int bbsID) {		
		String SQL = "SELECT * FROM BBS WHERE bbsID = ?;"; // 게시글 번호로 검색
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); // DB연결 실행 준비상태
			pstmt.setInt(1, bbsID); // 
			rs = pstmt.executeQuery(); // 실제 실행결과 가져옴
			if (rs.next()) { 
				Bbs bbs = new Bbs();
				bbs.setBbsID(rs.getInt(1)); // 게시글 번호
				bbs.setBbsTitle(rs.getString(2)); // 게시글 제목
				bbs.setUserID(rs.getString(3)); // 작성자 아이디
				bbs.setBbsDate(rs.getString(4)); // 작성일시
				bbs.setBbsContent(rs.getString(5)); // 게시글 내용
				bbs.setBbsAvailable(rs.getInt(6)); // 유효 체크
				return bbs; // 가져온 게시글 내용을 반환
			}			
		} catch (Exception e) {  
			e.printStackTrace();
		}
		return null; // 개당 번호에 해당하는 게시글이 없는 경우 null 값을 반환
		
	}
	// 게시글 수정 버튼 클릭시 동작 함수
	public int update(int bbsID, String bbsTitle, String bbsContent) {
		String SQL = "UPDATE BBS SET bbsTitle = ?, bbsContent = ? WHERE bbsID = ?;"; 
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); // DB연결 실행 준비상태
			pstmt.setString(1, bbsTitle); // 게시글 제목
			pstmt.setString(2, bbsContent); // 게시글 내용
			pstmt.setInt(3, bbsID); // 작성자 ID			
			return pstmt.executeUpdate(); // UPDATE문 실행 성공시 0 이상의 결과를 반환			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류시 -1을 반환 (0미만의 숫자) 
	}
	// 삭제 버튼 클릭시 동작 함수
	public int delete(int bbsID) {
		String SQL = "UPDATE BBS SET bbsAvailable = 0 WHERE bbsID = ?;"; // 글을 지우는게 아니라 유효값만 0으로 바꿔줌 
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); // DB연결 실행 준비상태
			pstmt.setInt(1, bbsID); // 작성자 ID			
			return pstmt.executeUpdate(); // UPDATE문 실행 성공시 0 이상의 결과를 반환			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류시 -1을 반환 (0미만의 숫자) 
	}
}
