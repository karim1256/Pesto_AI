import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradutionproject/Core/Consts/ResponsiveUI.dart';
import 'package:gradutionproject/Core/Consts/Theme.dart';
import 'package:gradutionproject/Features/PatientFeatures/PatientFeaturesCubit/PatientFeaturesCubit.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

Widget Button(
  BuildContext context, // Function fun,
  dynamic Widget, {

  double? width,
  double? height,
  Color? TextColor,
  Color? ContainerColor,
  double? fontsize,
  double? radius,
  void Function()? onPressed,
}) {
  return MaterialButton(
    onPressed: onPressed,
    child: Container(
      height: height ?? screenHeight(context) * 0.07,
      width: width ?? screenWidth(context) * 0.4,
      decoration: BoxDecoration(
        color: ContainerColor ?? MainColor,
        borderRadius: BorderRadius.circular(radius ?? 15),
      ),
      alignment: Alignment.center,

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Widget,
          //  LoadingAnimationWidget.horizontalRotatingDots(
          //                           color: Colors.white,
          //                           size: 60,
          //                         ),

          // text=="SignUp with Google"?
          // Image.asset('lib/Core/Assets/GoogleLogo.png');
        ],
      ),
    ),
  );
}

Text ButtonText(
  String text,
  BuildContext context, {
  Color? TextColor,
  double? FontSize,
}) {
  return Text(
    text,
    style: GoogleFonts.raleway(
      fontSize: FontSize ?? screenWidth(context) * 0.045,
      fontWeight: FontWeight.w700,
      color: TextColor ?? MainColor,
    ),
  );
}

Widget buildTextField(
  TextEditingController controller,
  String? text,
  BuildContext context, {
  String? Function(String?)? validator,
  String? hinttext,
  Color? FormColor,
  Color? TextColor,
  bool? isPassword,
  bool bigForm = false,
  TextInputType? textInputType,
  bool? init,
  String? initValue,
  String? Function(String)? onChanged,
}) {
  if (init == true && controller.text != (initValue ?? "")) {
    controller.text = initValue ?? "";
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ralewayText(
        text ?? "",
        context,
        fontSize: screenWidth(context) * 0.045,
        color: TextColor ?? MainColor,
      ),
      SizedBox(height: bodyHeight(context) * 0.01),
      SizedBox(
        width: screenWidth(context) * 0.9,
        height: bigForm ? screenHeight(context) * 0.15 : null,
        child:
        /////
        TextFormField(
          onChanged: onChanged,
          keyboardType: textInputType ?? TextInputType.text,
          validator: validator,
          controller: controller,
          obscureText: isPassword ?? false,
          maxLines: bigForm ? 5 : 1,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              vertical: screenHeight(context) * 0.01,
              horizontal: screenWidth(context) * 0.04,
            ),
            fillColor: FormColor ?? Colors.white,
            filled: true,
            hintText: hinttext,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(13),
            ),
          ),
        ),
      ),
      SizedBox(height: bodyHeight(context) * 0.01),
    ],
  );
}

