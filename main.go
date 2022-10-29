package main

import (
	"E-Ambulance/config"
	"E-Ambulance/controller"
	"os"

	"github.com/labstack/echo"
)

const (
	hostDB     = "localhost"
	userDB     = "postgres"
	passwordDB = "kresnavw210101"
	portDB     = "5432"
	nameDB     = "e_ambulance"
)

func main() {
	k := echo.New()

	os.Setenv(config.DBHost, hostDB)
	os.Setenv(config.DBPort, portDB)
	os.Setenv(config.DBName, nameDB)
	os.Setenv(config.DBUser, userDB)
	os.Setenv(config.DBPassword, passwordDB)

	// EndPoint Login
	k.POST("/login/", controller.Login)

	k.Start(":8080")
}
