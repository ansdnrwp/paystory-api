package paystory.api.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import paystory.api.dto.BillPay;
import paystory.api.dto.BillPayCancel;
import paystory.api.dto.Certification;
import paystory.api.dto.Detail;
import paystory.api.service.BillingService;

@Controller
@RequestMapping("/api/pg/bill")
@RequiredArgsConstructor
public class BillingController {
    private final BillingService billingService;

    @PostMapping("/payForm")
    public String payForm(@ModelAttribute @Valid Certification.Req data) throws Exception {
        billingService.setCertifyData(data);
        return "billForm";
    }

    @PostMapping("/issue")
    public String issue(@ModelAttribute @Valid Certification.Res data, Model model) throws Exception {
        billingService.issue(data, model);
        return "billResult";
    }

    @PostMapping("/pay")
    @ResponseBody
    public ResponseEntity<BillPay.Res> pay(@RequestBody @Valid BillPay.Req data, Model model) throws Exception {
        return ResponseEntity.ok(billingService.pay(data, model));
    }

    @PostMapping("/remove")
    @ResponseBody
    public ResponseEntity remove(@RequestBody @Valid String bid) throws Exception {
        return ResponseEntity.ok(billingService.remove(bid));
    }

    @PostMapping("/detail")
    @ResponseBody
    public ResponseEntity<Detail.Res> detail(@RequestBody @Valid Detail.Req data) throws Exception {
        return ResponseEntity.ok(billingService.detail(data));
    }

    @PostMapping("/cancel")
    @ResponseBody
    public ResponseEntity<BillPayCancel.Res> cancel(@RequestBody @Valid BillPayCancel.Req data) throws Exception {
        return ResponseEntity.ok(billingService.cancel(data));
    }
}
