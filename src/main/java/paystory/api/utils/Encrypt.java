package paystory.api.utils;

import org.springframework.stereotype.Component;
import paystory.api.dto.Certification;

import java.security.MessageDigest;
import java.text.SimpleDateFormat;
import java.util.Date;
import org.apache.commons.codec.binary.Hex;

@Component
public class Encrypt {
    public String encrypt(String strData) throws Exception {
        MessageDigest md;

        md = MessageDigest.getInstance("SHA-256");
        md.reset();
        md.update(strData.getBytes());
        byte[] raw = md.digest();

        return encodeHex(raw);
    }

    private String encodeHex(byte[] b) {
        char[] c = Hex.encodeHex(b);
        return new String(c);
    }

    public void setCertifyData(Certification.Req data, String mid, String key) throws Exception {
        String ediDate = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
        String encData = encrypt(mid + ediDate + data.getGoodsAmt() + key);

        data.setEdiDate(ediDate);
        data.setEncData(encData);
    }
}
