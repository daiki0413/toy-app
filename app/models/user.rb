class User < ApplicationRecord
    validates:name,{presence:true}
    validates:mail,{presence:true,uniqueness:true}
    validates:password,{presence:true}
    
    def posts
        return Post.where(user_id:self.id)
    end
    
    has_secure_password
end
