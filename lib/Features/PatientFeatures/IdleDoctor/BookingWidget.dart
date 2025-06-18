import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradutionproject/Core/Consts/ResponsiveUI.dart';
import 'package:gradutionproject/Core/Consts/Theme.dart';
import 'package:gradutionproject/Core/Widgets/Widgets.dart';
import 'package:gradutionproject/Features/PatientFeatures/PatientFeaturesCubit/PatientFeaturesCubit.dart';
import 'package:gradutionproject/Features/PatientFeatures/PatientFeaturesCubit/PatientFeaturesStates.dart';

class AppointmentBookingPage extends StatelessWidget {
  const AppointmentBookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainColor,

      body: BlocConsumer<PatientFeaturesCubit, PatientFeaturesStates>(
        listener: (context, state) {
          // if (state is PatientGetBookingFailureState) {
          //   ScaffoldMessenger.of(
          //     context,
          //   ).showSnackBar(SnackBar(content: Text(state.Message)));
          // }
        },
        builder: (context, state) {
          var cubit = BlocProvider.of<PatientFeaturesCubit>(context);

          return cubit.PatientAvlDatas.isNotEmpty
              ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight(context) * 0.12),
                  Text(
                    'Today, ${DateTime.now().day} ${monthShortcuts[DateTime.now().month - 1]}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth(context) * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: dateSelector(context),
                  ),
                  // const SizedBox(height: 20),
                  timeSlotSelection(context),
                  const SizedBox(height: 30),
                ],
              )
              : NotFound(
                text: "Available Sessions",
                context: context,
                textcolor: Colors.white,
              );
        },
      ),
    );
  }
}

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

