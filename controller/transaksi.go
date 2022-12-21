package controller

import (
	"E-Ambulance/config"
	"E-Ambulance/entity"
	"E-Ambulance/model"
	"net/http"

	"github.com/labstack/echo"
)

func UpdateTransaksi(ctx echo.Context) error {
	db := config.AccessDataBase()

	var transaksi entity.Transaksi

	transaksi.ID_Status_Transaksi = ctx.Param("id_status_transaksi")
	transaksi.ID_Transaksi = ctx.Param("id_transaksi")

	_, err := model.UpdateTransaksi(db, transaksi)

	if err != nil {
		data := entity.T{
			"Message": err.Error(),
			"Status":  400}
		return ctx.JSON(http.StatusOK, data)
	} else {
		data := entity.T{
			"Message": "Status Transaksi Updated Successfully",
			"Status":  200}
		return ctx.JSON(http.StatusOK, data)
	}
}

func ReadTransaksi(ctx echo.Context) error {
	db := config.AccessDataBase()

	var transaksi entity.Transaksi

	transaksi.ID_Supir = ctx.Param("id_supir")
	transaksi.Status_Transaksi = ctx.Param("id_status_transaksi")

	result, err := model.ReadTransaksi(db, transaksi)

	if err != nil {
		data := entity.U{"Data": result, "Message": err.Error(), "Status": 400}
		return ctx.JSON(http.StatusOK, data)
	} else {
		data := entity.U{"Data": result, "Message": "Data Transaksi Retrieved Successfully", "Status": 200}
		return ctx.JSON(http.StatusOK, data)
	}
}
