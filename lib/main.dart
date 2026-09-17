import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const RouteDesignPro());
}

class RouteDesignPro extends StatelessWidget {
  const RouteDesignPro({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Route Design Pro',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

// =====================================================
// ACCUEIL
// =====================================================

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Route Design Pro',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Conception des projets routiers',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Votre logiciel de conception et d’étude des routes.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),

            _moduleCard(
              context,
              icon: Icons.folder_open,
              title: 'Mes projets',
              subtitle: 'Créer et gérer les projets routiers',
              action: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProjectsPage(),
                  ),
                );
              },
            ),

            _moduleCard(
              context,
              icon: Icons.location_on,
              title: 'Topographie',
              subtitle: 'Points XYZ et données du terrain',
            ),

            _moduleCard(
              context,
              icon: Icons.alt_route,
              title: 'Tracé en plan',
              subtitle: 'Axe, alignements et courbes',
            ),

            _moduleCard(
              context,
              icon: Icons.show_chart,
              title: 'Profil en long',
              subtitle: 'Terrain naturel et ligne rouge',
            ),

            _moduleCard(
              context,
              icon: Icons.straighten,
              title: 'Profils en travers',
              subtitle: 'Chaussée, talus et fossés',
            ),

            _moduleCard(
              context,
              icon: Icons.construction,
              title: 'Terrassements',
              subtitle: 'Déblais, remblais et cubatures',
            ),

            _moduleCard(
              context,
              icon: Icons.water_drop,
              title: 'Assainissement',
              subtitle: 'Fossés, buses et dalots',
            ),

            _moduleCard(
              context,
              icon: Icons.account_tree,
              title: 'Chaussée',
              subtitle: 'Dimensionnement de la structure',
            ),

            _moduleCard(
              context,
              icon: Icons.calculate,
              title: 'Métré & Devis',
              subtitle: 'Quantités, prix et estimation',
            ),

            _moduleCard(
              context,
              icon: Icons.description,
              title: 'Rapports',
              subtitle: 'Générer les documents du projet',
            ),
          ],
        ),
      ),
    );
  }

  Widget _moduleCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? action,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(icon),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: action ??
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$title : module en préparation'),
                ),
              );
            },
      ),
    );
  }
}

// =====================================================
// MES PROJETS
// =====================================================

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  List<Map<String, dynamic>> projects = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadProjects();
  }

  Future<void> loadProjects() async {
    final prefs = await SharedPreferences.getInstance();

    final savedProjects = prefs.getStringList('projects') ?? [];

    final loadedProjects = savedProjects
        .map((project) {
          try {
            return Map<String, dynamic>.from(
              jsonDecode(project),
            );
          } catch (_) {
            return <String, dynamic>{};
          }
        })
        .where((project) => project.isNotEmpty)
        .toList();

    setState(() {
      projects = loadedProjects;
      loading = false;
    });
  }

  Future<void> deleteProject(int index) async {
    final prefs = await SharedPreferences.getInstance();

    projects.removeAt(index);

    final savedProjects =
        projects.map((project) => jsonEncode(project)).toList();

    await prefs.setStringList('projects', savedProjects);

    setState(() {});

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Projet supprimé.'),
      ),
    );
  }

  Future<void> openNewProject() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NewProjectPage(),
      ),
    );

    if (result == true) {
      await loadProjects();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes projets'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: openNewProject,
        icon: const Icon(Icons.add),
        label: const Text('Nouveau projet'),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : projects.isEmpty
              ? _emptyProjects()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: projects.length,
                  itemBuilder: (context, index) {
                    final project = projects[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.route),
                        ),
                        title: Text(
                          project['name'] ?? 'Projet sans nom',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          '${project['location'] ?? 'Localisation inconnue'}'
                          '\nLongueur : ${project['length'] ?? '-'} km',
                        ),
                        isThreeLine: true,
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            deleteProject(index);
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Widget _emptyProjects() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.folder_open,
              size: 80,
            ),
            const SizedBox(height: 20),
            const Text(
              'Aucun projet routier',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Commencez par créer votre premier projet.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            FilledButton.icon(
              onPressed: openNewProject,
              icon: const Icon(Icons.add),
              label: const Text('Nouveau projet'),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// NOUVEAU PROJET
// =====================================================

class NewProjectPage extends StatefulWidget {
  const NewProjectPage({super.key});

  @override
  State<NewProjectPage> createState() => _NewProjectPageState();
}

class _NewProjectPageState extends State<NewProjectPage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final locationController = TextEditingController();
  final ownerController = TextEditingController();
  final lengthController = TextEditingController();
  final speedController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    locationController.dispose();
    ownerController.dispose();
    lengthController.dispose();
    speedController.dispose();
    super.dispose();
  }

  Future<void> createProject() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    final project = {
      'name': nameController.text.trim(),
      'location': locationController.text.trim(),
      'owner': ownerController.text.trim(),
      'length': lengthController.text.trim(),
      'speed': speedController.text.trim(),
      'createdAt': DateTime.now().toIso8601String(),
    };

    final savedProjects = prefs.getStringList('projects') ?? [];

    savedProjects.add(jsonEncode(project));

    await prefs.setStringList(
      'projects',
      savedProjects,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Projet enregistré avec succès !'),
      ),
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouveau projet'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Informations du projet',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 24),

              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nom du projet',
                  hintText: 'Exemple : Route Bangui - Damara',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.route),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Veuillez saisir le nom du projet';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: locationController,
                decoration: const InputDecoration(
                  labelText: 'Localisation',
                  hintText: 'Exemple : Bangui',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: ownerController,
                decoration: const InputDecoration(
                  labelText: 'Maître d’ouvrage',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.business),
                ),
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: lengthController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Longueur de la route (km)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.straighten),
                ),
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: speedController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Vitesse de référence (km/h)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.speed),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.icon(
                  onPressed: createProject,
                  icon: const Icon(Icons.save),
                  label: const Text(
                    'Enregistrer le projet',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
