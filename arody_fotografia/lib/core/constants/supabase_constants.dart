class SupabaseConstants {
  // Supabase configuration - can be overridden with --dart-define
  static const String url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://iwdmagyoefjanvapgmpb.supabase.co',
  );
  static const String anonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Iml3ZG1hZ3lvZWZqYW52YXBnbXBiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQ1MTA2NDAsImV4cCI6MjA4MDA4NjY0MH0.9ML0GfPX_gZ2hC_EHe-MrNioPUQbZk40wsX5NydiyzQ',
  );
}
