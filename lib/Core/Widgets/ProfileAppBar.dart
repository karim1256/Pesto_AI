import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradutionproject/Core/Consts/Constants.dart';
import 'package:gradutionproject/Core/Consts/ResponsiveUI.dart';
import 'package:gradutionproject/Core/Consts/Theme.dart';
import 'package:gradutionproject/Features/PatientFeatures/PatientFeaturesCubit/PatientFeaturesCubit.dart';

Widget ProfileAppBar(
  BuildContext context, {
  bool backbutton = false,
  bool notAllowed = false,
  double height = 0.13,
  double width = 0.9,
  double toppic = 0.05,
}) {
  final cubit = BlocProvider.of<PatientFeaturesCubit>(context, listen: true);
  final s = supabase.auth.currentUser!.userMetadata!;
  final account = s["doctoraccount"];

  return Stack(
    clipBehavior: Clip.none,
    children: [
      // Background AppBar
      Container(
        width: screenWidth(context) * width,
        height: bodyHeight(context) * height,
        decoration: BoxDecoration(
          color: MainColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(screenWidth(context) * 0.12),
            bottomRight: Radius.circular(screenWidth(context) * 0.12),
          ),
        ),
        //  child:

        //  Stack(
        //   alignment: Alignment.center,
        //   children: [
        // Back Button
        // Positioned(
        //   left: 10,
        //   child: IconButton(
        //     icon: Icon(Icons.arrow_back, color: Colors.white),
        //     onPressed: () => Navigator.pop(context),
        //   ),
        // ),
        // Title
        // ralewayText(
        //   "${s["first_name"]} Profile",
        //   context,
        //   fontSize: screenWidth(context) * 0.06,
        //   fontWeight: FontWeight.bold,
        //   color: Colors.white,
        // ),
        //   ],
        // ),
      ),

      MaterialButton(
        child:
            backbutton
                ? Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: screenWidth(context) * 0.07,
                )
                : null,

        onPressed: () => Navigator.pop(context),
      ),
      // Profile Image
      Positioned(
        top: bodyHeight(context) * toppic,
        left: screenWidth(context) * 0.3,
        child: ProfilePic(context, notAllowed: notAllowed),
      ),
    ],
  );
}

Widget ProfilePic(BuildContext context, {bool notAllowed = false}) {
  final cubit = BlocProvider.of<PatientFeaturesCubit>(context, listen: true);

  return MaterialButton(
    onPressed: () {
      showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        backgroundColor: Colors.white,
        builder: (_) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (cubit.imageUrl != null) ...[
                  ListTile(
                    leading: Icon(Icons.remove_red_eye, color: Colors.blue),
                    title: Text('View Image'),
                    onTap: () {
                      Navigator.pop(context);
                      cubit.viewImage(cubit.imageUrl!, context);
                    },
                  ),

                  notAllowed
                      ? SizedBox(height: 0)
                      : ListTile(
                        leading: Icon(Icons.delete_forever, color: Colors.red),
                        title: Text('Delete Image'),
                        onTap: () async {
                          Navigator.pop(context);
                          await cubit.deleteImage();
                        },
                      ),
                ],
                notAllowed
                    ? SizedBox(height: 0)
                    : ListTile(
                      leading: Icon(Icons.image_outlined, color: Colors.teal),
                      title: Text(
                        cubit.imageUrl != null
                            ? 'Update Image'
                            : 'Upload Image',
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        cubit.pickImage();
                      },
                    ),
              ],
            ),
          );
        },
      );
    },
    child: Container(
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 4)),
        ],
      ),
      child: CircleAvatar(
        radius: screenWidth(context) * 0.15,
        backgroundColor: Colors.grey[300],
        backgroundImage:
            // cubit.pickedImage != null
            //     ? FileImage(File(cubit.pickedImage!.path))
            //     :
            (cubit.imageUrl != null
                    ? NetworkImage(cubit.imageUrl!)
                    : NetworkImage(emptyPic))
                as ImageProvider?,
        child:
            (cubit.pickedImage == null && cubit.imageUrl == null)
                ? Icon(
                  Icons.camera_alt_rounded,
                  size: screenWidth(context) * 0.08,
                  color: Colors.white,
                )
                : null,
      ),
    ),
  );
}
