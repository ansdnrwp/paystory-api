<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.net.URL" %>
<%@ page import="java.net.HttpURLConnection" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="org.json.simple.parser.JSONParser" %>
<%@ page import="org.apache.commons.codec.binary.Hex" %>
<%@ page import ="java.sql.*" %>
<%
request.setCharacterEncoding("utf-8"); 

/*
 * [상점 결제결과처리(DB) 페이지]
 *
 * 1) 위변조 방지를 위한 결과값 검증은 반드시 적용하셔야 합니다.
 * 2) 결제 성공결과 DB 처리페이지는 결제성공시 즉시 호출되며, 해당페이지 호출 실패시 가맹점관리자에서 설정한 전송횟수 및 전송주기에 따라 재전송됩니다.
 * 3) 결제결과 처리 파라미터는 상점 환경에 맞게 필요 대상만 선별 처리하시면 됩니다.   
 */

String merchantKey  = ""; 		// 상점키 (가맹점관리 시스템->[가맹점정보]->[결제환경 설정]->[KEY관리] 메뉴를 통해 확인 가능합니다.)
String sResultCd 	= "";		// [ 예) 신용카드 경우  3001 : 정상, 기타 : 실패]
String sResultMsg 	= "";		// 응답 메시지
String sPayMethod 	= "";		// 결제 방법(CARD,BANK,VACNT,PHONE,CULTUREGIFT)
String sTid	 		= "";		// 거래번호
String sMid	 		= "";		// 상점 ID
String sAppDtm		= "";		// 결제일시 (예 20210323163604)
String sCcDtm		= "";		// 취소일시 (예 20210323163604)
String sAppNo		= "";		// 승인번호
String sOrdNo		= "";		// 주문번호
String sGoodsName 	= "";		// 결제 상품명
String sAmt			= "";		// 결제금액
String sOrdNm 		= "";		// 구매자 
String sFnNm 		= "";		// 제휴사명
String sCancelYN 	= "";		// 결제 취소 여부 (승인:N, 취소:Y)
String sAppCardCd 	= "";		// 카드 발급사코드
String sAcqCardCd 	= "";		// 카드 매입사코드
String sEzpAuthCd	= "";		// 간편결제사 코드 (카드 간편결제시에만 전달)
String sEzpAuthNm	= "";		// 간편결제사명 (카드 간편결제시에만 전달)
String sQuota 		= "";		// 카드 할부기간
String sMbsUsrId	= "";		// 가맹점 할부기간
String sUsePointAmt = "";		// 사용 카드 포인트
String sCardType 	= "";		// 카드타입 (0:신용, 1:체크)
String sAuthType 	= "";		// 인증타입 (01:Keyin, 02:ISP, 03:MPI)
String sCashCrctFlg = ""; 		// 현금영수증 발급여부 (0:미발급, 1:발급)
String sVacntNo 	= "";		// 가상계좌번호
String sLmtDay 		= "";		// 입금기한
String sSocHpNo 	= "";		// 결제 휴대폰 번호
String sEdiDate	 	= "";		// 전문생성일시
String sHashStr		= "";		// 해쉬값
String sMbsReserved = "";		// 상점정의 필드

	
sResultCd 	= request.getParameter("resultCd");
sResultMsg 	= request.getParameter("resultMsg");
sPayMethod 	= request.getParameter("payMethod");
sTid	 	= request.getParameter("tid");
sMid	 	= request.getParameter("mid");
sAppDtm		= request.getParameter("appDtm");
sCcDtm		= request.getParameter("ccDtm");
sAppNo		= request.getParameter("appNo");
sOrdNo		= request.getParameter("ordNo");
sGoodsName	= request.getParameter("goodsName");
sAmt		= request.getParameter("goodsAmt");
sOrdNm		= request.getParameter("ordNm");
sFnNm		= request.getParameter("fnNm");
sMbsUsrId	= request.getParameter("mbsUsrId");
sCancelYN	= request.getParameter("cancelYN");
sAppCardCd	= request.getParameter("appCardCd");
sAcqCardCd	= request.getParameter("acqCardCd");
sEzpAuthCd	= request.getParameter("ezpAuthCd");
sEzpAuthNm 	= request.getParameter("ezpAuthNm");
sQuota		= request.getParameter("quota");
sUsePointAmt= request.getParameter("usePointAmt");
sCardType	= request.getParameter("cardType");
sAuthType	= request.getParameter("authType");
sCashCrctFlg= request.getParameter("cashCrctFlg");
sVacntNo	= request.getParameter("vacntNo");
sLmtDay		= request.getParameter("lmtDay");
sSocHpNo	= request.getParameter("socHpNo");
sEdiDate	= request.getParameter("ediDate");
sMbsReserved= request.getParameter("mbsReserved");
sHashStr	= request.getParameter("hashStr");


/*
*******************************************************
* <해쉬암호화> (수정하지 마세요)
* SHA-256 해쉬암호화는 거래 위변조를 막기위한 방법입니다. 
*******************************************************
*/

DataEncrypt sha256Enc 	= new DataEncrypt();
String hashStrLocal	 	= sha256Enc.encrypt(sMid + sEdiDate + sAmt + merchantKey);	// local에서 Hash 생성

%>
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
<%
/*
*******************************************************
* <결제성공 DB 처리 >
* 신용카드 결제 성공 (ResultCd : 3001, PayMethod : CARD)
* 계좌이체 결제 성공 (ResultCd : 4000, PayMethod : BANK)
* 가상계좌 입금 통보 (ResultCd : 4110, PayMethod : VACNT)
* 상품권  결제 성공 (ResultCd : 8000, PayMethod : CULTUREGIFT)
* 휴대폰 결제 성공 (ResultCd : A000, PayMethod : PHONE)

* <취소성공건 DB 처리 >
* 신용카드 취소성공	(ResultCd : 2001, PayMethod : CARD)
* 계좌이체 취소성공 (ResultCd : 2001, PayMethod : BANK)
* 가상계좌 결제 취소 성공 (ResultCd : 2211, PayMethod : VACNT)
* 문화상품권 취소성공 (ResultCd : 2001, PayMethod : CULTUREGIFT)
* 휴대폰 취소성공 (esultCd : 2001, PayMethod : PHONE) 
*******************************************************
*/

/************************************************************************************************
http 방식 : 설정된 noti URL의 http 응답 코드가 200인 경우 수신 성공으로 처리합니다.
json 방식 : 설정된 noti URL의 응답값이 json 형태의 {“resultCd”:”0000”} 인경우 수신 성공으로 처리합니다.
*************************************************************************************************/

if (sHashStr.trim().equals(hashStrLocal)){		// 결제성공 결과 위변조 체크
	// 결제수단별 결제성공 결과 처리
	if ("3001".equals(sResultCd) && "CARD".equals(sPayMethod) && "N".equals(sCancelYN))
	{
		// 결제결과 DB 연동

		 out.println("{\"resultCd\":\"0000\"}");		
	} else if ("2001".equals(sResultCd) && "CARD".equals(sPayMethod) && "Y".equals(sCancelYN)){
		// 취소 결과 DB 연동
	
		 out.println("{\"resultCd\":\"0000\"}");
	}		
} else {
	out.println("비정상호출이거나 해쉬값이 위변조되었습니다.");
}
%>