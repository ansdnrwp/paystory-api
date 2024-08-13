package paystory.api.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/api/pg/sample")
@RequiredArgsConstructor
public class SampleController {


    @GetMapping("/cardbill")
    public String home(Model model) {
        return "sample";
    }
}
