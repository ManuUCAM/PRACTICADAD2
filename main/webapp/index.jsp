<%@ page language='java' contentType='text/html; charset=UTF-8'
    pageEncoding='UTF-8'%>
<!DOCTYPE html>
<html>
<head>
<meta charset='UTF-8'>
<title>Home JSP</title>
	<script type='text/javascript' src='js/jquery-1.12.4.min.js'></script>
	
	<script type='text/javascript'>
		
		// -------- PARA USUARIOS --------
		function load(id, username, passwd) {
			
			var entry = document.createElement('li');
			var aBorrar = document.createElement('a');
			var linkTextB = document.createTextNode('  [Borrar]');
			
			aBorrar.appendChild(linkTextB);
			
			aBorrar.onclick = function(){
				$.ajax({
					url: 'rest/user/borrar/' + id,
					type: 'DELETE',
					dataType: 'json',
					success: function(result) {
						document.getElementById(id).remove();
					},
			    	error: function(jqXhr, textStatus, errorMessage){
						errorMessage = jqXhr.responseText;
						
						if (!errorMessage)
				    		console.log('Error desconocido al borrar usuario. Estado: ' + textStatus);
						
						alert(errorMessage);
			    	}
				})
			}
			
			var aModificar = document.createElement('a');
			var linkTextM = document.createTextNode('  [Modificar]');
			
			aModificar.appendChild(linkTextM);
			aModificar.onclick = function() {
				$('#idUserMod').val(id);
				$('#usernameUserMod').val(username);
				$('#passwdUserMod').val(passwd);
				
				$('#formUserMod').show();
			}
			
			entry.id = id;
			entry.appendChild(document.createTextNode('(' + id + ') ' + username + ' | ' + passwd ));
			entry.appendChild(aBorrar);
			entry.appendChild(aModificar);
			
			$('#usuarios').append(entry);
		}
		
		$(document).ready(function(){
			
			$('#crearUsuario').click(function(){
				
				var sendInfo = {
					username: $('#usernameUser').val(),
					passwd: $('#passwdUser').val()
				}
				
				$.ajax({
					url: 'rest/user/alta',
					headers: {
						'Accept': 'application/json',
						'Content-Type': 'application/json'
					},
					type: 'POST',
					dataType: 'json',
					success: function(result) {
						console.log(result.user);
						load(result.user.id, result.user.username, result.user.passwd);
					},
			    	error: function(jqXhr, textStatus, errorMessage){
						errorMessage = jqXhr.responseText;
						
						if (!errorMessage)
				    		console.log('Error desconocido al dar de alta usuario. Estado: ' + textStatus);
						
						alert(errorMessage);
					},
					data: JSON.stringify(sendInfo)
				})
			})
			
			$('#modificarUsuario').click(function(){
					
				const id = $('#idUserMod').val();
				
				const sendInfo = {
					username: $('#usernameUserMod').val(),
					passwd: $('#passwdUserMod').val(),
				}
				
				$.ajax({
					url: 'rest/user/modificar/' + id,
					type: 'PUT',
					headers: {
						'Accept': 'application/json',
						'Content-Type': 'application/json'
					},
					dataType: 'json',
					success: function(result){
						
						alert('Usuario modificado');
						document.getElementById(id).remove();
						
						load(result.user.id, result.user.username, result.user.passwd);
						
						$('#formUserMod').hide();
						
						$('#idUserMod').val('');
						$('#usernameUserMod').val('');
						$('#passwdUserMod').val('');
					},
			    	error: function(jqXhr, textStatus, errorMessage){
						errorMessage = jqXhr.responseText;
						
						if (!errorMessage)
				    		console.log('Error desconocido al modificar usuario. Estado: ' + textStatus);
						
						alert(errorMessage);
					},
					data: JSON.stringify(sendInfo)
				})	
			})
			
			$.ajax({
				url: 'rest/user/todos',	
				type: 'GET',
				dataType: 'json',
				success: function(result) {
					jQuery.each(result.users, function(i, val){
						load(val.id, val.username, val.passwd);
					})
				}
			})
			
		})
		
		// -------- PARA ESPACIOS --------
		function loadEspacio(id, name) {
			
			var entry = document.createElement('li');
			
			var aBorrar = document.createElement('a');
			var linkTextB = document.createTextNode('  [Borrar]');
			
			aBorrar.appendChild(linkTextB);
			
			aBorrar.onclick = function(){
				$.ajax({
					url: 'rest/espacio/borrar/' + id,
					type: 'DELETE',
					dataType: 'json',
					success: function(result) {
						document.getElementById(id).remove();
					},
			    	error: function(jqXhr, textStatus, errorMessage){
						errorMessage = jqXhr.responseText;
						
						if (!errorMessage)
				    		console.log('Error desconocido al borrar espacio. Estado: ' + textStatus);
						
						alert("Error: " + errorMessage);
			    	}
				});
			};
			
			var aModificar = document.createElement('a');
			var linkTextM = document.createTextNode('  [Modificar]');
			
			aModificar.appendChild(linkTextM);
			aModificar.onclick = function() {
				$('#idEspMod').val(id);
				$('#nombreEspMod').val(name);	
				$('#formEspMod').show();
			};
			
			entry.id = id;
			
			entry.appendChild(document.createTextNode('(' + id + ') ' + name));
			
			entry.appendChild(aBorrar);
			entry.appendChild(aModificar);
			
			$('#espacios').append(entry);
		}
		
		$(document).ready(function() {
	        $('#crearEspacio').click(function(){
	        	
	            var sendInfo = {
	                name: $('#nombreEsp').val()
	            };
	            
	            $.ajax({
	                url: 'rest/espacio/alta',
	                headers: {
	                    'Accept': 'application/json',
	                    'Content-Type': 'application/json'
	                },
	                type: 'POST',
	                dataType: 'json',
	                success: function(result) {
	                    console.log(result.espacio);
	                    loadEspacio(result.espacio.id, result.espacio.name);
	                    $('#nombreEsp').val('');
	                },
			    	error: function(jqXhr, textStatus, errorMessage){
						errorMessage = jqXhr.responseText;
						
						if (!errorMessage)
				    		console.log('Error desconocido al dar de alta espacio. Estado: ' + textStatus);
						
						alert("Error: " + errorMessage);
			    	},
	                data: JSON.stringify(sendInfo)
	            });
	        });
	        
	        
	        $('#modificarEspacio').click(function(){
	            const id = $('#idEspMod').val();
	            
	            const sendInfo = {
	                name: $('#nombreEspMod').val()
	            };
	            
	            $.ajax({
	                url: 'rest/espacio/modificar/' + id,
	                type: 'PUT',
	                headers: {
	                    'Accept': 'application/json',
	                    'Content-Type': 'application/json'
	                },
	                dataType: 'json',
	                success: function(result){
	                    alert('Espacio modificado exitosamente');
	                    
	                    document.getElementById(id).remove(); 
	                    
	                    loadEspacio(result.espacio.id, result.espacio.name);
	                    
	                    $('#formEspMod').hide();
	                    
	                    $('#idEspMod').val('');
	                    $('#nombreEspMod').val('');
	                },
	                error: function(jqXHR, textStatus, errorThrown){
	                    let errorMessage = jqXHR.responseText;
	                    
	                    if (!errorMessage) {
	                        errorMessage = 'Error desconocido al modificar  espacio. Estado: ' + textStatus;
	                    }
	                    alert('Error: ' + errorMessage);
	                },
	                data: JSON.stringify(sendInfo)
	            });
	        });
			
			$.ajax({
				url: 'rest/espacio/todos',	
				type: 'GET',
				dataType: 'json',
				success: function(result) {
					jQuery.each(result.espacios, function(i, val){
						loadEspacio(val.id, val.name);
					})
				}
			})
			
		})
		
		
		// -------- PARA HUECOS --------
        function loadHueco(id, idEspacio, fechaEntrada, fechaSalida) {
            var entry = document.createElement('li');
            var aBorrar = document.createElement('a');
            
            var linkTextB = document.createTextNode('  [Borrar]');
            
            aBorrar.appendChild(linkTextB);
            
            aBorrar.onclick = function() {
                
            	$.ajax({
                    url: 'rest/hueco/borrar/' + id, // Este endpoint aún no lo hemos creado en HuecoService
                    type: 'DELETE',
                    dataType: 'json',
                    success: function(result) {
                        document.getElementById(id).remove();
                    },
			    	error: function(jqXhr, textStatus, errorMessage){
						errorMessage = jqXhr.responseText;
						
						if (!errorMessage)
				    		console.log('Error desconocido al borrar hueco. Estado: ' + textStatus);
						
						alert("Error: " + errorMessage);
			    	}
                });
            };
                                
	       var aModificar = document.createElement('a');
	       var linkTextM = document.createTextNode('  [Modificar]');
	       
	       aModificar.appendChild(linkTextM);
	       
	       aModificar.onclick = function() {
	           
	    	   $('#idHuecoMod').val(id);
	           $('#idEspacioHuecoMod').val(idEspacio);
	           $('#fechaEntradaHuecoMod').val(fechaEntrada);
	           $('#fechaSalidaHuecoMod').val(fechaSalida);
	           $('#formHuecoMod').show();
	       };
	       
           entry.id = id;
           entry.appendChild(document.createTextNode('(' + id + ') Espacio: ' + idEspacio + ' Entrada: ' + fechaEntrada + ' Salida: ' + fechaSalida));
           entry.appendChild(aBorrar);
           entry.appendChild(aModificar);
           
           $('#huecos').append(entry);
		}
            
            
		$(document).ready(function (){

            $('#crearHueco').click(function(){
                
            	var sendInfo = {
                    idEspacio: $('#idEspacioHueco').val(),
                    fechaEntrada: $('#fechaEntradaHueco').val(),
                    fechaSalida: $('#fechaSalidaHueco').val()
                };
                
                $.ajax({
                    url: 'rest/hueco/alta',
                    headers: {
                        'Accept': 'application/json',
                        'Content-Type': 'application/json'
                    },
                    type: 'POST',
                    dataType: 'json',
                    success: function(result) {
                        
                    	console.log(result.hueco);
                        
                    	loadHueco(result.hueco.id, result.hueco.idEspacio, result.hueco.fechaEntrada, result.hueco.fechaSalida);

                        $('#fechaEntradaHueco').val('');
                        $('#fechaSalidaHueco').val('');
                        
                        // Si el hueco creado es del espacio que estamos viendo, recargamos
                        if (result.hueco.idEspacio === currentEspacioId) {
                            cargarHuecosEspacio(currentEspacioId, currentEspacioName);
                        }
                    },
                    error: function(jqXhr, textStatus, errorMessage){
                        errorMessage = jqXhr.responseText;
                        if (!errorMessage) 
                        	console.log('Error desconocido al dar de alta hueco. Estado: ' + textStatus);
                        
                        alert("Error al crear hueco: " + errorMessage);
                    },
                    data: JSON.stringify(sendInfo)
                });
                
                
                $('#modificarHueco').click(function(){

                    const sendInfo = {
                        idEspacio: $('#idEspacioHuecoMod').val(),
                        fechaEntrada: $('#fechaEntradaHuecoMod').val(),
                        fechaSalida: $('#fechaSalidaHuecoMod').val()
                    };

                    $.ajax({
                        url: 'rest/hueco/modificar/' + id, // Este endpoint aún no lo hemos creado en HuecoService
                        type: 'PUT',
                        headers: {
                            'Accept': 'application/json',
                            'Content-Type': 'application/json'
                        },
                        dataType: 'json',
                        success: function(result) {
                            alert('Hueco modificado correctamente');
                            
                            document.getElementById(id).remove();
                            
                            loadHueco(result.hueco.id, result.hueco.idEspacio, result.hueco.fechaEntrada, result.hueco.fechaSalida);
                            
                            $('#formHuecoMod').hide();
                            $('#idHuecoMod').val('');
                            $('#idEspacioHuecoMod').val('');
                            $('#fechaEntradaHuecoMod').val('');
                            $('#fechaSalidaHuecoMod').val('');
                            
                            // Si el hueco modificado pertenece al espacio que estamos viendo, recarga
                            if (result.hueco.idEspacio === currentEspacioId) {
                                cargarHuecosEspacio(currentEspacioId, currentEspacioName);
                            }
                        },
                        error: function(jqXhr, textStatus, errorMessage){
                            errorMessage = jqXhr.responseText;
                            if (!errorMessage) 
                            	console.log('Error desconocido al modificar hueco. Estado: ' + textStatus);
                            
                            alert("Error al modificar hueco: " + errorMessage);
                        },
                        data: JSON.stringify(sendInfo)
                    });
                });
            });
		})
		
	</script>
