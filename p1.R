#here is pseudocode
twitter <- read.table('twitter.Rdata', head=T,fileEncoding='UTF-8',stringsAsFactors=F)
g <- graph.data.frame(twitter)
matirx: from to 
        a    b

filePath = "C:/Users/L/Desktop/Big Data/Project1/Circles"
files = list.files(path = filePath, full.names = T, recursive = T)
#create a two cols matrix 
res = data.frame()
for (path in files){
	#print(path)
	g = try(read.table(path, fill = T, sep = '\t'))
	if (!inherits(g, 'try-error')) g
	gMatrix = as.matrix(g)
	circleSeq = scan(path, what = 'list', flush = T)
    name = gsub("C:/Users/L/Desktop/Big Data/Project1/Circles/", "", path)
    name = gsub(".circles", "", name)
	if (nrow(gMatrix) == 0) {
		test = data.frame(name, "null")
		res = rbind(res, test)
	}else{
		for (temp in gMatrix){
			test = data.frame(name, temp)
		    res = rbind(res, test)
		}
	}
  }

