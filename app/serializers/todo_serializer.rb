class TodoSerializer < ActiveModel::Serializer
  attributes :id, :title, :text, :created_at

  def created_at
    object.created_at&.in_time_zone&.iso8601
  end
end
