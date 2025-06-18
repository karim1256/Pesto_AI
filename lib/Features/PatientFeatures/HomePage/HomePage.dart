import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradutionproject/Core/BottomBar/bottombar.dart';
import 'package:gradutionproject/Core/Consts/Constants.dart';
import 'package:gradutionproject/Core/Consts/ResponsiveUI.dart';
import 'package:gradutionproject/Core/Consts/Theme.dart';
import 'package:gradutionproject/Core/Widgets/Drawer.dart';
import 'package:gradutionproject/Core/Widgets/VideoCall.dart';
import 'package:gradutionproject/Core/Widgets/Loading.dart';
import 'package:gradutionproject/Core/Widgets/Widgets.dart';
import 'package:gradutionproject/Features/PatientFeatures/HomePage/Model.dart';
import 'package:gradutionproject/Features/PatientFeatures/IdleDoctor/DoctorView.dart';
import 'package:gradutionproject/Features/PatientFeatures/Models/PatientModel.dart';
import 'package:gradutionproject/Features/PatientFeatures/PatientFeaturesCubit/PatientFeaturesCubit.dart';
import 'package:gradutionproject/Features/PatientFeatures/PatientFeaturesCubit/PatientFeaturesStates.dart';
import 'package:gradutionproject/Features/PatientFeatures/PatientProfilePage/PatientProfilePage.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class PatientHomepage extends StatefulWidget {
  const PatientHomepage({super.key});

  @override
  State<PatientHomepage> createState() => _PatientHomepageState();
}

class _PatientHomepageState extends State<PatientHomepage> {
  DateTime? closestDate;
  Timer? _timer;
  StreamSubscription? _subscription;

  @override
  void initState() {
     var cubit = BlocProvider.of<PatientFeaturesCubit>(context);
    super.initState();
    _subscription = InternetConnection().onStatusChange.listen((status) {
      switch (status) {
        case InternetStatus.connected:
          setState(() {
            
           cubit.isConnected(true,context);
            print(
              "-------------------------------Conected ${cubit.Connected}-------------------------------",
            );
          });
          break;
        case InternetStatus.disconnected:
          setState(() {
           cubit.isConnected(false,context);

            print(
              "-------------------------------Not Conected   ${cubit.Connected}-------------------------------",
            );
          });
          break;
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getClosestSessionDate();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _timer?.cancel();

    super.dispose();
  }

  Future<void> getClosestSessionDate() async {
    final accountType =
        supabase.auth.currentUser?.userMetadata?["doctoraccount"] == true
            ? 'doctor_id'
            : 'patient_id';

    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    try {
      final response = await supabase
          .from('Sessions')
          .select('date')
          .eq(accountType, userId);

      final sessionsDates =
          (response as List).map((e) => e['date'] as String).toList();
      getClosestDateFromList(sessionsDates);
    } catch (e) {
      debugPrint("Error getting sessions: $e");
    }
  }

  void getClosestDateFromList(List<String> dates) {
    if (dates.isEmpty) return;

    final now = DateTime.now();
    final parsedDates =
        dates
            .map((e) => DateTime.parse(e))
            .where((date) => date.isAfter(now))
            .toList();

    if (parsedDates.isEmpty) return;

    parsedDates.sort((a, b) => a.difference(now).compareTo(b.difference(now)));
    setState(() {
      closestDate = parsedDates.first;
    });
    startTimer();
  }

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (closestDate != null && DateTime.now().isAfter(closestDate!)) {
        BlocProvider.of<PatientFeaturesCubit>(context, listen: true).Navigate();
        timer.cancel();
      }
    });
  }

  // void _navigateToVideoCall() {
  //   if (!mounted) return;

