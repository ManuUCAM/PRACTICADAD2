package edu.ucam.services;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.time.DateTimeException;
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;
import java.util.Hashtable;

import org.json.JSONObject;

import edu.ucam.entity.Espacio;
import edu.ucam.entity.Hueco;
import jakarta.ws.rs.Consumes;
import jakarta.ws.rs.DELETE;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.POST;
import jakarta.ws.rs.PUT;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.PathParam;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

@Path("/")
public class HuecoService {

	public static Hashtable<String, Hueco> tablaHuecos = new Hashtable<String, Hueco>();
	public static int siguienteID = 1;
	
	@POST
	@Path("/hueco/alta")
	@Produces(MediaType.APPLICATION_JSON)
	@Consumes(MediaType.APPLICATION_JSON)
	public Response crearHueco(InputStream incomingData) {
		
		System.out.println("Registrar hueco");
		
		StringBuilder sb = new StringBuilder();
		
		try (BufferedReader in = new BufferedReader(new InputStreamReader(incomingData))) {
			
			String line;
			
			while ((line = in.readLine()) != null)
				sb.append(line);
		
		}
		catch (Exception e) {
			return Response.status(400).entity("JSON mal formado").build();
		}
		
		JSONObject json = new JSONObject(sb.toString());
		
		if (!json.has("idEspacio") || !json.has("fechaEntrada") || !json.has("fechaSalida")) {
			return Response.status(400).entity("idEspacio, fechaEntrada y fechaSalida son obligatorios").build();
		}
		
		String idEspacio = json.getString("idEspacio").trim();
		String fechaEntradaStr = json.getString("fechaEntrada").trim();
		String fechaSalidaStr = json.getString("fechaSalida").trim();
		
		// Validar que espacio exista
		if (!EspacioService.tablaEspacios.containsKey(idEspacio))
			return Response.status(404).entity("El espacio no existe").build();
		
		LocalDateTime fechaEntrada;
		LocalDateTime fechaSalida;
		
		try {
			fechaEntrada = LocalDateTime.parse(fechaEntradaStr);
			fechaSalida = LocalDateTime.parse(fechaSalidaStr);
		}
		catch (DateTimeParseException e) {
			return Response.status(400).entity("Formato de fecha incorrecto. (YYYY-MM-DDTHH:mm)").build();
		}
		
		//Validar fecha de entrada sea anterior a salida
		if (fechaEntrada.isAfter(fechaSalida) || fechaEntrada.isEqual(fechaSalida))
			return Response.status(400).entity("La fecha de entrada debe ser anterior a la fecha de salida.").build();
				
		String huecoId = "HUE" + siguienteID;

		Hueco hueco = new Hueco(huecoId, idEspacio, fechaEntrada, fechaSalida);
		
		tablaHuecos.put(hueco.getId(), hueco);
		siguienteID++;
		
		JSONObject jsonHueco = new JSONObject();
		jsonHueco.put("id", hueco.getId());
		jsonHueco.put("idEspacio", hueco.getIdEspacio());
		jsonHueco.put("fechaEntrada", hueco.getFechaEntrada().toString());
		jsonHueco.put("fechaSalida", hueco.getFechaSalida().toString());
		
		JSONObject respuesta = new JSONObject();
		respuesta.put("hueco", jsonHueco);
		
		System.out.println(respuesta.toString());
		
		return Response.status(201).entity(respuesta.toString()).build();
	}
	
	
	@PUT
    @Path("/hueco/modificar/{id}")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response modificarHueco(@PathParam("id") String id, InputStream incomingData) {
        System.out.println("Modificar hueco: " + id);
        StringBuilder sb = new StringBuilder();

        // Leer el JSON de la entrada
        try (BufferedReader in = new BufferedReader(new InputStreamReader(incomingData))) {
            String line;
            while ((line = in.readLine()) != null)
                sb.append(line);
        } catch (Exception e) {
            return Response.status(400).entity("JSON mal formado").build();
        }

		JSONObject json = new JSONObject(sb.toString());
		
		Hueco huecoEncontrado = tablaHuecos.get(id);
		
		if (huecoEncontrado == null) 
			return Response.status(404).entity("Hueco no encontrado").build();
		
		if (!json.has("idEspacio") || !json.has("fechaEntrada") || !json.has("fechaSalida")) {
			return Response.status(400).entity("idEspacio, fechaEntrada y fechaSalida son obligatorios").build();
		}
		
		String idEspacio = json.getString("idEspacio").trim();
		String fechaEntradaStr = json.getString("fechaEntrada").trim();
		String fechaSalidaStr = json.getString("fechaSalida").trim();
		
		// Validar que espacio exista
		if (!EspacioService.tablaEspacios.containsKey(idEspacio))
			return Response.status(404).entity("El espacio no existe").build();
		
		LocalDateTime fechaEntrada;
		LocalDateTime fechaSalida;
		
		try {
			fechaEntrada = LocalDateTime.parse(fechaEntradaStr);
			fechaSalida = LocalDateTime.parse(fechaSalidaStr);
		}
		catch (DateTimeParseException e) {
			return Response.status(400).entity("Formato de fecha incorrecto. (YYYY-MM-DDTHH:mm)").build();
		}
		
		//Validar fecha de entrada sea anterior a salida
		if (fechaEntrada.isAfter(fechaSalida) || fechaEntrada.isEqual(fechaSalida))
			return Response.status(400).entity("La fecha de entrada debe ser anterior a la fecha de salida.").build();
		
		huecoEncontrado.setIdEspacio(idEspacio);
		huecoEncontrado.setFechaEntrada(fechaEntrada);
		huecoEncontrado.setFechaSalida(fechaSalida);
		
		JSONObject jsonHueco = new JSONObject();
		
		jsonHueco.put("id", huecoEncontrado.getId());
		jsonHueco.put("idEspacio", huecoEncontrado.getIdEspacio());
		jsonHueco.put("fechaEntrada", huecoEncontrado.getFechaEntrada().toString());
		jsonHueco.put("fechaSalida", huecoEncontrado.getFechaSalida().toString());
		
		JSONObject respuesta = new JSONObject();
		respuesta.put("hueco", jsonHueco);
		
		System.out.println(respuesta.toString());
		
		return Response.status(201).entity(respuesta.toString()).build();
        
	}
	
