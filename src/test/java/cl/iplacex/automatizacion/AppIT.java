package cl.iplacex.automatizacion;

import static org.junit.jupiter.api.Assertions.*;
import com.sun.net.httpserver.HttpServer;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

class AppIT {
    private HttpServer server;
    private final HttpClient client = HttpClient.newHttpClient();
    private String base;

    @BeforeEach void setUp() throws Exception {
        server = App.start(0, "integration");
        base = "http://127.0.0.1:" + server.getAddress().getPort();
    }
    @AfterEach void tearDown() { server.stop(0); }

    private HttpResponse<String> get(String path) throws Exception {
        return client.send(HttpRequest.newBuilder(URI.create(base + path)).GET().build(),
                HttpResponse.BodyHandlers.ofString());
    }

    @Test void endpointSaludResponde() throws Exception {
        assertEquals("OK:integration", get("/health").body());
    }
    @Test void apiIntegraHttpYCalculadora() throws Exception {
        var response = get("/calculate?op=sumar&a=8&b=5");
        assertEquals(200, response.statusCode());
        assertEquals("13", response.body());
    }
    @Test void solicitudIncorrectaDevuelve400() throws Exception {
        assertEquals(400, get("/calculate?op=dividir&a=8&b=2").statusCode());
    }
}
