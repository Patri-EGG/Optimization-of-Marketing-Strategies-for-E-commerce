 --SELECT * FROM dbo.customer_journey

-- Expresión de Tabla Común (CTE) para marcar registros duplicados para su posterior eliminación

WITH DuplicateRecords AS (
    SELECT 
        JourneyID,  -- Identificador único para cada viaje (junto con cualquier otra columna que desees incluir en el resultado)
        CustomerID,  -- Identificador único para cada cliente
        ProductID,  -- Identificador único para cada producto
        VisitDate,  -- Fecha de la visita para rastrear las interacciones de los clientes en el tiempo
        Stage,  -- Etapa del viaje del cliente (por ejemplo, Awareness, Consideration, etc.)
        Action,  -- Acción realizada por el cliente (por ejemplo, Ver, Clic, Compra)
        Duration,  -- Duración de la acción o interacción
        -- Asigna un número secuencial a cada registro dentro de la partición especificada utilizando ROW_NUMBER()
        ROW_NUMBER() OVER (
            -- PARTITION BY agrupa las filas según las columnas especificadas para identificar unicidad
            PARTITION BY CustomerID, ProductID, VisitDate, Stage, Action  
            -- ORDER BY ordena las filas dentro de cada partición usando JourneyID, asegurando consistencia
            ORDER BY JourneyID  
        ) AS row_num  -- 'row_num' sirve para indexar cada fila dentro de su grupo
    FROM 
        dbo.customer_journey  -- Tabla de origen de la cual se seleccionan los datos
)

-- Recupera todos los registros de la CTE donde row_num > 1, resaltando los duplicados
    
SELECT *
FROM DuplicateRecords
-- WHERE row_num > 1  -- Mantiene solo las filas duplicadas (excluyendo la primera instancia donde row_num = 1)
ORDER BY JourneyID

-- La consulta externa recupera los datos limpios después del procesamiento
    
SELECT 
    JourneyID,  -- Identificador único del viaje para mantener la integridad de los datos
    CustomerID,  -- Identificador único del cliente para relacionar los viajes con clientes específicos
    ProductID,  -- Identificador único del producto para evaluar las interacciones de los clientes con distintos productos
    VisitDate,  -- Fecha de la visita para analizar la línea de tiempo de las interacciones
    Stage,  -- Utiliza valores en mayúsculas de la etapa para un análisis uniforme
    Action,  -- Registra la acción realizada por el cliente (por ejemplo, Ver, Clic, Compra)
    COALESCE(Duration, avg_duration) AS Duration  -- Rellena las duraciones faltantes con la duración promedio calculada para esa fecha
FROM 
    (
        -- Subconsulta para limpiar y procesar los datos
        SELECT 
            JourneyID,  -- Identificador del viaje para fines de rastreo
            CustomerID,  -- Identificador del cliente para enlazar datos
            ProductID,  -- Identificador del producto para el análisis
            VisitDate,  -- Fecha de la visita para rastrear las interacciones a lo largo del tiempo
            UPPER(Stage) AS Stage,  -- Estandariza los valores de Stage convirtiéndolos a mayúsculas
            Action,  -- Captura la acción específica realizada por el cliente
            Duration,  -- Utiliza directamente el campo Duration
            AVG(Duration) OVER (PARTITION BY VisitDate) AS avg_duration,  -- Calcula la duración promedio para cada fecha de visita
            ROW_NUMBER() OVER (
                PARTITION BY CustomerID, ProductID, VisitDate, UPPER(Stage), Action  -- Segmenta los datos en grupos para encontrar duplicados
                ORDER BY JourneyID  -- Ordena los registros por JourneyID para conservar la primera entrada
            ) AS row_num  -- Número asignado a cada fila dentro de su partición para el manejo de duplicados
        FROM 
            dbo.customer_journey  -- Tabla de origen de la cual se extraen los datos
    ) AS subquery  -- Alias para referenciar los datos procesados en la consulta externa
WHERE 
    row_num = 1;  -- Filtra los duplicados, manteniendo solo la primera instancia dentro de cada grupo
