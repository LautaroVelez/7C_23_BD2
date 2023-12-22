--delimitar para q en vez de ; sea //
DELIMITER //
--crear stored procedure
CREATE PROCEDURE GetAllProducts()
BEGIN
    SELECT * FROM products;
END //
DELIMITER ;


--llamar a un stored procedure
CALL GetAllProducts();


--definir una variable
DECLARE nombre_de_variable tipo_de_dato(tamaño) DEFAULT valor_predeterminado;
--osea
DECLARE total_sale INT DEFAULT 0;

--podes asignarle valores a esas VARIABLES

DECLARE total_count INT DEFAULT 0;
SET total_count = 10;

--o sino

DECLARE total_products INT DEFAULT 0;
SELECT COUNT(*) INTO total_products FROM products;

--Ejemplo de parámetro IN:
DELIMITER //
CREATE PROCEDURE GetOfficeByCountry(IN countryName VARCHAR(255))
BEGIN
    SELECT * 
    FROM offices
    WHERE country = countryName;
END //
DELIMITER ;

--para llamarlo y probar si anda es 
CALL GetOfficeByCountry('USA');

--Ejemplo de parámetro OUT:
DELIMITER $$
CREATE PROCEDURE CountOrderByStatus(
    IN orderStatus VARCHAR(25),
    OUT total INT
)
BEGIN
    SELECT COUNT(orderNumber)
    INTO total
    FROM orders
    WHERE status = orderStatus;
END $$
DELIMITER ;

--para llamarlo seria 
CALL CountOrderByStatus('Shipped', @total);
SELECT @total;

--Ejemplo de parámetro INOUT:

DELIMITER $$
CREATE PROCEDURE set_counter(INOUT count INT(4), IN inc INT(4))
BEGIN
    SET count = count + inc;
END $$
DELIMITER ;

--para probarlo es 

SET @counter = 1;
CALL set_counter(@counter, 1); -- 2
CALL set_counter(@counter, 1); -- 3
CALL set_counter(@counter, 5); -- 8
SELECT @counter; -- 8

--con un case

DELIMITER $$

CREATE PROCEDURE GetCustomerShipping(
    IN p_customerNumber INT(11), 
    OUT p_shipping VARCHAR(50))
BEGIN
    DECLARE customerCountry VARCHAR(50);

    SELECT country INTO customerCountry
    FROM customers
    WHERE customerNumber = p_customerNumber;

    CASE customerCountry
        WHEN 'USA' THEN
           SET p_shipping = 'Envío de 2 días';
        WHEN 'Canadá' THEN
           SET p_shipping = 'Envío de 3 días';
        ELSE
           SET p_shipping = 'Envío de 5 días';
    END CASE;

END$$

--lo llamas asi

SET @customerNo = 112;

SELECT country INTO @country
FROM customers
WHERE customernumber = @customerNo;

CALL GetCustomerShipping(@customerNo, @shipping);

SELECT @customerNo AS Cliente,
       @country AS País,
       @shipping AS Envío;


--CURSOR

DECLARE finalizado INTEGER DEFAULT 0;
DECLARE correo varchar(255) DEFAULT "";

-- declarar cursor para el correo electrónico de los empleados
DECLARE cursor_correo CURSOR FOR 
	SELECT correo FROM empleados;

-- declarar controlador NOT FOUND
DECLARE CONTINUE HANDLER 
FOR NOT FOUND SET finalizado = 1;

--lo abrimos
OPEN cursor_correo;

obtener_correo: LOOP
	FETCH cursor_correo INTO v_correo;
	IF v_finalizado = 1 THEN 
		LEAVE obtener_correo;
	END IF;
	-- construir lista de correos electrónicos
	SET lista_correos = CONCAT(v_correo,";",lista_correos);
END LOOP obtener_correo;


--store procedure creado con cursor

DELIMITER $$
CREATE PROCEDURE construir_lista_correos (INOUT lista_correos varchar(4000))
BEGIN
	DECLARE v_finalizado INTEGER DEFAULT 0;
    DECLARE v_correo varchar(100) DEFAULT "";

	-- declarar cursor para el correo electrónico de los empleados
	DEClARE cursor_correo CURSOR FOR 
		SELECT correo FROM empleados;

	-- declarar controlador NOT FOUND
	DECLARE CONTINUE HANDLER 
        FOR NOT FOUND SET v_finalizado = 1;

	OPEN cursor_correo;

	obtener_correo: LOOP

		FETCH cursor_correo INTO v_correo;

		IF v_finalizado = 1 THEN 
			LEAVE obtener_correo;
		END IF;

		-- construir lista de correos electrónicos
		SET lista_correos = CONCAT(v_correo,";",lista_correos);

	END LOOP obtener_correo;

	CLOSE cursor_correo;

END$$
DELIMITER ;


--para probarlo es 
SET @lista_correos = "";
CALL construir_lista_correos(@lista_correos);
SELECT @lista_correos;
