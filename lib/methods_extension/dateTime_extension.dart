enum DateTimeUnits {
  Y,
  M,
  W,
  D,
  H,
  MIN,
  S,
  MS,
  DATE,
  Q
}

Map<String, String> DateTimeUnitsMap = {
  'Y': 'year',
  'M': 'month',
  'W': 'week',
  'D': 'day',
  'H': 'hour',
  'MIN': 'minute',
  'S': 'second',
  'DATE': 'date',
  'MS': 'millisecond',
  'Q': 'quarter'
};

//const String FORMAT_DEFAULT = 'YYYY-MM-DDTHH:mm:ss';
const String FORMAT_DEFAULT = 'yyyy-MM-ddTHH:mm:ss';

/// 字符串扩展方法
extension DataTimeExtension on DateTime{
  
  String _addZero(String m){
  return int.parse(m) < 9 ? '0$m' : m;
  }

  /// 返回包含时间数值的 Map
  Map<String, int> toMap(){
    return {
      'years':this.year,
      'months':this.month,
      'date':this.day,
      'hours':this.hour,
      'minutes':this.minute,
      'seconds':this.second,
      'milliseconds':this.millisecond,
    };
  }

  /// 接收一系列的时间日期字符串并替换成相应的值
  String format({ String fm = FORMAT_DEFAULT }){
    final y = this.year.toString();
    final mh = this.month.toString();
    final d = this.day.toString();
    final h = this.hour.toString();
    final m = this.minute.toString();
    final s = this.second.toString();

    final matches = {
      'yyyy':y,
      'yy':y.substring(y.length - 2, y.length),
      'M':mh,
      'MM':_addZero(mh),
      'd':d,
      'dd':_addZero(d),
      'H':h,
      'HH':_addZero(h),
      'm':m,
      'mm':_addZero(m),
      's':s,
      'ss':_addZero(s),
      'a':this.hour < 12 ? 'am' : 'pm',
      'A':this.hour < 12 ? 'AM' : 'PM',
    };
    return fm.replaceAllMapped(new RegExp(r'\[.*?\]|y{2,4}|M{1,4}|D{1,2}|d{1,4}|H{1,2}|h{1,2}|a|A|m{1,2}|s{1,2}|Z{1,2}|SSS'), (Match m){
      final match = m.group(0);
      if (match.indexOf('[') > -1){
        return match.replaceAll(new RegExp(r'\[|\]'), '');
      }
      return matches[match];
    });
  }

   /**
   * 检查另外一个时间数值 是否与当前 DateTime 相应枚举相等
   */
  bool isSameValue(int that, DateTimeUnits unit){
    switch (unit) {
      case DateTimeUnits.Y:
        return that == this.year;
        break;
      case DateTimeUnits.M:
        return that == this.month;
        break;
      case DateTimeUnits.D:
        return that == this.day;
        break;
      case DateTimeUnits.H:
        return that == this.hour;
        break;
      case DateTimeUnits.MIN:
        return that == this.minute;
        break;
      default:
      return false;
    }
  }

   /**
   * 检查另外一个日期是否和实例日期当等
   */
  bool isSameDate(DateTime that){
    DateTime thisDate=DateTime(this.year,this.month,this.day);
    DateTime thatDate=DateTime(that.year,that.month,that.day);
    return thisDate == thatDate;
   
  }

  /// 增加指定单位的时间
  DateTime add(int num, DateTimeUnits unit){
    int y = this.year;
    int m = this.month;
    int d = this.day;
    int h = this.hour;
    int min = this.minute;
    int s = this.second;
    int ms = this.millisecond;
    switch (unit) {
      case DateTimeUnits.Y:
        return DateTime(
          y + num,
          m,
          d,
          h,
          min,
          s,
          ms
        );
        break;
      case DateTimeUnits.M:
          int afterMonth = m + num;
          if (afterMonth <= 12) {
            // 小于或等于 12 还是当年
            return DateTime(y, afterMonth, d, h, min, s, ms);
          } else {
            // 大于12 就是第二年了
            int ad = 12 - m;
            int bv = num - ad;
            y = y + 1;
            if ((bv/12) < 1) {
              return DateTime(y, bv, d, h, min, s, ms);
            } else {
              double dY = bv / 12;
              int newY = dY.floor();
              int absMonth = newY * 12;
              int newMonth = bv - absMonth;
              y = y + newY;
              return DateTime(y, newMonth, d, h, min, s, ms);
            }
          }
        break;
      case DateTimeUnits.D:
        return this.add(new Duration(days: num));
        break;
      case DateTimeUnits.H:
        return this.add(new Duration(hours:num));
        break;
      case DateTimeUnits.MIN:
        return this.add(new Duration(minutes:num));
        break;
      case DateTimeUnits.S:
        return this.add(new Duration(seconds: num));
        break;
      case DateTimeUnits.MS:
        return this.add(new Duration(milliseconds:num));
        break;
      default:
        return this;
        break;
    }
  }
  
  /// 减少指定单位的时间
  DateTime subtract(int num, DateTimeUnits unit){
    int y = this.year;
    int m = this.month;
    int d = this.day;
    int h = this.hour;
    int min = this.minute;
    int s = this.second;
    int ms = this.millisecond;
    switch (unit) {
      case DateTimeUnits.Y:
        return DateTime(
          y - num,
          m,
          d,
          h,
          min,
          s,
          ms
        );
        break;
      case DateTimeUnits.M:
        double dY = num / 12;
        if (dY < 1){
          // 说明减的月数没有超过一年
          int rangeM = m - num;
          if (rangeM < 0) {
            y = y - 1;
            m = 12 + rangeM;
            return DateTime(
              y,
              m,
              d,
              h,
              min,
              s,
              ms
            );
          } else {
            return DateTime(
              y,
              rangeM,
              d,
              h,
              min,
              s,
              ms
            );
          }
        } else {
          // 减的月数超过了一年
          int cY = dY.ceil();
          int bY = dY.floor();
          int cMonth = num - (12 * bY);
          int rangeM = m - cMonth;
          if (rangeM < 0) {
            m = 12 + rangeM;
            return DateTime(
              y - cY,
              m,
              d,
              h,
              min,
              s,
              ms
            );
          } else {
            return DateTime(
              y - bY,
              rangeM,
              d,
              h,
              min,
              s,
              ms
            );
          }
        }
        break;
      case DateTimeUnits.D:
        return this.subtract(new Duration(days: num));
        break;
      case DateTimeUnits.H:
        return this.subtract(new Duration(hours:num));
        break;
      case DateTimeUnits.MIN:
        return this.subtract(new Duration(minutes:num));
        break;
      case DateTimeUnits.S:
        return this.subtract(new Duration(seconds: num));
        break;
      case DateTimeUnits.MS:
        return this.subtract(new Duration(milliseconds:num));
        break;
      default:
        return this;
        break;
    }
  }

}