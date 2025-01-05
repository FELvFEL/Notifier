import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notificator1/cubit/requisiteCubit.dart';
import 'package:notificator1/requests/api.dart';

import '../Cubit/requisiteState.dart';

class SendListScreen extends StatefulWidget {
  @override
  _SendListScreenState createState() => _SendListScreenState();
}

class _SendListScreenState extends State<SendListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  TextEditingController _fromController = TextEditingController();
  List<int> _selectedRequisites = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Рассылка',style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF3D63AE),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: _buildTabBar(),
        ),
      ),
      body: Column(
        children: [
          _buildForm(),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      onTap: (index) {
        setState(() {
        });
      },
      tabs: [
        Tab(text: 'Email'),
        Tab(text: 'Push'),
        Tab(text: 'Tg'),
        Tab(text: 'Sms'),
      ],
      indicatorColor: Colors.white,
      labelColor: Colors.white,
      unselectedLabelColor: Colors.grey[400],
      labelStyle: TextStyle(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Заголовок',
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF3D63AE), width: 2.0),
              ),
            ),
          ),
          SizedBox(height: 8.0),
          TextField(
            controller: _contentController,
            decoration: InputDecoration(
              labelText: 'Содержание',
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF3D63AE), width: 2.0),
              ),
            ),
          ),
          SizedBox(height: 8.0),
          TextField(
            controller: _fromController,
            decoration: InputDecoration(
              labelText: 'От кого',
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF3D63AE), width: 2.0),
              ),
            ),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: _selectedRequisites.isNotEmpty ? _sendNotification : null,
            child: Text('Отправить', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF3D63AE),
              padding: EdgeInsets.symmetric(vertical: 13.0, horizontal: 25.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
          )
          ,
        ],
      ),
    );
  }

  Widget _buildContent() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildRequisitesList('email'),
        _buildRequisitesList('push'),
        _buildRequisitesList('tg'),
        _buildRequisitesList('sms'),
      ],
    );
  }

  Widget _buildRequisitesList(String type) {
    return BlocBuilder<RequisiteCubit, RequisiteState>(
      builder: (context, state) {
        if (state is RequisiteLoadingState) {
          return Center(child: CircularProgressIndicator());
        } else if (state is RequisiteLoadedState) {
          final requisitesList = state.data.data ?? [];
          final filteredList = requisitesList
              .where((requisite) => requisite.type == type)
              .toList();
          return Column(
            children: [
              Container(
                color: Colors.grey[400],
                child: CheckboxListTile(
                  title: Text(
                    'Выбрать всё',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  value: _selectedRequisites.length == filteredList.length,
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        _selectedRequisites = filteredList.map((requisite) => requisite.id!).toList();
                      } else {
                        _selectedRequisites.clear();
                      }
                    });
                  },
                  activeColor: Color(0xFF3D63AE),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: filteredList.length,
                  separatorBuilder: (context, index) => Divider(
                    color: Colors.grey[300],
                    thickness: 1,
                    height: 1,
                  ),
                  itemBuilder: (context, index) {
                    final requisite = filteredList[index];
                    return CheckboxListTile(
                      title: RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 16, color: Colors.black),
                          children: [
                            TextSpan(
                              text: "ID: ${requisite.id} ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: " ${requisite.requisite ?? ''}",
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      value: _selectedRequisites.contains(requisite.id),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            _selectedRequisites.add(requisite.id!);
                          } else {
                            _selectedRequisites.remove(requisite.id);
                          }
                        });
                      },
                      activeColor: Color(0xFF3D63AE),
                    );
                  },
                ),
              ),
            ],
          );
        } else if (state is RequisiteErrorState) {
          return Center(child: Text('Не удалось загрузить реквизиты', style: TextStyle(color: Colors.red)));
        } else {
          return Container();
        }
      },
    );
  }


  void _sendNotification() {
    if (_selectedRequisites.isEmpty) return;

    final requestPayload = {
      "type": _tabController.index == 0 ? "email" : _tabController.index == 1 ? "push" : _tabController.index == 2 ? "tg" : "sms",
      "content": _contentController.text,
      "title": _titleController.text,
      "to": _selectedRequisites,
      "from": _fromController.text,
      "isHistory": 1
    };

    sendNotification(requestPayload).then((response) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Уведомления отправлены"),
          duration: Duration(seconds: 2),
        ),
      );

      setState(() {
        _selectedRequisites.clear();
      });
    }).catchError((error) {
    });
  }


}
