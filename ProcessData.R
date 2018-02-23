library(igraph)
filePath = "C:/Users/L/Desktop/Big Data/Project1/Circles"
FeaturesPath = "C:/Users/L/Desktop/Big Data/Project1/Features"
FeaturesPath = "C:/Users/L/Desktop/Big Data/Project1/FeatureNames"

files = list.files(path = filePath, full.names = T, recursive = T)
#create a datafram to store edges
relations = data.frame() 
#ccreate a list to store name                             
name = data.frame()
nameList = as.list(name)          
for (path in files){
	g = scan(path)
	if (!inherits(g, 'try-error')) g                       # I am not sure scan() will catch blank here.
	gList = as.list(g)
	circleSeq = scan(path, what = 'list', flush = T)       # the number of circle in each file, dont know how to process
    name = gsub("C:/Users/L/Desktop/Big Data/Project1/Circles/", "", path)
    name = as.numeric(gsub(".circles", "", name))
    nameList = c(nameList, name)                               # get the name of file and input into list
	if (length(gList) != 0) {                              # skip the empty file, we already have all nodes in nameList
		for (temp in gList){                               # use this for loop to get edges of the node
			if (temp > 100) {
				test = data.frame(from = name, to = temp)
				nameList = c(nameList, temp)
		        relations = rbind(relations, test)
		    }
		}
	#}
}

node = as.list(data.frame())
for(row in 1:nrow(relations)) {
    for(col in 1:ncol(relations)) {
	    node = c(node, relations[row, col])
	}
}
unique(node)
#nameList[duplicated(nameList)] 
users = data.frame(name = node)
                   #Features = ,
                   #FeatureNames = )

g = graph_from_data_frame(relations, directed = TRUE, vertices = users)
is.simple(g)                                               # check duplicate
g = simplify(g)
plot(g, vertex.size = 4, vertex.label = NA, layout=layout.auto, edge.color = grey(0.5), edge.arrow.mode = "-")

########################################

com = walktrap.community(gg, steps = 5)
subgroup = split(com$labels, com$membership)
## subgroup
V(gg)$sg = com$membership + 1
V(gg)$color = rainbow(max(V(gg)$sg))[V(gg)$sg]
## png("net_walktrap.png", width = 500, height = 500)
plot(gg, layout = layout.auto, vertex.size = 4,
    vertex.color = V(gg)$color, vertex.label = NA, edge.color = grey(0.5),
    edge.arrow.mode = "-")
