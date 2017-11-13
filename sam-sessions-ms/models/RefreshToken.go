package models

import (
	"time"
)

type RefreshToken struct {
	ID        	string	`gorm:"primary_key" json:"-"`
	TokenID		string	`gorm:"not null;unique;index" json:"-"`
	Username	string  `gorm:"not null;index" json:"username"`
	ExpDate		time.Time	`json:"-"`
	CreatedAt 	*time.Time	`json:"-"`
	UpdatedAt 	*time.Time	`json:"-"`
}