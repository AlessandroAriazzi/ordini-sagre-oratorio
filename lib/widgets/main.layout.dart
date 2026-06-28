import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

// ── Design token colors (from DESIGN.md) ──────────────────────────────────────


const _containerLow   = Color(0xFFF2F4F6);
const _container      = Color(0xFFECEEF0);   // sidebar bg
const _containerHigh  = Color(0xFFE6E8EA);   // hover

const _onSurface      = Color(0xFF191C1E);   // primary text
const _onSurfaceVar   = Color(0xFF45464D);   // secondary text
const _outlineVar     = Color(0xFFC6C6CD);   // dividers
const _primary        = Color(0xFF000000);   // active bar / buttons
// ──────────────────────────────────────────────────────────────────────────────

class MainLayout extends StatefulWidget {
  final Widget child;
  final String currentPath;

  const MainLayout({
    super.key,
    required this.child,
    required this.currentPath,
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  bool isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _containerLow,
      body: Row(
        children: [
          // ── Sidebar ─────────────────────────────────────────────────────────
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: isExpanded ? 260 : 68,
            child: Container(
              decoration: const BoxDecoration(
                color: _container,
                border: Border(
                  right: BorderSide(color: _outlineVar, width: 1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand header
                  if (isExpanded)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'POS Master',
                            style: GoogleFonts.inter(
                              color: _onSurface,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Terminal #01',
                            style: GoogleFonts.inter(
                              color: _onSurfaceVar,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      child: Center(
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: _primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.restaurant_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),

                  

                  // Nav items
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      children: [
                        _NavItem(
                          icon: Icons.receipt_long_rounded,
                          label: 'Ordini',
                          isSelected: widget.currentPath.startsWith('/ordini') ||
                              widget.currentPath.startsWith('/ordine/'),
                          isExpanded: isExpanded,
                          onTap: () => context.go('/ordini'),
                        ),
                        _NavItem(
                          icon: Icons.calendar_today_outlined,
                          label: 'Gestione Serate',
                          isSelected: widget.currentPath.startsWith('/serate') ||
                              widget.currentPath.startsWith('/serata/') ||
                              widget.currentPath.startsWith('/resoconto/'),
                          isExpanded: isExpanded,
                          onTap: () => context.go('/serate'),
                        ),
                        
                        _NavItem(
                          icon: Icons.food_bank_outlined,
                          label: 'Alimenti, dolci e bevande',
                          isSelected: widget.currentPath.startsWith('/alimenti'),
                          isExpanded: isExpanded,
                          onTap: () => context.go('/alimenti'),
                        ),
                      ],
                    ),
                  ),

                  const Divider(color: _outlineVar, height: 1),

                  // Bottom items
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Column(
                      children: [
                        _NavItem(
                          icon: Icons.settings_outlined,
                          label: 'Impostazioni',
                          isSelected: widget.currentPath == '/settings',
                          isExpanded: isExpanded,
                          onTap: () => context.go('/settings'),
                        ),
                      ],
                    ),
                  ),

                  const Divider(color: _outlineVar, height: 1),

                  // Collapse toggle
                  InkWell(
                    onTap: () => setState(() => isExpanded = !isExpanded),
                    child: SizedBox(
                      height: 44,
                      child: Row(
                        mainAxisAlignment: isExpanded
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: isExpanded ? 16 : 0),
                            child: Icon(
                              isExpanded
                                  ? Icons.chevron_left_rounded
                                  : Icons.chevron_right_rounded,
                              color: _onSurfaceVar,
                              size: 20,
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

          // ── Main content ────────────────────────────────────────────────────
          Expanded(child: widget.child),
        ],
      ),
    );
  }
}



class _NavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final bool isExpanded;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: InkWell(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 48,
          decoration: BoxDecoration(
            color: widget.isSelected
                ? _outlineVar.withValues(alpha: 0.4)
                : isHovered
                    ? _containerHigh
                    : Colors.transparent,
          ),
          child: Row(
            children: [
              // 4px active indicator bar
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 4,
                height: widget.isSelected ? 48 : 0,
                color: _primary,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: widget.isSelected ? 16 : 20,
                  right: 12,
                ),
                child: Icon(
                  widget.icon,
                  color:  _onSurfaceVar,
                  size: 20,
                ),
              ),
              if (widget.isExpanded)
                Expanded(
                  child: Text(
                    widget.label,
                    style: GoogleFonts.inter(
                      color: _onSurfaceVar,
                      fontSize: 14,
                      fontWeight: FontWeight.w500 ,
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
