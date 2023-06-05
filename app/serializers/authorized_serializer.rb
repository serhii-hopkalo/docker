class AuthorizedSerializer < ActiveModel::Serializer

  attributes :uuid,
             :amount,
             :type,
             :status,
             :customer_email,
             :customer_phone,
             :created_at,


  def uuid
    object.id
  end

  def created_at
    object.created_at.strftime('%d/%m/%y %H:%M')
  end
end
