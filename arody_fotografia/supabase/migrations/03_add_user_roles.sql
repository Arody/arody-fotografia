-- Add role column to profiles table
ALTER TABLE public.profiles 
ADD COLUMN role TEXT DEFAULT 'client' CHECK (role IN ('client', 'super_admin'));

-- Update RLS policies for sessions to allow super_admin to view all sessions
DROP POLICY IF EXISTS "Users can view own sessions" ON public.sessions;
CREATE POLICY "Users can view own sessions or admin can view all" 
ON public.sessions FOR SELECT 
USING (
  auth.uid() = client_id 
  OR 
  EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'super_admin')
);

-- Update RLS policies for session_assets
DROP POLICY IF EXISTS "Users can view own session assets" ON public.session_assets;
CREATE POLICY "Users can view own session assets or admin can view all" 
ON public.session_assets FOR SELECT 
USING (
  EXISTS (
    SELECT 1 FROM public.sessions 
    WHERE id = session_assets.session_id 
    AND (
      client_id = auth.uid() 
      OR 
      EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'super_admin')
    )
  )
);

-- Allow super_admin to insert session_assets
CREATE POLICY "Super admin can insert session assets" 
ON public.session_assets FOR INSERT 
WITH CHECK (
  EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'super_admin')
);

-- Allow super_admin to delete session_assets
CREATE POLICY "Super admin can delete session assets" 
ON public.session_assets FOR DELETE 
USING (
  EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'super_admin')
);

-- Update storage policies for super_admin
DROP POLICY IF EXISTS "Service role can upload photos" ON storage.objects;
DROP POLICY IF EXISTS "Service role can update photos" ON storage.objects;
DROP POLICY IF EXISTS "Service role can delete photos" ON storage.objects;

-- Allow super_admin to upload photos
CREATE POLICY "Super admin can upload photos" 
ON storage.objects FOR INSERT 
WITH CHECK (
  bucket_id = 'session-photos'
  AND (
    auth.role() = 'service_role'
    OR
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'super_admin')
  )
);

-- Allow super_admin to update photos
CREATE POLICY "Super admin can update photos" 
ON storage.objects FOR UPDATE 
USING (
  bucket_id = 'session-photos'
  AND (
    auth.role() = 'service_role'
    OR
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'super_admin')
  )
);

-- Allow super_admin to delete photos
CREATE POLICY "Super admin can delete photos" 
ON storage.objects FOR DELETE 
USING (
  bucket_id = 'session-photos'
  AND (
    auth.role() = 'service_role'
    OR
    EXISTS (SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'super_admin')
  )
);

