class AuthorizedSerializer < ActiveModel::Serializer
  attributes :id,
             :amount,
             :type,
             :status,
             :customer_email,
             :customer_phone,
             :created_at,

  def created_at
    object.created_at.strftime('%d/%m/%y %H:%M')
  end
end
