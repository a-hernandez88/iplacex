package cl.iplacex.automatizacion;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpServer;
import java.io.IOException;
import java.net.InetSocketAddress;
import java.nio.charset.StandardCharsets;
import java.util.Map;
import java.util.Arrays;
import java.util.stream.Collectors;

public final class App {
    private App() { }

    public static HttpServer start(int port, String version) throws IOException {
        HttpServer server = HttpServer.create(new InetSocketAddress("127.0.0.1", port), 0);
        server.createContext("/health", exchange -> reply(exchange, 200, "OK:" + version));
        server.createContext("/calculate", exchange -> {
            try {
                Map<String, String> query = Arrays.stream(exchange.getRequestURI().getRawQuery().split("&"))
                        .map(part -> part.split("=", 2))
                        .collect(Collectors.toMap(part -> part[0], part -> part[1]));
                int a = Integer.parseInt(query.get("a"));
                int b = Integer.parseInt(query.get("b"));
                Calculadora calculator = new Calculadora();
                int result = switch (query.get("op")) {
                    case "sumar" -> calculator.sumar(a, b);
                    case "restar" -> calculator.restar(a, b);
                    default -> throw new IllegalArgumentException("Operación no admitida");
                };
                reply(exchange, 200, Integer.toString(result));
            } catch (RuntimeException error) {
                reply(exchange, 400, "Solicitud inválida");
            }
        });
        server.start();
        return server;
    }

    private static void reply(HttpExchange exchange, int status, String body) throws IOException {
        byte[] bytes = body.getBytes(StandardCharsets.UTF_8);
        exchange.getResponseHeaders().set("Content-Type", "text/plain; charset=utf-8");
        exchange.sendResponseHeaders(status, bytes.length);
        try (var output = exchange.getResponseBody()) { output.write(bytes); }
    }

    public static void main(String[] args) throws Exception {
        int port = Integer.parseInt(System.getenv().getOrDefault("APP_PORT", "8081"));
        String version = System.getenv().getOrDefault("APP_VERSION", "v1");
        start(port, version);
        System.out.println("Servidor " + version + " en puerto " + port);
    }
}
