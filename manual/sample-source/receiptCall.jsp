<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="org.apache.commons.codec.binary.Hex" %>

<%
request.setCharacterEncoding("utf-8"); 

String merchantKey  = ""; // 상점키 (가맹점관리 시스템->[가맹점정보]->[결제환경 설정]->[KEY관리] 메뉴를 통해 확인 가능합니다.)
String mid			= ""; // 상점 ID

/*
*******************************************************
* <해쉬암호화> (수정하지 마세요)
* SHA-256 해쉬암호화는 거래 위변조를 막기위한 방법입니다. 
*******************************************************
*/

DataEncrypt sha256Enc 	= new DataEncrypt();
String encData	 		= sha256Enc.encrypt(mid + merchantKey);	// Hash 값
%>

<!DOCTYPE html>
<html lang="kr">
<head>
    <meta charset="UTF-8">
    <title>영수증 조회 페이지</title>
</head>
<body>
<form name="receiptForm" id="receiptForm" method="post">
    <table class="tbl_sty02">
        <tr>
            <td>영수증 구분</td>
            <td>
                <select name="receiptType" id="receiptType">
                    <option value="general">거래명세서</option>
                    <option value="cash" selected>현금영수증</option>
                </select>
            </td>
        </tr>
        <tr>
            <td>상점아이디</td>
    		<td><input type="text" name="mid" id="mid" value="<%=mid%>"></td>
        </tr>
        <tr>
            <td>tid</td>
            <td><input type="text" name="tid" id="tid"></td>
        </tr>
		<!--  매출전표에 영어와 한글을 구분해서 사용해야 경우 언어 설정 기능을 사용가능.(default 한글)
		<tr>
            <td>매출전표 표시 언어</td>
            <td>
                <select name="lang" id="lang">
                    <option value="ko" selected>한글</option>
                    <option value="en">영어</option>
                </select>
            </td>
        </tr>
		-->
        	<input type="hidden" name="encData" id="encData" value="<%=encData%>">
    </table>
    
   <button type="button" id="selectBtn">조회</button>
</form>
 <script type="text/javascript" src="https://mms.minglepay.co.kr/js/receipt.js"></script>
</body>
</html>

<%!

//SHA-256 형식으로 암호화
public class DataEncrypt{
	MessageDigest md;
	String strSRCData = "";
	String strENCData = "";
	String strOUTData = "";
	
	public DataEncrypt(){ }
	public String encrypt(String strData){
		String passACL = null;
		MessageDigest md = null;
		try{
			md = MessageDigest.getInstance("SHA-256");
			md.reset();
			md.update(strData.getBytes());
			byte[] raw = md.digest();
			passACL = encodeHex(raw);
		}catch(Exception e){
			System.out.print("암호화 에러" + e.toString());
		}
		return passACL;
	}
	
	public String encodeHex(byte [] b){
		char [] c = Hex.encodeHex(b);
		return new String(c);
	}
}
%>
