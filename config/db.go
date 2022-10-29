package config

import (
	"database/sql"
	"fmt"
	"os"

	_ "github.com/lib/pq"
)

const (
	DBHost     = "DB_HOST"
	DBPort     = "DB_PORT"
	DBName     = "DB_NAME"
	DBUser     = "DB_USER"
	DBPassword = "DB_PASSWORD"
)

func AccessDataBase() *sql.DB {
	host := os.Getenv(DBHost)
	port := os.Getenv(DBPort)
	user := os.Getenv(DBUser)
	password := os.Getenv(DBPassword)
	dbname := os.Getenv(DBName)
	psqlcom := fmt.Sprintf("host=%s port=%s user=%s password=%s dbname=%s sslmode=disable", host, port, user, password, dbname)

	db, err := sql.Open("postgres", psqlcom)

	if err != nil {
		panic(err)
	}

	return db
}
