require 'digest'
class User < ApplicationRecord

  validates :first_name, :last_name, :username, :password, :date_birth, presence: {message: "Este campo es obligatorio"}
  validates :username, uniqueness: {message: "El usuario ya se encuentra en uso"}

  validates :password, length: { minimum: 8,
    too_short: "Este campo requiere al menos 8 caracteres" }

  validates :username, length: { minimum: 5,
    too_short: "Este campo requiere al menos 5 caracteres" }

  before_create do
    self.first_name = self.first_name.titlecase
    self.last_name = self.last_name.titlecase
  end

  def full_name
    "#{first_name}#{" "}#{last_name}"
  end

  def set_user
    self.username
  end

  def self.find_by_username(username)
    where(username: username).first
  end

  def to_json(options={})
    options[:except] ||= [:id, :created_at, :updated_at, :password]
    super(options)
  end

  def as_json(options={})
    options[:except] ||= [:id, :created_at, :updated_at, :password]
    super(options)
  end
end
