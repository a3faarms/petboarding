// src/supabaseClient.ts
import { createClient } from '@supabase/supabase-js';

const SUPABASE_URL = 'https://oqomfntlrldifwboqikk.supabase.co://your-project-id.supabase.co'; // Replace with your Supabase URL
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9xb21mbnRscmxkaWZ3Ym9xaWtrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTA4ODE5MjEsImV4cCI6MjA2NjQ1NzkyMX0.lLDJJYZ6V6i8_NfcV9GnICllq7dHBb40Vz7CRuf0cXs'; // Replace with your Supabase anon key

export const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
