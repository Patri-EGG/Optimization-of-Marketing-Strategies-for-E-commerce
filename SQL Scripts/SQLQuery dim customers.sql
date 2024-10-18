-- Declaración SQL para unir dim_customers con dim_geography para enriquecer los datos de los clientes con información geográfica

SELECT 
    c.CustomerID,  -- Selecciona el identificador único de cada cliente
    c.CustomerName,  -- Selecciona el nombre de cada cliente
    c.Email,  -- Selecciona el correo electrónico de cada cliente
    c.Gender,  -- Selecciona el género de cada cliente
    c.Age,  -- Selecciona la edad de cada cliente
    g.Country,  -- Selecciona el país de la tabla de geografía para enriquecer los datos del cliente
    g.City  -- Selecciona la ciudad de la tabla de geografía para enriquecer los datos del cliente
FROM 
    dbo.customers as c  -- Especifica el alias 'c' para la tabla dim_customers
LEFT JOIN
    dbo.geography g  -- Especifica el alias 'g' para la tabla dim_geography
ON 
    c.GeographyID = g.GeographyID;  -- Une las dos tablas mediante el campo GeographyID para relacionar clientes con su información geográfica
