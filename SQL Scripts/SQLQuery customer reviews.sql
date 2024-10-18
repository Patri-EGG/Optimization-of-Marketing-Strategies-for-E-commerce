--SELECT * FROM customer_reviews

-- Consulta para limpiar problemas de espacios en blanco en la columna ReviewText

SELECT 
    ReviewID,  -- Selecciona el identificador único de cada reseña
    CustomerID,  -- Selecciona el identificador único de cada cliente
    ProductID,  -- Selecciona el identificador único de cada producto
    ReviewDate,  -- Selecciona la fecha en la que se escribió la reseña
    Rating,  -- Selecciona la calificación numérica dada por el cliente (por ejemplo, de 1 a 5 estrellas)
    -- Limpia el texto de la reseña reemplazando dobles espacios por espacios simples para asegurar que el texto sea más legible y esté estandarizado
    REPLACE(ReviewText, '  ', ' ') AS ReviewText
FROM 
    dbo.customer_reviews;  -- Especifica la tabla de origen de la cual se seleccionan los datos
