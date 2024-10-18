-- SELECT * FROM dbo.engagement_data

-- Consulta para limpiar y normalizar la tabla engagement_data

SELECT 
    EngagementID,  -- Selecciona el identificador único de cada registro de participación
    ContentID,  -- Selecciona el identificador único de cada contenido
	CampaignID,  -- Selecciona el identificador único de cada campaña de marketing
    ProductID,  -- Selecciona el identificador único de cada producto
    UPPER(REPLACE(ContentType, 'Socialmedia', 'Social Media')) AS ContentType,  -- Reemplaza "Socialmedia" por "Social Media" y luego convierte todos los valores de ContentType a mayúsculas
    LEFT(ViewsClicksCombined, CHARINDEX('-', ViewsClicksCombined) - 1) AS Views,  -- Extrae la parte de Views de la columna ViewsClicksCombined tomando la subcadena antes del carácter '-'
    RIGHT(ViewsClicksCombined, LEN(ViewsClicksCombined) - CHARINDEX('-', ViewsClicksCombined)) AS Clicks,  -- Extrae la parte de Clicks de la columna ViewsClicksCombined tomando la subcadena después del carácter '-'
    Likes,  -- Selecciona el número de 'me gusta' que recibió el contenido
    -- Convierte la fecha de EngagementDate al formato dd.mm.yyyy
    FORMAT(CONVERT(DATE, EngagementDate), 'dd.MM.yyyy') AS EngagementDate  -- Convierte y formatea la fecha como dd.mm.yyyy
FROM 
    dbo.engagement_data  -- Especifica la tabla de origen de la cual se seleccionan los datos
WHERE 
    ContentType != 'Newsletter';  -- Filtra las filas donde ContentType es 'Newsletter', ya que no son relevantes para nuestro análisis