Widget LoginUPFormat(
  String MainText,
  String SecondText,
  BuildContext context,
) => Column(
  children: [
    Text(
      MainText,
      style: GoogleFonts.raleway(
        fontSize: screenWidth(context) * 0.08,
        fontWeight: FontWeight.bold,
        color: MainColor,
      ),
    ),
    SizedBox(height: bodyHeight(context) * 0.01),
    SizedBox(
      width: screenWidth(context) * 0.7,
      child: Text(
        SecondText,
        textAlign: TextAlign.center,
        style: GoogleFonts.raleway(
          fontSize: screenWidth(context) * 0.045,
          color: const Color.fromARGB(255, 141, 139, 139),
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  ],
);

Widget ralewayText(
  String text,
  BuildContext context, {
  double? fontSize,
  Color? color,
  FontWeight? fontWeight,
  TextAlign? align,
}) => Text(
  text,
  textAlign: align ?? TextAlign.center,
  style: GoogleFonts.raleway(
    fontSize: fontSize ?? screenWidth(context) * 0.04,
    color: color ?? MainColor,
    fontWeight: fontWeight ?? FontWeight.w700,
  ),
);

Widget buildCalendarWidget({
  required BuildContext context,
  required List<DateTime> focusedDays,
  required dynamic cubit,
}) {
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;

  // Clean dates by removing time components
  final cleanedDates =
      focusedDays
          .map((date) => DateTime(date.year, date.month, date.day))
          .toList();

  // Initialize with first upcoming date or today
  final now = DateTime.now();
  final initialDate =
      cleanedDates.isNotEmpty
          ? cleanedDates.firstWhere(
            (date) => date.isAfter(now),
            orElse: () => now,
          )
          : now;

  final focusedDayNotifier = ValueNotifier<DateTime>(initialDate);
  final selectedDayNotifier = ValueNotifier<DateTime?>(null);

  return Container(
    width: width * 0.82,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: MainColor, width: 2),
    ),
    child: ValueListenableBuilder<DateTime>(
      valueListenable: focusedDayNotifier,
      builder: (context, currentFocusedDay, _) {
        return Column(
          children: [
            // Calendar Header
            Container(
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: MainColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.chevron_left, color: Colors.white),
                    onPressed: () {
                      focusedDayNotifier.value = DateTime(
                        currentFocusedDay.year,
                        currentFocusedDay.month - 1,
                        1,
                      );
                    },
                  ),
                  Text(
                    DateFormat('MMMM yyyy').format(currentFocusedDay),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14, // smaller font
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.chevron_right, color: Colors.white),
                    onPressed: () {
                      focusedDayNotifier.value = DateTime(
                        currentFocusedDay.year,
                        currentFocusedDay.month + 1,
                        1,
                      );
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: height * 0.015),
            ValueListenableBuilder<DateTime?>(
              valueListenable: selectedDayNotifier,
              builder: (context, selectedDay, _) {
                return TableCalendar(
                  firstDay: DateTime(2000),
                  lastDay: DateTime(2050),
                  focusedDay: currentFocusedDay,
                  calendarFormat: CalendarFormat.month,
                  headerVisible: false,
                  availableGestures: AvailableGestures.all,
                  selectedDayPredicate: (day) {
                    return selectedDay != null && isSameDay(day, selectedDay);
                  },
                  onDaySelected: (newSelectedDay, _) {
                    final dateOnly = DateTime(
                      newSelectedDay.year,
                      newSelectedDay.month,
                      newSelectedDay.day,
                    );

                    final isValid = cleanedDates.any(
                      (d) => isSameDay(d, dateOnly),
                    );

                    if (isValid) {
                      if (selectedDay != null &&
                          isSameDay(selectedDay, dateOnly)) {
                        selectedDayNotifier.value = null;
                        cubit.i = -1;
                      } else {
                        selectedDayNotifier.value = dateOnly;
                        final index = focusedDays.indexWhere(
                          (d) => isSameDay(d, dateOnly),
                        );
                        if (index != -1) {
                          cubit.i = index;
                          cubit.SetDetails();
                        }
                      }
                    }
                  },
                  eventLoader: (day) {
                    return cleanedDates.any((d) => isSameDay(d, day))
                        ? [day]
                        : [];
                  },
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.amberAccent,
                      shape: BoxShape.circle,
                      border: Border.all(color: MainColor, width: 2),
                    ),
                    markerDecoration: BoxDecoration(
                      color: MainColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    ),
  );
}

Widget buildMeetingDetails(
  BuildContext context,
  DateTime? meetingDate,
  String? doctorName,
) {
  final width = MediaQuery.of(context).size.width;

  return Container(
    width: width * 0.81,
    margin: EdgeInsets.only(top: 10),
    padding: EdgeInsets.all(screenWidth(context) * 0.04),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: MainColor, width: 1.5),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          
          'Appointment Details',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: MainColor,
          ),
        ),
        SizedBox(height: width * 0.01),
        Divider(),
        SizedBox(height: width * 0.01),

        // Date and Time
        Row(
          children: [
            Icon(Icons.calendar_today, size: width * 0.06, color: MainColor),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meetingDate == null
                      ? 'No Dates'
                      : DateFormat('EEEE, MMMM d').format(meetingDate),
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  meetingDate == null
                      ? 'No dates'
                      : DateFormat('h:mm a').format(meetingDate),
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: width * 0.024),

        Row(
          children: [
            Icon(Icons.person, size: width * 0.06, color: MainColor),
            SizedBox(width: 10),
            Text(' $doctorName', style: TextStyle(fontSize: 16)),
          ],
        ),

        // Status
        // Row(
        //   children: [
        //     Icon(
        //       meetingDate.isAfter(DateTime.now())
        //           ? Icons.timer
        //           : Icons.check_circle,
        //       size: 20,
        //       color:
        //           meetingDate.isAfter(DateTime.now())
        //               ? Colors.orange
        //               : Colors.green,
        //     ),
        //     SizedBox(width: 10),
        //     Text(
        //       meetingDate.isAfter(DateTime.now()) ? 'Upcoming' : 'Completed',
        //       style: TextStyle(
        //         color:
        //             meetingDate.isAfter(DateTime.now())
        //                 ? Colors.orange
        //                 : Colors.green,
        //         fontSize: 16,
        //       ),
        //     ),
        //   ],
        // ),
      ],
    ),
  );
}

/// **Reusable Next Meeting Info Widget**
Widget buildNextMeetingInfo(BuildContext context) {
  double width = screenWidth(context);
  double height = screenHeight(context);
  var cubit = BlocProvider.of<PatientFeaturesCubit>(context, listen: true);

  return Container(
    width: width * 0.9,
    padding: EdgeInsets.symmetric(
      horizontal: width * 0.05,
      vertical: height * 0.015,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: MainColor, width: 1.5),
    ),
    child: Center(
      child: Text(
        //'Next Meeting at ${DateFormat('d/M/y, h:mm a').format(cubit.calenderList[cubit.i])}'
        "",
        style: TextStyle(fontSize: width * 0.04),
      ),
    ),
  );
}

/// **Reusable AppBar Widget**
Widget buildAppBar(BuildContext context) {
  return Container(
    width: screenWidth(context),
    height: bodyHeight(context) * 0.14,
    decoration: BoxDecoration(
      color: MainColor,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(screenWidth(context) * 0.12),
        bottomRight: Radius.circular(screenWidth(context) * 0.12),
      ),
    ),
    alignment: Alignment.center,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: screenWidth(context) * 0.06,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        SizedBox(width: screenWidth(context) * 0.172),
        ralewayText(
          "Table",
          context,
          fontSize: screenWidth(context) * 0.06,
          color: Colors.white,
        ),
      ],
    ),
  );
}

