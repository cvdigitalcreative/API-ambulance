package controller

import (
	"E-Ambulance/config"
	"E-Ambulance/entity"
	"E-Ambulance/model"
	"net/http"

	"github.com/labstack/echo"
)

func Login(ctx echo.Context) error {
	db := config.AccessDataBase()
	var user entity.Input

	user.Input_Username = ctx.FormValue("username")
	user.Input_Password = ctx.FormValue("password")

	hasil, err := model.Login(db, user)
	if err != nil {
		data := entity.U{"Data": hasil, "Message": err.Error(), "Status": 400}
		return ctx.JSON(http.StatusOK, data)
	} else {
		data := entity.U{"Data": hasil, "Message": "User Data Retrieved Successfully", "Status": 200}
		return ctx.JSON(http.StatusOK, data)
	}
}
