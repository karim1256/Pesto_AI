import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradutionproject/Core/Consts/ResponsiveUI.dart';
import 'package:gradutionproject/Core/Consts/Theme.dart';
import 'package:gradutionproject/Core/Widgets/Loading.dart';
import 'package:gradutionproject/Core/Widgets/Widgets.dart';
import 'package:gradutionproject/Features/DoctorFeatures/DoctorFeaturesCubit/DoctorFeaturesCubit.dart';
import 'package:gradutionproject/Features/DoctorFeatures/DoctorFeaturesCubit/DoctorFeaturesStates.dart';

final List<String> afternoonSlots = [
  "1:00 PM",
  "2:00 PM",
  "3:00 PM",
  "4:00 PM",
];

final List<String> eveningSlots = ["5:00 PM", "6:00 PM", "7:00 PM", "8:00 PM"];

List<String> monthShortcuts = [
  "Jan",
  "Feb",
  "Mar",
  "Apr",
  "May",
  "Jun",
  "Jul",
  "Aug",
  "Sep",
  "Oct",
  "Nov",
  "Dec",
];

List<String> filterPastTimeSlots(List<String> slots) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  return slots.where((slot) {
    final timeParts = slot.split(' ');
    final hourMinute = timeParts[0].split(':');
    int hour = int.parse(hourMinute[0]);
    final int minute = int.parse(hourMinute[1]);
    final String period = timeParts[1];

    // Convert to 24-hour format
    if (period == 'PM' && hour != 12) {
      hour += 12;
    } else if (period == 'AM' && hour == 12) {
      hour = 0;
    }

    final slotTime = DateTime(today.year, today.month, today.day, hour, minute);
    return slotTime.isAfter(now);
  }).toList();
}

Widget appointmentBookingContent(BuildContext context, {String? button}) {
  var cubit = BlocProvider.of<DoctorFeaturesCubit>(context, listen: true);

  String getFormattedSelectedDateTime() {
    int day = int.parse(getDateWithOffset(cubit.selectedDateIndex)["day"]);
    int month = int.parse(getDateWithOffset(cubit.selectedDateIndex)["month"]);
    int year = DateTime.now().year;

    late String timeStr =
        cubit.selectedTimeIndex! < 4
            ? afternoonSlots[cubit.selectedTimeIndex!]
            : eveningSlots[cubit.selectedTimeIndex! - 4];

    int hour = int.parse(timeStr.split(":")[0]);
    if (timeStr.contains("PM") && hour != 12) {
      hour += 12;
    }

    String hourStr = hour.toString().padLeft(2, '0');

    return "$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')} $hourStr:00:00";
  }

  return SingleChildScrollView(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth(context) * 0.04),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(height: screenHeight(context) * 0.02),
          ralewayText(
            'Today, ${DateTime.now().day} ${monthShortcuts[DateTime.now().month - 1]}',
            context,
            color: Colors.white,
            fontSize: screenWidth(context) * 0.045,
          ),
          SizedBox(height: screenHeight(context) * 0.025),
          dateSelector(context),
          SizedBox(
            height: _calculateSpacingHeight(context, cubit),
          ),
          timeSlotSelection(context),
          SizedBox(height: screenHeight(context) * 0.04),
          _buildActionButton(context, cubit),
          SizedBox(height: screenHeight(context) * 0.02),
        ],
      ),
    ),
  );
}

double _calculateSpacingHeight(BuildContext context, DoctorFeaturesCubit cubit) {
  if (cubit.selectedDateIndex == 0) {
    if (filterPastTimeSlots(afternoonSlots).isEmpty && 
        filterPastTimeSlots(eveningSlots).isNotEmpty) {
      return screenHeight(context) * 0.1;
    } else if (filterPastTimeSlots(afternoonSlots).isNotEmpty && 
              filterPastTimeSlots(eveningSlots).isEmpty) {
      return screenHeight(context) * 0.1;
    } else if (filterPastTimeSlots(afternoonSlots).isEmpty && 
              filterPastTimeSlots(eveningSlots).isEmpty) {
      return screenHeight(context) * 0.15;
    }
  }
  return screenHeight(context) * 0.03;
}

Widget _buildActionButton(BuildContext context, DoctorFeaturesCubit cubit) {
  String getFormattedSelectedDateTime() {
    int day = int.parse(getDateWithOffset(cubit.selectedDateIndex)["day"]);
    int month = int.parse(getDateWithOffset(cubit.selectedDateIndex)["month"]);
    int year = DateTime.now().year;

    late String timeStr =
        cubit.selectedTimeIndex! < 4
            ? afternoonSlots[cubit.selectedTimeIndex!]
            : eveningSlots[cubit.selectedTimeIndex! - 4];

    int hour = int.parse(timeStr.split(":")[0]);
    if (timeStr.contains("PM") && hour != 12) {
      hour += 12;
    }

    String hourStr = hour.toString().padLeft(2, '0');

    return "$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')} $hourStr:00:00";
  }

  return BlocConsumer<DoctorFeaturesCubit, DoctorFeaturesStates>(
    listener: (context, state) {
      // Add your listener logic here
    },
    builder: (context, state) {
      return SizedBox(
        width: screenWidth(context) * 0.8,
        height: screenHeight(context) * 0.065,
        child: ElevatedButton(
          onPressed: cubit.selectedTimeIndex == null ||
                  cubit.alreadBooked.contains(getFormattedSelectedDateTime())
              ? null
              : () {
                  String selected = getFormattedSelectedDateTime();
                  cubit.UpdateDataById(
                    cubit.date.contains(selected) ? false : true,
                    selected,
                  );
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: cubit.alreadBooked.contains(getFormattedSelectedDateTime())
                ? MainColor
                : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
          ),
          child: state is UpdateAvalTimeLoadingState
              ? Loading()
              : Text(
                  cubit.alreadBooked.contains(getFormattedSelectedDateTime())
                      ? "Already Booked"
                      : cubit.date.contains(getFormattedSelectedDateTime())
                          ? "Remove"
                          : "Add",
                  style: TextStyle(
                    fontSize: screenWidth(context) * 0.04,
                    color: cubit.alreadBooked.contains(getFormattedSelectedDateTime())
                        ? Colors.white
                        : MainColor,
                  ),
                ),
        ),
      );
    },
  );
}

