################################################################################
# Joshua C. Fjelstul, Ph.D.
# euaid R package
################################################################################

# define pipe function
`%>%` <- magrittr::`%>%`

##################################################
# read in data
##################################################

load("data/decisions_ddy.RData")
load("data/decisions_ddy_ct.RData")

##################################################
# decisions_net
##################################################

# make an edge list
decisions_net <- dplyr::filter(decisions_ddy, count_decisions > 0)

# time
decisions_net$time <- decisions_net$year - min(decisions_net$year) + 1

# from node ID
decisions_net$from_node_id <- as.numeric(as.factor(decisions_net$department_id))

# from node
decisions_net$from_node <- decisions_net$department

# to node ID
decisions_net$to_node_id <- as.numeric(as.factor(decisions_net$member_state_id))

# to node
decisions_net$to_node <- decisions_net$member_state

# edge weight
decisions_net$edge_weight <- decisions_net$count_decisions

# layer ID
decisions_net$layer_id <- as.numeric(as.factor(decisions_net$decision_type_id))

# layer
decisions_net$layer <- decisions_net$decision_type

# arrange
decisions_net <- dplyr::arrange(decisions_net, time, layer_id, from_node_id, to_node_id)

# key ID
decisions_net$key_id <- 1:nrow(decisions_net)

# select variables
decisions_net <- dplyr::select(
  decisions_net,
  key_id, time,
  layer_id, layer,
  from_node_id, from_node, to_node_id, to_node,
  edge_weight
)

# save
save(decisions_net, file = "data/decisions_net.RData")

##################################################
# decisions_net_ct
##################################################

# make an edge list
decisions_net_ct <- dplyr::filter(decisions_ddy_ct, count_decisions > 0)

# time
decisions_net_ct$time <- decisions_net_ct$year - min(decisions_net_ct$year) + 1

# from node ID
decisions_net_ct$from_node_id <- as.numeric(as.factor(decisions_net_ct$department_id))

# from node
decisions_net_ct$from_node <- decisions_net_ct$department

# to node ID
decisions_net_ct$to_node_id <- as.numeric(as.factor(decisions_net_ct$member_state_id))

# to node
decisions_net_ct$to_node <- decisions_net_ct$member_state

# edge weight
decisions_net_ct$edge_weight <- decisions_net_ct$count_decisions

# layer ID
decisions_net_ct$d1_layer_id <- as.numeric(as.factor(decisions_net_ct$case_type_id))
decisions_net_ct$d2_layer_id <- as.numeric(as.factor(decisions_net_ct$decision_type_id))

# layer
decisions_net_ct$d1_layer <- decisions_net_ct$case_type
decisions_net_ct$d2_layer <- decisions_net_ct$decision_type

# arrange
decisions_net_ct <- dplyr::arrange(decisions_net_ct, time, d1_layer_id, d2_layer_id, from_node_id, to_node_id)

# key ID
decisions_net_ct$key_id <- 1:nrow(decisions_net_ct)

# select variables
decisions_net_ct <- dplyr::select(
  decisions_net_ct,
  key_id, time,
  d1_layer_id, d1_layer, d2_layer_id, d2_layer,
  from_node_id, from_node, to_node_id, to_node,
  edge_weight
)

# save
save(decisions_net_ct, file = "data/decisions_net_ct.RData")

################################################################################
# end R script
################################################################################