Widget dateSelector(BuildContext context) {
  var cubit = BlocProvider.of<PatientFeaturesCubit>(context);

  // Group available dates by day to avoid duplicates
  final Map<String, List<String>> uniqueDays = {};
  for (var dateStr in cubit.PatientAvlDatas) {
    try {
      DateTime date = DateTime.parse(dateStr);
      String dayKey = "${date.year}-${date.month}-${date.day}";

      if (!uniqueDays.containsKey(dayKey)) {
        uniqueDays[dayKey] = [];
      }
      uniqueDays[dayKey]!.add(dateStr);
    } catch (e) {
      // Skip invalid dates
      continue;
    }
  }

  // Convert to list of unique days with their first occurrence
  final List<MapEntry<String, String>> uniqueDayEntries =
      uniqueDays.entries
          .map((entry) => MapEntry(entry.key, entry.value.first))
          .toList();

  return SizedBox(
    height: screenHeight(context) * 0.074,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: uniqueDayEntries.length,
      itemBuilder: (context, index) {
        final dateEntry = uniqueDayEntries[index];
        final DateTime parsedDate = DateTime.parse(dateEntry.value);
        final String formattedDate =
            "${parsedDate.day} ${monthShortcuts[parsedDate.month - 1]}";

        // Find if this day is currently selected
        bool isSelected = false;
        if (cubit.selectedDateIndex != null) {
          final selectedDateStr =
              cubit.PatientAvlDatas[cubit.selectedDateIndex!];
          final selectedDate = DateTime.parse(selectedDateStr);
          isSelected =
              selectedDate.year == parsedDate.year &&
              selectedDate.month == parsedDate.month &&
              selectedDate.day == parsedDate.day;
        }

        return GestureDetector(
          onTap: () {
            // Find the original index of this date in PatientAvlDatas
            final originalIndex = cubit.PatientAvlDatas.indexOf(
              dateEntry.value,
            );
            if (originalIndex != -1) {
              cubit.choiceDate(originalIndex);
            }
          },
          child: SizedBox(
            width: screenWidth(context) * 0.4,
            child: Card(
              color: isSelected ? Colors.white : MainColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: Colors.white,
                  width: isSelected ? 0 : 1.5, // White border when not selected
                ),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  formattedDate,
                  style: TextStyle(
                    fontSize: 16,
                    color: isSelected ? MainColor : Colors.white,
                    fontWeight: FontWeight.bold,
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
  final cubit = BlocProvider.of<PatientFeaturesCubit>(context, listen: true);

  // Return early if no date is selected
  if (cubit.selectedDateIndex == null) return const SizedBox();

  // Parse the selected date once
  final selectedDateStr = cubit.PatientAvlDatas[cubit.selectedDateIndex!];
  final selectedDate = DateTime.parse(selectedDateStr);

  // Combine and filter slots in a single operation for better performance
  final filteredSlots =
      [...cubit.afternoonSlots, ...cubit.eveningSlots].where((slot) {
        try {
          final slotDate = DateTime.parse(slot);
          return slotDate.year == selectedDate.year &&
              slotDate.month == selectedDate.month &&
              slotDate.day == selectedDate.day;
        } catch (e) {
          return false; // Skip invalid date formats
        }
      }).toList();

  // Categorize slots more efficiently
  final afternoonSlots = <String>[];
  final eveningSlots = <String>[];

  for (final slot in filteredSlots) {
    try {
      final time = DateTime.parse(slot);
      if (time.hour < 17) {
        afternoonSlots.add(slot);
      } else {
        eveningSlots.add(slot);
      }
    } catch (e) {
      continue; // Skip invalid time slots
    }
  }

  // Return appropriate widgets based on available slots
  if (filteredSlots.isEmpty) {
    return Center(
      child: ralewayText(
        'No available times for this date',
        context,
        color: Colors.white,
        fontSize: 16,
      ),
    );
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SizedBox(height: screenHeight(context) * 0.01),
      if (afternoonSlots.isNotEmpty) ...[
        sectionTitle('Afternoon', context),
        SizedBox(height: screenHeight(context) * 0.01),
        _buildTimeSlotGrid(afternoonSlots, context, 0),
        const SizedBox(height: 20),
      ],
      if (eveningSlots.isNotEmpty) ...[
        sectionTitle('Evening', context),
        SizedBox(height: screenHeight(context) * 0.01),
        _buildTimeSlotGrid(eveningSlots, context, afternoonSlots.length),
      ],
    ],
  );
}

// Helper method to build the time slot grid with white borders
Widget _buildTimeSlotGrid(
  List<String> slots,
  BuildContext context,
  int indexOffset,
) {
  final cubit = BlocProvider.of<PatientFeaturesCubit>(context);

  return Wrap(
    spacing: 12,
    runSpacing: 12,
    children: List.generate(slots.length, (index) {
      final globalIndex = index + indexOffset;
      final time = slots[index].split(' ')[1].substring(0, 5);
      final isSelected = cubit.selectedTimeIndex == globalIndex;

      return GestureDetector(
        onTap: () => cubit.choiceTime(globalIndex),
        child: Card(
          color: isSelected ? Colors.white : MainColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: Colors.white,
              width: isSelected ? 0 : 1.5, // White border when not selected
            ),
          ),
          child: Container(
            width: 82,
            height: 50,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.access_time,
                  size: 18,
                  color: isSelected ? MainColor : Colors.white,
                ),
                const SizedBox(width: 5),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 14,
                    color: isSelected ? MainColor : Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }),
  );
}

// Section title widget (unchanged from your original)
Widget sectionTitle(String title, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontSize: screenWidth(context) * 0.05,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

Widget timeSlotCard(int index, String fullDateTime, BuildContext context) {
  var cubit = BlocProvider.of<PatientFeaturesCubit>(context);

  String time = fullDateTime.split(' ')[1].substring(0, 5);

  return GestureDetector(
    onTap: () {
      cubit.choiceTime(index);
    },
    child: Card(
      color: cubit.selectedTimeIndex == index ? Colors.white : MainColor,
      //   elevation: cubit.selectedTimeIndex == index ? 5 : 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 82,
        height: 50,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.access_time,
              size: 18,
              color:
                  cubit.selectedTimeIndex == index ? MainColor : Colors.white,
            ),
            const SizedBox(width: 5),
            Text(
              time,
              style: TextStyle(
                fontSize: 14,
                color:
                    cubit.selectedTimeIndex == index ? MainColor : Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

String? getSelectedSlot(BuildContext context) {
  var cubit = BlocProvider.of<PatientFeaturesCubit>(context);

  if (cubit.selectedDateIndex == null || cubit.selectedTimeIndex == null) {
    return null;
  }

  String selectedDate = cubit.PatientAvlDatas[cubit.selectedDateIndex!];
  DateTime selectedDateTime = DateTime.parse(selectedDate);

  List<String> allSlots = [...cubit.afternoonSlots, ...cubit.eveningSlots];

  List<String> filteredSlots =
      allSlots.where((slot) {
        DateTime slotDate = DateTime.parse(slot);
        return slotDate.year == selectedDateTime.year &&
            slotDate.month == selectedDateTime.month &&
            slotDate.day == selectedDateTime.day;
      }).toList();

  if (cubit.selectedTimeIndex! < filteredSlots.length) {
    return filteredSlots[cubit.selectedTimeIndex!];
  } else {
    return null;
  }
}
