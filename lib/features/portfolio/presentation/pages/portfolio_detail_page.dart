import 'package:flutter/material.dart';
import 'package:artcollab_mobile/features/portfolio/data/remote/portfolio_service.dart';
import 'package:artcollab_mobile/core/theme/app_theme.dart';
import 'package:artcollab_mobile/shared/widgets/elegant_card.dart';
import 'package:artcollab_mobile/shared/widgets/network_image_with_fallback.dart';

class PortfolioDetailPage extends StatefulWidget {
  final PortfolioDto portfolio;

  const PortfolioDetailPage({
    super.key,
    required this.portfolio,
  });

  @override
  State<PortfolioDetailPage> createState() => _PortfolioDetailPageState();
}

class _PortfolioDetailPageState extends State<PortfolioDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.portfolio.categorias.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: CustomScrollView(
        slivers: [
          // App Bar con imagen
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppTheme.primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.portfolio.titulo,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black45,
                      offset: Offset(0, 1),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  NetworkImageWithFallback(
                    imageUrl: widget.portfolio.urlImagen,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  // Gradiente para mejorar legibilidad del título
                  Container(
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
                  ),
                ],
              ),
            ),
          ),
          
          // Contenido
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Descripción
                  ContentCard(
                    title: 'Descripción',
                    content: Text(
                      widget.portfolio.descripcion,
                      style: context.textTheme.bodyMedium?.copyWith(
                        height: 1.5,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: AppTheme.spacingMedium),
                  
                  // Categorías
                  if (widget.portfolio.categorias.isNotEmpty) ...[
                    Text(
                      'Categorías',
                      style: context.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingSmall),
                    Wrap(
                      spacing: AppTheme.spacingSmall,
                      runSpacing: AppTheme.spacingSmall,
                      children: widget.portfolio.categorias.map((cat) {
                        return Chip(
                          label: Text(cat.nombre ?? 'Sin nombre'),
                          backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                          labelStyle: const TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                          side: const BorderSide(
                            color: AppTheme.primaryColor,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: AppTheme.spacingLarge),
                  ],
                  
                  // Ilustraciones por categoría
                  if (widget.portfolio.categorias.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ilustraciones',
                          style: context.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingMedium),
                        
                        // Tabs de categorías
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                            boxShadow: AppTheme.cardShadow,
                          ),
                          child: TabBar(
                            controller: _tabController,
                            isScrollable: true,
                            labelColor: AppTheme.primaryColor,
                            unselectedLabelColor: AppTheme.textSecondaryColor,
                            indicatorColor: AppTheme.primaryColor,
                            indicatorWeight: 3,
                            tabs: widget.portfolio.categorias.map((cat) {
                              return Tab(
                                text: cat.nombre ?? 'Sin nombre',
                              );
                            }).toList(),
                          ),
                        ),
                        
                        const SizedBox(height: AppTheme.spacingMedium),
                        
                        // Contenido de tabs
                        SizedBox(
                          height: 400,
                          child: TabBarView(
                            controller: _tabController,
                            children: widget.portfolio.categorias.map((cat) {
                              final ilustraciones = cat.ilustraciones ?? [];
                              
                              if (ilustraciones.isEmpty) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.image_not_supported,
                                        size: 64,
                                        color: Colors.grey.shade400,
                                      ),
                                      const SizedBox(height: AppTheme.spacingMedium),
                                      Text(
                                        'No hay ilustraciones en esta categoría',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              
                              return GridView.builder(
                                padding: EdgeInsets.zero,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: AppTheme.spacingSmall,
                                  mainAxisSpacing: AppTheme.spacingSmall,
                                  childAspectRatio: 0.75,
                                ),
                                itemCount: ilustraciones.length,
                                itemBuilder: (context, index) {
                                  final ilustracion = ilustraciones[index];
                                  return _buildIllustrationCard(ilustracion);
                                },
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    )
                  else
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppTheme.spacingXLarge),
                        child: Column(
                          children: [
                            Icon(
                              Icons.image_not_supported,
                              size: 64,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: AppTheme.spacingMedium),
                            Text(
                              'No hay ilustraciones en este portafolio',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIllustrationCard(IllustrationDto ilustracion) {
    return ElegantCard(
      padding: EdgeInsets.zero,
      onTap: () {
        _showIllustrationDetail(ilustracion);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppTheme.borderRadiusMedium),
              ),
              child: NetworkImageWithFallback(
                imageUrl: ilustracion.urlImagen,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingSmall),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ilustracion.titulo,
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppTheme.spacingXSmall),
                Text(
                  ilustracion.descripcion,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showIllustrationDetail(IllustrationDto ilustracion) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusLarge),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Imagen
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppTheme.borderRadiusLarge),
                    ),
                    child: NetworkImageWithFallback(
                      imageUrl: ilustracion.urlImagen,
                      fit: BoxFit.contain,
                      width: double.infinity,
                    ),
                  ),
                  // Información
                  Padding(
                    padding: const EdgeInsets.all(AppTheme.spacingMedium),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ilustracion.titulo,
                          style: context.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingSmall),
                        Text(
                          ilustracion.descripcion,
                          style: context.textTheme.bodyMedium?.copyWith(
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spacingMedium),
            // Botón cerrar
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.close,
                color: Colors.white,
                size: 32,
              ),
              style: IconButton.styleFrom(
                backgroundColor: Colors.black.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