	@DELETE
	@Path("/hueco/borrar/{id}")
	@Produces(MediaType.APPLICATION_JSON)	
	public Response borrarHueco(@PathParam("id") String id) {
		System.out.println("Borrar Hueco");
		
		Hueco huecoEncontrado = tablaHuecos.remove(id);
		
		if (huecoEncontrado == null)
			return Response.status(404).entity("Hueco no encontrado").build();
		
		return Response.status(200).entity(true).build();
	}
	
	@GET
	@Path("/espacio/{idEspacio}/huecos")
	@Produces(MediaType.APPLICATION_JSON)
	public Response getHuecosDeEspacio(@PathParam("idEspacio") String idEspacio) {
		
		System.out.println("GET Huecos de espacio: " + idEspacio);
		
		if (!EspacioService.tablaEspacios.containsKey(idEspacio))
			return Response.status(404).entity("Espacio no encontrado").build();
		
		JSONObject jsonRespuesta = new JSONObject();
		
		for (Hueco hueco : tablaHuecos.values()) {
			if (hueco.getIdEspacio().equals(idEspacio)) {

				JSONObject jsonHueco = new JSONObject();
				
				jsonHueco.put("id", hueco.getId());
				jsonHueco.put("idEspacio", hueco.getIdEspacio());
				jsonHueco.put("fechaEntrada", hueco.getFechaEntrada());
				jsonHueco.put("fechaSalida", hueco.getFechaSalida());
				
				jsonRespuesta.append("huecos", jsonHueco);
			}
		}
		return Response.status(200).entity(jsonRespuesta.toString()).build();
	}
	
	@GET
	@Path("/hueco/todos")
	@Produces(MediaType.APPLICATION_JSON)
	public Response getHuecosTodos() {
		System.out.println("GET HUECOS");
		
		JSONObject jsonRespuesta = new JSONObject();
		
		for (Hueco hueco : tablaHuecos.values()) {
			JSONObject jsonHueco = new JSONObject();
			
			jsonHueco.put("id", hueco.getId());
			jsonHueco.put("idEspacio", hueco.getIdEspacio());
			jsonHueco.put("fechaEntrada", hueco.getFechaEntrada());
			jsonHueco.put("fechaSalida", hueco.getFechaSalida());
			
			jsonRespuesta.append("huecos", jsonHueco);
		}
		
		return Response.status(200).entity(jsonRespuesta.toString()).build();
	}
}
