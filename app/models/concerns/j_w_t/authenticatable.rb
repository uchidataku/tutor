# frozen_string_literal: true
module JWT
  # JWT用Concern
  module Authenticatable
    extend ActiveSupport::Concern

    included do
      # JWT失効させる
      def invalidate_jwt!(token)
        payload, _header = JWT::Helper.decode(token)
        fail JWT::InvalidSubError if payload['sub'] != id

        Jti.destroy(payload['jti'])
      end

      def jwt
        iat = Time.now.to_i
        exp = iat + (3600 * 24 * 7) # 有効期限は1週間
        jti = Jti.create!(account: self)

        payload = {
          iat: iat,
          exp: exp,
          jti: jti.id,
          sub: id
        }

        JWT::Helper.encode(payload)
      end
    end

    class_methods do
      def authenticate!(token)
        payload, _header = JWT::Helper.decode(
          token,
          algorithm: 'HS256',
          verify_jti: proc { |jti|
            Jti.exists?(jti)
          }
        )

        find(payload['sub'])
      end
    end
  end
end
