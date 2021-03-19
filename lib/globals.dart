import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


myStyle (double size,[Color color,FontWeight fw]){
  return GoogleFonts.cabin(
    fontSize: size,
    color: color,
    fontWeight: fw,
  );
}