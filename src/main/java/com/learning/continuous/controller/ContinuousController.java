package com.learning.continuous.controller;

import com.learning.continuous.controller.resource.CicdResponse;
import lombok.extern.log4j.Log4j2;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@Log4j2
public class ContinuousController {

    @GetMapping("/v1/getCiCdInfo")
    public CicdResponse getCiCdInfo() {
        log.info("--------- /v1/getCiCdInfo is executed -------- ");
        return new CicdResponse("My Cicd pipeline is working fine!!");
    }

    @GetMapping("/v1/getCiCdUser/{userId}")
    public CicdResponse getCicdUser() {
        log.info("----------- /v1/getCicdUser is executed ---------- ");
        return new CicdResponse("My Cicd user fetch is working fine!!");
    }
}
