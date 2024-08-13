<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="java.net.URL" %>
<%@ page import="java.net.HttpURLConnection" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="org.json.simple.parser.JSONParser" %>
<%@ page import="org.apache.commons.codec.binary.Hex" %>
<%
request.setCharacterEncoding("utf-8"); 
/*
****************************************************************************************
* <인증 결과 파라미터>
****************************************************************************************
*/

String resultCode 	= (String)request.getParameter("resultCode"); 	// 인증결과 : 0000(성공)
String resultMsg 	= (String)request.getParameter("resultMsg"); 	// 인증결과 메시지
String tid 			= (String)request.getParameter("tid"); 			// 거래 ID
String payMethod 	= (String)request.getParameter("payMethod"); 	// 결제수단
String ediDate 		= (String)request.getParameter("ediDate"); 		// 결제 일시
String mid 			= (String)request.getParameter("mid"); 			// 상점 아이디
String goodsAmt 	= (String)request.getParameter("goodsAmt"); 	// 결제 금액
String reqReserved 	= (String)request.getParameter("mbsReserved"); 	// 상점 예약필드
String signData		= (String)request.getParameter("signData");		// 인증결과 암호화 데이터 (최종 승인요청시 전달함)
String merchantKey  = "";											// 상점키 (가맹점관리 시스템->[가맹점정보]->[결제환경 설정]->[KEY관리] 메뉴를 통해 확인 가능합니다.)

DataEncrypt sha256Enc 	= new DataEncrypt();
String encData 			= sha256Enc.encrypt(mid + ediDate + goodsAmt + merchantKey);	// Hash 값

/*
****************************************************************************************
* <승인 결과 파라미터 정의>
* 샘플페이지에서는 승인 결과 파라미터 중 일부만 예시되어 있으며, 
* 추가적으로 사용하실 파라미터는 연동메뉴얼을 참고하세요.
****************************************************************************************
*/
String sResultCode 	= ""; String sResultMsg 	= "";	String sPayMethod 	= "";
String sGoodsName	= ""; String sAmt 			= ""; 	String sTid 		= ""; 
String sName		= ""; String sFnNm		= "";	String sQuota		= "";
String sHashString  = "";

