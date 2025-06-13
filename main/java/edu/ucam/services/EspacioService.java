package edu.ucam.services;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.Hashtable;

import org.json.JSONObject;

import edu.ucam.entity.Espacio;
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

@Path("/espacio")
public class EspacioService {

	public static Hashtable<String, Espacio> tablaEspacios = new Hashtable<String, Espacio>();
	public static int siguienteID = 1;

	@GET
	@Path("/todos")
	@Produces(MediaType.APPLICATION_JSON)
	public Response getTodosEspacios() {
		
		System.out.println("GET ESPACIOS");

		JSONObject jsonRespuesta = new JSONObject();

		for (Espacio esp : tablaEspacios.values()) {
			JSONObject json = new JSONObject();
			json.put("id", esp.getId());
			json.put("name", esp.getName());

			jsonRespuesta.append("espacios", json);
		}

		return Response.status(200).entity(jsonRespuesta.toString()).build();
	}

	@POST
	@Path("/alta")
	@Produces(MediaType.APPLICATION_JSON)
	@Consumes(MediaType.APPLICATION_JSON)
	public Response crearEspacio(InputStream incomingData) {
		
		System.out.println("Registrar espacio");
		StringBuilder sb = new StringBuilder();
		
		try (BufferedReader in = new BufferedReader(new InputStreamReader(incomingData))){
			String line;
			
			while((line = in.readLine()) != null)
				sb.append(line);
		}
		catch(Exception e) {
			return Response.status(400).entity("JSON mal formado").build();
			
		}
		
		JSONObject json = new JSONObject(sb.toString());
		
		System.out.println(json.toString());
		
		if (!json.has("name")) {
			return Response.status(400).entity("Nombre obligatorio").build();
		}
		
		String name = json.getString("name").trim();
		
		if (name.isEmpty()) {
			return Response.status(400).entity("Nombre no puede estar vacío").build();
		}
			
		Espacio esp = new Espacio();
		esp.setId("ESP" + siguienteID);
		esp.setName(name);
		
		tablaEspacios.put(esp.getId(), esp);
		siguienteID++;
		
		JSONObject jsonEsp = new JSONObject();
		jsonEsp.put("id", esp.getId());
		jsonEsp.put("name", esp.getName());
		
		JSONObject respuesta = new JSONObject();
		respuesta.put("espacio", jsonEsp);
		
		System.out.println(respuesta.toString());
		
		return Response.status(201).entity(respuesta.toString()).build();
	}
	
	
	@PUT
	@Path("/modificar/{id}") 
	@Consumes(MediaType.APPLICATION_JSON)
	@Produces(MediaType.APPLICATION_JSON)
	public Response modificarEspacio(@PathParam("id") String id, InputStream incomingData) {
		
		System.out.println("Modificar espacio");

		StringBuilder sb = new StringBuilder();
		
		try (BufferedReader in = new BufferedReader(new InputStreamReader(incomingData))){
			String line;
			while((line = in.readLine()) != null)
				sb.append(line);
		}
		catch(Exception e) {
			return Response.status(400).entity("JSON mal formado").build();
		}
		
		JSONObject json = new JSONObject(sb.toString());
			
		System.out.println(json.toString());
		
		Espacio espacioEncontrado = tablaEspacios.get(id);
		
		if (espacioEncontrado == null) {
			return Response.status(404).entity("Espacio no encontrado").build();
		}
		
		
		if (!json.has("name")) {
			return Response.status(400).entity("Nombre obligatorio").build();
		}
		
		String name = json.getString("name").trim();
		
		if (name.isEmpty()) {
			return Response.status(400).entity("Nombre no puede estar vacío").build();
		}
		
		espacioEncontrado.setName(name);
		
		JSONObject jsonEspacio = new JSONObject();
		jsonEspacio.put("id", espacioEncontrado.getId());
		jsonEspacio.put("name", espacioEncontrado.getName());
		
		JSONObject respuesta = new JSONObject();
		respuesta.put("espacio", jsonEspacio);
		
		System.out.println(respuesta.toString());
		
		return Response.status(200).entity(respuesta.toString()).build(); 
	}
	
	
	@DELETE
	@Path("/borrar/{id}")
	@Produces(MediaType.APPLICATION_JSON)
	public Response borrarEspacio(@PathParam("id") String id){
		System.out.println("Borrar espacio");
		
		Espacio espacioEncontrado = tablaEspacios.get(id);
		
		if (espacioEncontrado == null)
			return Response.status(404).entity("Espacio no encontrado").build();
		
		tablaEspacios.remove(id, espacioEncontrado);
		
		return Response.status(201).entity(true).build();
	}
}
