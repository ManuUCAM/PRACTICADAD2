package edu.ucam.entity;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import jakarta.json.bind.annotation.JsonbDateFormat;

public class Hueco {
	
	private String id;
	private String idEspacio;
	
	//formateo para comunicacion entre front y back
	@JsonbDateFormat("yyyy-MM-dd'T'HH:mm")
	private LocalDateTime fechaEntrada;
	@JsonbDateFormat("yyyy-MM-dd'T'HH:mm")
	private LocalDateTime fechaSalida;
	
	public Hueco() {
		
	}

	public Hueco(String id, String idEspacio, LocalDateTime fechaEntrada, LocalDateTime fechaSalida) {
		super();
		this.id = id;
		this.idEspacio = idEspacio;
		this.fechaEntrada = fechaEntrada;
		this.fechaSalida = fechaSalida;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getIdEspacio() {
		return idEspacio;
	}

	public void setIdEspacio(String idEspacio) {
		this.idEspacio = idEspacio;
	}

	public LocalDateTime getFechaEntrada() {
		return fechaEntrada;
	}

	public void setFechaEntrada(LocalDateTime fechaEntrada) {
		this.fechaEntrada = fechaEntrada;
	}

	public LocalDateTime getFechaSalida() {
		return fechaSalida;
	}

	public void setFechaSalida(LocalDateTime fechaSalida) {
		this.fechaSalida = fechaSalida;
	}

	@Override
	public String toString() {
		
		DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
		
		String formattedEntrada = (fechaEntrada != null) ? fechaEntrada.format(dateFormatter) : "N/A";
		String formattedSalida = (fechaSalida != null) ? fechaSalida.format(dateFormatter) : "N/A";
		
		return "Hueco [id=" + id + ", idEspacio=" + idEspacio + ", fechaEntrada=" + formattedEntrada + ", fechaSalida="
				+ formattedSalida + "]";
	}
}
