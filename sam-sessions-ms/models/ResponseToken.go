package models

type ResponseToken struct {
	Token string `json:"token"`
	RefToken string `json:"refresh"`
}
