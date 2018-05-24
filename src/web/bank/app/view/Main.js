Ext.define('bank.view.Main', {
    extend: 'Ext.container.Container',
    requires:[
        'Ext.tab.Panel',
        'Ext.layout.container.Auto',
        'Ext.window.Window'

    ],
    
    xtype: 'app-main',

    layout: {
        type: 'auto',
        
    },



  



    items:[{
        xtype:'label',
        name:'title',
        text:'Bank Project',

        align:'center'
    },
        
        
        {
        xtype: 'panel',
        name:'navbar',
        width:'100%',
        height:'20%',
        
        items:[{   
            xtype:'button',
            text:'Login',
            name:'Login', 
            handler:function(){
                login(); 
      
            }
        },
       
        {
            xtype:'button',
            text:'Signup',
            name:'Signup',
            handler:function(){
                     signup(); 
           
            }
        }]
    }]

   
});

function login(){
    var win= Ext.create('Ext.window.Window',{
        width:'20%',
        title:'Login',
        defaultType: 'textfield',
        items: [{
            fieldLabel: 'Username',
            emptyText: 'Username',
            allowblank:'false',
            name: 'user'
        },
        {
            fieldLabel: 'Password',
            emptyText: 'Password',
            allowblank:'false',
            inputType: 'password',
            name: 'password'
        },{
            xtype:'button',
            text:'Login',
            name:'Login'
        }]
    });
    win.show();
}


function signup(){
    var win = Ext.create('Ext.window.Window',{
        title: 'Information',
        items:[{
            
            defaultType: 'textfield',
            defaults: {
                anchor: '100%'
            },
            items: [
			
			{fieldLabel:'Username',
				emptyText: 'Username',
				allowblank: 'false',
				name:'user',
				id: 'user'
				
			},
			{
                fieldLabel: 'First Name',
                emptyText: 'First Name',
                allowblank:'false',
                name: 'firs',
				id: 'first'
            },
            {
                fieldLabel: 'Last Name',
                emptyText: 'Last Name',
                allowblank:'false',
                name: 'last',
				id:'last'
            },
           {
                fieldLabel: 'Password',
                emptyText: 'Password',
                allowblank:'false',
                inputType: 'password',
                name: 'password',    
				id: 'password'
            },
			{
                fieldLabel: 'Phone',
                allowblank:'false',
				name: 'phone',
                id:'phone'
            },
			
            {
                fieldLabel: 'Email',
                allowblank:'false',
                vtype: 'email',
				name: 'email',
				id:'mail' 
            },
            {
				fieldLabel: 'Address Street',
				allowblank: 'false',
				name:'addstreet',
				id:'addstreet'
				
			},
			{
				fieldLabel: 'Postal Code',
				allowblank: 'false',
				name:'pcode',
				id:'pcode'
			},
			{
				fieldLabel: 'City',
				allowblank: 'false',
				name:'city',
				id:'city'
			},
            {
                xtype: 'combobox',
                fieldLabel: 'State',
                valueField: 'abbr',
                displayField: 'state',
                typeAhead: true,
                queryMode: 'local',
                emptyText: 'Select a state...',
                allowblank:'false',
				name: 'state',
				id:'state'
            },
			{
				fieldLabel: 'Country Code',
				allowblank: 'false',
				name:'country',
				id:'country'
				
			},
            {
                xtype:'button',
                text:'Signup',
                align:'center',
                handler: function(){
                    xt.define('client.JsonReader', {
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
                        },
                    
                        buildRequest: function(operation) {
                            var request = Ext.data.proxy.Ajax.prototype.buildRequest.call(this, operation);
                            return request;
                        },
                    
                    });
                    
                    
                        var localProxy = Ext.create('client.WebDriverProxy');
                        
                        var jsonRequest = {
                            create_user:{
                                "user":form.down("#user").getValue() 
                                ,"first":form.down("#first").getValue()
                                ,"last":form.down("#last").getValue()
                                ,"password": form.down("#password").getValue()
                                ,"phone":form.down("#phone").getValue()
                                ,"email":form.down("#mail").getValue()
                                ,"address":{
                                "addresstreet": form.down("#addstreet").getValue()
                                ,"postalCode":form.down("#pcode").getValue()
                                ,"city": form.down("#city").getValue()
                                ,"state":form.down("#state").getValue()
                                ,"countryCode":form.down("#country").getValue()
                              }
                              }
                         }
                        
                        var callback = function(data){
                            Ext.getBody().unmask();
                            if(data.success == false){
                               alert('Error!');
                            }
                        }
                        Ext.getBody().mask( "calling service..."); 
                        localProxy.callService(this, callback, jsonRequest);	
                    


                }
            }]
        }]
    });



    win.show();
}
    


