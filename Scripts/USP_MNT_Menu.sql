USE [DB_Invitados]
GO
/****** Object:  StoredProcedure [dbo].[USP_MNT_Menu]    Script Date: 22/09/2022 1:49:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
             
ALTER PROCEDURE [dbo].[USP_MNT_Menu]          
            
	@nOpcion INT,   
	@pParametro VARCHAR(max)
                                                                                   
AS     

BEGIN

	BEGIN
		
		DECLARE @nIdPersona     INT;

	END
	
	--VARIABLE TABLA
	BEGIN

		DECLARE @tParametro TABLE (
			id int,
			valor varchar(max)
		);

	END

	--Descontena el parametro con split
	BEGIN
		IF(LEN(LTRIM(RTRIM(@pParametro))) > 0)
			BEGIN
			    INSERT INTO @tParametro (id, valor ) SELECT id, valor FROM dbo.Split(@pParametro, '|');
			END;
	END;
        
		
	IF @nOpcion = 1   --CONSULTAR MENU
	BEGIN	                                                                                                                                                     
			SELECT 
				IdMenu,
				Name,
				Route,
				Icon,
				IdParent,
				Level,
				Status
			FROM [Menu] 
			ORDER BY Level ASC, Name ASC
				                                                                 
	END;                                     
		

END
