package paystory.api.dto;

import jakarta.validation.constraints.NotEmpty;
import jdk.jfr.Description;
import lombok.Data;

import java.util.List;

public class Detail {
    @Data
    public static class Req {
        @NotEmpty(message = "거래번호는 필수값입니다.")
        @Description(value = "거래번호")
        private String tid;
        @Description(value = "주문번호 (거래번호 대신 사용할 수 있음)")
        private String ordNo;
    }

    @Data
    public static class Res {
        @Description(value = "조회 결과 코드 (0000 : 성공, 이외 실패)")
        private String resultCd;
        @Description(value = "조회 결과 메시지")
        private String resultMsg;
        @Description("조회 결제 건수")
        private String cnt;
        @Description(value = "결제 정보 데이터")
        private List<ResultData> resultData;
    }

    @Data
    public static class ResultData {
        @Description(value = "결과 코드")
        private String resultCd;
        @Description(value = "결과 메시지")
        private String resultMsg;
        @Description(value = "상품 이름")
        private String goodsName;
        @Description(value = "상품 이름")
        private String goodsNm;
        @Description(value = "주문 번호")
        private String ordNo;
        @Description(value = "결제 금액")
        private String goodsAmt;
        @Description(value = "승인 번호")
        private String appNo;
        @Description(value = "승인일자")
        private String appDtm;
        @Description(value = "구매자 명")
        private String ordNm;
        @Description(value = "결제 취소 여부 (승인 : N, 취소 : Y)")
        private String cancelYN;
        @Description(value = "카드사 명")
        private String fnNm;
        @Description(value = "카드 발급사 코드")
        private String appCardCd;
        @Description(value = "카드 매입사 코드")
        private String acqCardCd;
        @Description(value = "카드번호")
        private String cardNo;;
        @Description(value = "거래 번호")
        private String tid;
        @Description(value = "결제 통화")
        private String currencyType;
        @Description(value = "가맹점 정의 필드")
        private String mbsReserved;
        @Description(value = "카드사 코드")
        private String cpCd;
        @Description(value = "카드사 명")
        private String cpNm;
        @Description(value = "")
        private String authType;
        @Description(value = "거배 번호")
        private String otid;
        @Description(value = "결제 금액")
        private String amt;
        @Description(value = "구매자 ID")
        private String mbsUsrId;
        @Description(value = "")
        private String cardType;
        @Description(value = "할부 개월")
        private String quota;
        @Description(value = "사용 포인트 금액")
        private String usePointAmt;
    }
}
