module render.screenComponents.Clickable;

interface Clickable {
	nothrow bool checkClick(float x, float y, int button);
}
