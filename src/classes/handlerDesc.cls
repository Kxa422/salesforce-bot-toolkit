public with sharing class handlerDesc implements BotHandler{
	public BotResponse handle(String utterance, String[] params, Map<String, String> session) {

        List<BotRecord> records = new List<BotRecord>();
		
		String sObjectName = params[0];
		String sFieldName = '';
		if (params.size() > 1){
			sFieldName = params[1];
		}

		Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
		for(String sKey : gd.KeySet()){
			if (params[0].toLowerCase() == gd.get(skey).getDescribe().getLabel().toLowerCase() || params[0].toLowerCase() == gd.get(skey).getDescribe().getLabelPlural()){
				sObjectName = gd.get(skey).getDescribe().getName();
				break;
			}
		}

		Schema.DescribeSObjectResult[] descResult = Schema.describeSObjects(new String[]{sObjectName});
		Map<String, Schema.SObjectField> fieldMap = descResult[0].getSobjectType().getDescribe().fields.getMap();
		for (string sKey : fieldMap.Keyset()){
			if (sFieldName =='' || (sFieldName != '' && (sFieldName == fieldMap.Get(sKey).getDescribe().getName() || sFieldName == fieldMap.Get(sKey).getDescribe().getLabel()) )){
				List<BotField> fields = new List<BotField>();
				fields.add(new BotField('Name', '' + fieldMap.Get(sKey).getDescribe().getName() ));
				fields.add(new BotField('Label', '' + fieldMap.Get(sKey).getDescribe().getLabel() ));
				fields.add(new BotField('Type', '' + fieldMap.Get(sKey).getDescribe().getType()));
				if (fieldMap.Get(sKey).getDescribe().getLength() > 0){
					fields.add(new BotField('Length', '' + fieldMap.Get(sKey).getDescribe().getLength()));
				}
				if (fieldMap.Get(sKey).getDescribe().getPrecision() > 0){
					fields.add(new BotField('Precision', '' + fieldMap.Get(sKey).getDescribe().getPrecision()));
					fields.add(new BotField('Scale', '' + fieldMap.Get(sKey).getDescribe().getScale()));
				}
				try{
					List<Schema.PicklistEntry> lstP = fieldMap.Get(sKey).getDescribe().getPicklistValues();
					String sReturn = '';
					For (Schema.PicklistEntry pe : lstP){
						if (pe.isActive()){
							fields.add(new BotField('Picklist', pe.getValue() ));
						}
					}
				}
				catch(Exception e){}

				records.add(new BotRecord(fields));
			}
		}

        return new BotResponse(new BotMessage('Bot', 'Here is a desc of "' + params[0] + ' ' + sFieldName + '":', records));

	}
}
