/* Query para obtener todos los usuarios en base al arreglo de usuarios JSON que espera como parametro 
 * 
 * Ejemplo de JsonRequest
 * [{"idusuario": 10000, "nombre":null,"telefono":null},{"idusuario": 20000, "nombre":null,"telefono":null}]
 * 
 * Ejemplo de JsonResponse
 * 
 * [{"idusuario" : 20000, "nombre" : "prueba2", "telefono" : "1111111 ", "notificacion" : "cel"}, {"idusuario" : 10000, "nombre" : "prueba", "telefono" : "7777777 ", "notificacion" : ""}]
 * 
 * */
select
	json_agg(
    json_build_object(
        'idUsuario', u.id_usuario ,
        'nombre', u.nombre ,
        'telefono', u.telefono,
        'notificacion', u.tipo_notif 
    )
    ) as resultado
FROM usuario u
where u.id_usuario  in (select  (json_array_elements_text(:jsonParams)::jsonb->'idusuario')::int4 as id)


/* Query para obtener todos los usuarios de la tabla 
 * 
 * 
 * Ejemplo de JsonResponse
 * 
 * [{"idusuario" : 20000, "nombre" : "prueba2", "telefono" : "1111111 ", "notificacion" : "cel"}, {"idusuario" : 10000, "nombre" : "prueba", "telefono" : "7777777 ", "notificacion" : null}]
 * 
 * */

select
	json_agg(
    json_build_object(
        'idusuario', u.id_usuario ,
        'nombre', u.nombre ,
        'telefono', u.telefono, 
        'notificacion', u.tipo_notif 
    )
    ) as resultado
FROM usuario u

 

/* Query para insertar el usuario enviado como parametro en un arreglo Json 
 * 
 * Ejemplo de JsonRequest
 * [{"nombre":"Prueba","telefono":"11111111", "notificacion":"SMS"}]
 * 
 * */

insert into usuario (nombre , telefono , tipo_notif )
select trim(nombre) as nombre, trim(telefono) as telefono, trim(notificacion) as notificacion from   json_to_recordset(:jsonParams)
		as x("idusuario" text, "nombre" text, "telefono" text, "notificacion" text);
	
	
	
/* Query para modificar el usuario enviado como parametro en un arreglo Json 
 * 
 * Ejemplo de JsonRequest
 * [{"idusuario" : 20000,"nombre":"Prueba","telefono":null, "notificacion":"SMS"}]
 * 
 * */	
	
UPDATE usuario
SET nombre = coalesce (usRecord.nombre, usuario.nombre, usRecord.nombre), 
    telefono = coalesce (usRecord.telefono, usuario.telefono, usRecord.telefono),
    tipo_notif =coalesce (usRecord.notificacion, usuario.tipo_notif, usRecord.notificacion)
FROM (
select * from   json_to_recordset(:jsonParams)
		as x("idusuario" text, "nombre" text, "telefono" text, "notificacion" text)
) AS usRecord
WHERE 
    usRecord.idusuario::int4 = usuario.id_usuario
    
    
    
 /* Query para eliminar el usuario enviado como parametro en un arreglo Json 
 * 
 * Ejemplo de JsonRequest
 * [{"idusuario" : 20000,"nombre":null,"telefono":null, "notificacion":null}]
 * 
 * */   
    
   delete from usuario u 
   where u.id_usuario in (
	select idusuario::int4 from   json_to_recordset(:jsonParams)
			as x("idusuario" text, "nombre" text, "telefono" text, "notificacion" text)
	) AS usRecord
	
	
	
-- Metodos para obtener data de la tabla empresa

	
/* Query para obtener todos las empresas de la tabla 
 * 
 * 
 * Ejemplo de JsonResponse
 * 
 * [{"idempresa": 10000, "nombre":"Davivienda", "nombrecorto":"Davi", "tipoempresa":3,"nit":null}, {"idempresa": 10000, "nombre":"Banco Agricola", "nombrecorto":"BA", "tipoempresa":3,"nit":null}]
 * 
 * */

