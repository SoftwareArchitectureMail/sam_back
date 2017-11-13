package sessions

import "crypto/rsa"
import "io/ioutil"
import jwt "github.com/dgrijalva/jwt-go"
import "time"
import "net/http"
import "encoding/json"
import (
	"arquitectura/sam_sessions_ms/database"
	"arquitectura/sam_sessions_ms/models"
	"log"

	"github.com/dgrijalva/jwt-go/request"
	"github.com/julienschmidt/httprouter"
	"github.com/satori/go.uuid"
)

const TokenMaxTime = 5    //Minutes
const RefTokenMaxTime = 168 //Hours

const (
	refresh = "Refresh"
	auth    = "Authorization"
)

var (
	privateKey *rsa.PrivateKey
	publicKey  *rsa.PublicKey
)

func init() {
	privateBytes, err := ioutil.ReadFile("/go/src/arquitectura/sam_sessions_ms/rsa_keys/private.rsa")
	errorHandler(err)
	publicBytes, err := ioutil.ReadFile("/go/src/arquitectura/sam_sessions_ms/rsa_keys/public.rsa.pub")
	errorHandler(err)
	privateKey, err = jwt.ParseRSAPrivateKeyFromPEM(privateBytes)
	errorHandler(err)
	publicKey, err = jwt.ParseRSAPublicKeyFromPEM(publicBytes)
	errorHandler(err)
}

func errorHandler(err error) {
	if err != nil {
		log.Println(err.Error())
	}
}

func GetSessionToken(w http.ResponseWriter, r *http.Request, ps httprouter.Params) {
	username := ps.ByName("username")
	w = generateTokens(username, w)
}

func RefreshToken(w http.ResponseWriter, r *http.Request, ps httprouter.Params) {
	var token *jwt.Token
	var err error
	token, w, err = extractToken(w, r)
	if err == nil {
		var refToken models.RefreshToken
		database.DB.Where(&models.RefreshToken{ID: getTokClaim(token, "jti")}).First(&refToken)
		if token.Valid && refToken != (models.RefreshToken{}) {
			username := getTokClaim(token, "sub")
			w = generateTokens(username, w)
			database.DB.Delete(&refToken)
		} else {
			w.WriteHeader(http.StatusBadRequest)
		}
	}
}

func ValidateToken(w http.ResponseWriter, r *http.Request, ps httprouter.Params) {
	var token *jwt.Token
	var err error
	token, w, err = extractToken(w, r)
	if err == nil {
		if token.Valid && getTokClaim(token, "typ") == auth {
			w.WriteHeader(http.StatusOK)
		} else {
			w.WriteHeader(http.StatusForbidden)
		}
	}
}

func RevokeToken(w http.ResponseWriter, r *http.Request, ps httprouter.Params) {
	var token *jwt.Token
	var err error
	token, w, err = extractToken(w, r)
	if err == nil {
		if token.Valid && getTokClaim(token, "typ") == auth {
			database.DB.Delete(models.RefreshToken{}, "TokenID = ?", getTokClaim(token, "jti"))
			w.WriteHeader(http.StatusOK)
		} else {
			w.WriteHeader(http.StatusForbidden)
		}
	}
}

func RevokeAllTokens(w http.ResponseWriter, r *http.Request, ps httprouter.Params) {
	var token *jwt.Token
	var err error
	paramsUsername := ps.ByName("username")
	token, w, err = extractToken(w, r)
	if err == nil {
		if token.Valid && getTokClaim(token, "typ") == auth && getTokClaim(token, "sub") == paramsUsername {
			database.DB.Delete(models.RefreshToken{}, "username = ?", paramsUsername)
			w.WriteHeader(http.StatusOK)
		} else {
			w.WriteHeader(http.StatusForbidden)
		}
	}
}

