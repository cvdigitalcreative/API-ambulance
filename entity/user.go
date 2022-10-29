package entity

type Users struct {
	ID       string `json:"p_id_user"`
	Username string `json:"p_username"`
	ID_level string `json:"p_id_user_level"`
	Status   string `json:"p_status"`
}

type Input struct {
	Input_Username string `json:"username`
	Input_Password string `json:"password"`
}

type U map[string]interface{}
