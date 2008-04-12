class AnalyticsController < ApplicationController

        def index
                @total_users = Connection.find(:all, :conditions => ['used_on > ?', Time.now - 1.month]).group_by(&:mac).length
                @total_users_ever = Connection.find(:all).group_by(&:mac).length

                nodes = AccessNode.find(:all)

                nodes_by_bandwidth = nodes.sort {|b,a| a.total_aggregate_bandwidth <=> b.total_aggregate_bandwidth}
                @top_five_nodes_bandwidth = nodes_by_bandwidth[0..5]

                nodes_by_connection = nodes.sort {|b,a| a.connections.group_by(&:mac).length <=> b.connections.group_by(&:mac).length}
                @top_five_nodes_conn = nodes_by_connection[0..5]
        end

end
