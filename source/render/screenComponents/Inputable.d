module render.screenComponents.Inputable;

private void delegate() nothrow[] lostCalls;

interface Inputable {
	nothrow void focusLost();		//Called when any other inputable field gains focus
	final nothrow void focusGained() {
		ClearFocus();
	}
	final nothrow void registerFocus(void delegate() nothrow d) {
		lostCalls ~= d;
	}
}

static nothrow void ClearFocus() {
	foreach(void delegate() nothrow d; lostCalls)
		d();
}
