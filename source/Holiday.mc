class Holiday {
	
    private const jieNum = [3.87, 18.73, 5.63, 20.646, 4.81, 20.1, 5.52, 21.04, 5.678, 21.37, 7.108, 22.83, 7.5, 23.13, 7.646, 23.042, 8.318, 23.438, 7.438, 22.36, 7.18, 21.94, 5.4055, 20.12];

    private var year;
    private var solar_month;
    private var solar_day;
    private var lunar_month;
    private var lunar_day;
    private var lunar_lastday;
    private var week;

	function initialize(year, solar_month, solar_day, lunar_month, lunar_day, lunar_lastday, week) {
		self.year = year;
        self.solar_month = solar_month;
        self.solar_day = solar_day;
        self.lunar_month = lunar_month;
        self.lunar_day = lunar_day;
        self.lunar_lastday = lunar_lastday;
        self.week = week;
	}

	private function getJie(_year, index) {
        var year = _year - 2000;
        var extra = 0;
        if (index <= 1 || index >= 22) {
            extra = 1;
        }
        var val = Math.floor(year * 0.2422 + jieNum[index]) - Math.floor((year - extra) / 4);
        if (year == 26 && index == 1) {
            val--;
        }
        else if (year == 84 && index == 3) {
            val++;
        }
        else if (year == 89) {
            if (index == 17 || index == 18) {
                val++;
            }
        }
        else if (year == 82 && index == 23) {
            val++;
        }
        return val;
    }

    function getHoliday() {
        var holiday_array = getHolidayArray();
        if(holiday_array.size() == 0) {
            return "";
        }
        var holidays = holiday_array[0];
        for(var i = 1; i < holiday_array.size(); i++) {
            holidays += "\n";
            holidays += holiday_array[i];
        }
        return holidays;
    }

    function getHolidayArray() {
        var holiday = [];
        switch (solar_month) {
            case 1:
                if (solar_day >= 5 && solar_day <= 7) {
                    if (solar_day == getJie(year, 22)) {
                        holiday.add("小寒");
                    }
                }
                else if (solar_day >= 19 && solar_day <= 21) {
                    if (solar_day == getJie(year, 23)) {
                        holiday.add("大寒");
                    }
                }
                else if (solar_day == 1) {
                    holiday.add("元旦");
                }
                break;
            case 2:
                if (solar_day >= 3 && solar_day <= 5) {
                    if (solar_day == getJie(year, 0)) {
                        holiday.add("立春");
                    }
                }
                else if (solar_day >= 18 && solar_day <= 20) {
                    if (solar_day == getJie(year, 1)) {
                        holiday.add("雨水");
                    }
                }
                else if (solar_day == 14) {
                    holiday.add("西洋情人節");
                }
                else if (solar_day == 28) {
                    holiday.add("和平紀念日");
                }
                break;
            case 3:
                if (solar_day >= 5 && solar_day <= 7) {
                    if (solar_day == getJie(year, 2)) {
                        holiday.add("驚蟄");
                    }
                }
                else if (solar_day >= 20 && solar_day <= 22) {
                    if (solar_day == getJie(year, 3)) {
                        holiday.add("春分");
                    }
                }
                else if (solar_day == 12) {
                    holiday.add("植樹節");
                }
                else if (solar_day == 14) {
                    holiday.add("白色情人節");
                }
                else if (solar_day == 29) {
                    holiday.add("青年節");
                }
                break;
            case 4:
                if (solar_day >= 4 && solar_day <= 6) {
                    if (solar_day == getJie(year, 4)) {
                        holiday.add("清明節");
                    }
                    if (solar_day == 4) {
                        holiday.add("兒童節");
                    }
                }
                else if (solar_day >= 19 && solar_day <= 21) {
                    if (solar_day == getJie(year, 5)) {
                        holiday.add("穀雨");
                    }
                }
                else if (solar_day == 1) {
                    holiday.add("愚人節");
                }
                else if (solar_day == 22) {
                    holiday.add("世界地球日");
                }

                break;
            case 5:
                if (solar_day >= 8 && solar_day <= 14) {
                    if (week == 0) {
                        holiday.add("母親節");
                    }
                }
                else if (solar_day >= 5 && solar_day <= 7) {
                    if (solar_day == getJie(year, 6)) {
                        holiday.add("立夏");
                    }
                }
                else if (solar_day >= 20 && solar_day <= 22) {
                    if (solar_day == getJie(year, 7)) {
                        holiday.add("小滿");
                    }
                }
                else if (solar_day == 1) {
                    holiday.add("勞動節");
                }
                break;
            case 6:
                if (solar_day >= 5 && solar_day <= 7) {
                    if (solar_day == getJie(year, 8)) {
                        holiday.add("芒種");
                    }
                }
                else if (solar_day >= 20 && solar_day <= 22) {
                    if (solar_day == getJie(year, 9)) {
                        holiday.add("夏至");
                    }
                }
                break;
            case 7:
                if (solar_day >= 6 && solar_day <= 8) {
                    if (solar_day == getJie(year, 10)) {
                        holiday.add("小暑");
                    }
                }
                else if (solar_day >= 22 && solar_day <= 24) {
                    if (solar_day == getJie(year, 11)) {
                        holiday.add("大暑");
                    }
                }
                break;
            case 8:
                if (solar_day >= 7 && solar_day <= 9) {
                    if (solar_day == getJie(year, 12)) {
                        holiday.add("立秋");
                    }
                    if (solar_day == 8) {
                        holiday.add("父親節");
                    }
                }
                else if (solar_day >= 22 && solar_day <= 24) {
                    if (solar_day == getJie(year, 13)) {
                        holiday.add("處暑");
                    }
                }
                break;
            case 9:
                if (solar_day >= 7 && solar_day <= 9) {
                    if (solar_day == getJie(year, 14)) {
                        holiday.add("白露");
                    }
                }
                else if (solar_day >= 22 && solar_day <= 24) {
                    if (solar_day == getJie(year, 15)) {
                        holiday.add("秋分");
                    }
                }
                else if (solar_day == 3) {
                    holiday.add("軍人節");
                }
                else if (solar_day == 28) {
                    holiday.add("教師節");
                }
                break;
            case 10:
                if (solar_day >= 7 && solar_day <= 9) {
                    if (solar_day == getJie(year, 16)) {
                        holiday.add("寒露");
                    }
                }
                else if (solar_day >= 23 && solar_day <= 24) {
                    if (solar_day == getJie(year, 17)) {
                        holiday.add("霜降");
                    }
                }
                else if (solar_day == 10) {
                    holiday.add("國慶日");
                }
                else if (solar_day == 25) {
                    holiday.add("光復節");
                }
                else if (solar_day == 31) {
                    holiday.add("萬聖節");
                }
                break;
            case 11:
                if (solar_day >= 7 && solar_day <= 8) {
                    if (solar_day == getJie(year, 18)) {
                        holiday.add("立冬");
                    }
                }
                else if (solar_day >= 21 && solar_day <= 23) {
                    if (solar_day == getJie(year, 19)) {
                        holiday.add("小雪");
                    }
                }
                else if (solar_day == 11) {
                    holiday.add("光棍節");
                }
                break;
            case 12:
                if (solar_day >= 6 && solar_day <= 8) {
                    if (solar_day == getJie(year, 20)) {
                        holiday.add("大雪");
                    }
                }
                else if (solar_day >= 21 && solar_day <= 23) {
                    if (solar_day == getJie(year, 21)) {
                        holiday.add("冬至");
                    }
                }
                else if (solar_day == 24) {
                    holiday.add("平安夜");
                }
                else if (solar_day == 25) {
                    holiday.add("聖誕節");
                }
        }

        switch (lunar_month) {
            case 1:
                if (lunar_day == 1) {
                    holiday.add("春節");
                }
                else if (lunar_day == 15) {
                    holiday.add("元宵節");
                }
                break;
            case 2:
                if (lunar_day == 2) {
                    holiday.add("頭牙");
                }
                break;
            case 5:
                if (lunar_day == 5) {
                    holiday.add("端午節");
                }
                break;
            case 7:
                if (lunar_day == 1) {
                    holiday.add("鬼門開");
                }
                else if (lunar_day == 7) {
                    holiday.add("七夕情人節");
                }
                else if (lunar_day == 15) {
                    holiday.add("中元節");
                }
                else if (lunar_lastday == 1) {
                    holiday.add("鬼門關");
                }
                break;
            case 8:
                if (lunar_day == 15) {
                    holiday.add("中秋節");
                }
                break;
            case 9:
                if (lunar_day == 9) {
                    holiday.add("重陽節");
                }
                break;
            case 10:
                if (lunar_day == 15) {
                    holiday.add("下元節");
                }
                break;
            case 12:
                if (lunar_day == 16) {
                    holiday.add("尾牙");
                }
                else if (lunar_lastday == 2) {
                    holiday.add("小年夜");
                }
                else if (lunar_lastday == 1) {
                    holiday.add("除夕");
                }
        }
        return holiday;
    }
}