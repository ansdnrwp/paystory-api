package paystory.api.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.apache.hc.core5.http.NameValuePair;
import org.apache.hc.core5.http.message.BasicNameValuePair;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import paystory.api.dto.*;
import paystory.api.utils.Encrypt;
import paystory.api.utils.Http;

import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class BillingService implements Payment<BillPay.Req, BillPay.Res, BillPayCancel.Res, BillPayCancel.Req>{
    @Value("${bill.key}")
    private String key;
    @Value("${bill.mid}")
    private String mid;
    private final Http http;
    private final Encrypt encrypt;
    private final ObjectMapper objectMapper;

    @Override
    public void setCertifyData(Certification.Req data) throws Exception {
        encrypt.setCertifyData(data, mid, key);
    }

    public void issue(Certification.Res data, Model model) throws Exception {
        String res = http.requestAfterCertify(data, mid, model, key);

        model.addAttribute("res", objectMapper.readValue(res, BillKeyIssue.Res.class));
    }

    @Override
    public BillPay.Res pay(BillPay.Req data, Model model) throws Exception {
        Certification.Req certificationReq =
                Certification.Req
                        .builder()
                        .goodsAmt(data.getGoodsAmt())
                        .build();

        encrypt.setCertifyData(certificationReq, mid, key);

        List<NameValuePair> nvList = new ArrayList<>();
        nvList.add(new BasicNameValuePair("bid", data.getBid()));
        nvList.add(new BasicNameValuePair("payMethod", data.getPayMethod()));
        nvList.add(new BasicNameValuePair("trxCd", "0"));
        nvList.add(new BasicNameValuePair("mid", mid));
        nvList.add(new BasicNameValuePair("ordNo", data.getOrdNo()));
        nvList.add(new BasicNameValuePair("goodsNm", data.getGoodsNm()));
        nvList.add(new BasicNameValuePair("goodsAmt", data.getGoodsAmt()));
        nvList.add(new BasicNameValuePair("goodsSplAmt", data.getGoodsSplAmt()));
        nvList.add(new BasicNameValuePair("goodsVat", data.getGoodsVat()));
        nvList.add(new BasicNameValuePair("goodsSvsAmt", data.getGoodsSvsAmt()));
        nvList.add(new BasicNameValuePair("quotaMon", data.getQuotaMon()));
        nvList.add(new BasicNameValuePair("ordNm", data.getOrdNm()));
        nvList.add(new BasicNameValuePair("ordTel", data.getOrdTel()));
        nvList.add(new BasicNameValuePair("ordEmail", data.getOrdEmail()));
        nvList.add(new BasicNameValuePair("mbsUsrId", data.getMbsUsrId()));
        nvList.add(new BasicNameValuePair("mbsReserved", data.getMbsReserved()));
        nvList.add(new BasicNameValuePair("noIntFlg", "0"));
        nvList.add(new BasicNameValuePair("pointFlg", "0"));
        nvList.add(new BasicNameValuePair("notiUrl", data.getNotiUrl()));
        nvList.add(new BasicNameValuePair("ediDate", certificationReq.getEdiDate()));
        nvList.add(new BasicNameValuePair("encData", certificationReq.getEncData()));

        String res = http.post("https://pg.minglepay.co.kr/payment.doBill", nvList);

        if (res == null) {
            throw new Exception("데이터 전송 실패");
        }

        return objectMapper.readValue(res, BillPay.Res.class);
    }

    public BillKeyRemove.Res remove(String bid) throws Exception {
        Certification.Req certificationReq =
                Certification.Req
                        .builder()
                        .goodsAmt(bid)
                        .build();

        encrypt.setCertifyData(certificationReq, mid, key);

        List<NameValuePair> nvList = new ArrayList<>();
        nvList.add(new BasicNameValuePair("bid", bid));
        nvList.add(new BasicNameValuePair("mid", mid));
        nvList.add(new BasicNameValuePair("ediDate", certificationReq.getEdiDate()));
        nvList.add(new BasicNameValuePair("encData", certificationReq.getEncData()));

        String res = http.post("https://pg.minglepay.co.kr/payment.deleteBill", nvList);

        if (res == null) {
            throw new Exception("데이터 전송 실패");
        }

        return objectMapper.readValue(res, BillKeyRemove.Res.class);
    }

    @Override
    public Detail.Res detail(Detail.Req data) throws Exception {
        return http.getDetail(data, mid, key);
    }

    @Override
    public BillPayCancel.Res cancel(BillPayCancel.Req data) throws Exception {
        Certification.Req certificationReq =
                Certification.Req
                        .builder()
                        .goodsAmt(data.getCanAmt())
                        .build();

        encrypt.setCertifyData(certificationReq, mid, key);

        List<NameValuePair> nvList = new ArrayList<>();
        nvList.add(new BasicNameValuePair("mid", mid));
        nvList.add(new BasicNameValuePair("tid", data.getTid()));
        nvList.add(new BasicNameValuePair("payMethod", data.getPayMethod()));
        nvList.add(new BasicNameValuePair("canAmt", data.getCanAmt()));

        if (data.getOrdNo() != null) {
            nvList.add(new BasicNameValuePair("ordNoChk", data.getOrdNoChk()));
            nvList.add(new BasicNameValuePair("ordNo", data.getOrdNo()));
        }

        nvList.add(new BasicNameValuePair("canId", data.getCanId()));
        nvList.add(new BasicNameValuePair("canNm", data.getCanNm()));
        nvList.add(new BasicNameValuePair("canMsg", data.getCanMsg()));
        nvList.add(new BasicNameValuePair("canIp", data.getCanIp()));
        nvList.add(new BasicNameValuePair("partCanFlg", data.getPartCanFlg()));
        nvList.add(new BasicNameValuePair("notiUrl", data.getNotiUrl()));
        nvList.add(new BasicNameValuePair("goodsSplAmt", data.getGoodsSplAmt()));
        nvList.add(new BasicNameValuePair("goodsVat", data.getGoodsVat()));
        nvList.add(new BasicNameValuePair("goodsSvsAmt", data.getGoodsSvsAmt()));
        nvList.add(new BasicNameValuePair("encData", certificationReq.getEncData()));
        nvList.add(new BasicNameValuePair("ediDate", certificationReq.getEdiDate()));

        String res = http.post("https://pg.minglepay.co.kr/payment.cancel", nvList);

        if (res == null) {
            throw new RuntimeException("데이터 전송 실패");
        }

        return objectMapper.readValue(res, BillPayCancel.Res.class);
    }
}
