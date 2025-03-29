import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;

class TestView extends WatchUi.WatchFace
{
	var font_num = null;
	var img_weeks = [];

	var img_bluetooth = null;
	var img_alarm = null;

	var center_screenWidth = System.getDeviceSettings().screenWidth / 2;
	var center_screenHeight = System.getDeviceSettings().screenHeight / 2;

	var now = null;
	var saved_day = null;
	var since = null;
	var lunar_now = null;
	var lunar_date = null;
	var holiday = null;

	function initialize()
	{
		WatchFace.initialize();
		
		// font
		font_num = WatchUi.loadResource(Rez.Fonts.num_font);

		// week
		img_weeks.add(WatchUi.loadResource(Rez.Drawables.week_7));
		img_weeks.add(WatchUi.loadResource(Rez.Drawables.week_1));
		img_weeks.add(WatchUi.loadResource(Rez.Drawables.week_2));
		img_weeks.add(WatchUi.loadResource(Rez.Drawables.week_3));
		img_weeks.add(WatchUi.loadResource(Rez.Drawables.week_4));
		img_weeks.add(WatchUi.loadResource(Rez.Drawables.week_5));
		img_weeks.add(WatchUi.loadResource(Rez.Drawables.week_6));

		// icon
		img_bluetooth = WatchUi.loadResource(Rez.Drawables.bluetooth);
		img_alarm = WatchUi.loadResource(Rez.Drawables.alarm);

		// now
		now = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
		saved_day = now.day;
		updateDate();
	}

	// Load your resources here
	function onLayout(dc as Dc) as Void
	{
		setLayout(Rez.Layouts.WatchFace(dc));
	}

	// Called when this View is brought to the foreground. Restore
	// the state of this View and prepare it to be shown. This includes
	// loading resources into memory.
	function onShow() as Void
	{
	}

	function getBodyBatteryIterator() {
		return Toybox.SensorHistory.getBodyBatteryHistory({
			:period => 1,
			:order => Toybox.SensorHistory.ORDER_NEWEST_FIRST
		});
	}

	function getBodyBattery() as Number {
		var bodyBatteryIterator = getBodyBatteryIterator();
		var sample = bodyBatteryIterator.next();

		if (sample != null) {
			return sample.data;
		}
		return 0;
	}

	// function getStressIterator() {
	// 	return Toybox.SensorHistory.getStressHistory({
	// 		:period => 1,
	// 		:order => Toybox.SensorHistory.ORDER_NEWEST_FIRST
	// 	});
	// }

	// function getStress() as Number {
	// 	var stressIterator = getStressIterator();
	// 	var sample = stressIterator.next();

	// 	if (sample != null) {
	// 		return sample.data;
	// 	}
	// 	return 0;
	// }

	function updateDate()
	{	
		// since
		var now_moment = Gregorian.moment({
			:year => now.year,
			:month => now.month,
			:day => now.day
		});
		var birth = Gregorian.moment({
			:year => 2003,
			:month => 7,
			:day => 13
		});

		since = now_moment.subtract(birth).value() / 86400 + 1;

		// lunar
		var lunar = new Lunar(now.year, now.month, now.day);
		lunar_now = lunar.date;
		var lunar_display = new LunarDisplay(lunar_now);
		lunar_date = lunar_display.getDate();

		// holiday
		holiday = new Holiday(now.year, now.month, now.day, lunar_now["month"], lunar_now["day"], lunar_now["last_day"], now.day_of_week - 1);
	}

