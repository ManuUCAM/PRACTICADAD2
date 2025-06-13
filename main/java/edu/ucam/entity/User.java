package edu.ucam.entity;

public class User {
	
	private int id;
	private String username;
	private String passwd;
	private boolean isAdmin;
	
	public User() {
		
	}

	public User(int id, String username, String passwd, boolean isAdmin) {
		super();
		this.id = id;
		this.username = username;
		this.passwd = passwd;
		this.isAdmin = isAdmin;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPasswd() {
		return passwd;
	}

	public void setPasswd(String passwd) {
		this.passwd = passwd;
	}

	public boolean isAdmin() {
		return isAdmin;
	}

	public void setAdmin(boolean isAdmin) {
		this.isAdmin = isAdmin;
	}
}
