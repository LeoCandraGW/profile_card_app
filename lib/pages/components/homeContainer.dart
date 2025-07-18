import 'package:flutter/material.dart';

class HomeContainer extends StatelessWidget {
  final Color conColor;
  final Color shadColor;
  final String headline;
  final double size;
  final IconData icon;
  final String navigate;
  final isDetail;
  const HomeContainer({
    super.key,
    required this.conColor,
    required this.shadColor,
    required this.headline,
    required this.size,
    required this.icon,
    required this.navigate,
    required this.isDetail,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        isDetail
            ? Navigator.pushNamed(context, navigate, arguments: 1)
            : Navigator.pushNamed(context, navigate);
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: conColor,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: shadColor,
                spreadRadius: 4,
                blurRadius: 0,
                offset: Offset(-2, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [Icon(icon), Text(headline)],
            ),
          ),
        ),
      ),
    );
  }
}
