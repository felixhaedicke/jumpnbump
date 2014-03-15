package org.jumpnbump;

import org.libsdl.app.SDLActivity;

import android.annotation.SuppressLint;
import android.os.Bundle;
import android.view.View;
import android.view.ViewConfiguration;

public class JNBActivity extends SDLActivity {

	@Override
	public void onWindowFocusChanged(boolean hasFocus) {
		if (hasFocus) {
			enableImmersiveModeIfNeeded();
		}
		super.onWindowFocusChanged(hasFocus);
	}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		enableImmersiveModeIfNeeded();
		super.onCreate(savedInstanceState);
	}
	
	@SuppressLint("NewApi")
	private void enableImmersiveModeIfNeeded() {
		if ((android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.KITKAT) && (!ViewConfiguration.get(this).hasPermanentMenuKey())) {
			getWindow().getDecorView().setSystemUiVisibility(
	                View.SYSTEM_UI_FLAG_LAYOUT_STABLE
	                | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
	                | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
	                | View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
	                | View.SYSTEM_UI_FLAG_FULLSCREEN
	                | View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY);
			}
	}

}