Map getDateWithOffset(int daysOffset) {
  DateTime now = DateTime.now();
  DateTime futureDate = now.add(Duration(days: daysOffset));
  return {
    "day": futureDate.day.toString(),
    "month": futureDate.month.toString(),
  };
}

Widget dateSelector(BuildContext context) {
  var cubit = BlocProvider.of<DoctorFeaturesCubit>(context, listen: true);
  return SizedBox(
    height: screenHeight(context) * 0.08,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 10,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth(context) * 0.015),
          child: GestureDetector(
            onTap: () => cubit.choiceDate(index),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth(context) * 0.04,
                vertical: screenHeight(context) * 0.01,
              ),
              decoration: BoxDecoration(
                color: cubit.selectedDateIndex == index ? Colors.white : MainColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white, width: 1),
              ),
              child: Center(
                child: Text(
                  index == 0
                      ? "Today ${getDateWithOffset(index)["day"]} ${monthShortcuts[int.parse(getDateWithOffset(index)["month"]) - 1]}"
                      : index == 1
                          ? "Tomorrow ${getDateWithOffset(index)["day"]} ${monthShortcuts[int.parse(getDateWithOffset(index)["month"]) - 1]}"
                          : "${getDateWithOffset(index)["day"]} ${monthShortcuts[int.parse(getDateWithOffset(index)["month"]) - 1]}",
                  style: TextStyle(
                    fontSize: screenWidth(context) * 0.035,
                    fontWeight: FontWeight.w500,
                    color: cubit.selectedDateIndex == index ? MainColor : Colors.white,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}

Widget timeSlotSelection(BuildContext context) {
  var cubit = BlocProvider.of<DoctorFeaturesCubit>(context, listen: true);
  final availableAfternoon = filterPastTimeSlots(afternoonSlots);
  final availableEvening = filterPastTimeSlots(eveningSlots);
  
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      if (cubit.selectedDateIndex > 0 || availableAfternoon.isNotEmpty)
        Column(
          children: [
            ralewayText(
              'Afternoon',
              context,
              color: Colors.white,
              fontSize: screenWidth(context) * 0.04,
            ),
            SizedBox(height: screenHeight(context) * 0.015),
            _buildTimeSlots(
              context,
              cubit.selectedDateIndex == 0 ? availableAfternoon : afternoonSlots,
              cubit,
              isAfternoon: true,
            ),
            SizedBox(height: screenHeight(context) * 0.025),
          ],
        ),
      if (cubit.selectedDateIndex > 0 || availableEvening.isNotEmpty)
        Column(
          children: [
            ralewayText(
              'Evening',
              context,
              color: Colors.white,
              fontSize: screenWidth(context) * 0.04,
            ),
            SizedBox(height: screenHeight(context) * 0.015),
            _buildTimeSlots(
              context,
              cubit.selectedDateIndex == 0 ? availableEvening : eveningSlots,
              cubit,
              isAfternoon: false,
            ),
          ],
        ),
    ],
  );
}

Widget _buildTimeSlots(
  BuildContext context,
  List<String> slots,
  DoctorFeaturesCubit cubit, {
  required bool isAfternoon,
}) {
  if (slots.isEmpty) return SizedBox();
  
  return Wrap(
    spacing: screenWidth(context) * 0.03,
    runSpacing: screenHeight(context) * 0.015,
    alignment: WrapAlignment.center,
    children: List.generate(slots.length, (index) {
      final adjustedIndex = isAfternoon ? index : index + 4;
      return _TimeSlotButton(
        index: adjustedIndex,
        time: slots[index],
        isSelected: cubit.timeString == slots[index],
        onTap: () => cubit.choiceTime(adjustedIndex, slots[index]),
      );
    }),
  );
}

class _TimeSlotButton extends StatelessWidget {
  final int index;
  final String time;
  final bool isSelected;
  final VoidCallback onTap;

  const _TimeSlotButton({
    required this.index,
    required this.time,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth(context) * 0.05,
          vertical: screenHeight(context) * 0.015,
        ),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : MainColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white),
        ),
        child: Text(
          time,
          style: TextStyle(
            color: isSelected ? MainColor : Colors.white,
            fontSize: screenWidth(context) * 0.035,
          ),
        ),
      ),
    );
  }
}