(function(){var a,b;b=require("base64"),a=function(){function a(a){this.maxResults=a.maxResults||5,this.auth=a.auth,this.resource=a.resource}return a.prototype.getEmailsFrom=function(a,b){return this.resource.list({userId:"me",maxResults:this.maxResults,q:"from:"+a,auth:this.auth},function(a){return function(c,d){return a.respondMessages(c,d,b)}}(this))},a.prototype.respondMessages=function(a,b,c){return c(a?a:b.messages)},a.prototype.getFormatedEmailById=function(a,b){return this.getEmailById(a,function(a){return function(c,d){return a.respondFormatedEmail(c,d,b)}}(this))},a.prototype.getEmailById=function(a,b){return this.resource.get({userId:"me",id:a,auth:this.auth},function(){return function(a,c){return b(a,c)}}(this))},a.prototype.respondFormatedEmail=function(a,b,c){return a?c(a):(console.log(b),c(this.formatEmail(b.id,b.payload)))},a.prototype.formatEmail=function(a,b){return{id:a,from:this.emailSender(b.headers),subject:this.emailSubject(b.headers),body:this.decodeEmailBody(b.body)}},a.prototype.emailSender=function(a){return this.getHeaderValue("From",a)},a.prototype.emailSubject=function(a){return this.getHeaderValue("Subject",a)},a.prototype.decodeEmailBody=function(a){return a.data&&b.decode(a.data)},a.prototype.getHeaderValue=function(a,b){var c;return c=b.filter(function(b){return b.name===a}),c[0]?c[0].value:""},a}(),module.exports=a}).call(this);