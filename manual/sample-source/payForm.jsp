<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="org.apache.commons.codec.binary.Hex" %>
<%
/*
*******************************************************
* <결제요청 파라미터>
* 결제시 Form 에 보내는 결제요청 파라미터입니다.
*******************************************************
*/

String merchantID 		= "";									// 상점 ID															
String merchantKey  	= "";									// 상점키 (가맹점관리 시스템->[가맹점정보]->[결제환경 설정]->[KEY관리] 메뉴를 통해 확인 가능합니다.)
String goodsNm 			= "테스트상품"; 						// 결제상품명
String goodsAmt 		= "1004"; 								// 결제상품금액	
String ordNm 			= "홍길동"; 							// 구매자명
String ordTel 			= "01012345678"; 						// 구매자연락처
String ordEmail 		= "test@pay-story.co.kr";				// 구매자메일주소
String ordNo 			= "";				 					// 상품주문번호	
String returnUrl 		= "https://test.com/payResult.jsp";   // 인증결과 리턴페이지(모바일 결제시 필수)





/*
*******************************************************
* <해쉬암호화> (수정하지 마세요)
* SHA-256 해쉬암호화는 거래 위변조를 막기위한 방법입니다. 
*******************************************************
*/
DataEncrypt sha256Enc 	= new DataEncrypt();
String ediDate 			= getyyyyMMddHHmmss();												// 전문 생성일시
String encData 			= sha256Enc.encrypt(merchantID + ediDate + goodsAmt + merchantKey); // Hash 값
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta http-equiv="Cache-Control" content="no-cache" />
<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1.0, minimum-scale=1.0, maximum-scale=3.0">
<title>결제 요청</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.1/jquery.min.js"></script>
<script src="https://pg.minglepay.co.kr/js/pgAsistant.js"></script>
</head>
<body>
<script type="text/javascript">
// 결제창 호출 함수
function doPaySubmit(){
	SendPay(document.payInit);  
}
// 결제창 return 함수(pay_result_submit 이름 변경 불가능)
function pay_result_submit(){
	payResultSubmit()
}
// 결제창 종료 함수(pay_result_close 이름 변경 불가능)
function pay_result_close(){
	alert('결제를 취소하였습니다.');
}
</script>
<div style="text-align:center;">
<div id="sampleInput" class="paypop_con" style="padding:20px 15px 35px 15px;display: inline-block;float: inherit;">
<p class="square_tit mt0" style="text-align:center;"><strong>결제정보</strong></p>
<form name="payInit" method="post" id="payInit" action="./payResult.jsp">
	<table class="tbl_sty02">
		<tr>
			<td align="right">결제수단</td>
			<td align="left">
				<select name="payMethod">
					<option value="" selected="selected">전체</option>
					<option value="CARD">신용카드</option>
					<option value="BANK">계좌이체</option>
					<option value="VACNT">가상계좌</option>
					<option value="PHONE">휴대폰</option>
					<option value="CULTUREGIFT">문화상품권</option>
				</select> 
			</td>
		</tr>
		<tr>
			<td align="right"> 상점 ID  *</td>
			<td><input type="text" name="mid" value="<%=merchantID%>"></td>
		</tr>
		<tr>
			<td align="right">상품명  *</td>
			<td><input type="text" name="goodsNm" value="<%=goodsNm%>"></td>
		</tr>
		<tr>
			<td align="right">주문번호  *</td>
			<td><input type="text" name="ordNo" value="<%=merchantID+ediDate%>"></td>
		</tr>
		<tr>
			<td align="right">결제금액 *</td>
			<td><input type="text" name="goodsAmt" value="<%=goodsAmt%>"></td>
		</tr>
		<tr>
			<td align="right">구매자명 *</td>
			<td><input type="text" name="ordNm" value="<%=ordNm%>"></td>
		</tr>
		<tr>
			<td align="right">구매자연락처</td>
			<td><input type="text" name="ordTel" value="<%=ordTel%>"></td>
		</tr>
		<tr>
			<td align="right">구매자이메일</td>
			<td><input type="text" name="ordEmail" value="<%=ordEmail%>"></td>
		</tr>
		
		<tr>
			<td align="right">고객 ID</td>
			<td><input type="text" name="mbsUsrId" value="user1234"></td>
		</tr>
		<tr>
			<td align="right">returnURL  *</td>
			<td><input type="text" name="returnUrl" value="<%=returnUrl%>"></td><!-- 모바일 환경에서 결과페이지 호출시 필수 -->
		</tr>
	</table>
	<!-- 옵션 --> 
	<input type="hidden" name="userIp"	value="127.0.0.1">
	<input type="hidden" name="mbsReserved" value="상점정의 필드입니다"><!-- 상점 예약필드 -->
	<input type="hidden" name="charSet" value="UTF-8">
	<input type="hidden" name="language" value="KOR">
	<!-- <input type="hidden" name="goodsSplAmt" value="0"> -->
	<!-- <input type="hidden" name="goodsVat" value="0"> -->
	<!-- <input type="hidden" name="goodsSvsAmt" value="0"> -->
	<!-- <input type="hidden" name="notiUrl" value="https://상점도메인/payNoti.jsp">--><!-- 결제결과를 통보 받고자 할 때 사용 (가상계좌 사용시 필수)-->

	
	<!-- 변경 불가능 -->
	<input type="hidden" name="ediDate" value="<%=ediDate%>"><!-- 전문 생성일시 -->
	<input type="hidden" name="encData" value="<%=encData%>"><!-- 해쉬값 -->
	<input type="hidden" name="trxCd"	value="0"> 

</form>	
	<a href="#;" id="payBtn" class="btn_sty01 bg01" style="margin:15px;" onClick="doPaySubmit();">결제하기</a>
	</div>
</div>
<div id="mask"></div>
<div class="window">
	<div class="cont">
		<iframe id="pay_frame" name="pay_frame" width="100%" height="500" marginwidth="0" marginheight="0" frameborder="no" scrolling="yes"></iframe>
	</div>
</div>
</body>
</html>
<%!
public final synchronized String getyyyyMMddHHmmss(){
	SimpleDateFormat yyyyMMddHHmmss = new SimpleDateFormat("yyyyMMddHHmmss");
	return yyyyMMddHHmmss.format(new Date());
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