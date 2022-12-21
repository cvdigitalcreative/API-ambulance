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

func ReadTransaksi(db *sql.DB, data entity.Transaksi) ([]entity.DataTransaksi, error) {

	readSQL := "SELECT * FROM read_all_transaksi_supir_by_id_and_status_transaksi($1, $2)"
	rows, err := db.Query(readSQL,
		data.ID_Supir,
		data.Status_Transaksi)

	if err != nil {
		return []entity.DataTransaksi{}, err
	}

	defer rows.Close()

	hasil := []entity.DataTransaksi{}

	for rows.Next() {
		transaksi_data := entity.DataTransaksi{}

		error2 := rows.Scan(
			&transaksi_data.ID_Transaksi,
			&transaksi_data.Nomor_Invoice,
			&transaksi_data.Nomor_Registrasi,
			&transaksi_data.Nomor_Surat_Tugas,
			&transaksi_data.Link_Tracking,
			&transaksi_data.Alamat,
			&transaksi_data.Jarak,
			&transaksi_data.Latitude,
			&transaksi_data.Longitude,
			&transaksi_data.Tanggal,
			&transaksi_data.Foto,
			&transaksi_data.ID_Supir_Detail_1,
			&transaksi_data.ID_Supir_Detail_2,
			&transaksi_data.ID_Status_Transaksi,
			&transaksi_data.ID_Ambulance,
			&transaksi_data.ID_Wilayah,
			&transaksi_data.ID_Nakes,
			&transaksi_data.ID_Pasien_Detail,
			&transaksi_data.ID_Pembayaran,
			&transaksi_data.Tarif,
			&transaksi_data.Nama,
			&transaksi_data.Jenis_Kelamin,
			&transaksi_data.Nama_Ruangan,
			&transaksi_data.Nomor_Rekam_Medik,
			&transaksi_data.Nomor_Kamar,
			&transaksi_data.Golongan_Pasien,
			&transaksi_data.Nomor_Telepon,
			&transaksi_data.Tarif_Supir,
			&transaksi_data.Nama_Supir)

		if error2 != nil {
			return []entity.DataTransaksi{}, err
		}
		hasil = append(hasil, transaksi_data)
	}

	return hasil, err
}
