class User < ApplicationRecord
    has_many :microposts, dependent: :destroy
    before_save {self.email = self.email.downcase}
    validates :name, presence:true, length: { maximum: 50 }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email,presence:true, 
                        length: { maximum: 255 }, 
                        format: { with:VALID_EMAIL_REGEX },
                        uniqueness: true
    has_secure_password
    validates :password,presence: true, length: {minimum:6}   
    
    # 渡された文字列のハッシュ値を返す
    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end

    # 永続化セッションのためにユーザーをデータベースに記憶する
    def remember
        self.remember_token = User.new_token
        update_attribute(:remember_digest, User.digest(remember_token))
        remember_digest
    end

    # セッションハイジャック防止のためにセッショントークンを返す
    # この記憶ダイジェストを再利用しているのは単に利便性のため
    def session_token
        remember_digest || remember
    end

    # 試作feedの定義
    # 完全な実装は次章の「ユーザーをフォローする」を参照
    def feed
        Micropost.where("user_id = ?", id)
    end

end