	// Update the view
	function onUpdate(dc as Dc) as Void
	{
		now = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
		if(saved_day != now.day) {
			updateDate();
		}
		saved_day = now.day;
		
		// Call the parent onUpdate function to redraw the layout
		View.onUpdate(dc);
		dc.drawBitmap(center_screenWidth - 16, 13, img_weeks[now.day_of_week - 1]);

		if(System.getDeviceSettings().phoneConnected) {
			dc.drawBitmap(40, 170, img_bluetooth);
		}

		if(Toybox.System.getDeviceSettings().alarmCount > 0) {
			dc.drawBitmap(176, 170, img_alarm);
		}

		// Get and show the current time
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

		dc.drawText(dc.getWidth() / 2, 40, Graphics.FONT_MEDIUM,
					Lang.format("$1$月$2$日", [ now.month, now.day ]),
					Graphics.TEXT_JUSTIFY_CENTER);
		dc.drawText(dc.getWidth() / 2, 60, Graphics.FONT_MEDIUM,
					Lang.format("$1$月$2$", [ lunar_date["month"], lunar_date["day"] ]),
					Graphics.TEXT_JUSTIFY_CENTER);

		var hour = now.hour;
		hour = hour < 6 ? 24 + hour : hour;

		dc.drawText(dc.getWidth() / 2, 90, font_num,
					// Lang.format("$1$$2$", [ clockTime.hour.format("%02d"), clockTime.min.format("%02d") ]),
					Lang.format("$1$:$2$", [ hour.format("%02d"), now.min.format("%02d") ]),
					Graphics.TEXT_JUSTIFY_CENTER);

		 dc.drawText(dc.getWidth() / 2, 157, Graphics.FONT_MEDIUM,
					Lang.format("$1$", [ holiday.getHoliday() ]),
					Graphics.TEXT_JUSTIFY_CENTER);

		dc.setPenWidth(10);

		var battery = Toybox.System.getSystemStats().battery;
		if(battery > 50) {
			var color = Math.round((100 - battery) * 5.1) * 65536 + 0x00ff00;
			dc.setColor(color, Graphics.COLOR_TRANSPARENT);
		}
		else {
			var color = Math.round(battery * 5.1) * 256 + 0xff0000;
			dc.setColor(color, Graphics.COLOR_TRANSPARENT);
		}
		if(battery * 90.0 / 100 >= 1) {
			dc.drawArc(center_screenWidth, center_screenHeight, 115, Graphics.ARC_CLOCKWISE, 180, 180 - battery * 90.0 / 100);
		}
		dc.drawText(0, 0, Graphics.FONT_MEDIUM,
					Lang.format("$1$", [ battery.format("%d") ]),
					Graphics.TEXT_JUSTIFY_LEFT);


		dc.setColor(0xccff00, Graphics.COLOR_TRANSPARENT);
		var bodyBattery = getBodyBattery();
		if(bodyBattery * 90.0 / 100 >= 1) {
			dc.drawArc(center_screenWidth, center_screenHeight, 115, Graphics.ARC_COUNTER_CLOCKWISE, 0, bodyBattery * 90.0 / 100);
		}
		dc.drawText(240, 0, Graphics.FONT_MEDIUM,
					Lang.format("$1$", [ bodyBattery.format("%d") ]),
					Graphics.TEXT_JUSTIFY_RIGHT);

		dc.setColor(0x18ffdc, Graphics.COLOR_TRANSPARENT);
		if((since % 100) * 90.0 / 100 >= 1) {
			dc.drawArc(center_screenWidth, center_screenHeight, 115, Graphics.ARC_COUNTER_CLOCKWISE, 180, 180 + (since % 100) * 90.0 / 100);
		}
		dc.drawText(0, 216, Graphics.FONT_MEDIUM,
					Lang.format("$1$", [ since.format("%d") ]),
					Graphics.TEXT_JUSTIFY_LEFT);

		dc.setColor(0xfeabfe, Graphics.COLOR_TRANSPARENT);
		var step = Toybox.ActivityMonitor.getInfo().steps;
		if(step * 90.0 / 10000 >= 1) {
			if(step < 10000) {
				dc.drawArc(center_screenWidth, center_screenHeight, 115, Graphics.ARC_CLOCKWISE, 0, 360 - step * 90.0 / 10000);
			}
			else {
				dc.drawArc(center_screenWidth, center_screenHeight, 115, Graphics.ARC_CLOCKWISE, 0, 270);
			}
		}
		dc.drawText(240, 216, Graphics.FONT_MEDIUM,
					Lang.format("$1$", [ step.format("%d") ]),
					Graphics.TEXT_JUSTIFY_RIGHT);
	}

	// Called when this View is removed from the screen. Save the
	// state of this View here. This includes freeing resources from
	// memory.
	function onHide() as Void
	{
	}

	// The user has just looked at their watch. Timers and animations may be started here.
	function onExitSleep() as Void
	{
	}

	// Terminate any active timers and prepare for slow updates.
	function onEnterSleep() as Void
	{
	}
}
