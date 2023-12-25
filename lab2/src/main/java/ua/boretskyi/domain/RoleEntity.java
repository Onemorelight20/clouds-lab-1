package ua.boretskyi.domain;

import javax.persistence.*;
import java.util.Objects;

@Entity
@Table(name = "role")
public class RoleEntity {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;

	private String title;


	public RoleEntity() {}

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}



	@Override
	public String toString() {
		return "Role [id=" + id + ", title=" + title + "]";
	}

	@Override
	public boolean equals(Object o) {
		if (this == o) return true;
		if (o == null || getClass() != o.getClass()) return false;
		RoleEntity role = (RoleEntity) o;
		return Objects.equals(id, role.id) && Objects.equals(title, role.title) ;
	}

	@Override
	public int hashCode() {
		return Objects.hash(id, title);
	}
}
