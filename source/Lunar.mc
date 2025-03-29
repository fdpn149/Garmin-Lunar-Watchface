class Lunar {
	private const days_in_month = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
	private const day_agg = [40, 394, 778, 1132, 1486, 1870, 2225, 2579, 2963, 3318, 3702, 4056, 4410, 4794, 5148, 5502, 5886, 6241, 6596, 6980, 7334, 7718, 8072, 8426, 8810, 9164, 9519, 9903, 10258, 10642, 10996, 11350, 11733, 12088, 12442, 12826, 13181, 13535, 13919, 14273, 14657, 15011, 15366, 15750, 16104, 16459, 16843, 17197, 17581, 17935, 18289, 18673, 19028, 19382, 19766, 20121, 20475, 20859, 21213, 21597, 21951, 22306, 22690, 23044, 23399, 23782, 24136, 24520, 24874, 25229, 25613, 25968, 26322, 26706, 27060, 27414, 27798];
	private const year_months = [0x004b6, 0x06a6e, 0x00a4e, 0x00d26, 0x05ea6, 0x00d53, 0x005aa, 0x0376a, 0x0096d, 0x0b4af, 0x004ad, 0x00a4d, 0x16d0b, 0x00d25, 0x00d52, 0x05dd4, 0x00b5a, 0x0056d, 0x0255b, 0x0049b, 0x07a57, 0x00a4b, 0x00aa5, 0x15b25, 0x006d2, 0x00ada, 0x134b6, 0x00937, 0x0849f, 0x00497, 0x0064b, 0x1668a, 0x00ea5, 0x006aa, 0x14a6c, 0x00aae, 0x0092e, 0x03d2e, 0x00c96, 0x07d55, 0x00d4a, 0x00da5, 0x055d5, 0x0056a, 0x00a6d, 0x0455d, 0x0052d, 0x08a9b, 0x00a95, 0x00b4a, 0x06b6a, 0x00ad5, 0x0055a, 0x04aba, 0x00a5b, 0x0052b, 0x03b27, 0x00693, 0x07733, 0x006aa, 0x00ad5, 0x154b5, 0x004b6, 0x00a57, 0x0454e, 0x00d16, 0x08e96, 0x00d52, 0x00daa, 0x166aa, 0x0056d, 0x004ae, 0x04a9d, 0x00a2d, 0x00d15, 0x02f25];
	public var date = null;

	function initialize(year, month, day) {
		var agg_days = calcAggDays(year, month, day);
		var lunar_year_index = getLunarYearIndex(agg_days);
		var lunar_months_info = getLunarMonthsInfo(lunar_year_index);
		var lunar_months_size_agg = getLunarYearMonthsSizeAgg(lunar_months_info["leap"], lunar_months_info["pattern"]);
		self.date = getLunarDate(agg_days, lunar_year_index, lunar_months_size_agg);
	}

	private function calcAggDays(year, month, day) {    // 2024/1/1 -> 1    2025/1/1 -> 367
		var year_from_2024 = year - 2024;
		var base_day = Math.ceil(365.25 * year_from_2024);	// 1/0
		var agg_days = base_day;
		for(var i = 1; i < month; i++) {
			if(i == 2 && year % 4 == 0 && year % 100 != 0) {
				agg_days += 29;
			}
			else {
				agg_days += days_in_month[i - 1];
			}
		}
		agg_days += day;
		return agg_days;
	}

	private function getLunarYearIndex(agg_days) {	// 算agg_days在第幾個農曆年
		var index = 0;
		while (day_agg[index] < agg_days) {
			index++;
		}
		return index - 1;
	}

	private function getLunarMonthsInfo(lunar_year_index) {	// 將year_months的資訊攤開
		return {
			"pattern" => year_months[lunar_year_index] & 4095,
			"leap" => year_months[lunar_year_index] >> 12
		};
	}

	private function getLunarYearMonthsSizeAgg(leap, pattern) {
		var months_size_agg = [];
		var months_name = [];

		var leap_month = leap % 15;
		var agg = 0;

		for(var i = 0; i < 12; i++) {
			var month = i + 1;
			months_name.add(month);
			months_size_agg.add(agg);

			var greater = pattern & (1 << (11 - i));
			agg += (greater > 0 ? 30 : 29);
			
			if(leap_month == month) {
				months_name.add(100 + month);	// 閏三月以103表示，閏十二月以112表示
				months_size_agg.add(agg);
				greater = leap >> 4;
				agg += (greater > 0 ? 30 : 29);
			}
		}
		
		months_size_agg.add(agg);

		return {
			"name" => months_name,
			"size_agg" => months_size_agg
		};
	}

	private function getLunarDate(agg_days, lunar_year_index, lunar_months_size_agg) {
		var base_day = day_agg[lunar_year_index];
		var size_agg = lunar_months_size_agg["size_agg"];
		var index = size_agg.size() - 2;
		while (agg_days <= base_day + size_agg[index]) {
			index--;
		}

		var day = agg_days - (base_day + size_agg[index]);
		var last_day = (base_day + size_agg[index + 1]) - agg_days + 1;

		return {
			"month" => lunar_months_size_agg["name"][index].toNumber(),
			"day" => day.toNumber(),
			"last_day" => last_day.toNumber()
		};
	}
}