public with sharing class ANEFI_ValidarCamposCierreOportunidadCC {
    
    @AuraEnabled()
    public static CamposFaltantesCierreOportunidadDTO obtenerCamposFaltantesCierreOportunidad(String oportunidadId){
        CamposFaltantesCierreOportunidadDTO camposFaltantesCierreOportunidadDTO = new CamposFaltantesCierreOportunidadDTO();
        if(!String.isBlank(oportunidadId) && !String.isEmpty(oportunidadId)){
            
            camposFaltantesCierreOportunidadDTO = obtenerCamposFaltantesOportunidad(oportunidadId);
        }
        
        return camposFaltantesCierreOportunidadDTO;
    }
    
    public static CamposFaltantesCierreOportunidadDTO obtenerCamposFaltantesOportunidad(String oportunidadId){
        CamposFaltantesCierreOportunidadDTO camposFaltantesCierreOportunidadDTO = new CamposFaltantesCierreOportunidadDTO();
        if(!String.isBlank(oportunidadId) && !String.isEmpty(oportunidadId)){
            
            List<Opportunity> oportunidades = [Select Id, Account.Tipo_de_persona_juridica__c,
                                               AccountId,Account.Fecha_de_constitucion__c, Account.Politicamente_expuesto__c,
                                                Account.Phone, Account.Nacionalidad__c,  Account.Actividad_Economica__c,
                                               Account.Calle_principal_direccion_trabajo__c,Account.Canton_direccion_de_trabajo__c ,
                                                Account.Pais_direccion_trabajo__c, Account.Interseccion_direccion_trabajo__c,
                                                Account.Numero_direccion_trabajo__c,Account.AnnualRevenue,
                                               Account.Total_activos__c, Account.Total_pasivos__c,
                                               Account.Total_gastos__c ,Account.Entidad_financiera__c,Account.Numero_de_cuenta_bancaria__c,
                                                Account.Tipo_de_cuenta_bancaria__c,Complementarios__c,
                                               Transaccion_cooparticipe__c,Fecha_efectiva_primer_aporte__c,
                                               Numero_documento_deposito__c,Forma_de_Pago__c, Moneda__c,Producto_de_Interes__c,
                                               Entidad_financiera__c, RecordType.Name, Account.Paga_impuestos__c, Account.Fecha_de_nacimiento__c,
                                               Account.Genero__c,Account.Pais_direccion_domicilio__c,Account.Calle_principal_direccion_domicilio__c,
                                               Account.Es_direccion_fiscal_direccion_domicilio__c,Account.Total_patrimonio__c,
                                               Account.Canton_direccion_domicilio__c, Account.Telefono_domicilio__c,Account.Telefono_celular__c,
                                               Account.Correo_electronico__c, Account.Estado_civil__c 
                                               from Opportunity where Id =: oportunidadId];
            
            if(oportunidades.size() > 0){
                Opportunity oportunidad = oportunidades.get(0);
                
                if(oportunidad.RecordType.Name == 'Persona Jurídica'){
                    camposFaltantesCierreOportunidadDTO = obtenerCamposFaltantesPersonaJuridica(oportunidad);
                }else if(oportunidad.RecordType.Name == 'Persona Natural'){
                    camposFaltantesCierreOportunidadDTO = obtenerCamposFaltantesPersonaNatural(oportunidad);
                } else if(oportunidad.RecordType.Name == 'Fondos de Inversión'){
                    camposFaltantesCierreOportunidadDTO = obtenerCamposFaltantesPersonaNatural(oportunidad);
                }
				camposFaltantesCierreOportunidadDTO.clienteId = oportunidad.AccountId;                
            }
        }
        return camposFaltantesCierreOportunidadDTO;
    }
    
    public static CamposFaltantesCierreOportunidadDTO obtenerCamposFaltantesPersonaJuridica(Opportunity oportunidad){
        CamposFaltantesCierreOportunidadDTO camposFaltantesOportunidadDTO = new CamposFaltantesCierreOportunidadDTO();
        List<String> camposFaltantesCliente = new List<String>();
        List<String> camposFaltantesOportunidad = new List<String>(); 
        if(oportunidad != null){
            if(oportunidad.Account.Correo_electronico__c == null){
                camposFaltantesCliente.add('Correo_electronico__c');  
            } 
            if(String.isBlank(oportunidad.Account.Tipo_de_persona_juridica__c)){
                camposFaltantesCliente.add('Tipo_de_persona_juridica__c');  
            }
            if(oportunidad.Account.Fecha_de_constitucion__c == null){
                camposFaltantesCliente.add('Fecha_de_constitucion__c');
            }
            if(String.isBlank(oportunidad.Account.Politicamente_expuesto__c)){
                camposFaltantesCliente.add('Politicamente_expuesto__c');  
            }
            if(String.isBlank(oportunidad.Account.Phone)){
                camposFaltantesCliente.add('Phone');  
            }
            if(String.isBlank(oportunidad.Account.Telefono_celular__c)){
                camposFaltantesCliente.add('Telefono_celular__c');  
            }
            if(oportunidad.Account.Nacionalidad__c == null){
                camposFaltantesCliente.add('Nacionalidad__c');  
            }
            if(oportunidad.Account.Actividad_Economica__c == null){
                camposFaltantesCliente.add('Actividad_Economica__c');  
            }
            if(String.isBlank(oportunidad.Account.Calle_principal_direccion_trabajo__c)){
                camposFaltantesCliente.add('Calle_principal_direccion_trabajo__c');  
            }
            if(oportunidad.Account.Canton_direccion_de_trabajo__c == null){
                camposFaltantesCliente.add('Canton_direccion_de_trabajo__c');  
            }
            if(oportunidad.Account.Pais_direccion_trabajo__c == null){
                camposFaltantesCliente.add('Pais_direccion_trabajo__c');  
            }
            if(String.isBlank(oportunidad.Account.Interseccion_direccion_trabajo__c)){
                camposFaltantesCliente.add('Interseccion_direccion_trabajo__c');  
            }
            if(String.isBlank(oportunidad.Account.Numero_direccion_trabajo__c)){
                camposFaltantesCliente.add('Numero_direccion_trabajo__c');  
            }
            if(oportunidad.Account.AnnualRevenue == null){
                camposFaltantesCliente.add('AnnualRevenue');  
            }
            if(oportunidad.Account.Total_activos__c == null){
                camposFaltantesCliente.add('Total_activos__c');  
            }
            if(oportunidad.Account.Total_pasivos__c == null){
                camposFaltantesCliente.add('Total_pasivos__c');  
            }
            if(oportunidad.Account.Total_gastos__c == null){
                camposFaltantesCliente.add('Total_gastos__c');  
            }
            if(oportunidad.Account.Entidad_financiera__c == null){
                camposFaltantesCliente.add('Entidad_financiera__c');  
            }
            if(String.isBlank(oportunidad.Account.Numero_de_cuenta_bancaria__c)){
                camposFaltantesCliente.add('Numero_de_cuenta_bancaria__c');  
            }
            if(String.isBlank(oportunidad.Account.Tipo_de_cuenta_bancaria__c)){
                camposFaltantesCliente.add('Tipo_de_cuenta_bancaria__c');  
            }
            if(String.isBlank(oportunidad.Complementarios__c)){
                camposFaltantesOportunidad.add('Complementarios__c');  
            }
            if(String.isBlank(oportunidad.Transaccion_cooparticipe__c)){
                camposFaltantesOportunidad.add('Transaccion_cooparticipe__c');  
            }
            if(oportunidad.Fecha_efectiva_primer_aporte__c == null){
                camposFaltantesOportunidad.add('Fecha_efectiva_primer_aporte__c');  
            }
            if(String.isBlank(oportunidad.Numero_documento_deposito__c)){
                camposFaltantesOportunidad.add('Numero_documento_deposito__c');  
            }
            if(String.isBlank(oportunidad.Forma_de_Pago__c)){
                camposFaltantesOportunidad.add('Forma_de_Pago__c');  
            }
            if(String.isBlank(oportunidad.Moneda__c)){
                camposFaltantesOportunidad.add('Moneda__c');  
            }
            if((oportunidad.Producto_de_Interes__c == 'F001' || oportunidad.Producto_de_Interes__c == 'F002')
               && oportunidad.Entidad_financiera__c  == null){
                   camposFaltantesOportunidad.add('Entidad_financiera__c');  
            }
            camposFaltantesOportunidadDTO.camposFaltantesCliente = camposFaltantesCliente;
            camposFaltantesOportunidadDTO.camposFaltantesOportunidad = camposFaltantesOportunidad;
            
        }
        return camposFaltantesOportunidadDTO;
    }
    
    public static CamposFaltantesCierreOportunidadDTO obtenerCamposFaltantesPersonaNatural(Opportunity oportunidad){
        CamposFaltantesCierreOportunidadDTO camposFaltantesOportunidadDTO = new CamposFaltantesCierreOportunidadDTO();
        List<String> camposFaltantesCliente = new List<String>();
        List<String> camposFaltantesOportunidad = new List<String>(); 
        if(oportunidad != null){
            if(String.isBlank(oportunidad.Account.Telefono_celular__c)){
                camposFaltantesCliente.add('Telefono_celular__c');  
            }
            if(oportunidad.Account.Correo_electronico__c == null){
                camposFaltantesCliente.add('Correo_electronico__c');  
            } 
            if(oportunidad.Account.Estado_civil__c == null){
                camposFaltantesCliente.add('Estado_civil__c');  
            }  
            if(String.isBlank(oportunidad.Account.Genero__c)){
                camposFaltantesCliente.add('Genero__c');  
            }
            if(oportunidad.Account.Nacionalidad__c == null){
                camposFaltantesCliente.add('Nacionalidad__c');  
            }
            if(String.isBlank(oportunidad.Account.Politicamente_expuesto__c)){
                camposFaltantesCliente.add('Politicamente_expuesto__c');  
            } 
            if(String.isBlank(oportunidad.Account.Paga_impuestos__c)){
                camposFaltantesCliente.add('Paga_impuestos__c');  
            }
            if(oportunidad.Account.Fecha_de_nacimiento__c == null){
                camposFaltantesCliente.add('Fecha_de_nacimiento__c');  
            }
                            
           
            if(oportunidad.Account.Actividad_Economica__c == null){
                camposFaltantesCliente.add('Actividad_Economica__c');  
            }          
            if(oportunidad.Account.Pais_direccion_domicilio__c == null){
                camposFaltantesCliente.add('Pais_direccion_domicilio__c');  
            }
            if(oportunidad.Account.Canton_direccion_domicilio__c == null){
                camposFaltantesCliente.add('Canton_direccion_domicilio__c');  
            }
            if(String.isBlank(oportunidad.Account.Telefono_domicilio__c)){
                camposFaltantesCliente.add('Telefono_domicilio__c');  
            }
           
            if(String.isBlank(oportunidad.Account.Calle_principal_direccion_domicilio__c)){
                camposFaltantesCliente.add('Calle_principal_direccion_domicilio__c');  
            }
            if(String.isBlank(oportunidad.Account.Es_direccion_fiscal_direccion_domicilio__c)){
                camposFaltantesCliente.add('Es_direccion_fiscal_direccion_domicilio__c');  
            }            
            if(oportunidad.Account.Total_activos__c == null){
                camposFaltantesCliente.add('Total_activos__c');  
            }
            if(oportunidad.Account.Total_pasivos__c == null){
                camposFaltantesCliente.add('Total_pasivos__c');  
            }
            if(oportunidad.Account.Total_patrimonio__c == null){
                camposFaltantesCliente.add('Total_patrimonio__c');  
            }
            if(oportunidad.Account.Entidad_financiera__c == null){
                camposFaltantesCliente.add('Entidad_financiera__c');  
            }
            if(String.isBlank(oportunidad.Account.Numero_de_cuenta_bancaria__c)){
                camposFaltantesCliente.add('Numero_de_cuenta_bancaria__c');  
            }
            if(String.isBlank(oportunidad.Account.Tipo_de_cuenta_bancaria__c)){
                camposFaltantesCliente.add('Tipo_de_cuenta_bancaria__c');  
            }
            if(String.isBlank(oportunidad.Complementarios__c)){
                camposFaltantesOportunidad.add('Complementarios__c');  
            }
            if(String.isBlank(oportunidad.Transaccion_cooparticipe__c)){
                camposFaltantesOportunidad.add('Transaccion_cooparticipe__c');  
            }
            if(oportunidad.Fecha_efectiva_primer_aporte__c == null){
                camposFaltantesOportunidad.add('Fecha_efectiva_primer_aporte__c');  
            }
            if(String.isBlank(oportunidad.Numero_documento_deposito__c)){
                camposFaltantesOportunidad.add('Numero_documento_deposito__c');  
            }
            if(String.isBlank(oportunidad.Forma_de_Pago__c)){
                camposFaltantesOportunidad.add('Forma_de_Pago__c');  
            }
            if(String.isBlank(oportunidad.Moneda__c)){
                camposFaltantesOportunidad.add('Moneda__c');  
            }
            if((oportunidad.Producto_de_Interes__c == 'F001' || oportunidad.Producto_de_Interes__c == 'F002')
               && oportunidad.Entidad_financiera__c  == null){
                   camposFaltantesOportunidad.add('Entidad_financiera__c');  
            }
            camposFaltantesOportunidadDTO.camposFaltantesCliente = camposFaltantesCliente;
            camposFaltantesOportunidadDTO.camposFaltantesOportunidad = camposFaltantesOportunidad;
        }
        return camposFaltantesOportunidadDTO;
    }
    
    public class CamposFaltantesCierreOportunidadDTO{
        @AuraEnabled
        public List<String> camposFaltantesCliente;
        @AuraEnabled
        public List<String> camposFaltantesOportunidad;
        @AuraEnabled
        public String clienteId;        
    }
    
    @AuraEnabled()
    public static list<String> CamposFaltantesAltaCliente(String AccountID){      

        list<String> camposFaltantesCliente = new list<String>();

        Account cliente = [ SELECT Fecha_de_constitucion__c,Politicamente_expuesto__c, Recordtype.Developername, Phone, Nacionalidad__c,Tipo_de_persona_juridica__c, 
                                Actividad_Economica__c, Calle_principal_direccion_trabajo__c,Canton_direccion_de_trabajo__c,  Pais_direccion_trabajo__c,
                                Interseccion_direccion_trabajo__c, Numero_direccion_trabajo__c, AnnualRevenue, Total_activos__c, Total_pasivos__c, Total_gastos__c ,
                                Entidad_financiera__c,Numero_de_cuenta_bancaria__c, Tipo_de_cuenta_bancaria__c,Paga_impuestos__c, Fecha_de_nacimiento__c, Genero__c,
                                Pais_direccion_domicilio__c, Calle_principal_direccion_domicilio__c, Es_direccion_fiscal_direccion_domicilio__c,
                                Total_patrimonio__c, Canton_direccion_domicilio__c, Telefono_domicilio__c,Telefono_celular__c, Correo_electronico__c, Estado_civil__c from Account where id =: AccountID
                               ];
        
        if(cliente.Recordtype.DeveloperName == 'Persona_Juridica'){

            if(cliente.Correo_electronico__c == null){
                camposFaltantesCliente.add('Correo_electronico__c');  
            } 
            if(String.isBlank(cliente.Tipo_de_persona_juridica__c)){
                camposFaltantesCliente.add('Tipo_de_persona_juridica__c');  
            }
            if(cliente.Fecha_de_constitucion__c == null){
                camposFaltantesCliente.add('Fecha_de_constitucion__c');
            }
            if(String.isBlank(cliente.Politicamente_expuesto__c)){
                camposFaltantesCliente.add('Politicamente_expuesto__c');  
            }
            if(String.isBlank(cliente.Phone)){
                camposFaltantesCliente.add('Phone');  
            }
            if(String.isBlank(cliente.Telefono_celular__c)){
                camposFaltantesCliente.add('Telefono_celular__c');  
            }
            if(cliente.Nacionalidad__c == null){
                camposFaltantesCliente.add('Nacionalidad__c');  
            }
            if(cliente.Actividad_Economica__c == null){
                camposFaltantesCliente.add('Actividad_Economica__c');  
            }
            if(String.isBlank(cliente.Calle_principal_direccion_trabajo__c)){
                camposFaltantesCliente.add('Calle_principal_direccion_trabajo__c');  
            }
            if(cliente.Canton_direccion_de_trabajo__c == null){
                camposFaltantesCliente.add('Canton_direccion_de_trabajo__c');  
            }
            if(cliente.Pais_direccion_trabajo__c == null){
                camposFaltantesCliente.add('Pais_direccion_trabajo__c');  
            }
            if(String.isBlank(cliente.Interseccion_direccion_trabajo__c)){
                camposFaltantesCliente.add('Interseccion_direccion_trabajo__c');  
            }
            if(String.isBlank(cliente.Numero_direccion_trabajo__c)){
                camposFaltantesCliente.add('Numero_direccion_trabajo__c');  
            }
            if(cliente.AnnualRevenue == null){
                camposFaltantesCliente.add('AnnualRevenue');  
            }
            if(cliente.Total_activos__c == null){
                camposFaltantesCliente.add('Total_activos__c');  
            }
            if(cliente.Total_pasivos__c == null){
                camposFaltantesCliente.add('Total_pasivos__c');  
            }
            if(cliente.Total_gastos__c == null){
                camposFaltantesCliente.add('Total_gastos__c');  
            }
            if(cliente.Entidad_financiera__c == null){
                camposFaltantesCliente.add('Entidad_financiera__c');  
            }
            if(String.isBlank(cliente.Numero_de_cuenta_bancaria__c)){
                camposFaltantesCliente.add('Numero_de_cuenta_bancaria__c');  
            }
            if(String.isBlank(cliente.Tipo_de_cuenta_bancaria__c)){
                camposFaltantesCliente.add('Tipo_de_cuenta_bancaria__c');  
            }
            
        }else{
            if(cliente.Recordtype.DeveloperName == 'Persona_Natural'){
                if(String.isBlank(cliente.Telefono_celular__c)){
                    camposFaltantesCliente.add('Telefono_celular__c');  
                }
                if(cliente.Correo_electronico__c == null){
                    camposFaltantesCliente.add('Correo_electronico__c');  
                } 
                if(cliente.Estado_civil__c == null){
                    camposFaltantesCliente.add('Estado_civil__c');  
                }  
                if(String.isBlank(cliente.Genero__c)){
                    camposFaltantesCliente.add('Genero__c');  
                }
                if(cliente.Nacionalidad__c == null){
                    camposFaltantesCliente.add('Nacionalidad__c');  
                }
                if(String.isBlank(cliente.Politicamente_expuesto__c)){
                    camposFaltantesCliente.add('Politicamente_expuesto__c');  
                } 
                if(String.isBlank(cliente.Paga_impuestos__c)){
                    camposFaltantesCliente.add('Paga_impuestos__c');  
                }
                if(cliente.Fecha_de_nacimiento__c == null){
                    camposFaltantesCliente.add('Fecha_de_nacimiento__c');  
                }                                               
                if(cliente.Actividad_Economica__c == null){
                    camposFaltantesCliente.add('Actividad_Economica__c');  
                }          
                if(cliente.Pais_direccion_domicilio__c == null){
                    camposFaltantesCliente.add('Pais_direccion_domicilio__c');  
                }
                if(cliente.Canton_direccion_domicilio__c == null){
                    camposFaltantesCliente.add('Canton_direccion_domicilio__c');  
                }
                if(String.isBlank(cliente.Telefono_domicilio__c)){
                    camposFaltantesCliente.add('Telefono_domicilio__c');  
                }               
                if(String.isBlank(cliente.Calle_principal_direccion_domicilio__c)){
                    camposFaltantesCliente.add('Calle_principal_direccion_domicilio__c');  
                }
                if(String.isBlank(cliente.Es_direccion_fiscal_direccion_domicilio__c)){
                    camposFaltantesCliente.add('Es_direccion_fiscal_direccion_domicilio__c');  
                }            
                if(cliente.Total_activos__c == null){
                    camposFaltantesCliente.add('Total_activos__c');  
                }
                if(cliente.Total_pasivos__c == null){
                    camposFaltantesCliente.add('Total_pasivos__c');  
                }
                if(cliente.Total_patrimonio__c == null){
                    camposFaltantesCliente.add('Total_patrimonio__c');  
                }
                if(cliente.Entidad_financiera__c == null){
                    camposFaltantesCliente.add('Entidad_financiera__c');  
                }
                if(String.isBlank(cliente.Numero_de_cuenta_bancaria__c)){
                    camposFaltantesCliente.add('Numero_de_cuenta_bancaria__c');  
                }
                if(String.isBlank(cliente.Tipo_de_cuenta_bancaria__c)){
                    camposFaltantesCliente.add('Tipo_de_cuenta_bancaria__c');  
                }
                
            }
        }
        
        
        return camposFaltantesCliente;
        
    }
}