select
	json_agg(
    json_build_object(
        'idempresa', e.id_empresa ,
        'nombre', e.nombre ,
        'nombrecorto', e.nombre_corto ,
        'tipoempresa', e.id_tipo_empresa ,
        'nit', e.nit 
    )
    ) as resultado
FROM empresa e	
	
	
	
	
/* Query para obtener todas las empresas en base al arreglo de usuarios JSON que espera como parametro 
 * 
 * Ejemplo de JsonRequest
 * [{"idempresa": 10000, "nombre":null, "nombrecorto":null, "tipoempresa":null,"nit":null},{"idempresa": 10000, "nombre":null, "nombrecorto":null, "tipoempresa":null,"nit":null}]
 * 
 * Ejemplo de JsonResponse
 * 
 * [{"idempresa": 10000, "nombre":"Davivienda", "nombrecorto":"Davi", "tipoempresa":3,"nit":null}, {"idempresa": 10000, "nombre":"Banco Agricola", "nombrecorto":"BA", "tipoempresa":3,"nit":null}]
 * 
 * */
select
	json_agg(
    json_build_object(
        'idempresa', e.id_empresa ,
        'nombre', e.nombre ,
        'nombrecorto', e.nombre_corto ,
        'tipoempresa', e.id_tipo_empresa ,
        'nit', e.nit 
    )
    ) as resultado
FROM empresa e
where e.id_empresa  in (select  (json_array_elements_text(:jsonParams)::jsonb->'idempresa')::int4 as id)




/* Query para insertar la empresa enviada como parametro en un arreglo Json 
 * 
 * Ejemplo de JsonRequest
 * [{"idempresa": 10000, "nombre":"Davivienda", "nombrecorto":"Davi", "tipoempresa":3,"nit":null}, {"idempresa": 10000, "nombre":"Banco Agricola", "nombrecorto":"BA", "tipoempresa":3,"nit":null}]
 * 
 * */

insert into empresa (nombre , nombre_corto , id_tipo_empresa , nit )
select trim(nombre) as nombre, trim(nombrecorto) as nombrecorto, tipoempresa::int4, trim(nit) as nit from   json_to_recordset(:jsonParams)
		as x("idempresa" text, "nombre" text, "nombrecorto" text, "tipoempresa" text, "nit" text);
	
	
	
/* Query para modificar la empresa enviada como parametro en un arreglo Json 
 * 
 * Ejemplo de JsonRequest
 * [{"idempresa": 10000, "nombre":"Davivienda", "nombrecorto":"Davi", "tipoempresa":3,"nit":null}, {"idempresa": 10000, "nombre":"Banco Agricola", "nombrecorto":"BA", "tipoempresa":3,"nit":null}]
 * 
 * */	
	
UPDATE empresa
SET nombre = coalesce (usRecord.nombre, empresa.nombre, usRecord.nombre), 
    nombre_corto = coalesce (usRecord.nombrecorto, empresa.nombre_corto , usRecord.nombrecorto),
    id_tipo_empresa =coalesce (usRecord.tipoempresa::int4, empresa.id_tipo_empresa , usRecord.tipoempresa::int4),
    nit =coalesce (usRecord.nit, empresa.nit , usRecord.nit)
FROM (
select * from   json_to_recordset(:jsonParams)
		as x("idempresa" text, "nombre" text, "nombrecorto" text, "tipoempresa" text, "nit" text)
) AS usRecord
WHERE 
    usRecord.idempresa::int4 = empresa.id_empresa 
    

      
    
    
 /* Query para eliminar la empresa enviado como parametro en un arreglo Json 
 * 
 * Ejemplo de JsonRequest
 * [{"idempresa": 10000, "nombre":"Davivienda", "nombrecorto":"Davi", "tipoempresa":3,"nit":null}, {"idempresa": 10000, "nombre":"Banco Agricola", "nombrecorto":"BA", "tipoempresa":3,"nit":null}]
 * 
 * */   
    
   delete from empresa e 
   where e.id_empresa in (
	select idempresa::int4 from   json_to_recordset(:jsonParams)
			as x("idempresa" text, "nombre" text, "nombrecorto" text, "tipoempresa" text, "nit" text)
	) 
	
	
	
	
	
	
