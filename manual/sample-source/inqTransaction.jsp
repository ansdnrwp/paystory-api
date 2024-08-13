<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="java.io.BufferedReader"%>
<%@ page import="java.io.InputStreamReader"%>
<%@ page import="java.io.OutputStreamWriter"%>
<%@ page import="java.io.OutputStream"%>
<%@ page import="java.net.URL"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="java.net.HttpURLConnection"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="org.json.simple.parser.JSONParser"%>
<%@ page import="org.apache.commons.codec.binary.Hex"%>

<%
request.setCharacterEncoding("utf-8"); 
/*
****************************************************************************************
* <조회 요청 파라미터>
****************************************************************************************
*/
String merchantKey  = "";		// 가맹점 Key
String mid			= "";		// 가맹점 ID
String tid 			= "";		// 거래번호 
String ordNo 		= "";		// 주문번호 

/*
*******************************************************
* <SHA-256 해시 암호화>
*******************************************************
*/
DataEncrypt sha256Enc 	= new DataEncrypt();
String ediDate 			= getyyyyMMddHHmmss();										// 요청일자
String hashStr	 		= sha256Enc.encrypt(mid + ediDate + tid + merchantKey);		// 해시데이터

/*
****************************************************************************************
* <조회 요청 >
****************************************************************************************
*/
StringBuffer requestData = new StringBuffer();
requestData.append("tid=").append(tid).append("&");
requestData.append("ordNo=").append(ordNo).append("&");
requestData.append("mid=").append(mid).append("&");
requestData.append("ediDate=").append(ediDate).append("&");
requestData.append("hashStr=").append(hashStr);

String receiveData = connectToServer(requestData.toString(), "https://pg.minglepay.co.kr/transaction");


/****************************************************************************************
* <조회 응답 파라미터 정의 >
****************************************************************************************/

JSONParser jsonparse = new JSONParser();
Object obj = jsonparse.parse(receiveData);
JSONObject jsonObject = (JSONObject)obj;

String inqResultCd =  (jsonObject.get("resultCd")).toString();		// 조회결과 코드	
String inqResultMsg = (jsonObject.get("resultMsg")).toString();		// 조회결과 메세지
String inqResultCnt = (jsonObject.get("cnt")).toString();			// 조회건수
String resultData 	= (jsonObject.get("resultData")).toString();	// 조회데이터

out.println("조회결과 코드 : "+inqResultCd+"<br>");
out.println("조회결과 메세지 : "+inqResultMsg+"<br>");
out.println("조회건수 : "+jsonObject.get("cnt")+"<br>");
out.println("거래데이터 : "+resultData);
	
%>

<%!
public final synchronized String getyyyyMMddHHmmss(){
	SimpleDateFormat yyyyMMddHHmmss = new SimpleDateFormat("yyyyMMddHHmmss");
	return yyyyMMddHHmmss.format(new Date());
}
//server to server 통신
public String connectToServer(String data, String reqUrl) throws Exception{
	HttpURLConnection conn 		= null;
	BufferedReader resultReader = null;
	PrintWriter pw 				= null;
	URL url 					= null;
	
	int statusCode = 0;
	StringBuffer recvBuffer = new StringBuffer();
	try{

        url = new URL(reqUrl +  "?" + data);
        conn = (HttpURLConnection) url.openConnection();
        conn.setConnectTimeout(15000);
		conn.setReadTimeout(25000);
		conn.setDoOutput(true);
        conn.setRequestMethod("GET");
		conn.setRequestProperty("Content-Type","application/x-www-form-urlencoded");
		
		statusCode = conn.getResponseCode();
		resultReader = new BufferedReader(new InputStreamReader(conn.getInputStream(), "utf-8"));
		for(String temp; (temp = resultReader.readLine()) != null;){
			recvBuffer.append(temp).append("\n");
		}
		
		if(!(statusCode == HttpURLConnection.HTTP_OK)){
			throw new Exception();
		}
		
		return recvBuffer.toString().trim();
	}catch (Exception e){
		return "9999";
	}finally{
		recvBuffer.setLength(0);
		
		try{
			if(resultReader != null){
				resultReader.close();
			}
		}catch(Exception ex){
			resultReader = null;
		}
		
		try{
			if(pw != null) {
				pw.close();
			}
		}catch(Exception ex){
			pw = null;
		}
		
		try{
			if(conn != null) {
				conn.disconnect();
			}
		}catch(Exception ex){
			conn = null;
		}
	}
}

// SHA-256 형식으로 암호화
public class DataEncrypt{
	MessageDigest md;
	String strSRCData = "";
	String strENCData = "";
	String strOUTData = "";
	
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
