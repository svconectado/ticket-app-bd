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

insert into empresa (nombre , nombrecorto , id_tipo_empresa , nit )
select trim(nombre) as nombre, trim(nombrecorto) as nombrecorto, id_tipo_empresa::int4, trim(nit) as nit from   json_to_recordset(:jsonParams)
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
    id_tipo_empresa =coalesce (usRecord.tipoempresa, empresa.id_tipo_empresa , usRecord.tipoempresa::int4),
    nit =coalesce (usRecord.nit, empresa.nit , usRecord.nit)
FROM (
select * from   json_to_recordset(:jsonParams)
		as x("idempresa" text, "nombre" text, "nombrecorto" text, "tipoempresa" text, "nit" text)
) AS usRecord
WHERE 
    usRecord.idempresa::int4 = empresa.id_empresa 
    
    
    
 /* Query para eliminar el usuario enviado como parametro en un arreglo Json 
 * 
 * Ejemplo de JsonRequest
 * [{"idempresa": 10000, "nombre":"Davivienda", "nombrecorto":"Davi", "tipoempresa":3,"nit":null}, {"idempresa": 10000, "nombre":"Banco Agricola", "nombrecorto":"BA", "tipoempresa":3,"nit":null}]
 * 
 * */   
    
   delete from empresa e 
   where e.id_empresa in (
	select idempresa::int4 from   json_to_recordset(:jsonParams)
			as x("idempresa" text, "nombre" text, "nombrecorto" text, "tipoempresa" text, "nit" text)
	) AS usRecord
