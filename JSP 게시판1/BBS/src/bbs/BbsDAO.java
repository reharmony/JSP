package bbs;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class BbsDAO {

	private Connection conn;
	private ResultSet rs;
	// MySQL�� ������ �α����ϰ� BBS��� �̸��� DB�� �����ϴ� �Լ�
	public BbsDAO() {
		try {
			String dbURL = "jdbc:mysql://localhost:3306/BBS?useUnicode=true&characterEncoding=UTF-8"; // UTF-8�� ���ڵ�
			String dbID = "root";
			String dbPassword = "1234";
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	// �ۼ� �Ͻ� ���ϴ� �Լ�
	public String getDate() {
		 String SQL = "SELECT NOW()"; // ����ð� ���ϴ� SQL����
		 try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); // DB���� ���� �غ����
			rs = pstmt.executeQuery(); // ���� ������ ������
			if (rs.next()) { // ����� �������� 
				return rs.getString(1); // �� ������� �״�� ��ȯ
			}
		 } catch (Exception e) {
			 e.printStackTrace();
		 }
		 return ""; // �����ͺ��̽� ���� 
	}
	// �Խñ� ��ȣ ���ϴ� �Լ�
	public int getNext() {
		String SQL = "SELECT bbsID FROM BBS ORDER BY bbsID DESC"; // ���� ������ �Խñ� ��ȣ ���ϴ� SQL����
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); // DB���� ���� �غ����
			rs = pstmt.executeQuery(); // ���� ������ ������
			if (rs.next()) { // ����� �������� 
				return rs.getInt(1) + 1; // ���� ������ �Խñ� ��ȣ�� +1�� ���ڸ� ��ȯ
			}
			return 1; // ù ��° �Խù��� ���
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // �����ͺ��̽� ���� 
	}
	// ���� �ۼ��� �� DB�� ����ϴ� �Լ�
	public int write(String bbsTitle, String userID, String bbsContent) {
		String SQL = "INSERT INTO BBS VALUES (?, ?, ?, ?, ?, ?)"; 
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); // DB���� ���� �غ����
			pstmt.setInt(1, getNext()); // �Խñ� ��ȣ
			pstmt.setString(2, bbsTitle); // �Խñ� ����
			pstmt.setString(3, userID); // �ۼ��� ID
			pstmt.setString(4, getDate()); // �ۼ� �Ͻ�
			pstmt.setString(5, bbsContent); // �Խñ� ����
			pstmt.setInt(6, 1); // ��������(Available): ������0 / �����ƴҽ�1
			return pstmt.executeUpdate(); // INSERT�� ���� ������ 0 �̻��� ����� ��ȯ			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // �����ͺ��̽� ������ -1�� ��ȯ (0�̸��� ����) 
	}
	// Bbs.java���Ͽ��� �ܺ� ���̺귯���� ArrayList�� ������?
	public ArrayList<Bbs> getList(int pageNumber) {
		// ��ȿ���� 1��(�������� ����) �Խù� �� (��������-1) x 10���� �ֱ� �Խù�(���� ���������� ���� ���������� �Խù�)�� �ǳʶٰ� ���� �ֱ��� �Խù�(���� �������� �Խù�)�� �ִ� 10������  �ҷ�����
		String SQL = "SELECT * FROM BBS WHERE bbsAvailable = 1 ORDER BY bbsID DESC LIMIT 10 OFFSET ?"; // LIMIT: �ִ� ���ڵ� ��, OFFSET: �ǳʶ� ����
		ArrayList<Bbs> list = new ArrayList<Bbs>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); // DB���� ���� �غ����
			pstmt.setInt(1, (pageNumber - 1) * 10); // SQL������ ?�� ���� ����, ���� ���ڴ� ?�� ���� ����
			rs = pstmt.executeQuery(); // ���� ������ ������
			while (rs.next()) { // �ϳ��� ���
				Bbs bbs = new Bbs();
				bbs.setBbsID(rs.getInt(1)); // �Խñ� ��ȣ
				bbs.setBbsTitle(rs.getString(2)); // �Խñ� ����
				bbs.setUserID(rs.getString(3)); // �ۼ��� ���̵�
				bbs.setBbsDate(rs.getString(4)); // �ۼ��Ͻ�
				bbs.setBbsContent(rs.getString(5)); // �Խñ� ����
				bbs.setBbsAvailable(rs.getInt(6)); // ��ȿ üũ
				list.add(bbs); // ���� ����Ʈ�� ����
			}			
		} catch (Exception e) {  
			e.printStackTrace();
		}
		return list; // ����Ʈ ��ȯ
	}
	// ���� ������ ���� ���� üũ�ϴ� �Լ�
	public boolean nextPage(int pageNumber) {
		// 		// ��ȿ���� 1��(�������� ����) �Խù� �� (��������-1) x 10���� �ֱ� �Խù�(���� ���������� ���� ���������� �Խù�)�� �ǳʶٰ� ���� �ֱ��� �Խù�(���� �������� �Խù�)�� �ִ� 10������  �ҷ�����
		String SQL = "SELECT * FROM BBS WHERE bbsAvailable = 1 ORDER BY bbsID DESC LIMIT 10 OFFSET ?";

		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); // DB���� ���� �غ����
			pstmt.setInt(1, (pageNumber - 1) * 10); // ?�� ���� ��: (��������-1) x 10��
			rs = pstmt.executeQuery(); // ���� ������ ������
			if (rs.next()) { // ����� �ϳ��� �����Ѵٸ� true�� ��ȯ�Ͽ� ���� ��ư�� ǥ�� �ǵ��� ��
				return true; // 
			}			
		} catch (Exception e) {  
			e.printStackTrace();
		}
		return false; // �Խñ� ��ȣ�� 10�� ����� ������ �������� ������������ �Ѿ �ʿ䰡 ���� ��� false�� ��ȯ
	}
	 // Ư�� �Խñ� Ŭ���� �� ������ �ҷ����� �Լ�
	public Bbs getBbs(int bbsID) {		
		String SQL = "SELECT * FROM BBS WHERE bbsID = ?;"; // �Խñ� ��ȣ�� �˻�
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); // DB���� ���� �غ����
			pstmt.setInt(1, bbsID); // 
			rs = pstmt.executeQuery(); // ���� ������ ������
			if (rs.next()) { 
				Bbs bbs = new Bbs();
				bbs.setBbsID(rs.getInt(1)); // �Խñ� ��ȣ
				bbs.setBbsTitle(rs.getString(2)); // �Խñ� ����
				bbs.setUserID(rs.getString(3)); // �ۼ��� ���̵�
				bbs.setBbsDate(rs.getString(4)); // �ۼ��Ͻ�
				bbs.setBbsContent(rs.getString(5)); // �Խñ� ����
				bbs.setBbsAvailable(rs.getInt(6)); // ��ȿ üũ
				return bbs; // ������ �Խñ� ������ ��ȯ
			}			
		} catch (Exception e) {  
			e.printStackTrace();
		}
		return null; // ���� ��ȣ�� �ش��ϴ� �Խñ��� ���� ��� null ���� ��ȯ
		
	}
	// �Խñ� ���� ��ư Ŭ���� ���� �Լ�
	public int update(int bbsID, String bbsTitle, String bbsContent) {
		String SQL = "UPDATE BBS SET bbsTitle = ?, bbsContent = ? WHERE bbsID = ?;"; 
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); // DB���� ���� �غ����
			pstmt.setString(1, bbsTitle); // �Խñ� ����
			pstmt.setString(2, bbsContent); // �Խñ� ����
			pstmt.setInt(3, bbsID); // �ۼ��� ID			
			return pstmt.executeUpdate(); // UPDATE�� ���� ������ 0 �̻��� ����� ��ȯ			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // �����ͺ��̽� ������ -1�� ��ȯ (0�̸��� ����) 
	}
	// ���� ��ư Ŭ���� ���� �Լ�
	public int delete(int bbsID) {
		String SQL = "UPDATE BBS SET bbsAvailable = 0 WHERE bbsID = ?;"; // ���� ����°� �ƴ϶� ��ȿ���� 0���� �ٲ��� 
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); // DB���� ���� �غ����
			pstmt.setInt(1, bbsID); // �ۼ��� ID			
			return pstmt.executeUpdate(); // UPDATE�� ���� ������ 0 �̻��� ����� ��ȯ			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // �����ͺ��̽� ������ -1�� ��ȯ (0�̸��� ����) 
	}
}