-- Metodos para obtener data de la tabla cola

	
/* Query para obtener todos las colas de la tabla 
 * 
 * 
 * Ejemplo de JsonResponse
 * 
 * [{"idcola": 10000, "descripcion":"DescripcionCola", "idestablecimiento":2, "cupos":3,"ultimoatendido":null}, {"idcola": 20000, "descripcion":"DescripcionCola", "idestablecimiento":2, "cupos":3,"ultimoatendido":null}]
 * 
 * */

select
	json_agg(
    json_build_object(
        'idcola', c.id_cola ,
        'descripcion', c.descripcion ,
        'idestablecimiento', c.id_establecimiento ,
        'cupos', c.cupos ,
        'ultimoatendido', c.ultimo_atendido 
    )
    ) as resultado
FROM cola c	
	
	
	
	
/* Query para obtener todas las colas en base al arreglo de usuarios JSON que espera como parametro 
 * 
 * Ejemplo de JsonRequest
 * [{"idcola": 10000, "descripcion":"DescripcionCola", "idestablecimiento":2, "cupos":3,"ultimoatendido":null}, {"idcola": 20000, "descripcion":"DescripcionCola", "idestablecimiento":2, "cupos":3,"ultimoatendido":null}]
 * 
 * Ejemplo de JsonResponse
 * 
 * [{"idcola": 10000, "descripcion":"DescripcionCola", "idestablecimiento":2, "cupos":3,"ultimoatendido":null}, {"idcola": 20000, "descripcion":"DescripcionCola", "idestablecimiento":2, "cupos":3,"ultimoatendido":null}]
 * 
 * */
select
	json_agg(
    json_build_object(
        'idcola', c.id_cola ,
        'descripcion', c.descripcion ,
        'idestablecimiento', c.id_establecimiento ,
        'cupos', c.cupos ,
        'ultimoatendido', c.ultimo_atendido 
    )
    ) as resultado
FROM cola c
where c.id_cola  in (select  (json_array_elements_text(:jsonParams)::jsonb->'idcola')::int4 as id)




/* Query para insertar la cola enviada como parametro en un arreglo Json 
 * 
 * Ejemplo de JsonRequest
 * [{"idcola": 10000, "descripcion":"DescripcionCola", "idestablecimiento":2, "cupos":3,"ultimoatendido":null}, {"idcola": 20000, "descripcion":"DescripcionCola", "idestablecimiento":2, "cupos":3,"ultimoatendido":null}]
 * 
 * */

insert into cola (descripcion , id_establecimiento , cupos , ultimo_atendido )
select trim(descripcion) as descripcion, idestablecimiento::int4 as idestablecimiento, cupos::int2 as cupos, ultimoatendido::int8 as ultimoatendido from   json_to_recordset(:jsonParams)
		as x("idcola" text, "descripcion" text, "idestablecimiento" text, "cupos" text, "ultimoatendido" text);
	

	
	
	
/* Query para modificar la cola enviada como parametro en un arreglo Json 
 * 
 * Ejemplo de JsonRequest
 * [{"idcola": 10000, "descripcion":"DescripcionCola", "idestablecimiento":2, "cupos":3,"ultimoatendido":null}, {"idcola": 20000, "descripcion":"DescripcionCola", "idestablecimiento":2, "cupos":3,"ultimoatendido":null}]
 * 
 * */	
	
UPDATE cola
SET descripcion = coalesce (usRecord.descripcion, cola.descripcion , usRecord.descripcion), 
    id_establecimiento = coalesce (usRecord.idestablecimiento, cola.id_establecimiento id , usRecord.idestablecimiento::int4),
    cupos =coalesce (usRecord.cupos, cola.cupos , usRecord.cupos::int2),
    ultimo_atendido =coalesce (usRecord.ultimoatendido, cola.ultimo_atendido , usRecord.ultimoatendido::int8)
