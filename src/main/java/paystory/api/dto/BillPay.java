package paystory.api.dto;

import jakarta.validation.constraints.NotEmpty;
import lombok.Data;

public class BillPay {
    @Data
    public static class Req {
        @NotEmpty(message = "빌키는 필수값입니다.")
        private String bid;
        @NotEmpty(message = "결제 수단은 필수값입니다. (CARD, PHONE)")
        private String payMethod;
        @NotEmpty(message = "주문번호는 필수값잆니다.")
        private String ordNo;
        @NotEmpty(message = "상품명은 필수값입니다.")
        private String goodsNm;
        @NotEmpty(message = "결제 금액은 필수값입니다.")
        private String goodsAmt;
        private String goodsSplAmt;
        private String goodsVat;
        private String goodsSvsAmt;
        @NotEmpty(message = "할부기간은 필수값입니다. (00, 01 ..., 12 두자리)")
        private String quotaMon;
        @NotEmpty(message = "구매자명은 필수값입니다.")
        private String ordNm;
        @NotEmpty(message = "구매자 전화번호는 필수값입니다.")
        private String ordTel;
        private String ordEmail;
        private String mbsUsrId;
        private String mbsReserved;
        private String notiUrl;
    }

    @Data
    public static class Res {
        private String cpCd;
        private String cashCrctFlg;
        private String acqCardCd;
        private String lmtDay;
        private String mid;
        private String appNo;
        private String amt;
        private String cardNo;
        private String tid;
        private String hashStr;
        private String ordNm;
        private String mbsUsrId;
        private String ordNo;
        private String payMethod;
        private String fnNm;
        private String quota;
        private String appDtm;
        private String ediDate;
        private String usePointAmt;
        private String authType;
        private String goodsName;
        private String appCardCd;
        private String goodsAmt;
        private String charSet;
        private String resultCd;
        private String cpNm;
        private String goodsNm;
        private String cancelYN;
        private String cardType;
        private String resultMsg;
        private String vacntNo;
        private String mbsReserved;
        private String socHpNo;
    }
}