  //   Navigator.of(context).push(
  //     PageRouteBuilder(
  //       pageBuilder: (context, animation, secondaryAnimation) => const VideoCallScreen(),
  //       transitionsBuilder: (context, animation, secondaryAnimation, child) {
  //         return FadeTransition(
  //           opacity: animation,
  //           child: child,
  //         );
  //       },
  //       transitionDuration: const Duration(milliseconds: 300),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<PatientFeaturesCubit>(context, listen: true);
    return Scaffold(
      drawer: const CustomDrawer(),

      bottomNavigationBar: CustomBottomBar(),
      body:
         cubit.Connected == false
              ? Center(
                child: Image.asset(
                  'lib/Core/Assets/NoWifi.png',
                  width: screenWidth(context),
                  height: screenHeight(context),
                ),
              )
              : cubit.doctors.isNotEmpty
              ? BlocConsumer<PatientFeaturesCubit, PatientFeaturesStates>(
                listener: (context, state) {
                  if (state is FavouriteUpdateFailureState) {
                    buildSnackBar(context, state.Message, Colors.red);
                  }

                  if (cubit.Nav == true) {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder:
                            (context, animation, secondaryAnimation) =>
                                VideoCallScreen(),
                      ),
                    );
                    cubit.Navigate();
                  }

                  if (state is ModelFailureState) {
                    buildSnackBar(context, state.Message, Colors.red);
                  } else if (state is ModelSucceedState) {
                    showPredictionDialog(context, cubit.result);
                  }
                },
                builder: (context, state) {
                  return SingleChildScrollView(
                    child: SafeArea(
                      top: false,
                      left: false,
                      right: false,
                      bottom: true,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth(context) * 0.04,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: bodyHeight(context) * 0.06),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Welcome back",
                                  style: TextStyle(
                                    fontSize: screenWidth(context) * 0.05,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                ),
                                Builder(
                                  builder: (context) {
                                    return IconButton(
                                      onPressed: () async {
                                        await BlocProvider.of<
                                          PatientFeaturesCubit
                                        >(context).fetchImageUrl();

                                        Scaffold.of(context).openDrawer();
                                      },
                                      icon: CircleAvatar(
                                        radius: screenWidth(context) * 0.052,
                                        backgroundImage: AssetImage(
                                          'lib/Core/Assets/drawer.png',
                                        ),
                                        backgroundColor: Colors.grey[200],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            Text(
                              "${supabase.auth.currentUser!.userMetadata!["first_name"]} !",
                              style: TextStyle(
                                fontSize: screenWidth(context) * 0.05,
                                fontWeight: FontWeight.bold,
                                color: MainColor,
                              ),
                            ),
                            SizedBox(height: bodyHeight(context) * 0.035),
                            SizedBox(
                              height: screenHeight(context) * 0.072,
                              child: TextField(
                                readOnly: true,
                                onTap: () {
                                  Navigator.pushNamed(context, 'DoctorSearch');
                                },
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: MainColor,
                                    size: screenWidth(context) * 0.07,
                                  ),
                                  hintText: "Search a Doctor",
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: bodyHeight(context) * 0.03),
                            Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(
                                    screenWidth(context) * 0.04,
                                  ),
                                  decoration: BoxDecoration(
                                    color: MainColor,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Ai Medical Check!",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize:
                                              screenWidth(context) * 0.045,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      SizedBox(
                                        width: screenWidth(context) * 0.6,
                                        child: Text(
                                          "Keeping an eye on your Pets medical condition by AI through your phone camera",
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize:
                                                screenWidth(context) * 0.032,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                        ),
                                        onPressed: () {
                                          cubit.pickImageAndPredict();
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "Check now",
                                              style: TextStyle(
                                                color: MainColor,
                                              ),
                                            ),
                                            Icon(
                                              Icons.arrow_forward,
                                              color: MainColor,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Positioned(
                                  right: 0,
                                  bottom: screenWidth(context) * -0.05,
                                  child: Image.asset(
                                    'lib/Core/Assets/ai.png',
                                    width: screenWidth(context) * 0.4,
                                    height: screenWidth(context) * 0.5,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: bodyHeight(context) * 0.03),
                            Text(
                              "Our Top Consultants",
                              style: TextStyle(
                                fontSize: screenWidth(context) * 0.045,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: bodyHeight(context) * 0.008),
                            SizedBox(
                              height: bodyHeight(context) * 0.131,
                              width: double.infinity,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: cubit.doctors.length,
                                itemBuilder: (context, index) {
                                  return DoctorCard(
                                    image: cubit.doctors[index].image,
                                    name: cubit.doctors[index].name,
                                    reviewsnum:
                                        cubit.doctors[index].raviews.length
                                            .toString(),
                                    rating: cubit.doctors[index].rateing,
                                    context: context,
                                    id: cubit.doctors[index].id,
                                    experiance: cubit.doctors[index].experience,
                                    certificate:
                                        cubit.doctors[index].cartificates,
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: bodyHeight(context) * 0.01),
                            Text(
                              "Past doctors",
                              style: TextStyle(
                                fontSize: screenWidth(context) * 0.045,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height:
                                  cubit.PastDoctors.isEmpty
                                      ? bodyHeight(context) * 0.06
                                      : bodyHeight(context) * 0.008,
                            ),

                            cubit.PastDoctors.isEmpty &&
                                    cubit.seccuss == false &&
                                    cubit.load == true
                                ? Center(child: Loading())
                                : cubit.PastDoctors.isEmpty &&
                                    cubit.seccuss == true &&
                                    cubit.load == false
                                ? Center(
                                  child: NotFound(
                                    text: "Doctors",
                                    context: context,
                                    fontSize: screenWidth(context) * 0.06,
                                  ),
                                )
                                : cubit.faild == true
                                ? Center(child: Error(context: context))
                                : SizedBox(
                                  height: bodyHeight(context) * 0.131,
                                  width: double.infinity,

                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: cubit.PastDoctors.length,
                                    itemBuilder: (context, index) {
                                      return DoctorCard(
                                        image: cubit.PastDoctors[index].image,
                                        name: cubit.PastDoctors[index].name,
                                        reviewsnum:
                                            cubit
                                                .PastDoctors[index]
                                                .raviews
                                                .length
                                                .toString(),
                                        rating:
                                            cubit.PastDoctors[index].rateing,
                                        context: context,
                                        id: cubit.PastDoctors[index].id,
                                        experiance:
                                            cubit.PastDoctors[index].experience,
                                        certificate:
                                            cubit
                                                .PastDoctors[index]
                                                .cartificates,
                                      );
                                    },
                                  ),
                                ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
              : Loading(),
    );
  }
}

class DoctorCard extends StatelessWidget {
  final String name;
  final String reviewsnum;
  final List rating;
  final BuildContext context;
  final bool? view;
  final bool? search;
  final bool? pop;

  final String id;
  final String? experiance;
  final String? certificate;
  final String? image;

  const DoctorCard({
    super.key,
    required this.name,
    required this.reviewsnum,
    required this.rating,
    required this.context,
    this.view,
    this.pop,
    required this.id,
    required this.experiance,
    required this.certificate,
    this.search,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<PatientFeaturesCubit>(context, listen: true);

    double width() {
      double width = 0;
      search != null
          ? width = screenWidth(context) * 1.8
          : view == null
          ? width = screenWidth(context) * 0.73
          : width = screenWidth(context) * 0.86;
      return width;
    }

    double height =
        view == null
            ? screenHeight(context) * 0.135
            : screenHeight(context) * 0.175;

    return Hero(
      tag: 'doctor-card-$id-${DateTime.now().millisecondsSinceEpoch}',
      child: MaterialButton(
        onPressed:
            view != null
                ? null
                : () {
                  cubit.getDateById(id);

                  pop == null
                      ? Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder:
                              (BuildContext context) => Doctorview(
                                name,
                                reviewsnum,
                                rating,
                                id,
                                view,
                                experiance!,
                                certificate!,
                                image!,
                              ),
                        ),
                      )
                      : Navigator.pop(context);
                },
        child: SizedBox(
          width: width(),
          height: height,
          child: Card(
            color:
                view != null ? const Color.fromARGB(149, 255, 254, 254) : null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            //  elevation: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: screenWidth(context) * 0.17,
                    height: screenWidth(context) * 0.17,
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: MainColor, width: 2),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                        image == null || image!.isEmpty
                            ? emptyPic
                            : image!.trim(),
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) =>
                                Icon(Icons.person, size: 40),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  // Info column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: screenWidth(context) * 0.042,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        // SizedBox(height: screenHeight(context) * 0.001),
                        Text(
                          "$reviewsnum Review",
                          style: TextStyle(
                            color: MainColor,
                            fontSize: screenWidth(context) * 0.033,
                          ),
                          maxLines: 1,
                        ),
                        //  SizedBox(height: 4),
                        Align(
                          alignment: Alignment.topLeft,
                          child: buildStarRating(
                            CalcuRating(rating),
                            context,
                            MainAxisAlignment.start,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Favourite icon
                  IconButton(
                    onPressed: () => cubit.AddOrDeleteFavourite(id),
                    icon: Icon(
                      cubit.Is_Favourite.contains(id)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color:
                          cubit.Is_Favourite.contains(id)
                              ? Colors.red
                              : MainColor,
                      size: screenWidth(context) * 0.06,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PatientCard extends StatelessWidget {
  final String name;
  final String image;
  final PatientModel pm;

  const PatientCard({
    super.key,
    required this.name,
    required this.image,
    required this.pm,
  });

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<PatientFeaturesCubit>(context, listen: true);
    return Container(
      width: screenWidth(context) * 0.65, // Slightly wider
      height: screenHeight(context) * 0.132, // Slightly taller
      margin: const EdgeInsets.all(8), // More spacing around cards
      child: MaterialButton(
        padding: EdgeInsets.zero,
        onPressed: () async {
          cubit.pickedImage != null;
          cubit.imageUrl = image;
          cubit.patient = pm;
          await cubit.selectAllSession();
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder:
                  (BuildContext context) =>
                      PatientprofileVieawpage(patient: pm),
            ),
          );
        },
        child: Card(
          elevation: 4, // More pronounced shadow
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: BorderSide(
              color: MainColor, // Violet border
              width: 1.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(9), // More internal padding
            child: Row(
              children: [
                Container(
                  width: screenWidth(context) * 0.14, // Larger image
                  height: screenWidth(context) * 0.14,
                  decoration: BoxDecoration(
                    color: Colors.grey[200], // Lighter background
                    borderRadius: BorderRadius.circular(40),
                    // border: Border.all(
                    //   color: MainColor, // Violet border for image
                    //   width: 1.5,
                    // ),
                    image: DecorationImage(
                      image: NetworkImage(
                        image.isEmpty ? emptyPic : image.trim(),
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12), // More spacing
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize:
                              screenWidth(context) * 0.045, // Slightly larger
                          fontWeight: FontWeight.bold,
                          color: MainColor, // Dark violet text
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: MainColor, // Violet icon
                  size: screenWidth(context) * 0.09,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
