# Railway Image Size Optimization Guide

## Problem
Railway has image size limits, and your backend image was too large.

## Solution Applied

I've created optimized files to reduce your image size by **~180MB+**:

### 1. Backend-Specific Requirements (`Backend/requirements.txt`)
- ✅ Removed `streamlit` (frontend only, saves ~50MB)
- ✅ Removed `sentence-transformers` (not used, saves ~100MB+)
- ✅ Removed `matplotlib` and `plotly` (not used in backend, saves ~30MB)
- ✅ Kept only essential backend dependencies

### 2. `.dockerignore` File
- Excludes Frontend/, documentation, test files, and other unnecessary files
- Prevents these from being copied into the Docker image

### 3. `railway.json` Configuration
- Points Railway to use `Backend/requirements.txt` for builds

## How to Deploy with Optimized Settings

### On Railway:

1. **Go to your Railway service** → **Settings**

2. **Build Settings**:
   - **Build Command**: `pip install -r Backend/requirements.txt`
   - **Start Command**: `python Backend/main.py`
   - **Root Directory**: Leave empty (or set to `.`)

3. **Environment Variables**:
   - `PYTHON_VERSION=3.12`
   - `GEMINI_API_KEY=your_api_key_here`

4. **Redeploy**: Click "Redeploy" or push a new commit

## Verification

After deployment, check the build logs:
- You should see: `pip install -r Backend/requirements.txt`
- Image size should be significantly smaller
- No errors about image size limits

## If Still Too Large

If you still get size errors:

1. **Check what's being installed**:
   - Look at Railway build logs
   - See if any unexpected packages are being installed

2. **Further optimizations**:
   - Consider using a lighter base image (Railway uses Nixpacks by default)
   - Remove any other unused dependencies
   - Check if `uv.lock` or `pyproject.toml` is causing extra packages

3. **Alternative**: Use Railway's Dockerfile option:
   - Create a minimal Dockerfile in `Backend/`
   - Use `python:3.12-slim` base image
   - Copy only Backend files

## File Structure

```
Backend/
  ├── requirements.txt  ← Optimized, backend-only dependencies
  ├── main.py
  └── ... (other backend files)

.dockerignore  ← Excludes unnecessary files
railway.json   ← Railway configuration
```

## Notes

- The root `requirements.txt` still has all dependencies (for local development)
- `Backend/requirements.txt` is optimized for deployment only
- Frontend dependencies are not needed in the backend container

