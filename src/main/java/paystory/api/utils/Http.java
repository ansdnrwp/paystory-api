package paystory.api.utils;

import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.extern.log4j.Log4j2;
import org.apache.hc.client5.http.classic.methods.HttpGet;
import org.apache.hc.client5.http.classic.methods.HttpPost;
import org.apache.hc.client5.http.entity.UrlEncodedFormEntity;
import org.apache.hc.client5.http.impl.classic.CloseableHttpClient;
import org.apache.hc.client5.http.impl.classic.HttpClients;
import org.apache.hc.core5.http.ClassicHttpRequest;
import org.apache.hc.core5.http.HttpEntity;
import org.apache.hc.core5.http.NameValuePair;
import org.apache.hc.core5.http.io.entity.EntityUtils;
import org.apache.hc.core5.http.message.BasicNameValuePair;
import org.apache.hc.core5.net.URIBuilder;
import org.springframework.stereotype.Component;
import org.springframework.ui.Model;
import paystory.api.dto.Certification;
import paystory.api.dto.Detail;

import java.io.IOException;
import java.net.URI;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

@Component
@Log4j2
public class Http {

    public String post(String uri, List<NameValuePair> nvList) throws Exception {
        HttpPost httpPost = new HttpPost(uri);
        httpPost.setHeader("Content-Type", "application/x-www-form-urlencoded;charset=UTF-8");
        httpPost.setEntity(new UrlEncodedFormEntity(nvList, StandardCharsets.UTF_8));

        try {
            return submit(httpPost);
        } finally {
            httpPost.clear();
        }
    }

    public String get(String uri, List<NameValuePair> nvList) throws Exception {
        HttpGet httpGet = new HttpGet(uri);
        httpGet.setHeader("Content-Type", "application/x-www-form-urlencoded;charset=UTF-8");
        URI queryString = new URIBuilder(httpGet.getUri())
                .addParameters(nvList)
                .build();

        httpGet.setUri(queryString);

        try {
            return submit(httpGet);
        } finally {
            httpGet.clear();
        }
    }

    private String submit(ClassicHttpRequest request) throws Exception {
        CloseableHttpClient client = HttpClients.createDefault();

        try {
            return client.execute(request, res -> {
                HttpEntity responseEntity = res.getEntity();

                if (responseEntity == null) {
                    return null;
                }

                return EntityUtils.toString(responseEntity);
            });
        } finally {
            try {
                client.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    public String requestAfterCertify(Certification.Res data, String mid, Model model, String key) throws Exception {
        if (!"0000".equals(data.getResultCode())) {
            return "{\"resultCd\":\"" + data.getResultCode() + "\",\"resultMsg\":\"" + data.getResultMsg() + "\"}";
        }

        String encData = new Encrypt().encrypt(mid + data.getEdiDate() + data.getGoodsAmt() + key);

        List<NameValuePair> nvList = new ArrayList<>();
        nvList.add(new BasicNameValuePair("mid", mid));
        nvList.add(new BasicNameValuePair("tid", data.getTid()));
        nvList.add(new BasicNameValuePair("goodsAmt", data.getGoodsAmt()));
        nvList.add(new BasicNameValuePair("charSet", "utf-8"));
        nvList.add(new BasicNameValuePair("ediDate", data.getEdiDate()));
        nvList.add(new BasicNameValuePair("encData", encData));
        nvList.add(new BasicNameValuePair("signData", data.getSignData()));

        String res = post("https://pg.minglepay.co.kr/payment.do", nvList);

        if (res == null) {
            return "{\"resultCd\":\"9999\",\"resultMsg\":\"데이터 전송 실패\"}";
        }

        return res;
    }

    public Detail.Res getDetail(Detail.Req data, String mid, String key) throws Exception {
        Certification.Req certificationReq = Certification.Req.builder().goodsAmt(data.getTid()).build();
        new Encrypt().setCertifyData(certificationReq, mid, key);

        List<NameValuePair> nvList = new ArrayList<>();
        nvList.add(new BasicNameValuePair("mid", mid));
        nvList.add(new BasicNameValuePair("tid", data.getTid()));
        nvList.add(new BasicNameValuePair("ordNo", data.getOrdNo()));
        nvList.add(new BasicNameValuePair("ediDate", certificationReq.getEdiDate()));
        nvList.add(new BasicNameValuePair("hashStr", certificationReq.getEncData()));

        String res = get("https://pg.minglepay.co.kr/transaction", nvList);

        if (res == null) {
            throw new RuntimeException("데이터 전송 실패");
        }

        ObjectMapper objectMapper = new ObjectMapper();

        return objectMapper.readValue(res, Detail.Res.class);
    }
}
