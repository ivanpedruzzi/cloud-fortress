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
    ,path:location.pathname + 'service'
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
            
        //me.headers["Authorization"] = 'Basic ' + Ext.util.Base64.encode(this.username+':'+this.password); 
    
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
            if (data
                && data.resultSet 
                && data.resultSet.records 
                && data.resultSet.records[0])
                data = data.resultSet.records[0];
            
            if(data.success==false){
                console.log(data.error);
            }

            //ALWAYS invoke callback even if data is null
            callbackParam.call(context, data);
        }

        var operation = new Ext.data.Operation({
            'action'  :'read',
            'jsonData':jsonRequest
        });

        this.doRequest(operation, privateCallBack, context);
    }

    ,buildRequest: function(operation) {
        var request = Ext.data.proxy.Ajax.prototype.buildRequest.call(this, operation);
        request.jsonData = operation.jsonData;
        return request;
    },
});