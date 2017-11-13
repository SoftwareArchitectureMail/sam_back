package models

type ErrorResponse struct {
	Message string `json:"message"`
	ErrType string `json:"error"`
}
