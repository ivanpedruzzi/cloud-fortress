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
            items: [{
                fieldLabel: 'First Name',
                emptyText: 'First Name',
                allowblank:'false',
                name: 'first'
            },
            {
                fieldLabel: 'Last Name',
                emptyText: 'Last Name',
                allowblank:'false',
                name: 'last'
            },
           
            {
                fieldLabel: 'Email',
                name: 'email',
                allowblank:'false',
                vtype: 'email'
            },
            {
                fieldLabel: 'Password',
                emptyText: 'Password',
                allowblank:'false',
                inputType: 'password',
                name: 'password',                            
            },


            {
                xtype: 'combobox',
                fieldLabel: 'State',
                name: 'state',
                valueField: 'abbr',
                displayField: 'state',
                typeAhead: true,
                queryMode: 'local',
                emptyText: 'Select a state...',
                allowblank:'false',
            },
            {
                xtype: 'datefield',
                fieldLabel: 'Date of Birth',
                name: 'dob',
                allowBlank: false,
                maxValue: new Date(),
                allowblank:'false',
            },
            {
                xtype:'button',
                text:'Signup',
                align:'center'
            }
            
        ]
        }]

        });
        win.show();
}