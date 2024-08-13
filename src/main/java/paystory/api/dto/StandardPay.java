package paystory.api.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

public class StandardPay {
    @Data
    @AllArgsConstructor
    @NoArgsConstructor
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
