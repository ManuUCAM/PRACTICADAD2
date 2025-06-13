package edu.ucam.services;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.Hashtable;

import org.json.JSONObject;

import edu.ucam.entity.User;
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

@Path("/user")
public class UserService {

	public static Hashtable<Integer, User> tablaUsuarios = new Hashtable<>();
	public static int siguienteID = 1;
	
	@GET
	@Path("/todos")
	@Produces(MediaType.APPLICATION_JSON)
	public Response getTodosUsuarios() {
		
		JSONObject jsonRespuesta = new JSONObject();
	
		for (User u : tablaUsuarios.values()) {
			JSONObject json = new JSONObject();
			json.put("id", u.getId());
			json.put("username", u.getUsername());
			json.put("passwd", u.getPasswd());
			
			jsonRespuesta.append("users", json);
		}

		return Response.status(200).entity(jsonRespuesta.toString()).build();
		
	}
	
	@POST
	@Path("/alta")
	@Consumes(MediaType.APPLICATION_JSON)
	@Produces(MediaType.APPLICATION_JSON)
	public Response crearUsuario(InputStream incomingData) {
		
		System.out.println("Registrar usuario");
		StringBuilder sb = new StringBuilder();
		
		try (BufferedReader in = new BufferedReader(new InputStreamReader(incomingData))){
			String line;
			
			while((line = in.readLine()) != null) 
				sb.append(line);
		}
		catch(Exception e) {
			return Response.status(400).entity("Error: json mal formado").build();
		}
		
		JSONObject json = new JSONObject(sb.toString());
		
		System.out.println(json.toString());
		
		if (!json.has("username") || !json.has("passwd")) {
			return Response.status(400).entity("Error: Username y contraseña son obligatorios").build();
		}
		
		String username = json.getString("username").trim();
		String passwd = json.getString("passwd").trim();
		
		if (username.isEmpty() || passwd.isEmpty()) {
			return Response.status(400).entity("Error: Username o contraseña no puede estar vacío").build();
		}
		
		for (User u : tablaUsuarios.values()) {
			if (u.getUsername().equalsIgnoreCase(username)) {
				return Response.status(400).entity("Error: Ya existe un usuario con ese nombre").build();
			}
		}
		
		User usuario = new User();
		usuario.setId(siguienteID);
		usuario.setUsername(json.getString("username"));
		usuario.setPasswd(json.getString("passwd"));
		
		tablaUsuarios.put(usuario.getId(), usuario);
		siguienteID++;
		
		JSONObject jsonUsuario = new JSONObject();
		jsonUsuario.put("id", usuario.getId());
		jsonUsuario.put("username", usuario.getUsername());
		jsonUsuario.put("passwd", usuario.getPasswd());
		
		JSONObject respuesta = new JSONObject();
		respuesta.put("user", jsonUsuario);
		
		
		System.out.println(respuesta.toString());
		
		return Response.status(201).entity(respuesta.toString()).build();
	}
	
	
	@PUT
	@Path("/modificar/{id}")
	@Consumes(MediaType.APPLICATION_JSON)
	@Produces(MediaType.APPLICATION_JSON)
	public Response modificarUsuario(@PathParam("id") int id, InputStream incomingData) {
		
		System.out.println("Modificar usuario");
		StringBuilder sb = new StringBuilder();
		
		try (BufferedReader in = new BufferedReader(new InputStreamReader(incomingData))){
			String line;
			
			while((line = in.readLine()) != null) 
				sb.append(line);
		}
		catch(Exception e) {
			return Response.status(400).entity("Error: json mal formado").build();
		}
		
		JSONObject json = new JSONObject(sb.toString());
		
		System.out.println(json.toString());
		
		User usuarioEncontrado = tablaUsuarios.get(id);
		
		if (usuarioEncontrado == null)
			return Response.status(404).entity("Error: Usuario no encontrado").build();
		
		if (!json.has("username") || !json.has("passwd")) {
			return Response.status(400).entity("Error: Username y contraseña son obligatorios").build();
		}
		
		String username = json.getString("username").trim();
		String passwd = json.getString("passwd").trim();
		
		if (username.isEmpty() || passwd.isEmpty()) {
			return Response.status(400).entity("Error: Username o contraseña no puede estar vacío").build();
		}
		
		User usuario = new User();
		usuario.setId(siguienteID);
		usuario.setUsername(json.getString("username"));
		usuario.setPasswd(json.getString("passwd"));
		
		tablaUsuarios.put(usuario.getId(), usuario);
		
		JSONObject jsonUsuario = new JSONObject();
		jsonUsuario.put("id", usuario.getId());
		jsonUsuario.put("username", usuario.getUsername());
		jsonUsuario.put("passwd", usuario.getPasswd());
		
		JSONObject respuesta = new JSONObject();
		respuesta.put("user", jsonUsuario);
		
		System.out.println(respuesta.toString());
		
		return Response.status(201).entity(respuesta.toString()).build();
	}
	
	
	@DELETE
	@Path("/borrar/{id}")
	@Produces(MediaType.APPLICATION_JSON)
	public Response borrarUsuario(@PathParam("id") int id) {
		System.out.println("Borrar usuario");
		
		User usuarioEncontrado = tablaUsuarios.get(id);
		
		if (usuarioEncontrado == null)
			return Response.status(404).entity("Usuario no encontrado").build(); 
		
		tablaUsuarios.remove(id, usuarioEncontrado);
		
		return Response.status(201).entity(true).build();
	}
	
}
