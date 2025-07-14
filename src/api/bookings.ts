// src/api/bookings.tsimport { SupabaseClient } from '@supabase/supabase-js';
import { supabase } from '../types/supabaseClient'; 

export interface BookingPayload {
  pet_name: string;
  owner_name: string;
  owner_phone: string;
  start_date: string;  // ISO string format
  end_date: string;
  pet_type: string;
  special_notes?: string;
}

export async function createBooking(payload: BookingPayload) {
  const { data, error } = await supabase.from('bookings').insert([payload]);

  if (error) {
    console.error('Error inserting booking:', error);
    return { success: false, error };
  }

  return { success: true, data };
}
