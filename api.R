library(httr)
library(jsonlite)

oauth_endpoints("github")
myapp<-oauth_app("cleandata", "6f4192ca740def43c3e7", secret="xxx")
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

gtoken <- config(token = github_token)
req <- GET("https://api.github.com/users/jtleek/repos", gtoken)
