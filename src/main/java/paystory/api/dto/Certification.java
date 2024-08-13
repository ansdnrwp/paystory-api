package paystory.api.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.Builder;
import lombok.Data;

public class Certification {

    @Data
    @Builder
    public static class Req {
        private String payMethod;
        private String cardCd;
        @Pattern(regexp = "^[YN]$", message = "Y 또는 N만 사용할 수 있습니다.")
        private String easyPayYN;
        private String easyPayCd;
        private String mid;
        @NotEmpty(message = "에스크로 여부는 필수값입니다.")
        @Pattern(regexp = "^[01]$", message = "0 또는 1만 사용할 수 있습니다.")
        private String trxCd;
        private String noIntMonth;
        @NotEmpty(message = "상품명은 필수값입니다.")
        @Size(max = 100, message = "100byte까지만 사용가능합니다.")
        private String goodsNm;
        @NotEmpty
        @Size(max = 40, message = "40byte까지만 사용가능합니다.")
        @Pattern(regexp = "^[\\w_()@#*+=$`~%^&?/\\[\\]-]+$", message = "특수문자는 _()@#*+=$`~\n%^&?/-[] 만 허용됩니다.(공백 불가)")
        private String ordNo;
        @NotEmpty
        @Size(max = 9, message = "9byte까지만 사용가능합니다.")
        private String goodsAmt;
        @NotEmpty
        @Size(max = 30, message = "30byte까지만 사용가능합니다.")
        private String ordNm;
        @NotEmpty
        @Size(max = 20, message = "20byte까지만 사용가능합니다.")
        private String ordTel;
        @Size(max = 60, message = "60byte까지만 사용가능합니다.")
        @Email(message = "올바른 이메일 형식이 아닙니다.")
        private String ordEmail;
        @Size(max = 20, message = "20byte까지만 사용가능합니다.")
        @Pattern(regexp = "^[\\w_()@#*+=$`~%^&?/\\[\\]-]+$", message = "특수문자는 _()@#*+=$`~\n%^&?/-[] 만 허용됩니다.(공백 불가)")
        private String mbsUsrId;
        @Size(max = 9, message = "9byte까지만 사용가능합니다.")
        private String goodsSplAmt;
        @Size(max = 9, message = "9byte까지만 사용가능합니다.")
        private String goodsVat;
        private String ediDate;
        private String encData;
        private String notiUrl;
        private String billHpFlg;
        private String returnUrl;
    }

    @Data
    @Builder
    public static class Res {
        private String resultCode;
        private String resultMsg;
        private String payMethod;
        private String tid;
        private String ediDate;
        private String goodsAmt;
        private String mbsReserved;
        private String signData;
    }
}
