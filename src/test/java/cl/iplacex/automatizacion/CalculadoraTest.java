package cl.iplacex.automatizacion;

import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.Test;

class CalculadoraTest {
    private final Calculadora calculator = new Calculadora();

    @Test void sumaDosNumeros() { assertEquals(7, calculator.sumar(3, 4)); }
    @Test void restaDosNumeros() { assertEquals(2, calculator.restar(5, 3)); }
    @Test void detectaDesbordamiento() {
        assertThrows(ArithmeticException.class, () -> calculator.sumar(Integer.MAX_VALUE, 1));
    }
}
