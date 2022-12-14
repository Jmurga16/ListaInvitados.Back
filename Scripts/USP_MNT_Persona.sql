USE [DB_Invitados]
GO
/****** Object:  StoredProcedure [dbo].[USP_MNT_Persona]    Script Date: 22/09/2022 1:26:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[USP_MNT_Persona]          
            
	@nOpcion INT,   
	@pParametro VARCHAR(max)
                                                                                   
AS     

BEGIN

	BEGIN
		
		DECLARE @nIdPersona     INT;
		DECLARE @sDNI   VARCHAR(MAX)
		DECLARE @sNombre VARCHAR(MAX)    
		DECLARE @sApellidoPaterno	 VARCHAR(MAX);
		DECLARE @sApellidoMaterno	 VARCHAR(MAX);

		DECLARE @bEstado BIT;
		DECLARE @nEstado INT;
		
		DECLARE @nContador INT

		DECLARE @IdUsuario	 VARCHAR(MAX);
		DECLARE @Password	 VARCHAR(MAX);
    	

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
        
		
	IF @nOpcion = 1   --CONSULTAR INVITADOS  
	BEGIN	                                                                                                                                                     
			SELECT 
				pers.nIdPersona,
				pers.sDNI,
				pers.sNombre,
				pers.sApellidoPaterno,
				pers.sApellidoMaterno,
				CONCAT(TRIM(pers.sApellidoPaterno), ' ', TRIM(pers.sApellidoMaterno), ' ',TRIM(pers.sNombre)) AS 'sNombrePersona',
				bEstado
			FROM [Persona] pers
			WHERE
				pers.bEstado = 1
			ORDER BY
				pers.sApellidoPaterno ASC
				                                                                 
	END;                                     

	ELSE IF @nOpcion = 2  --CONSULTAR POR DNI                                                 
	BEGIN
		BEGIN
			SET @sDNI	= (SELECT valor FROM @tParametro WHERE id = 1);	
		END	
		
		BEGIN
			SELECT 
				pers.nIdPersona,
				pers.sDNI,
				pers.sNombre,
				pers.sApellidoPaterno,
				pers.sApellidoMaterno,
				CONCAT(TRIM(pers.sApellidoPaterno), ' ', TRIM(pers.sApellidoMaterno), ' ',TRIM(pers.sNombre)) AS 'sNombrePersona',
				bEstado
			FROM [Persona] pers
			WHERE sDNI = @sDNI
		
		END
	END;

	ELSE IF @nOpcion = 3  --INSERTAR  (R)                                                        
	BEGIN
		BEGIN
			SET @sDNI				= (SELECT valor FROM @tParametro WHERE id = 1);
			SET @sApellidoPaterno	= (SELECT valor FROM @tParametro WHERE id = 2);
			SET @sApellidoMaterno	= (SELECT valor FROM @tParametro WHERE id = 3);
			SET @sNombre			= (SELECT valor FROM @tParametro WHERE id = 4);

		END	

		BEGIN
			
			IF((SELECT COUNT(*) FROM Persona WHERE sDNI = @sDNI AND bEstado = 1) > 0)
				BEGIN
					SELECT '0|Ya existe el DNI registrado'
				END

			ELSE
				BEGIN

					INSERT INTO [Persona]
							(sDNI,  sNombre,  sApellidoPaterno,  sApellidoMaterno, bEstado)
					VALUES	(@sDNI, UPPER(@sNombre), UPPER(@sApellidoPaterno), UPPER(@sApellidoMaterno), 1)

					SET @nIdPersona = SCOPE_IDENTITY()
		
					SELECT '1|Se registró con éxito'

				END
			
		END
		
	END
	   
	   
	ELSE IF @nOpcion = 4  -- EDITAR   (U)                                                        
	BEGIN
		BEGIN
			SET @sDNI				= (SELECT valor FROM @tParametro WHERE id = 1);
			SET @sApellidoPaterno	= (SELECT valor FROM @tParametro WHERE id = 2);
			SET @sApellidoMaterno	= (SELECT valor FROM @tParametro WHERE id = 3);
			SET @sNombre			= (SELECT valor FROM @tParametro WHERE id = 4);
			SET @nIdPersona			= (SELECT valor FROM @tParametro WHERE id = 5);
			
		END	

		UPDATE [Persona]                           
		SET 
			sDNI			 = UPPER(@sDNI),
			sNombre			 = UPPER(@sNombre),
			sApellidoPaterno = UPPER(@sApellidoPaterno),
			sApellidoMaterno = UPPER(@sApellidoMaterno)     
		WHERE 
			nIdPersona = @nIdPersona                          
		   
		SELECT '1|Se actualizó con éxito'
                                                       
	END;                            

                                                           
	ELSE IF @nOpcion = 5  -- ELIMINAR (D)                                                          
	BEGIN  
		BEGIN
			SET @nIdPersona	= (SELECT valor FROM @tParametro WHERE id = 1);	
			SET @bEstado	= (SELECT valor FROM @tParametro WHERE id = 2);	
		END	
        
		BEGIN
				
			--Eliminacion Logica
			UPDATE Persona
				SET	 bEstado = @bEstado
			WHERE 
				nIdPersona = @nIdPersona

			SELECT '1|Se actualizó con éxito'

        END                                               
	END;                                                        
     
	ELSE IF @nOpcion = 6  -- ACCESO
	BEGIN  
		BEGIN
			SET @IdUsuario	= (SELECT valor FROM @tParametro WHERE id = 1);	
			SET @Password	= (SELECT valor FROM @tParametro WHERE id = 2);	
		END	
        
		BEGIN
			
			IF(@IdUsuario ='admin' AND @Password ='2022')
				BEGIN
					SELECT '1|Se ingresó con éxito'					
				END
			ELSE
				BEGIN
					SELECT '0|Credenciales incorrectas'										
				END


        END                                               
	END;    
	
END
