package paystory.api.dto;

import lombok.Data;

public class BillKeyIssue {
    @Data
    public static class Res {
        private String resultCd;
        private String resultMsg;
        private String payMethod;
        private String tid;
        private String mid;
        private String ediDate;
        private String appDtm;
        private String ordNo;
        private String goodsName;
        private String amt;
        private String ordNm;
        private String cancelYN;
        private String fnNm;
        private String appCardCd;
        private String socHpNo;
        private String mbsReserved;
        private String hashStr;
        private String bid;
        private String ordTel;
        private String mbsUsrId;
        private String cardNo;
    }
}
