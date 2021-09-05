import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasir_mri/bloc/absensi_bloc/absensi_bloc.dart';
import 'package:kasir_mri/bloc/pegawai_bloc/pegawai_bloc.dart';
import 'package:kasir_mri/repo/absensi_repo.dart';
import 'package:kasir_mri/repo/pegawai_repository.dart';
import 'package:kasir_mri/res/styling.dart';
import 'package:kasir_mri/ui/screens/absensi/absensi_body.dart';

class AbsensiScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Absensi"),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                  AppTheme.selectedTabBackgroundColor,
                  Colors.yellow
                ])),
          ),
        ),
        body: BlocProvider(create: (context) => PegawaiBloc(PegawaiRepositoryImpl()),child: BlocProvider(create: (context) => AbsensiBloc(AbsensiRepositoryImpl()),child: AbsensiBody()))
        
      );
  }
}
