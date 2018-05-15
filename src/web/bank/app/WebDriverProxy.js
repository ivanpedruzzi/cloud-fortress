Ext.define('client.JsonReader', {
    extend: 'Ext.data.reader.Json'

    ,type: 'json'
    ,readRecordsOnFailure: false
    ,rootProperty:'data'
    ,totalProperty: 'totalCount'
    ,messageProperty:'error'
    ,successProperty:'success'
    ,getMessage:function(data){
        return data.error;
    }
    ,getSuccess:function(data){
        return data.success;
    }
    ,readRecords: function(data, readOptions) {
        if(this._model)
            return this.callParent(arguments);
        else 
            return new Ext.data.ResultSet({
                total  : 0,
                count  : 0,
                records: [data],
                success: data.success | true,
                message: data.error | ""
            });
    }

});

Ext.define('client.WebDriverProxy', {
    extend: 'Ext.data.proxy.Ajax'

    ,url:location.protocol + '//' + location.hostname+(location.port ? ':'+location.port: '') 
    ,path:'/service'
    ,actionMethods: {
        create : 'POST',
        read   : 'POST',
        update : 'POST',
        destroy: 'POST'
    }
    ,userHeaders:{
        "Content-type":"application/json",
        'X-Requested-With':'XMLHttpRequest'
    }
    ,callback:null
    ,context:{}
    ,jsonData:{}
    ,paramsAsJson:true

    ,username:''
    ,password:''
    //,withCredentials:true

    ,destroy: function() {
        //OVERRIDE DEFAULT IMPLEMENTATION
        //return this.doRequest.apply(this, arguments);
    }

    ,constructor: function(config) {

        var me = this;

        this._reader = client.JsonReader.create();
        
        if(config && config.userHeaders)
            me.headers = config.userHeaders;
        else
            me.headers =  me.userHeaders;
            
        me.headers["Authorization"] = 'Basic ' + Ext.util.Base64.encode(this.username+':'+this.password); 
    
        Ext.apply(this,{
            actionMethods: {
                create : 'POST',
                read   : 'POST',
                update : 'POST',
                destroy: 'POST'
            }
            ,reader:me.reader
            ,headers:me.headers
        });
        this.callParent(arguments);

        this.api['read'] = this.path;
    },

    getReader:function(){
        return this._reader;
    },    


    callService:function(context, callbackParam, jsonRequest, sourcePanel){
        var privateCallBack = function(data){
            var msg = null;
            if(data==null || data[0]==null){
                //msg = "Server return no data";
                console.log('callService: Server return no data request:' + Ext.JSON.encode(jsonRequest));
                
                if(sourcePanel)
                    console.log('WebDriverProxy.callService sourcePanel.id:' + sourcePanel.id);

                Ext.GlobalEvents.fireEvent('showLogin', true, sourcePanel);
            }
            else if(data[0].error){
                if(data[0].error.code && data[0].error.code === 'TOKEN_ID_EXPIRED') {
                    Ext.GlobalEvents.fireEvent('showLogin', true, sourcePanel);
                    return;
                }
                else if(data[0].error.message)
                    msg = data[0].error.message;
            }
            else{
                var realData = data[0].data;
                if(realData && realData.error){
                    msg = realData.error;
                }
            }
            if(msg!=null){
                Ext.MessageBox.show({
                    title: 'Server Error',
                    msg: msg,
                    buttons: Ext.MessageBox.OK,
                    icon: "Error"
                });
            }
            
            //ALWAYS invoke callback even if data is null
            callbackParam.call(context, realData);
        }


        var operation = this.createOperation('read', {
             callback:privateCallBack
            ,scope:context
            ,params:jsonRequest
        });    
        this.doRequest(operation);
    }

    /*buildRequest: function(operation) {
        var request = Ext.data.proxy.Ajax.prototype.buildRequest.call(this, operation);
        return request;
    },*/

});

/*
	var localProxy = Ext.create('client.WebDriverProxy');
	
	var jsonRequest = {
	 create_user:{
	   "first":form.down("#firstname").getValue()
	  ,"last":form.down("#lastname").getValue()
	  ,"phone":form.down("#phone").getValue()
	  ,"email":form.down("#email").getValue()
	  ,"address":{
	    "street": form.down("#street").getValue()
	   ,"city": form.down("city").getValue()
	   ,"zip":form.down("zip").getValue()
	   ,"state":form.down("state").getValue()
	   ,"country":form.down("country").getValue()
	  }
	 }	
	 }
	}

	var callback = function(data){
		Ext.getBody().unmask();

		if(data.success == false){

			< msgbox(data.error) >
		}

    }

	Ext.getBody().mask( "calling service..."); 
	localProxy.callService(this, callback, jsonRequest);	
*/