FROM (
select * from   json_to_recordset(:jsonParams)
		as x("idcola" text, "descripcion" text, "idestablecimiento" text, "cupos" text, "ultimoatendido" text)
) AS usRecord
WHERE 
    usRecord.idcola::int4 = cola.id_cola 
    
    
    
 /* Query para eliminar la cola enviada como parametro en un arreglo Json 
 * 
 * Ejemplo de JsonRequest
 * [{"idcola": 10000, "descripcion":"DescripcionCola", "idestablecimiento":2, "cupos":3,"ultimoatendido":null}, {"idcola": 20000, "descripcion":"DescripcionCola", "idestablecimiento":2, "cupos":3,"ultimoatendido":null}]
 * 
 * */   
    
   delete from cola c 
   where c.id_cola in (
	select idcola::int4 from   json_to_recordset(:jsonParams)
			as x("idcola" text, "descripcion" text, "idestablecimiento" text, "cupos" text, "ultimoatendido" text)
	) AS usRecord
	
	
	
-- Metodos para obtener data de la tabla tipo empresa

	
/* Query para obtener todos las colas de la tabla 
 * 
 * 
 * Ejemplo de JsonResponse
 * 
 * [{"idtipo": 10000, "tipo":"Banco"}, {"idtipo": 20000, "tipo":"Farmacia"}]
 * 
 * */

select
	json_agg(
    json_build_object(
        'idtipo', te.id_tipo_empresa ,
        'tipo', te.tipo_empresa 
    )
    ) as resultado
FROM tipo_empresa te	
	
	
	
	
/* Query para obtener todos los tipos de empresa en base al arreglo de usuarios JSON que espera como parametro 
 * 
 * Ejemplo de JsonRequest
 * [{"idtipo": 10000, "tipo":"Banco"}, {"idtipo": 20000, "tipo":"Farmacia"}]
 * 
 * Ejemplo de JsonResponse
 * 
 * [{"idtipo": 10000, "tipo":"Banco"}, {"idtipo": 20000, "tipo":"Farmacia"}]
 * 
 * */
select
	json_agg(
    json_build_object(
        'idtipo', te.id_tipo_empresa ,
        'tipo', te.tipo_empresa 
    )
    ) as resultado
FROM tipo_empresa te
where te.id_tipo_empresa  in (select  (json_array_elements_text(:jsonParams)::jsonb->'idtipo')::int4 as id)




/* Query para insertar los tipo de empresa enviados como parametro en un arreglo Json 
 * 
 * Ejemplo de JsonRequest
 * [{"idtipo": 10000, "tipo":"Banco"}, {"idtipo": 20000, "tipo":"Farmacia"}]
 * 
 * */

insert into tipo_empresa (tipo)
select trim(tipo) as tipo from   json_to_recordset(:jsonParams)
		as x("idtipo" text, "tipo" text);
	
	
	
/* Query para modificar los tipos de empresa enviados como parametro en un arreglo Json 
 * 
 * Ejemplo de JsonRequest
 * [{"idtipo": 10000, "tipo":"Banco"}, {"idtipo": 20000, "tipo":"Farmacia"}]
 * 
 * */	
	
UPDATE tipo_empresa 
SET tipo_empresa = coalesce (usRecord.tipo, tipo_empresa.tipo_empresa , usRecord.tipo)
FROM (
select * from   json_to_recordset(:jsonParams)
		as x("idtipo" text, "tipo" text)
) AS usRecord
WHERE 
    usRecord.idtipo::int4 = tipo_empresa.id_tipo_empresa 
    
    
    
 /* Query para eliminar los tipos de empresas enviados como parametro en un arreglo Json 
 * 
 * Ejemplo de JsonRequest
 * [{"idtipo": 10000, "tipo":"Banco"}, {"idtipo": 20000, "tipo":"Farmacia"}]
 * 
 * */   
    
   delete from tipo_empresa te 
   where te.id_tipo_empresa in (
	select idtipo::int4 from   json_to_recordset(:jsonParams)
			as x("idtipo" text, "tipo" text)
	) 
    

    
