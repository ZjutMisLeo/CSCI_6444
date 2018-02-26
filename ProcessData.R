library(igraph)
filePath = "/Users/leo/Desktop/big data/Project1/Features"
circlePath = "/Users/leo/Desktop/big data/Project1/Circles"
files = list.files(path = filePath, full.names = T, recursive = T)
circles = list.files(path = circlePath, full.names = T, recursive = T)
#create a datafram to store edges
relations = data.frame() 
#ccreate a list to store name of each file                           
nameList = as.list(data.frame())          
vertices = as.list(data.frame())  

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

#get path in circles
crealtions = data.frame() 
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
    		crelations = rbind(relations, test)
    	}
  	}
  }
}
crealtions = c(unique(crelations))
relations = rbind(relations,crelations)
relations = c(unique(relations))

gg = graph_from_data_frame(relations, directed = TRUE)
is.simple(gg)                                               # check duplicate
gg = simplify(gg)

V(gg)$vertex_degree <-  degree(gg)

plot(gg,layout = layout.auto, vertex.size = V(gg)$vertex_degree, 
	vertex.label = NA, edge.color = grey(0.5),
    edge.arrow.mode = "-")

#get 25 ego nodes with the largest circles
res = data.frame() 
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



#matrix of node and feature
featpath = "/Users/leo/Desktop/big data/Project1/Features/134943586.feat"
featNamePath = "/Users/leo/Desktop/big data/Project1/FeatureNames/134943586.featnames"
feat = read.table(featpath, stringsAsFactors = F)    
featureName = read.table(featNamePath, stringsAsFactors = F, comment.char = '~', fill = TRUE)
for(row in 1:nrow(feat)) {
	for(col in 1:ncol(feat)) {
		if (col == 1) {
        #first column here is the sub node
        test = data.frame(from = name, to = feat[row, col])
        relations = rbind(relations, test)
        vertices = c(vertices, as.numeric(feat[row, col]))
        }else {
        	if (feat[row, col] == 0){

        	}else {
        	#somedatastructure.add featureName[col][2]
            }
        }
    }
}
