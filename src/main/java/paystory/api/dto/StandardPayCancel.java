package paystory.api.dto;

import jakarta.validation.constraints.NotEmpty;
import jdk.jfr.Description;
import lombok.Data;

public class StandardPayCancel {
    @Data
    public static class Req {
        private String mid;
        @NotEmpty(message = "거래 번호는 필수값입니다.")
        @Description(value = "거래 번호")
        private String tid;
        @NotEmpty(message = "취소금액은 필수값입니다.")
        @Description(value = "취소금액")
        private String canAmt;
        private String canId;
        @NotEmpty(message = "취소사유는 필수값입니다.")
        @Description(value = "취소사유")
        private String canMsg;
        private String canIp;
        @NotEmpty(message = "부분 취소 여부는 필수값입니다. (0: 전체취소, 1: 부분취소")
        @Description(value = "부분 취소 여부")
        private String partCanFlg;
        private String notiUrl;
        private String refundBankCd;
        private String refundAccnt;
        private String refundNm;
        private String mbsUsrId;
        private String ordNoChk;
        private String ordNo;
        private String goodsSplAmt;
        private String goodsVat;
        private String goodsSvsAmt;
        private String charset;
    }

    @Data
    public static class Res {
        private String resultCd;
        private String resultMsg;
        private String payMethod;
        private String tid;
        private String mid;
        private String ordNo;
        private String cancelYN;
        private String amt;
        private String appDtm;
        private String mbsUsrId;
        private String appNo;
        private String charSet;
        private String hashStr;
        private String oTid;
        private String ediDate;
    }
}
