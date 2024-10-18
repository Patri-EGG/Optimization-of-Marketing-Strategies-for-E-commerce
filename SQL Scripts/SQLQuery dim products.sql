SELECT * FROM dbo.products

-- Consulta SQL para categorizar productos según su precio

SELECT 
    ProductID,  -- Selecciona el identificador único de cada producto
    ProductName,  -- Selecciona el nombre de cada producto
    Price,  -- Selecciona el precio de cada producto
	-- Category, -- Selecciona la categoría del producto para cada producto

    CASE  -- Clasifica los productos en categorías de precio: Bajo, Medio o Alto
        WHEN Price < 50 THEN 'Low'  -- Si el precio es menor a 50, clasifica como 'Bajo'
        WHEN Price BETWEEN 50 AND 200 THEN 'Medium'  -- Si el precio está entre 50 y 200 (inclusive), clasifica como 'Medio'
        ELSE 'High'  -- Si el precio es mayor a 200, clasifica como 'Alto'
    END AS PriceCategory  -- Nombra la nueva columna como PriceCategory

FROM 
    dbo.products;  -- Especifica la tabla de origen de la cual se seleccionan los datos