func generateTokens(username string, w http.ResponseWriter) http.ResponseWriter {
	tokenUUID := uuid.NewV4()
	refTokenUUID := uuid.NewV4()

	token, err := generateJWT(username, tokenUUID)
	errorHandler(err)
	refToken, err1 := generateRefreshJWT(username, tokenUUID, refTokenUUID)
	errorHandler(err1)

	if err != nil || err1 != nil {
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusInternalServerError)
		json.Marshal(models.ErrorResponse{"Error while generating tokens", "500 Internal Server Error"})
	} else {
		tokens := models.ResponseToken{token, refToken}
		jsonResult, _ := json.Marshal(tokens)
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		w.Write(jsonResult)
	}

	return w
}

func generateJWT(username string, token_uuid uuid.UUID) (string, error) {
	// crear el token
	signer := jwt.New(jwt.SigningMethodRS256)

	claims := make(jwt.MapClaims)
	// definir los claims
	//claims["user_info"] = models.User{Username: username}
	claims["sub"] = username
	claims["jti"] = token_uuid
	claims["typ"] = auth
	claims["iss"] = "miniGmail"
	claims["exp"] = time.Now().Add(time.Minute * TokenMaxTime).Unix()
	signer.Claims = claims
	result, err := signer.SignedString(privateKey)

	return result, err
}

func generateRefreshJWT(username string, token_uuid uuid.UUID, refresh_uuid uuid.UUID) (string, error) {
	expTime := time.Now().Add(time.Hour * RefTokenMaxTime)
	// crear y guardar el refresh token en la base de datos
	refreshToken := models.RefreshToken{refresh_uuid.String(), token_uuid.String(), username, expTime, nil, nil}
	database.DB.Create(&refreshToken)
	// crear el token
	signer := jwt.New(jwt.SigningMethodRS256)
	claims := make(jwt.MapClaims)

	// definir los claims
	//claims["user_info"] = refreshToken
	claims["sub"] = username
	claims["typ"] = refresh
	claims["jti"] = refresh_uuid
	claims["iss"] = "miniGmail"
	claims["exp"] = expTime.Unix()
	signer.Claims = claims
	result, err := signer.SignedString(privateKey)

	return result, err
}

func handleTokenErrors(w http.ResponseWriter, err error) http.ResponseWriter {
	switch err.(type) {
	case *jwt.ValidationError:
		switch err.(*jwt.ValidationError).Errors {
		case jwt.ValidationErrorExpired:
			w.WriteHeader(http.StatusUnauthorized)
			jsonResult, err := json.Marshal(models.ErrorResponse{"Token already expired", "401 Unauthorized"})
			errorHandler(err)
			w.Write(jsonResult)
		case jwt.ValidationErrorSignatureInvalid:
			w.WriteHeader(http.StatusBadRequest)
			jsonResult, err := json.Marshal(models.ErrorResponse{"Invalid Token", "400 Forbidden"})
			errorHandler(err)
			w.Write(jsonResult)
		default:
			w.WriteHeader(http.StatusBadRequest)
			jsonResult, err := json.Marshal(models.ErrorResponse{"Error verifying token", "400 Bad Request"})
			errorHandler(err)
			w.Write(jsonResult)
		}
	default:
		log.Println(err)
		w.WriteHeader(http.StatusBadRequest)
		jsonResult, err := json.Marshal(models.ErrorResponse{"Error verifying token", "400 Bad Request"})
		errorHandler(err)
		w.Write(jsonResult)
	}
	return w
}

func extractToken(w http.ResponseWriter, r *http.Request) (*jwt.Token, http.ResponseWriter, error) {
	token, err := request.ParseFromRequest(r, request.OAuth2Extractor,
		func(token *jwt.Token) (interface{}, error) {
			return publicKey, nil
		})
	if err != nil {
		w = handleTokenErrors(w, err)
	}
	return token, w, err
}

func getTokClaim(token *jwt.Token, claim string) string {
	return token.Claims.(jwt.MapClaims)[claim].(string)
}
