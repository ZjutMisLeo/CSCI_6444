library(igraph)
filePath = "/Users/leo/Desktop/big data/Project1/Features"
circlePath = "/Users/leo/Desktop/big data/Project1/Circles"
files = list.files(path = filePath, full.names = T, recursive = T)
circles = list.files(path = circlePath, full.names = T, recursive = T)

#create a datafram to store direct edges
relations = data.frame() 
#create a list to store name of each file                           
nameList = as.list(data.frame())          
#create a list to store circle node of all files     
vertices = as.list(data.frame())  

#get path by edges
edgePath = "/Users/leo/Desktop/big data/Project1/Edges"
edges = list.files(path = edgePath, full.names = T, recursive = T)
for (edge in edges){
	#get the first column of node
    edgeMatrix = as.matrix(read.table(edge))
    for (row in 1 : nrow(edgeMatrix)) {
    	test = data.frame(from = edgeMatrix[row, 1], to = edgeMatrix[row, 2])
    	print(test)
    	relations = rbind(relations, test)
    }
}

#get path by feats
for (path in files){
	#get the first column of node
    subNode = as.list(scan(path, what = 'list', flush = T))
    name = gsub("/Users/leo/Desktop/big data/Project1/Features/", "", path)
    name = as.numeric(gsub(".feat", "", name))
    nameList = c(nameList, name)
    for(node in subNode) {
       test = data.frame(from = name, to = as.numeric(node))
       relations = rbind(relations, test)
       vertices = c(vertices, as.numeric(node))
    }
}

vertices = unique(vertices)
relations = c(unique(relations))

#get path by circles
crelations = data.frame() 
for (circle in circles){
  c = scan(circle)
  if (!inherits(c, 'try-error')) c
  cList = as.list(c)
  cname = gsub("/Users/leo/Desktop/big data/Project1/Circles/", "", circle)
  cname = as.numeric(gsub(".circles", "", cname))
  if (length(cList) != 0) {                              # skip the empty file, we already have all nodes in nameList
    for (temp in cList){                                 # use this for loop to get edges of the node
    	if (temp > 100) {
    		test = data.frame(from = cname, to = temp)
    		crelations = rbind(crelations, test)
    	}
  	}
  }
}

#to check if paths are same by these two ways
crelations = c(unique(crelations))
relations = rbind(relations,crelations)
relations = c(unique(relations))

#create graph
gg = graph_from_data_frame(relations, directed = TRUE)
is.simple(gg)                                               # check duplicate
gg = simplify(gg)

print(gsize(gg)) #get number of edges for this graph

V(gg)$vertex_degree <-  degree(gg) # u can set vertex size base on degree by this way

plot(gg,layout = layout.auto, vertex.size = 4, vertex.label = NA, edge.color = grey(0.5),
    edge.arrow.mode = "-")

#get 25 ego nodes with the largest circles,here we consider the node has largest circle is the node with biggest degree
sort(degree(gg), decreasing = T)

#matrix of 25 nodes and feature
library(plyr)
library(reshape2)
egopath = "/Users/leo/Desktop/big data/Project1/EgoFeatures"
egos = list.files(path = egopath, full.names = T, recursive = T)
list = as.list(data.frame())
g = data.frame()
for (path in egos){
    feat = as.matrix(read.table(path, stringsAsFactors = F, fill = T))  
    egoName = gsub("/Users/leo/Desktop/big data/Project1/EgoFeatures/", "", path)
    egoName = as.numeric(gsub(".egofeat", "", egoName))
    list = c(list, egoName)
    featNamePath = paste("/Users/leo/Desktop/big data/Project1/FeatureNames/", egoName, ".featnames", sep = "")
    featureName = as.matrix(read.table(featNamePath, stringsAsFactors = F, comment.char = '~', fill = TRUE))
    fList = as.list(data.frame())
    for(row in 1 : nrow(feat)) {
	    for(col in 1 : ncol(feat)) {
		    if (feat[row, col] == 1){
			    fList = c(fList, featureName[col, 2])
		    }
	    }
	}
	if(length(fList) == 0) fList = c(fList, NA)#necessary
	temp = data.frame(egoName, fList)
	g = rbind.fill(g, temp)
}

# show each featurename contains which node
featNameList = as.list(data.frame())
g = as.matrix(g)
gg = data.frame()
for(val in g) {
	featNameList = c(featNameList, g)
}
#remove duplicate elements
featNameList = unique(featNameList)
#remove NA
featNameList[!is.na(featNameList)]
for (index in featNameList) {
	nodeList = as.list(data.frame())
	for (row in 1 : nrow(g)) {
		check = FALSE
		for (col in 1 : ncol(g)) {
			if (g[row, col] == index) {
				nodeList = c(nodeList, g[row][1])
				check = TRUE
				break
			}
		}
		if (check == FALSE){
			nodeList = c(nodeList, NA)
		}
    }
    temp = data.frame(index, nodeList)
    gg = cbind.fill(gg, temp)
}


#central person
central_person = alpha.centrality(gg)
cp = tail(sort(central_person), 5)
print(as.list(cp))

#longest path
longest_path = get_diameter(gg)

#largest clique
largest_cliques = largest_cliques(gg)
print(largest_cliques)


# ego
ego = ego(gg, gorder(gg), V(gg))
print(ego)


# betweenness and power
betweenness = betweenness(gg)
print(betweenness)
power = power_centrality(gg)
print(power)


#get the node with original large circle
for (circle in circles){
  c = scan(circle)
  if (!inherits(c, 'try-error')) c
  clist = as.list(c)
  circleSeq = scan(circle, what='list', flush = TRUE)
  cname = gsub("/Users/leo/Desktop/big data/Project1/Circles/", "", circle)
  cname = as.numeric(gsub(".circles", "", cname))
  if (length(clist) != 0){
  	max = 0
    for (index in 1 : length(clist)){
      if (index == 0) {
      	i = 1
      }else if (clist[index] < 100 && index != 0){
      	if (index - i - 1 > max) {
      		max = index - i - 1;
      	}
      	i = index
      }else if (index == length(clist)) {
      	if (length(clist) - i > max){
      		max = length(clist) - i
      	}
      }
    }
    temp = data.frame(Node = cname, amount = max)
    res = rbind(res, temp)
    }
}
res = res[order(res$amount, decreasing = T),]
