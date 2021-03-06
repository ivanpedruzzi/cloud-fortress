Ext.define('bank.view.Main', {
    extend: 'Ext.container.Container',
    requires:[
        'Ext.tab.Panel',
        'Ext.layout.container.Auto',
        'Ext.window.Window',
        'client.WebDriverProxy'

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
        id:"signupForm",
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
                    var form = this.up("#signupForm");
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
                    };
                    
                    var callback = function(data){
                        Ext.getBody().unmask();
                        if(data && data.success == false){
                            alert(data.error);
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
    


