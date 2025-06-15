<%@ page language='java' contentType='text/html; charset=UTF-8'
    pageEncoding='UTF-8'%>
<!DOCTYPE html>
<html>
<head>
<meta charset='UTF-8'>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Home JSP</title>
	<script type='text/javascript' src='https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js'></script>
	
	<script type='text/javascript'>

		function displayMessage(message, isError = false) {
			
			const messageDiv = document.getElementById('messageDisplay');
			
			messageDiv.textContent = message;
			messageDiv.style.color = isError ? 'red' : 'green';
            messageDiv.style.fontWeight = 'bold';
            
            setTimeout(() => {
                messageDiv.textContent = '';
                messageDiv.style.color = 'initial';
                messageDiv.style.fontWeight = 'normal';
            }, 5000);
		}

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
                       
						displayMessage('Espacio borrado correctamente.');
					},
			    	error: function(jqXhr, textStatus, errorMessage){
						errorMessage = jqXhr.responseText;
						
						if (!errorMessage)
				    		console.error('Error desconocido al borrar espacio. Estado: ' + textStatus);
						
						displayMessage("Error al borrar espacio: " + errorMessage, true);
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

            var aVerHuecos = document.createElement('a');
            var linkTextV = document.createTextNode('  [Ver Huecos]');
            aVerHuecos.appendChild(linkTextV);
            aVerHuecos.onclick = function() {
                cargarHuecoEspacio(id, name);
            };
			
			entry.id = id;
			
			entry.appendChild(document.createTextNode('(' + id + ') ' + name));
			
			entry.appendChild(aBorrar);
			entry.appendChild(aModificar);
            entry.appendChild(aVerHuecos);
			
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
                        
	                    displayMessage('Espacio creado correctamente.');
	                },
			    	error: function(jqXhr, textStatus, errorMessage){
						errorMessage = jqXhr.responseText;
						
						if (!errorMessage)
				    		console.error('Error desconocido al dar de alta espacio. Estado: ' + textStatus);
						
						displayMessage("Error al crear espacio: " + errorMessage, true);
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
	                    displayMessage('Espacio modificado correctamente.');
	                    
	                    document.getElementById(id).remove(); 
	                    
	                    loadEspacio(result.espacio.id, result.espacio.name);
	                    
	                    $('#formEspMod').hide();
	              		
	                    $('#idEspMod').val('');
	                    $('#nombreEspMod').val('');
	                },
			    	error: function(jqXhr, textStatus, errorMessage){
						errorMessage = jqXhr.responseText;
						
						if (!errorMessage)
				    		console.error('Error desconocido al modificar espacio. Estado: ' + textStatus);
						
						displayMessage("Error al modificar espacio: " + errorMessage, true);
			    	},
	                data: JSON.stringify(sendInfo)
	            });
	        });
			
			$.ajax({
				url: 'rest/espacio/todos',	
				type: 'GET',
				dataType: 'json',
				success: function(result) {
                    if (result.espacios) {
                        jQuery.each(result.espacios, function(i, val){
                            loadEspacio(val.id, val.name);
                        });
                    } else {
                        console.log('No spaces found or result.espacios is undefined.');
                    }
				}
				/*
                error: function(jqXhr, textStatus, errorMessage){
                    console.error('Error al cargar todos los espacios: ' + textStatus, errorMessage);
                    displayMessage("Error al cargar espacios: " + (jqXhr.responseText || errorMessage), true);
                }
				*/
			});
		});
		
		
		// -------- PARA HUECOS --------
		var currentEspacioId = null; 
		var currentEspacioName = null;
		
		function cargarHuecoEspacio(idEspacio, nombreEspacio) {
			
			currentEspacioId = idEspacio;
			currentEspacioName = nombreEspacio;
			
			$('#huecos').empty();
			$('#tituloHuecos').text('Listado de huecos para ' + nombreEspacio + ' (ID: ' + idEspacio + ')');
			
			$('#formCrearHueco').show();
			$('#idEspacioHueco').val(idEspacio);
            $('#huecosSection').show();
            
            $('#formHuecoMod').hide();

			$.ajax({
				url: 'rest/hueco/espacio/' + idEspacio,
				type: 'GET',
				dataType: 'json',
                success: function(result) {
                    $('#huecos').empty();
                    
                    if (result.huecos && result.huecos.length > 0) { 
                        jQuery.each(result.huecos, function(i, val) {
                            
                        	const fechaEntrada = val.fechaEntrada || '';
                        	const fechaSalida = val.fechaSalida || '';
                            
                            
                            loadHueco(val.id, val.idEspacio, fechaEntrada, fechaSalida);
                        });
                    } else {
                        $('#huecos').append('<li>No hay huecos registrados para este espacio.</li>');
                    }
                },
		    	error: function(jqXhr, textStatus, errorMessage){
					errorMessage = jqXhr.responseText;
					
					if (!errorMessage)
			    		console.error('Error desconocido al cargar huecos. Estado: ' + textStatus);
					
					displayMessage("Error al cargar huecos: " + errorMessage, true);
		    	}
				
			});
		}	
		
		
        function loadHueco(id, idEspacio, fechaEntrada, fechaSalida) {
            var entry = document.createElement('li');
            var aBorrar = document.createElement('a');
            
            var linkTextB = document.createTextNode('  [Borrar]');
            
            aBorrar.appendChild(linkTextB);
            
            aBorrar.onclick = function() {
                
            	$.ajax({
                    url: 'rest/hueco/borrar/' + id,
                    type: 'DELETE',
                    dataType: 'json',
                    success: function(result) {
                        document.getElementById(id).remove();
                        displayMessage('Hueco borrado correctamente.');
                        
                        if (currentEspacioId) {
                            cargarHuecoEspacio(currentEspacioId, currentEspacioName);
                        }
                    },
			    	error: function(jqXhr, textStatus, errorMessage){
						errorMessage = jqXhr.responseText;
						
						if (!errorMessage)
				    		console.error('Error desconocido al borrar hueco. Estado: ' + textStatus);
						
						displayMessage("Error al borrar hueco: " + errorMessage, true);
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
           const entradaFormatted = fechaEntrada.replace('T', ' / ');
           const salidaFormatted = fechaSalida.replace('T', ' / ');
           entry.appendChild(document.createTextNode('(' + id + ') Espacio: ' + idEspacio + ' Entrada: ' + entradaFormatted + ' Salida: ' + salidaFormatted));
 
           entry.appendChild(aBorrar);
           entry.appendChild(aModificar);
           
           $('#huecos').append(entry);
		}
            
            
		$(document).ready(function (){

            $('#crearHueco').click(function(){

            	var fechaEntrada = $('#fechaEntradaHueco').val().replace(" ", "T");
            	var fechaSalida = $('#fechaSalidaHueco').val().replace(" ", "T");
                
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
                        
                        displayMessage('Hueco creado correctamente.');
                        
                        if (result.hueco.idEspacio === currentEspacioId) {
                            cargarHuecoEspacio(currentEspacioId, currentEspacioName);
                        }
                        
                        $('#fechaEntradaHueco').val('');
                        $('#fechaSalidaHueco').val('');
                    },
                    error: function(jqXhr, textStatus, errorMessage){
                        errorMessage = jqXhr.responseText;
                        if (!errorMessage) 
                        	console.error('Error desconocido al dar de alta hueco. Estado: ' + textStatus);
                        
                        displayMessage("Error al crear hueco: " + errorMessage, true);
                    },
                    data: JSON.stringify(sendInfo)
                });
            });
            
            
            $('#modificarHueco').click(function(){

            	const id = $('#idHuecoMod').val();

                const sendInfo = {
                    idEspacio: $('#idEspacioHuecoMod').val(),
                    fechaEntrada: $('#fechaEntradaHuecoMod').val(),
                    fechaSalida: $('#fechaSalidaHuecoMod').val()
                };

                $.ajax({
                    url: 'rest/hueco/modificar/' + id,
                    type: 'PUT',
                    headers: {
                        'Accept': 'application/json',
                        'Content-Type': 'application/json'
                    },
                    dataType: 'json',
                    success: function(result) {
                        displayMessage('Hueco modificado correctamente.');
                                                
                        $('#formHuecoMod').hide();
                        $('#idHuecoMod').val('');
                        $('#idEspacioHuecoMod').val('');
                        $('#fechaEntradaHuecoMod').val('');
                        $('#fechaSalidaHuecoMod').val('');
                        
                        if (result.hueco.idEspacio === currentEspacioId) {
                            cargarHuecoEspacio(currentEspacioId, currentEspacioName);
                        }
                    },
                    error: function(jqXhr, textStatus, errorMessage){
                        errorMessage = jqXhr.responseText;
                        if (!errorMessage) 
                        	console.error('Error desconocido al modificar hueco. Estado: ' + textStatus);
                        
                        displayMessage("Error al modificar hueco: " + errorMessage, true);
                    },
                    data: JSON.stringify(sendInfo)
                });
            });
		})
		
	</script>
</head>
<body>
    <div id="messageDisplay" style="margin-bottom: 15px;"></div>

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

	<br>
	
	<h3>Listado espacios</h3>
	<ul id='espacios'></ul>
	
	<br>

    <div id="huecosSection" style="display: none;">
        <div id="formCrearHueco" style="margin-top: 20px;">
            <h3>Añadir Hueco al Espacio Actual</h3>
            <input type="hidden" id="idEspacioHueco">
            Fecha/Hora Entrada: <input type="datetime-local" id="fechaEntradaHueco"><br>
            Fecha/Hora Salida: <input type="datetime-local" id="fechaSalidaHueco"><br>
            <button id="crearHueco">Añadir Hueco</button>
        </div>

        <div id="formHuecoMod" style="display: none; margin-top: 20px;">
            <h3>Modificar Hueco</h3>
            <input type="hidden" id="idHuecoMod">
            <input type="hidden" id="idEspacioHuecoMod">
            Nueva Fecha/Hora Entrada: <input type="datetime-local" id="fechaEntradaHuecoMod"><br>
            Nueva Fecha/Hora Salida: <input type="datetime-local" id="fechaSalidaHuecoMod"><br>
            <button id="modificarHueco">Modificar Hueco</button>
        </div>

        <h3 id="tituloHuecos"></h3>
        <ul id='huecos'></ul>
    </div>

</body>
</html>
