package com.medibee.webapp;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.web.servlet.MockMvc;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;
import static org.hamcrest.Matchers.containsString;

@SpringBootTest
@AutoConfigureMockMvc
class PublicPagesTests {
    @Autowired MockMvc mvc;

    @Test void rendersPublicPagesWithoutLogin() throws Exception {
        for (String path : new String[]{"/", "/login", "/register", "/doctors"}) {
            mvc.perform(get(path)).andExpect(status().isOk())
                .andExpect(content().string(containsString("MediBee")));
        }
    }

    @Test void protectsUnimplementedPrivateRoutes() throws Exception {
        mvc.perform(get("/admin")).andExpect(status().isForbidden());
    }

    @Test void exposesHealth() throws Exception {
        mvc.perform(get("/actuator/health")).andExpect(status().isOk())
            .andExpect(jsonPath("$.status").value("UP"));
    }
}
