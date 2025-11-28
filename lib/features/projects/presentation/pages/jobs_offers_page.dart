import 'package:flutter/material.dart';
import 'package:artcollab_mobile/features/projects/presentation/pages/job_detail_page.dart';
import 'package:artcollab_mobile/shared/widgets/network_image_with_fallback.dart';
import 'package:artcollab_mobile/core/theme/app_theme.dart';
import 'package:artcollab_mobile/shared/widgets/elegant_card.dart';
import 'package:artcollab_mobile/shared/widgets/elegant_button.dart';

class JobsOffersPage extends StatefulWidget {
  const JobsOffersPage({super.key});

  @override
  State<JobsOffersPage> createState() => _JobsOffersPageState();
}

class _JobsOffersPageState extends State<JobsOffersPage> {
  String? selectedCategory;
  String? selectedMode;

  final List<Map<String, dynamic>> jobs = [
    {
      'title': 'Colaboración de creación de un cómic',
      'author': 'Carolina Suárez',
      'category': 'Infantil',
      'location': 'Lima',
      'mode': 'Presencial',
      'technique': 'Pintura digital',
      'budget': '\$500 - \$1,000',
      'image':
          'https://img.freepik.com/free-vector/comic-book-background-with-halftone-elements_23-2148835816.jpg',
      'time': 'Publicado hace 4 horas',
      'description':
          'Buscamos un colaborador para crear un cómic infantil de estilo colorido y expresivo. Ideal para artistas interesados en narrativa visual y personajes dinámicos.'
    },
    {
      'title': 'Creación de un libro infantil ilustrado',
      'author': 'Carolina Suárez',
      'category': 'Infantil',
      'location': 'Cusco',
      'mode': 'Remoto',
      'technique': 'Acuarela',
      'budget': '\$800 - \$1,500',
      'image':
          'https://img.freepik.com/free-vector/kid-reading-book-concept_23-2148515204.jpg',
      'time': 'Publicado hace 1 día',
      'description':
          'Se busca ilustrador para colaborar en un libro infantil con temática educativa. Ideal para quienes disfrutan de los colores suaves y composiciones cálidas.'
    },
  ];

  List<Map<String, dynamic>> get filteredJobs {
    return jobs.where((job) {
      final matchesCategory = selectedCategory == null || job['category'] == selectedCategory;
      final matchesMode = selectedMode == null || job['mode'] == selectedMode;
      return matchesCategory && matchesMode;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        children: [
          // Filtros elegantes
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingMedium),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: AppTheme.cardShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Filtrar Ofertas',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingMedium),
                Row(
                  children: [
                    Expanded(
                      child: _buildFilterDropdown(
                        label: 'Categoría',
                        value: selectedCategory,
                        items: ['Infantil', 'Digital', 'Literario', 'Ilustración'],
                        onChanged: (value) => setState(() => selectedCategory = value),
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingMedium),
                    Expanded(
                      child: _buildFilterDropdown(
                        label: 'Modalidad',
                        value: selectedMode,
                        items: ['Presencial', 'Remoto', 'Híbrido'],
                        onChanged: (value) => setState(() => selectedMode = value),
                      ),
                    ),
                  ],
                ),
                if (selectedCategory != null || selectedMode != null) ...[
                  const SizedBox(height: AppTheme.spacingSmall),
                  ElegantButton(
                    text: 'Limpiar Filtros',
                    type: ElegantButtonType.text,
                    size: ElegantButtonSize.small,
                    onPressed: () {
                      setState(() {
                        selectedCategory = null;
                        selectedMode = null;
                      });
                    },
                  ),
                ],
              ],
            ),
          ),

          // Lista de ofertas
          Expanded(
            child: filteredJobs.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: AppTheme.spacingMedium),
                        Text(
                          'No se encontraron ofertas',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingSmall),
                        Text(
                          'Intenta con otros filtros',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(AppTheme.spacingMedium),
                    itemCount: filteredJobs.length,
                    itemBuilder: (context, index) {
                      final job = filteredJobs[index];
                      return _buildJobCard(job);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
        border: Border.all(
          color: value != null ? AppTheme.primaryColor : Colors.grey.shade300,
          width: value != null ? 2 : 1,
        ),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: value != null ? AppTheme.primaryColor : AppTheme.textSecondaryColor,
            fontWeight: value != null ? FontWeight.w600 : FontWeight.normal,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingMedium,
            vertical: AppTheme.spacingSmall,
          ),
        ),
        items: items
            .map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(item),
                ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildJobCard(Map<String, dynamic> job) {
    return ElegantCard(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingMedium),
      padding: EdgeInsets.zero,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => JobDetailPage(job: job),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppTheme.borderRadiusMedium),
            ),
            child: Stack(
              children: [
                NetworkImageWithFallback(
                  imageUrl: job['image'],
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                // Overlay con gradiente
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(AppTheme.spacingMedium),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job['title'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppTheme.spacingXSmall),
                        Row(
                          children: [
                            const Icon(
                              Icons.person,
                              size: 16,
                              color: Colors.white70,
                            ),
                            const SizedBox(width: AppTheme.spacingXSmall),
                            Text(
                              job['author'],
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Badge de categoría
                Positioned(
                  top: AppTheme.spacingSmall,
                  right: AppTheme.spacingSmall,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingSmall,
                      vertical: AppTheme.spacingXSmall,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      job['category'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Información
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Detalles
                Row(
                  children: [
                    _buildInfoChip(
                      icon: Icons.location_on,
                      label: job['location'],
                      color: Colors.red,
                    ),
                    const SizedBox(width: AppTheme.spacingSmall),
                    _buildInfoChip(
                      icon: Icons.laptop,
                      label: job['mode'],
                      color: Colors.blue,
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingSmall),
                Row(
                  children: [
                    _buildInfoChip(
                      icon: Icons.brush,
                      label: job['technique'],
                      color: Colors.purple,
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingMedium),

                // Presupuesto
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacingSmall),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.green.shade50,
                        Colors.green.shade100,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.green.shade700,
                          borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                        ),
                        child: const Icon(
                          Icons.attach_money,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingSmall),
                      Text(
                        job['budget'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        job['time'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingSmall,
        vertical: AppTheme.spacingXSmall,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color.withOpacity(0.9),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
