package edu.ucam.entity;

public class Espacio {
	
	private String id;
	private String name;
	
	public Espacio() {
		
	}

	public Espacio(String id, String name) {
		super();
		this.id = id;
		this.name = name;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}
	
	
	

}