</head>
<body>

	<div>
		<h3>Registro de usuarios</h3>
		Username: <input type=text id='usernameUser'><br>
		Password: <input type=text id='passwdUser'><br>
		<button id='crearUsuario'>Registrar usuario</button>
	</div>
	
	<div id='formUserMod' style='display: none'>
		<h3>Modificar usuario</h3>
		<input type=hidden id='idUserMod'>
		Nuevo username: <input type=text id='usernameUserMod'><br>
		Password: <input type=text id='passwdUserMod'><br>
		<button id='modificarUsuario'>Modificar usuario</button>
	</div>

	<div>
		<h3>Registro de espacios</h3>
		Introduzca nombre del espacio a añadir: <input type=text id='nombreEsp'>
		<button id='crearEspacio'>Registrar espacio</button>
	</div>
	
	<div id='formEspMod' style='display: none'>
		<h3>Modificar espacio</h3>
		<input type=hidden id='idEspMod'>
		Nuevo nombre espacio <input type=text id='nombreEspMod'>
		<button id='modificarEspacio'>Modificar espacio</button>
	</div>

	<div id="formCrearHueco" style="display: none">
		<h3>Añadir Hueco al Espacio Actual</h3>
		<input type="hidden" id="idEspacioHueco"> Fecha/Hora Entrada:
		<input type="datetime-local" id="fechaEntradaHueco"><br>
		Fecha/Hora Salida: <input type="datetime-local" id="fechaSalidaHueco"><br>
		<button id="crearHueco">Añadir Hueco</button>
	</div>

	<div id="formHuecoMod" style="display: none; margin-top: 20px;">
		<h3>Modificar Hueco</h3>
		<input type="hidden" id="idHuecoMod"> <input type="hidden"
			id="idEspacioHuecoMod"> Nueva Fecha/Hora Entrada: <input
			type="datetime-local" id="fechaEntradaHuecoMod"><br>
		Nueva Fecha/Hora Salida: <input type="datetime-local"
			id="fechaSalidaHuecoMod"><br>
		<button id="modificarHueco">Modificar Hueco</button>
	</div>


	<h3>Listado usuarios</h3>
	<ul id='usuarios'></ul>
	
	<br>
	
	<h3>Listado espacios</h3>
	<ul id='espacios'></ul>
	
	

</body>
</html>