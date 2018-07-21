module render.window.MapWindow;

import render.screenComponents;
import render.window.WindowObject;
import render.responsiveControl;
import render.drawing.MapBase;
import std.uuid;
import save.SaveData;
import render.Color;
import std.conv;

class MapWindow : WindowObject {

	this() {
		super("Solar Map", 640, 480);
	}

	private RenderScrollList solarList;
	private RenderMapBase map;

	public override void loadRenderObjects() {
		FillRegion list = new FillRegion(new AnchorPercentage(-1f, Side.left), new AnchorPercentage(1f, Side.top), new AnchorPixel(100, true, Side.right), new AnchorPercentage(-1f, Side.bottom));
		FillRegion mapR = new FillRegion(new AnchorRegion(list, Side.left), new AnchorPercentage(1f, Side.top), new AnchorPercentage(1f, Side.right), new AnchorPercentage(-1f, Side.bottom));
		regions ~= list;
		regions ~= mapR;
		solarList = new RenderScrollList(100f, 100f, this);
		map = new RenderMapBase(100f, 100f, this);
		list.setFill(solarList);
		mapR.setFill(map);
		UUID[] k = getGameSave().world.systems.keys;
		selected = k[0];
		RenderObject[] lst;
		foreach(UUID d; k) {
			lst ~= new RenderContentButton(100f, 20f, Colors.Blue2, to!string(getGameSave().world.systems[d].getRadius()) ~ ", " ~ to!string(getGameSave().world.systems[d].getAngle()), this, genDel(d));
		}
		solarList.setElements(lst);
		sortSol();
	}

	private UUID selected;

	private nothrow void sortSol() {
		import save.WorldSave;
		import world.SolarSystem;
		WorldSave w = getGameSave().world;
		UUID[] sols = w.systems.keys;
		for(int i = sols.length - 1; i > 0; i--) {		//Bubble sort by nearest distance to selected
			for(int j = 0; j < i; j++) {
				if (distanceBetween(w.systems[sols[j]], w.systems[selected]) > distanceBetween(w.systems[sols[j+1]], w.systems[selected])) {
					UUID tmp = sols[j];
					sols[j] = sols[j+1];
					sols[j+1] = tmp;
				}
			}
		}
		RenderObject[] newList = solarList.getElements();
		foreach(int i, UUID d; sols) {
			import std.stdio;
			writelnNothrow(distanceBetween(w.systems[selected], w.systems[d]));
			try {
			if (RenderContentButton but = cast(RenderContentButton)newList[i]) {
				but.setText(to!string(w.systems[d].getRadius()) ~ ", " ~ to!string(w.systems[d].getAngle()));
				but.clearClick();
				but.setClick(genDel(d));
			}
			} catch (Exception e) { assert(0); }
		}
		solarList.setElements(newList);
	}

	private void delegate() nothrow genDel(UUID d) nothrow {
		return (){
			selected = d;
			sortSol();
		};
	}

}