/*
****************************************************************************************
* <인증 결과 성공시 승인 진행>
****************************************************************************************
*/
if( "0000".equals(resultCode)) {
	
	/*
	****************************************************************************************
	* <승인 요청 >
	****************************************************************************************
	*/
	StringBuffer requestData = new StringBuffer();
	requestData.append("tid=").append(tid).append("&");
	requestData.append("mid=").append(mid).append("&");
	requestData.append("goodsAmt=").append(goodsAmt).append("&");
	requestData.append("ediDate=").append(ediDate).append("&");
	requestData.append("charSet=").append("utf-8").append("&");
	requestData.append("encData=").append(encData).append("&");
	requestData.append("signData=").append(signData);

	String receiveData = connectToServer(requestData.toString(), "https://pg.minglepay.co.kr/payment.do");
	Map<String, Object> resultData = jsonStringToHashMap(receiveData);

	/*
	****************************************************************************************
	* <결제 결과 파라미터>
	****************************************************************************************
	*/
	sResultCode	 	= (String)resultData.get("resultCd"); 	// 결과코드
	sResultMsg 		= (String)resultData.get("resultMsg"); 	// 결과메시지
	sPayMethod 		= (String)resultData.get("payMethod"); 	// 결제수단
	sAmt 			= (String)resultData.get("amt"); 		// 결제금액
	sTid 			= (String)resultData.get("tid"); 		// 거래ID
	sName			= (String)resultData.get("ordNm");		// 고객명
	sGoodsName		= (String)resultData.get("goodsName");	// 상품명
	sFnNm			= (String)resultData.get("fnNm");		// 카드번호
	sHashString		= (String)resultData.get("hashString");	// 해쉬값
	sQuota			= (String)resultData.get("quota");		// 할부개월
	if("0".equals(sQuota) || "00".equals(sQuota)){
		sQuota = "일시불";
	}else{
		sQuota = sQuota + "개월";
	}
	
} else {
	// 인증실패 or 결제창 닫힘.

}

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="Cache-Control" content="no-cache" />
<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1.0, minimum-scale=1.0, maximum-scale=3.0">
<title>PAY RESULT</title>
<style>
.pop_wrap {background:rgba(0, 0, 0, 0.4);}
.tbl_th{box-sizing:border-box; line-height:40px; padding:0px 10px 0px 10px; text-align:left; width:160px; background:#e9eaeb; border-top:1px solid #2a323c; border-bottom:1px solid #d4d6d8; font-size:15px; font-weight:normal; color:#333; font-family:'Malgun Gothic','맑은 고딕',sans-serif;}
.tbl_td{box-sizing:border-box; line-height:40px; padding:0px 10px 0px 10px; text-align:left; border-top:1px solid #2a323c; border-bottom:1px solid #d4d6d8; font-size:15px; font-weight:bold; color:#333; font-family:'Malgun Gothic','맑은 고딕',sans-serif;}
</style>
</head>
<body>
<div style="width: 100%; text-align: center;">
    <div id="sampleInput" style="display: inline-block; padding:0 10px; margin:0 auto;">
        <table style="border-spacing:0;">
            <tbody>
                <tr>
                    <td colspan="3"><p style="margin:10px 0 10px; text-align:center; font-size:34px; color:#2a323c; font-family:'Malgun Gothic','맑은 고딕',sans-serif;">결제 결과</p></td>
                </tr>                		
                <tr>
                    <td colspan="3">
                        <table style="border-collapse:collapse; width:100%">
                            <tbody>
                                <tr>
                                    <th scope="row" class="tbl_th">결과 내용</th>
                                </tr>
                                <tr>
                                    <td class="tbl_td">[<%=sResultCode%>]<%=sResultMsg%></td>
                                </tr>                              
                                <tr>
                                    <th scope="row" class="tbl_th">결제수단</th>
                                </tr>
                                <tr>
                                    <td class="tbl_td"><%=sPayMethod%></td>
                                </tr>
                                <tr>
                                    <th scope="row" class="tbl_th">금액</th>
                                 </tr>
                                <tr>
                                    <td class="tbl_td"><%=sAmt%></td>
                                </tr>
                                <tr>
                                    <th scope="row" class="tbl_th">거래아이디</th>
                                 </tr>
                                <tr>
                                    <td class="tbl_td"><%=sTid%></td>
                                </tr>
                                <tr>
                                    <th scope="row" class="tbl_th">구매자명</th>
                                 </tr>
                                <tr>
                                    <td class="tbl_td"><%=sName%>&nbsp;</td>
                                </tr>
                                <tr>
									<th scope="row" class="tbl_th">상품명</th>
							      </tr>
                                <tr>
									<td class="tbl_td"><%=sGoodsName%></td>
								</tr>
								<tr>
									<th scope="row" class="tbl_th">카드사</th>
								 </tr>
                                <tr>
									<td class="tbl_td"><%=sFnNm%></td>
								</tr>
								<tr>
									<th scope="row" class="tbl_th">할부개월</th>
									 </tr>
                                <tr>
									<td class="tbl_td"><%=sQuota%></td>
								</tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>
<%!
	//server to server 통신
	public String connectToServer(String data, String reqUrl) throws Exception{
		HttpURLConnection conn 		= null;
		BufferedReader resultReader = null;
		PrintWriter pw 				= null;
		URL url 					= null;
		
		int statusCode = 0;
		StringBuffer recvBuffer = new StringBuffer();
		try{
			url = new URL(reqUrl);
			conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("POST");
			conn.setConnectTimeout(15000);
			conn.setReadTimeout(25000);
			conn.setDoOutput(true);
			
			pw = new PrintWriter(conn.getOutputStream());
			pw.write(data);
			pw.flush();
			
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
	//JSON String -> HashMap 변환
	private static HashMap jsonStringToHashMap(String str) throws Exception{
		HashMap dataMap = new HashMap();
		JSONParser parser = new JSONParser();
		try{
			Object obj = parser.parse(str);
			JSONObject jsonObject = (JSONObject)obj;
			
			Iterator<String> keyStr = jsonObject.keySet().iterator();
			while(keyStr.hasNext()){
				String key = keyStr.next();
				Object value = jsonObject.get(key);
				
				dataMap.put(key, value);
			}
		}catch(Exception e){
			
		}
		return dataMap;
	}

	// SHA-256 형식으로 암호화
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