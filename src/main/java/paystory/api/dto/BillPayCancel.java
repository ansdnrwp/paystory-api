package paystory.api.dto;

import jakarta.validation.constraints.NotEmpty;
import lombok.Data;

public class BillPayCancel {
    @Data
    public static class Req {
        @NotEmpty(message = "결제 수단은 필수값입니다. (CARD, PHONE)")
        private String payMethod;
        @NotEmpty(message = "거래번호는 필수값입니다.")
        private String tid;
        @NotEmpty(message = "취소 금액은 필수값입니다.")
        private String canAmt;
        private String ordNoChk;
        private String ordNo;
        private String canId;
        private String canNm;
        @NotEmpty(message = "취소 사유는 필수값입니다.")
        private String canMsg;
        private String canIp;
        @NotEmpty(message = "부분 취소 여부는 필수값입니다. (0: 전체취소, 1: 부분취소")
        private String partCanFlg;
        private String notiUrl;
        private String goodsSplAmt;
        private String goodsVat;
        private String goodsSvsAmt;
    }

    @Data
    public static class Res {
        private String resultCd;
        private String resultMsg;
        private String payMethod;
        private String oTid;
        private String tid;
        private String appDtm;
        private String ordNo;
        private String amt;
        private String cancelYN;
        private String mid;
    }
}
