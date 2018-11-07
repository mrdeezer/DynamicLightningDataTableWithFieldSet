public class DynamicDataTableWithFieldSetController {


	@AuraEnabled
	public static DataTableResponse getAccounts(String strObjectName, String strFieldSetName) {

		//Get the fields from FieldSet
        Schema.SObjectType SObjectTypeObj = Schema.getGlobalDescribe().get(strObjectName);
        Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();            
        Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(strFieldSetName);
        
        List<DataColumn> lstDataTableColumns = new List<DataColumn>();

        //list to hold field names
        List<String> lstQueryFields = new List<String>();

        DataTableResponse response = new DataTableResponse();

        for(Schema.FieldSetMember obj : fieldSetObj.getFields()) {

        	String dataType = String.valueOf(obj.getType()).toLowerCase();

        	if(dataType == 'datetime') {

        		dataType = 'date';
        	}

        	DataColumn objDataColumn = new DataColumn(String.valueOf(obj.getLabel()),
        											  String.valueOf(obj.getFieldPath()),
        										   	  String.valueOf(obj.getType()));

			lstDataTableColumns.add(objDataColumn);
			lstQueryFields.add(String.valueOf(obj.getFieldPath()));
        }

        if(lstDataTableColumns != NULL) {

        	response.lstDataColumns = lstDataTableColumns;

        	String strQuery = 'SELECT '+ String.join(lstQueryFields, ',') + ' FROM Account';
        	response.lstDataTableResponse = Database.query(strQuery);
        	System.debug('DataTableResponse '+response.lstDataTableResponse);
        }

        return response;
	}

	//Wrapper class to hold Data Table Column
	public class DataColumn {

		@AuraEnabled
		public String strLabel {get;set;}
		@AuraEnabled
		public String strType {get;set;}
		@AuraEnabled
		public String strFieldName{get;set;}

		public DataColumn( String strLabel, String strFieldName, String strType) {

			this.strLabel = strLabel;
			this.strType = strType;
			this.strFieldName = strFieldName;
		}
	}

	//Wrapper Class to hold FieldSet response
	public class DataTableResponse {

		@AuraEnabled
		public List<DataColumn> lstDataColumns {get;set;}
		@AuraEnabled
		public List<sObject> lstDataTableResponse {get;set;}

		public DataTableResponse() {

			lstDataColumns = new List<DataColumn>();
			lstDataTableResponse = new List<sObject>();
		}
	}
}