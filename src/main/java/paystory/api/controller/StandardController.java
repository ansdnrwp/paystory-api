package paystory.api.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import paystory.api.dto.Certification;
import paystory.api.dto.Detail;
import paystory.api.dto.StandardPayCancel;
import paystory.api.service.StandardService;

@Controller
@RequestMapping("/api/pg/standard")
@RequiredArgsConstructor
public class StandardController {
    private final StandardService standardService;

    @PostMapping("/payForm")
    public String payForm(@ModelAttribute @Valid Certification.Req data, Model model) throws Exception{
        standardService.setCertifyData(data);
        return "payForm";
    }

    @PostMapping("/pay")
    public String pay(@ModelAttribute @Valid Certification.Res data, Model model) throws Exception {
        standardService.pay(data, model);
        return "payResult";
    }

    @PostMapping("/inqTrans")
    @ResponseBody
    public ResponseEntity<Detail.Res> inqTrans(@ModelAttribute @Valid Detail.Req data) throws Exception {
        return ResponseEntity.ok(standardService.detail(data));
    }

    @PostMapping("/cancel")
    @ResponseBody
    public ResponseEntity<StandardPayCancel.Res> cancel(@ModelAttribute @Valid StandardPayCancel.Req data, Model model) throws Exception {
        return ResponseEntity.ok(standardService.cancel(data));
    }
}
