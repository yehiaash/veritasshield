import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..fetchData(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Veritas Shield'),
        ),
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HomeLoaded) {
              return Center(child: Text(state.message));
            } else if (state is HomeError) {
              return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
            }
            return const Center(child: Text('Press the button to fetch data'));
          },
        ),
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton(
              onPressed: () => context.read<HomeCubit>().fetchData(),
              child: const Icon(Icons.refresh),
            );
          },
        ),
      ),
    );
  }
}
