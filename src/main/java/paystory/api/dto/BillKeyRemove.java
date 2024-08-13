package paystory.api.dto;

import lombok.Data;

public class BillKeyRemove {
    @Data
    public static class Res {
        private String resultCd;
        private String resultMsg;
        private String appDtm;
        private String mid;
        private String bid;
    }
}
