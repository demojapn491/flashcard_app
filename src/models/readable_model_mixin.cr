module ReadableModelMixin
  def find(id : Int)
    all[id]
  end
  def find(id : String)
    id.to_i?.try{|i| all[i]}
  end
end
