package com.learning.continuous.controller;

import com.learning.continuous.controller.resource.CicdResponse;
import lombok.extern.log4j.Log4j2;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@Log4j2
public class ContinuousController {

    @GetMapping("/v1/ciCdInfo")
    public CicdResponse getProfile() {
        log.info("/v1/getProfile is executed");
        return new CicdResponse("My Cicd pipeline is working fine");
    }
}
