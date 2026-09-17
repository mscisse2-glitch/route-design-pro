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
        onTap: () {
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
