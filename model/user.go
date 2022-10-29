package model

import (
	"E-Ambulance/entity"
	"database/sql"
)

func Login(db *sql.DB, data entity.Input) ([]entity.Users, error) {

	insertStmt := "select * from login($1, $2)"
	rows, err := db.Query(insertStmt,
		data.Input_Username,
		data.Input_Password)
	// Exit jika terjadi error
	if err != nil {
		return []entity.Users{}, err
	}
	defer rows.Close()

	hasil := []entity.Users{}

	for rows.Next() {
		users_data := entity.Users{}

		error2 := rows.Scan(&users_data.ID, &users_data.Username, &users_data.ID_level, &users_data.Status)

		if error2 != nil {
			return []entity.Users{}, err
		}
		hasil = append(hasil, users_data)
	}

	return hasil, err
}
