-- Create storage bucket for session photos
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'session-photos',
  'session-photos',
  false,
  10485760, -- 10MB limit per file
  ARRAY['image/jpeg', 'image/jpg', 'image/png', 'image/webp']
);

-- Policy: Users can view photos from their own sessions
CREATE POLICY "Users can view own session photos"
ON storage.objects FOR SELECT
USING (
  bucket_id = 'session-photos' 
  AND auth.uid() IN (
    SELECT client_id 
    FROM public.sessions 
    WHERE id::text = (storage.foldername(name))[1]
  )
);

-- Policy: Admins can upload photos (you'll need to manage this separately)
-- For now, uploads will be done manually via Supabase Dashboard
CREATE POLICY "Service role can upload photos"
ON storage.objects FOR INSERT
WITH CHECK (
  bucket_id = 'session-photos'
  AND auth.role() = 'service_role'
);

-- Policy: Admins can update photos
CREATE POLICY "Service role can update photos"
ON storage.objects FOR UPDATE
USING (
  bucket_id = 'session-photos'
  AND auth.role() = 'service_role'
);

-- Policy: Admins can delete photos
CREATE POLICY "Service role can delete photos"
ON storage.objects FOR DELETE
USING (
  bucket_id = 'session-photos'
  AND auth.role() = 'service_role'
);

