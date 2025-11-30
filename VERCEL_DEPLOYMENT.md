# Vercel Deployment Guide for FastAPI Backend

## Important: Vercel Configuration

Vercel works differently than traditional platforms. It uses **serverless functions**, not a traditional build process.

### For Vercel Dashboard:

If deploying via Vercel Dashboard (web interface):

1. **Build Command**: Leave **empty** or use:
   ```
   pip install -r Backend/requirements.txt
   ```
   (Vercel will handle this automatically with `@vercel/python`)

2. **Output Directory**: Leave **empty** (not used for serverless functions)

3. **Root Directory**: Leave **empty** (or set to `.`)

4. **Install Command**: (Optional, if available)
   ```
   pip install -r Backend/requirements.txt
   ```

### For Vercel CLI:

Use the `vercel.json` configuration file (already created in your project root).

---

## Step-by-Step Deployment

### Option 1: Vercel Dashboard (Web Interface)

1. **Sign up** at [vercel.com](https://vercel.com)

2. **Import Project** → Connect your GitHub repository

3. **Configure Project**:
   - **Framework Preset**: Other (or leave as default)
   - **Root Directory**: Leave empty (or `.`)
   - **Build Command**: Leave empty (Vercel auto-detects Python)
   - **Output Directory**: Leave empty (not applicable)
   - **Install Command**: `pip install -r Backend/requirements.txt` (optional)

4. **Environment Variables**:
   - Add `GEMINI_API_KEY` = `your_api_key_here`

5. **Deploy**

### Option 2: Vercel CLI (Recommended)

1. **Install Vercel CLI**:
   ```bash
   npm install -g vercel
   ```
   Or on Windows (PowerShell):
   ```powershell
   npm install -g vercel
   ```

2. **Login**:
   ```bash
   vercel login
   ```

3. **Deploy** (from project root):
   ```bash
   vercel
   ```
   - Follow prompts
   - It will use `vercel.json` automatically

4. **Set Environment Variables**:
   ```bash
   vercel env add GEMINI_API_KEY
   ```
   Enter your API key when prompted.

5. **Production Deploy**:
   ```bash
   vercel --prod
   ```

---

## Important: Adapting FastAPI for Vercel

Vercel requires FastAPI to be exposed as a serverless function. You may need to create a wrapper file.

### ✅ Entrypoint Created: `api/main.py`

I've created `api/main.py` which:
- Imports the FastAPI app from `Backend/main.py`
- Sets up the correct Python path for Backend imports
- Exports the `app` variable that Vercel expects

This is the standard Vercel structure for FastAPI apps.

---

## Configuration Files

### `vercel.json` (already created):

```json
{
  "version": 2,
  "builds": [
    {
      "src": "Backend/main.py",
      "use": "@vercel/python"
    }
  ],
  "routes": [
    {
      "src": "/(.*)",
      "dest": "Backend/main.py"
    }
  ],
  "env": {
    "PYTHON_VERSION": "3.12"
  }
}
```

### `requirements.txt` for Vercel:

**Option 1: Use Backend/requirements.txt directly**
- In Vercel Dashboard → Settings → Build & Development Settings
- Set **Install Command**: `pip install -r Backend/requirements.txt`

**Option 2: Create root requirements.txt for Vercel**
- Temporarily copy `Backend/requirements.txt` to root as `requirements.txt` for deployment
- Or use the `vercel-requirements.txt` file I created and set Install Command to use it

**Note**: The root `requirements.txt` has all dependencies (including frontend). For Vercel, we only need backend dependencies from `Backend/requirements.txt`.

---

## Limitations

⚠️ **Important Limitations:**

1. **Function Timeout**:
   - Free tier: 10 seconds max
   - Pro tier: 60 seconds max
   - Your medical queries might exceed this!

2. **Cold Starts**: First request after idle may be slow (1-3 seconds)

3. **Memory**: Limited to 1GB on free tier

4. **Request Size**: 4.5MB limit

---

## Troubleshooting

### Error: "Module not found"
- Ensure `Backend/requirements.txt` has all dependencies
- Check that `vercel.json` points to correct path

### Error: "Function timeout"
- Your queries are taking too long (>10s on free tier)
- Consider using Render or Railway instead for longer-running operations

### Error: "Build failed"
- Check Python version (should be 3.12)
- Ensure `requirements.txt` is accessible
- Check build logs in Vercel dashboard

---

## Recommendation

**For your use case (medical queries that may take time):**

Vercel might not be ideal due to:
- 10-second timeout on free tier (medical queries can take longer)
- Cold starts can be slow

**Better alternatives:**
- **Render** (no timeout, free tier available)
- **Railway** (no timeout, $5 credit/month)
- **Google Cloud Run** (generous free tier, longer timeouts)

---

## Quick Answer Summary

**For Vercel Dashboard:**
- **Build Command**: Leave empty (or `pip install -r Backend/requirements.txt`)
- **Output Directory**: Leave empty (not used)
- **Root Directory**: Leave empty (or `.`)

**For Vercel CLI:**
- Use `vercel.json` (already created)
- Run `vercel` from project root
- No build/output directory needed

