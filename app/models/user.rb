class User < ApplicationRecord
    before_save{self.mail=mail.downcase}

    validates:name,{presence:true}
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates:mail,{uniqueness:{case_sensitive:false},format:{with:VALID_EMAIL_REGEX},allow_blank: true}
    validates:mail,{presence:true}
    validates:password,{presence:true,length:{minimum:6},allow_nil:true}

    def posts
        return Post.where(user_id:self.id)
    end

    has_many:posts
    has_many :active_relationships,class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy # フォローする
    has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy # フォローされる
    has_many :following, through: :active_relationships, source: :followed # 自分がフォローしている人
    has_many :followers, through: :passive_relationships, source: :follower # 自分をフォローしている人
    
    has_secure_password
end