ScaffoldFeatureController buildSnackBar(
  BuildContext context,
  String text,
  Color color,
) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text, style: TextStyle(color: Colors.white)),
      backgroundColor: color,
      duration: Duration(seconds: 4),
    ),
  );
}

LoadingDialog(BuildContext context) => showDialog(
  context: context,
  builder: (context) {
    return Center(child: CircularProgressIndicator());
  },
);

Widget EditProfileButton(
  BuildContext context,
  String Navigation,
  String text, {
  void Function()? onpressed,
}) {
  return ElevatedButton(
    onPressed:
        onpressed ??
        () {
          Navigator.pushNamed(context, Navigation);
        },
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      side: BorderSide(color: MainColor),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(screenWidth(context) * 0.2),
      ),
    ),
    child: ralewayText(text, context, fontSize: screenWidth(context) * 0.04),
  );
}

Widget Error({String? text, required BuildContext context}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,

    children: [
      Text(
        text != null ? "Error while featch $text" : "Error occurred",
        style: TextStyle(
          color: Colors.red,
          fontSize: screenWidth(context) * 0.05,
        ),
      ),
      SizedBox(width: screenWidth(context) * 0.02),
      Image.asset(
        "lib/Core/Assets/Error.png",
        width: screenWidth(context) * 0.14,
      ),
    ],
  );
}

Widget NotFound({
  required String text,
  required BuildContext context,
  double? fontSize,
  double? iconsize,
  Color? textcolor,
}) {
  return Center(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "No $text",
          style: TextStyle(
            color: textcolor ?? MainColor,
            fontSize: fontSize ?? screenWidth(context) * 0.05,
          ),
        ),
        SizedBox(width: screenWidth(context) * 0.02),

        Image.asset(
          "lib/Core/Assets/NotFound.png",
          width: iconsize ?? screenWidth(context) * 0.14,
        ),
      ],
    ),
  );
}

Widget backButton(BuildContext context) {
  return IconButton(
    icon: Icon(
      Icons.arrow_back_ios,
      color: MainColor,
      size: screenWidth(context) * 0.085,
    ),
    onPressed: () => Navigator.pop(context),
  );
}

double CalcuRating(List rateing) {
  double u = 0;
  for (var i in rateing) {
    u += i;
  }
  u = u / rateing.length;

  return u;
}

Widget buildStarRating(
  double rating,
  BuildContext context,
  MainAxisAlignment mainAxisAlignment,
) {
  int fullStars = rating.floor();
  bool hasHalfStar =
      (rating - fullStars) >= 0.25 && (rating - fullStars) < 0.75;
  int totalStars = 5; // Total number of stars (e.g., out of 5)

  return Row(
    mainAxisAlignment: mainAxisAlignment,
    crossAxisAlignment: CrossAxisAlignment.end,
    children: List.generate(totalStars, (index) {
      if (index < fullStars) {
        return Icon(
          Icons.star,
          color: Colors.amber,
          size: MediaQuery.of(context).size.width * 0.049,
        );
      } else if (index == fullStars && hasHalfStar) {
        return Icon(
          Icons.star_half,
          color: Colors.amber,
          size: MediaQuery.of(context).size.width * 0.049,
        );
      } else {
        return Icon(
          Icons.star_border,
          color: Colors.amber,
          size: MediaQuery.of(context).size.width * 0.049,
        );
      }
    }),
  );
}
