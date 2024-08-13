package paystory.api.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.apache.hc.core5.http.NameValuePair;
import org.apache.hc.core5.http.message.BasicNameValuePair;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import paystory.api.dto.Certification;
import paystory.api.dto.Detail;
import paystory.api.dto.StandardPay;
import paystory.api.dto.StandardPayCancel;
import paystory.api.utils.Encrypt;
import paystory.api.utils.Http;

import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
@Log4j2
public class StandardService implements Payment<Certification.Res, Void, StandardPayCancel.Res, StandardPayCancel.Req>{
    @Value("${standard.key}")
    private String key;
    @Value("${standard.mid}")
    private String mid;
    private final Http http;
    private final Encrypt encrypt;
    private final ObjectMapper objectMapper;

    @Override
    public void setCertifyData(Certification.Req data) throws Exception {
        data.setMid(mid);
        encrypt.setCertifyData(data, mid, key);
    }

    @Override
    public Void pay(Certification.Res data, Model model) throws Exception {
        String res = http.requestAfterCertify(data, mid, model, key);
        model.addAttribute("res", objectMapper.readValue(res, StandardPay.Res.class));
        return null;
    }


    @Override
    public Detail.Res detail(Detail.Req data) throws Exception {
        return http.getDetail(data, mid, key);
    }

    @Override
    public StandardPayCancel.Res cancel(StandardPayCancel.Req data) throws Exception {
        Certification.Req certificationReq =
                Certification.Req
                        .builder()
                        .goodsAmt(data.getCanAmt())
                        .build();

        encrypt.setCertifyData(certificationReq, mid, key);

        List<NameValuePair> nvList = new ArrayList<>();
        nvList.add(new BasicNameValuePair("mid", mid));
        nvList.add(new BasicNameValuePair("tid", data.getTid()));
        nvList.add(new BasicNameValuePair("canAmt", data.getCanAmt()));
        nvList.add(new BasicNameValuePair("canId", data.getCanId()));
        nvList.add(new BasicNameValuePair("canMsg", data.getCanMsg()));
        nvList.add(new BasicNameValuePair("canIp", data.getCanIp()));
        nvList.add(new BasicNameValuePair("partCanFlg", data.getPartCanFlg()));
        nvList.add(new BasicNameValuePair("notiUrl", data.getNotiUrl()));
        nvList.add(new BasicNameValuePair("refundBankCd", data.getRefundBankCd()));
        nvList.add(new BasicNameValuePair("refundAccnt", data.getRefundAccnt()));
        nvList.add(new BasicNameValuePair("refundNm", data.getRefundNm()));
        nvList.add(new BasicNameValuePair("mbsUsrId", data.getMbsUsrId()));
        nvList.add(new BasicNameValuePair("encData", certificationReq.getEncData()));
        nvList.add(new BasicNameValuePair("ediDate", certificationReq.getEdiDate()));
        nvList.add(new BasicNameValuePair("ordNo", data.getOrdNo()));
        nvList.add(new BasicNameValuePair("goodsSplAmt", data.getGoodsSplAmt()));
        nvList.add(new BasicNameValuePair("goodsVat", data.getGoodsVat()));
        nvList.add(new BasicNameValuePair("goodsSvsAmt", data.getGoodsSvsAmt()));
        nvList.add(new BasicNameValuePair("charset", data.getCharset()));

        String res = http.post("https://pg.minglepay.co.kr/payment.cancel", nvList);

        if (res == null) {
            throw new RuntimeException("데이터 전송 실패");
        }

        return objectMapper.readValue(res, StandardPayCancel.Res.class);
    }
}
