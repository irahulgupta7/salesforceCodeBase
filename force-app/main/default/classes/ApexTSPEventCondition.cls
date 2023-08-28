global class ApexTSPEventCondition implements TxnSecurity.EventCondition {

	public boolean evaluate(SObject event) {
		return false;
	}

}