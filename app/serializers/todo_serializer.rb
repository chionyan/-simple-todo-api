class TodoSerializer < ActiveModel::Serializer
  attributes :id, :title, :text
end
