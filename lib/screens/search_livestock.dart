import 'package:farm_up/bloc/authentication/authentication_bloc.dart';
import 'package:farm_up/bloc/get_livestock/get_livestock_bloc.dart';
import 'package:farm_up/screens/animal_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livestock_repository/livestock_repository.dart';
import 'package:user_repository/user_repository.dart';

class SearchLivestock extends StatefulWidget {
  @override
  _SearchLivestockState createState() => _SearchLivestockState();
}

class _SearchLivestockState extends State<SearchLivestock> {
  TextEditingController _searchController = TextEditingController();
  List<Livestock> _filteredLivestock = [];
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AuthenticationBloc(myUserRepository: FirebaseUserRepository()),
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state.status == AuthenticationStatus.authenticated) {
            return BlocProvider(
              create: (context) => GetLivestockBloc(
                livestockRepository: FirebaseLivestockRepository(),
              )..add(GetLivestock(state.user!.uid)),
              child: BlocBuilder<GetLivestockBloc, GetLivestockState>(
                builder: (context, state) {
                  if (state is GetLivestockLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is GetLivestockSuccess) {
                    List<Livestock> livestock = state.livestock;
                    _filteredLivestock = livestock.where((livestock) {
                      return livestock.name
                          .toLowerCase()
                          .contains(_searchController.text.toLowerCase());
                    }).toList();

                    return Scaffold(
                      appBar: AppBar(
                        title: Text('Livestock Search'),
                      ),
                      body: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              focusNode: _searchFocusNode,
                              controller: _searchController,
                              onChanged: (value) {
                                setState(() {});
                              },
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: _filteredLivestock.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(_filteredLivestock[index].name),
                                  onTap: () {
                                    // Handle the selection of a livestock item
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AnimalDetails(
                                                livestockId:
                                                    _filteredLivestock[index]
                                                        .id)));
                                    print(
                                        'Selected: ${_filteredLivestock[index].name}');
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (state is GetLivestockFailure) {
                    return Center(child: Text('Failed to load livestock'));
                  } else {
                    return Container();
                  }
                },
              ),
            );
          } else {
            return Center(child: Text('Not authenticated'));
          }
        },
      ),
    );
  }
}
