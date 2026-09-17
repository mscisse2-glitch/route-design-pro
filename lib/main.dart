import 'package:flutter/material.dart';

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
              'Bienvenue dans votre logiciel de conception routière.',
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

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes projets'),
      ),
      body: Center(
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NewProjectPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Nouveau projet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NewProjectPage extends StatefulWidget {
  const NewProjectPage({super.key});

  @override
  State<NewProjectPage> createState() => _NewProjectPageState();
}

class _NewProjectPageState extends State<NewProjectPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController locationController =
      TextEditingController();

  final TextEditingController ownerController =
      TextEditingController();

  final TextEditingController lengthController =
      TextEditingController();

  final TextEditingController speedController =
      TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    locationController.dispose();
    ownerController.dispose();
    lengthController.dispose();
    speedController.dispose();
    super.dispose();
  }

  void createProject() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Projet créé avec succès !'),
        ),
      );

      Navigator.pop(context);
    }
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
                  if (value == null || value.trim().isEmpty) {
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
                    'Créer le projet',
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
