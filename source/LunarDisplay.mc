class LunarDisplay {
    private const months = ['正', '二', '三', '四', '五', '六', '七', '八', '九', '十', '冬', '臘'];
    private const days_digit = ['一', '二', '三', '四', '五', '六', '七', '八', '九', '十'];

    private var month = null;
    private var day = null;

    function initialize(lunar_date) {
        month = lunar_date["month"];
        day = lunar_date["day"];
    }

    function getDate() {
        var month_display = "";
        var day_display = "";

        if(month > 100) {
            month_display = "閏";
        }
        month_display += months[(month - 1) % 100];

        if(day <= 10) {
            day_display = "初";
            day_display += days_digit[day - 1];
        }
        else if(day <= 19) {
            day_display = "十";
            day_display += days_digit[day - 11];
        }
        else if(day % 10 == 0) {
            day_display = days_digit[day / 10 - 1];
            day_display += "十";
        }
        else {
            day_display = "廿";
            day_display += days_digit[day - 21];
        }

        return {
            "month" => month_display,
            "day" => day_display
        };
    }
}