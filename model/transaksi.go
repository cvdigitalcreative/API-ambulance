package model

import (
	"E-Ambulance/entity"
	"database/sql"
)

func UpdateTransaksi(db *sql.DB, data entity.Transaksi) (bool, error) {

	updateTransaksi := "SELECT * FROM update_status_transaksi($1, $2)"

	_, err := db.Query(updateTransaksi,
		data.ID_Status_Transaksi,
		data.ID_Transaksi)
	// Exit jika terjadi error
	if err != nil {
		return false, err
	}

	return true, err
}
