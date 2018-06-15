module render.responsiveControl.ResponsiveElement;

interface ResponsiveElement {

	nothrow bool isStretchy();
	nothrow float getMinWidth();
	nothrow float getMinHeight();
	nothrow float getDefaultWidth();
	nothrow float getDefaultHeight();

	final nothrow float getDifferenceHeight() {
		return getDefaultHeight() - getMinHeight();
	}
	final nothrow float getDifferenceWidth() {
		return getDefaultWidth() - getMinWidth();
	}

}
