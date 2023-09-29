class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  enum :role, [:anonimo, :usuario, :admin]

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def to_s
    self.email
  end

end
# rails g scaffold News title:string imagen:string description:text 
# rails g scaffold Comment content:text user:references news:references
