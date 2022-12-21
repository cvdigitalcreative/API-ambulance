package entity

type Transaksi struct {
	ID_Status_Transaksi string `json:"p_id_status_transaksi"`
	ID_Transaksi        string `json:"p_id_transaksi"`
	ID_Supir            string `json:"param_id_supir"`
	Status_Transaksi    string `json:"param_status_transaksi"`
}

type DataTransaksi struct {
	ID_Transaksi        string `json:"p_id_transaksi"`
	Nomor_Invoice       string `json:"p_nomor_invoice"`
	Nomor_Registrasi    string `json:"p_nomor_registrasi"`
	Nomor_Surat_Tugas   string `json:"p_nomor_surat_tugas"`
	Link_Tracking       string `json:"p_link_tracking"`
	Alamat              string `json:"p_alamat"`
	Jarak               string `json:"p_jarak"`
	Latitude            string `json:"p_latitude_tujuan"`
	Longitude           string `json:"p_longitude_tujuan"`
	Tanggal             string `json:"p_tanggal_transaksi"`
	Foto                string `json:"p_foto_maps"`
	ID_Supir_Detail_1   string `json:"p_id_supir_detail"`
	ID_Supir_Detail_2   string `json:"p_id_supir_detail_2"`
	ID_Status_Transaksi string `json:"p_id_status_transaksi"`
	ID_Ambulance        string `json:"p_id_ambulance"`
	ID_Wilayah          string `json:"p_id_wilayah"`
	ID_Nakes            string `json:"p_id_user_nakes"`
	ID_Pasien_Detail    string `json:"p_id_pasien_detail"`
	ID_Pembayaran       string `json:"p_id_pembayaran"`
	Tarif               string `json:"p_tarif_pembayaran"`
	Nama                string `json:"p_nama_lengkap"`
	Jenis_Kelamin       string `json:"p_jenis_kelamin"`
	Nama_Ruangan        string `json:"p_nama_ruangan_medik"`
	Nomor_Rekam_Medik   string `json:"p_nomor_rekam_medik"`
	Nomor_Kamar         string `json:"p_nomor_kamar"`
	Golongan_Pasien     string `json:"p_golongan_pasien"`
	Nomor_Telepon       string `json:"p_nomor_telepon"`
	Tarif_Supir         string `json:"p_tarif_supir"`
	Nama_Supir          string `json:"p_nama_supir"`
}

type T map[string]interface{}
