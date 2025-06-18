import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradutionproject/Core/Consts/Constants.dart';
import 'package:gradutionproject/Features/DoctorFeatures/DoctorFeaturesCubit/DoctorFeaturesCubit.dart';
import 'package:gradutionproject/Features/DoctorFeatures/DoctorVideoCall/SessionDiagnosis.dart';
import 'package:gradutionproject/Features/PatientFeatures/IdleDoctor/ReviewDoctorDialog.dart';
import 'package:gradutionproject/Features/PatientFeatures/PatientFeaturesCubit/PatientFeaturesCubit.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({super.key});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  late RtcEngine _engine;
  int? _remoteUid;
  bool _localUserJoined = false;
  bool _isMuted = false;
  bool _videoDisabled = false;

  @override
  void initState() {
    super.initState();
    initAgora();
    startRepeatingEverySecond();
  }

  @override
  void dispose() {
    _timer?.cancel();

    _dispose();
    super.dispose();
  }

  Timer? _timer;

  void startRepeatingEverySecond() {
    var cubit = BlocProvider.of<PatientFeaturesCubit>(context);
    var cubitt = BlocProvider.of<DoctorFeaturesCubit>(context);

    _timer?.cancel(); // إلغاء أي مؤقت سابق

    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      print("⏱ Tick at: ${cubit.count}");

      if (cubit.isSessionStarted == false) {
        _timer!.cancel();
        cubit.isSessionStarted = false;
        //   await cubit.getClosestSessionDate();
        //  cubit.startTimer();
        //   await cubitt.getCalenderDates()
        //

        await _engine.leaveChannel();
        await _engine.release();

        Navigator.pop(context);

        supabase.auth.currentUser!.userMetadata!["doctoraccount"]
            ? showDoctorMedicalDialog(context, "")
            : showRatingDialog(context);
      } else {
        cubitt.Diagnisisdate = cubit.closeSession;
      }
    });
  }

  Future<void> initAgora() async {
    await [Permission.microphone, Permission.camera].request();

    _engine = createAgoraRtcEngine();
    await _engine.initialize(
      const RtcEngineContext(
        appId: appId,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ),
    );

    await _engine.enableVideo();
    await _engine.startPreview();
    await _engine.joinChannel(
      token: token,
      channelId: channel,
      options: const ChannelMediaOptions(
        autoSubscribeVideo: true,
        autoSubscribeAudio: true,
        publishCameraTrack: true,
        publishMicrophoneTrack: true,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
      uid: 0,
    );

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("Local user ${connection.localUid} joined");
          setState(() => _localUserJoined = true);
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("Remote user $remoteUid joined");
          setState(() => _remoteUid = remoteUid);
        },
        onUserOffline: (
          RtcConnection connection,
          int remoteUid,
          UserOfflineReasonType reason,
        ) {
          debugPrint("Remote user $remoteUid left");
          setState(() => _remoteUid = null);
        },
      ),
    );
  }

  Future<void> _dispose() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

  void _toggleMute() {
    setState(() => _isMuted = !_isMuted);
    _engine.muteLocalAudioStream(_isMuted);
  }

  void _toggleVideo() {
    setState(() => _videoDisabled = !_videoDisabled);
    _engine.muteLocalVideoStream(_videoDisabled);
  }

  void _switchCamera() {
    _engine.switchCamera();
  }

  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: const RtcConnection(channelId: channel),
        ),
      );
    } else {
      return const Center(
        child: Text(
          'Waiting for remote user to join...',
          style: TextStyle(color: Colors.white),
        ),
      );
    }
  }

  Widget _localPreview() {
    return SizedBox(
      width: 100,
      height: 150,
      child: Center(
        child:
            _localUserJoined
                ? AgoraVideoView(
                  controller: VideoViewController(
                    rtcEngine: _engine,
                    canvas: const VideoCanvas(uid: 0),
                  ),
                )
                : const CircularProgressIndicator(),
      ),
    );
  }

  Widget _controlButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    required String heroTag,
  }) {
    return FloatingActionButton(
      heroTag: heroTag,
      backgroundColor: color,
      onPressed: onPressed,
      child: Icon(icon, color: Colors.black),
    );
  }

  Widget _buildControls() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _controlButton(
              icon: _isMuted ? Icons.mic_off : Icons.mic,
              color: _isMuted ? Colors.red : Colors.white,
              onPressed: _toggleMute,
              heroTag: 'micButton',
            ),
            _controlButton(
              icon: _videoDisabled ? Icons.videocam_off : Icons.videocam,
              color: _videoDisabled ? Colors.red : Colors.white,
              onPressed: _toggleVideo,
              heroTag: 'videoButton',
            ),
            _controlButton(
              icon: Icons.switch_camera,
              color: Colors.white,
              onPressed: _switchCamera,
              heroTag: 'switchCameraButton',
            ),
            _controlButton(
              icon: Icons.call_end,
              color: Colors.red,
              onPressed: () async {
                await _dispose();
                Navigator.pop(context);
              },
              heroTag: 'endCallButton',
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Remote video with Hero animation
            Hero(tag: 'remoteVideoHero', child: _remoteVideo()),

            // Local preview with Hero animation
            Align(
              alignment: Alignment.topLeft,
              child: Hero(tag: 'localVideoHero', child: _localPreview()),
            ),

            // Control buttons (no Hero widgets here)
            _buildControls(),
          ],
        ),
      ),
    );
  }
}
