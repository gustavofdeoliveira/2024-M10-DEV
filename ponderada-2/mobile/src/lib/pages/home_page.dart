import 'package:flutter/material.dart';
import 'package:mobile/controller/home_controller.dart';
import 'package:mobile/pages/edit_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = HomeController();

  _start() {
    return Container();
  }

  Future<void> refreshList() async {
    await Future.delayed(Duration(seconds: 2)); // Simulate network delay

    setState(() {
      controller.start();
      // Reversing items to simulate data change
      controller.tags = controller.tags.reversed.toList();
    });
  }

  _sucess() {
    return RefreshIndicator(
      onRefresh: refreshList,
      child: ListView.builder(
        itemCount: controller.tags.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Tag: ${controller.tags[index].name}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min, // Importante para evitar overflow
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    // Chamar a função de editar
                    // editTag(controller.tags[index]);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditPage(
                            id: controller.tags[index].id ?? 0,
                            name: controller.tags[index].name ?? '',
                            description:
                                controller.tags[index].description ?? ''),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    // Chamar a função de excluir
                    controller.delete(context, controller.tags[index].id);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  _error() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          setState(() {});
        },
        child: const Text('Try again'),
      ),
    );
  }

  _loading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  stateManagement(state) {
    switch (state) {
      case HomeState.start:
        return _start();
      case HomeState.loading:
        return _loading();
      case HomeState.success:
        return _sucess();
      case HomeState.error:
        return _error();
      default:
        return _start();
    }
  }

  @override
  void initState() {
    super.initState();
    controller.start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tags Page'),
      ),
      body: AnimatedBuilder(
        animation: controller.state,
        builder: (context, child) {
          return stateManagement(controller.state.value);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/create-tag');
        },
      ),
    );
  }
}
