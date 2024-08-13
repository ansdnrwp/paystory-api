package paystory.api.service;

import org.springframework.ui.Model;
import paystory.api.dto.Certification;
import paystory.api.dto.Detail;

public interface Payment<T, R, Y, X> {
    void setCertifyData(Certification.Req data) throws Exception;
    R pay(T data, Model model) throws Exception;
    Detail.Res detail(Detail.Req data) throws Exception;
    Y cancel(X data) throws Exception;
}
