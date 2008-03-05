module NoticesHelper

  def list_all_nodes
    nodes = AccessNode.find(:all)
    result = ''
    result += '<option value="all" />All</option>'
    nodes.each do |node|
      result += '<option value="'+ node.id.to_s + '" />' + node.name + '</option>'
    end
    return result;
  end

end
