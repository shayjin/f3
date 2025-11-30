# Fixing Vercel "ERR_OUT_OF_RANGE" Size Error

## Problem

You're getting this error:
```
RangeError [ERR_OUT_OF_RANGE]: The value of "size" is out of range
```

This happens because your deployment package is too large for Vercel's limits.

## Root Cause

1. **`sentence-transformers`** downloads large ML models (~100MB+)
2. **Full `requirements.txt`** includes frontend dependencies (streamlit, etc.)
3. **Vercel free tier** has strict size limits (~50MB for serverless functions)

## Solution

### Option 1: Use Optimized Requirements (Recommended)

**In Vercel Dashboard:**

1. Go to **Settings** → **Build & Development Settings**
2. Set **Install Command** to:
   ```
   pip install --no-cache-dir -r Backend/requirements.txt
   ```
   This uses the optimized requirements that exclude:
   - `sentence-transformers` (~100MB+ saved)
   - `streamlit` (~50MB saved)
   - `matplotlib` and `plotly` (~30MB saved)

3. **Redeploy**

### Option 2: Create Minimal requirements.txt for Vercel

Create a `requirements-vercel.txt` in the root:

```txt
# Minimal requirements for Vercel deployment
fastapi==0.111.0
uvicorn==0.24.0
requests==2.31.0
python-dotenv==1.0.1
strands-agents>=1.0.1
strands-agents[gemini]
fastmcp>=2.2.0
pandas>=2.2.0
numpy>=1.26.0,<2.0.0
```

Then set Install Command to:
```
pip install --no-cache-dir -r requirements-vercel.txt
```

### Option 3: Upgrade to Vercel Pro

Vercel Pro allows larger function sizes (up to 250MB), but costs $20/month.

## Files Created

1. **`.vercelignore`** - Excludes unnecessary files from deployment
2. **Updated `vercel.json`** - Increased size limits (requires Pro plan)

## Better Alternative: Use Render or Railway

**Vercel has strict size limits that make it unsuitable for ML/AI backends.**

### Recommended: Switch to Render

1. Go to [render.com](https://render.com)
2. **New** → **Web Service**
3. Connect GitHub
4. Configure:
   - **Build Command**: `pip install -r Backend/requirements.txt`
   - **Start Command**: `python Backend/main.py`
   - **Python Version**: 3.12
5. **Environment Variables**: `GEMINI_API_KEY=your_key`
6. Deploy!

**Advantages:**
- ✅ No size limits (within reason)
- ✅ No timeout limits
- ✅ Free tier available
- ✅ Better for ML/AI workloads

## Why Vercel Isn't Ideal for Your Use Case

1. **Size Limits**: ML models are too large
2. **Timeout Limits**: 10s free, 60s paid (medical queries can take longer)
3. **Cold Starts**: Can be slow for ML models
4. **Memory Limits**: May not be enough for large models

## Quick Fix Summary

**Immediate fix:**
1. In Vercel Dashboard → Settings
2. Set **Install Command**: `pip install --no-cache-dir -r Backend/requirements.txt`
3. Redeploy

**Long-term solution:**
- Switch to **Render** or **Railway** for better ML/AI support

