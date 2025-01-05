import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notificator1/cubit/requisiteCubit.dart';

import '../Cubit/requisiteState.dart';

class RequisitesListScreen extends StatefulWidget {
  @override
  _RequisitesListScreenState createState() => _RequisitesListScreenState();
}

class _RequisitesListScreenState extends State<RequisitesListScreen> {
  Map<int, List<Map<String, String>>> _groupedRequisites = {};

  @override
  void initState() {
    super.initState();
    context.read<RequisiteCubit>().loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Список реквизитов',style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF3D63AE),
        toolbarHeight: 103.5,
      ),
      body: BlocBuilder<RequisiteCubit, RequisiteState>(
        builder: (context, state) {
          if (state is RequisiteLoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is RequisiteLoadedState) {
            final requisitesList = state.data.data ?? [];
            _groupedRequisites = {};
            for (var item in requisitesList) {
              final id = item.id ?? 0;
              if (!_groupedRequisites.containsKey(id)) {
                _groupedRequisites[id] = [];
              }
              _groupedRequisites[id]?.add({
                'type': item.type ?? '',
                'requisite': item.requisite ?? '',
              });
            }
            return ListView.builder(
              itemCount: _groupedRequisites.keys.length,
              itemBuilder: (context, index) {
                final id = _groupedRequisites.keys.elementAt(index);
                final details = _groupedRequisites[id]!;
                return Card(
                  margin: EdgeInsets.all(8),
                  child: ExpansionTile(
                    tilePadding: EdgeInsets.symmetric(horizontal: 16.0),
                    title: Text('ID: $id', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF3D63AE))),
                    children: details.map((detail) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: ListTile(
                          title: Text(detail['requisite'] ?? '', style: TextStyle(fontSize: 16)),
                          subtitle: Text('Type: ${detail['type']}', style: TextStyle(color: Colors.grey[600])),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            );
          } else if (state is RequisiteErrorState) {
            return Center(child: Text('Не удалось загрузить реквизиты', style: TextStyle(color: Colors.red)));
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
