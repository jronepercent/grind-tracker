# GRIND TRACKER

> Personal sales tracker สำหรับ solopreneur — ตั้งเป้า, ติ๊กยอด, ดู progress
>
> Stack: Vanilla JS + Supabase + Vercel · Cost: ฿0/month (free tier)

---

## 📋 เตรียมตัวก่อนเริ่ม

ต้องสมัคร 3 อย่าง (ใช้ Gmail เดียวกันได้):

| Service | URL | ใช้ทำอะไร |
|---|---|---|
| **GitHub** | github.com | เก็บ code |
| **Supabase** | supabase.com | Database + Login |
| **Vercel** | vercel.com | Hosting (สมัครด้วย GitHub ได้เลย) |

ทั้ง 3 บริการฟรีหมด — ไม่ต้องผูกบัตร

---

## 🚀 STEP 1 — ตั้งค่า Supabase

### 1.1 สร้าง Project
1. เข้า [supabase.com](https://supabase.com) → **Start your project** → login ด้วย GitHub
2. กด **New Project**
3. กรอก:
   - **Name**: `grind-tracker`
   - **Database Password**: ตั้งรหัสยาวๆ (เก็บไว้ — กู้ไม่ได้)
   - **Region**: `Southeast Asia (Singapore)` (ใกล้ไทยสุด)
4. กด **Create new project** → รอ ~2 นาที

### 1.2 สร้าง Database Tables
1. เมนูซ้าย → **SQL Editor**
2. กด **New query**
3. เปิดไฟล์ `schema.sql` → copy ทั้งหมด → paste ลงใน SQL Editor
4. กด **Run** (มุมขวาล่าง) หรือ `Ctrl+Enter`
5. ถ้าเห็น "Success. No rows returned" = เรียบร้อย ✅

### 1.3 เก็บ API Keys
1. เมนูซ้าย → **Project Settings** (ไอคอนเฟือง) → **API**
2. Copy ค่า 2 อย่างนี้ไว้ (วางใน Notepad):
   - **Project URL** — เช่น `https://abcxyz123.supabase.co`
   - **anon public key** — เริ่มด้วย `eyJ...` ยาวๆ

> ⚠️ `anon public key` ปลอดภัยที่จะใส่ใน frontend (มี RLS ป้องกัน) ห้าม copy `service_role key`

### 1.4 ตั้ง Email Settings (ไม่บังคับ แต่แนะนำ)
1. เมนูซ้าย → **Authentication** → **Email Templates** → **Magic Link**
2. แก้หัวข้ออีเมลเป็นไทยถ้าต้องการ (เช่น "ลิงก์เข้าใช้ Grind Tracker")
3. กด **Save**

---

## 🛠 STEP 2 — ใส่ Config ใน Code

1. เปิดไฟล์ `index.html` ด้วย editor (VS Code, Notepad, Sublime อะไรก็ได้)
2. ค้นหา (`Ctrl+F`) คำว่า `YOUR_SUPABASE_URL_HERE`
3. แก้ 2 บรรทัดนี้:

```javascript
const SUPABASE_URL = 'YOUR_SUPABASE_URL_HERE';
const SUPABASE_ANON_KEY = 'YOUR_SUPABASE_ANON_KEY_HERE';
```

ใส่ค่าที่ copy มาจาก Step 1.3:

```javascript
const SUPABASE_URL = 'https://abcxyz123.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1...ยาวมาก';
```

4. **Save** ไฟล์

### ทดสอบ Local (ไม่บังคับ)
- Double-click `index.html` ใน file explorer → เปิดใน browser
- ลอง login ด้วย email → ถ้าได้ลิงก์ในเมล = พร้อม deploy

---

## 📤 STEP 3 — Push ขึ้น GitHub

### วิธีง่ายสุด: ผ่าน Web (ไม่ต้องใช้ command line)

1. เข้า [github.com](https://github.com) → กดปุ่ม `+` มุมขวาบน → **New repository**
2. กรอก:
   - **Repository name**: `grind-tracker`
   - **Public** หรือ **Private** ก็ได้ (Private ก็ deploy ได้)
   - ติ๊ก **Add a README file** (จะ overwrite ทีหลัง)
3. กด **Create repository**
4. ในหน้า repo → กด **Add file** → **Upload files**
5. ลากไฟล์ทั้งหมดในโฟลเดอร์ `grind-tracker/` ใส่ (index.html, schema.sql, README.md, .gitignore)
6. กด **Commit changes**

### วิธี command line (สำหรับคนคุ้นเคย)
```bash
cd grind-tracker
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/grind-tracker.git
git push -u origin main
```

---

## 🌐 STEP 4 — Deploy บน Vercel

1. เข้า [vercel.com](https://vercel.com) → **Sign Up** ด้วย GitHub
2. กด **Add New** → **Project**
3. หา repo `grind-tracker` → กด **Import**
4. หน้า Configure:
   - **Framework Preset**: Other
   - **Root Directory**: `./` (default)
   - ที่เหลือไม่ต้องแก้
5. กด **Deploy** → รอ ~30 วินาที
6. เสร็จแล้วจะได้ URL เช่น `grind-tracker-jr.vercel.app`

---

## 🔐 STEP 5 — ตั้งค่า Auth Redirect

นี่คือ step สำคัญที่ลืมบ่อย — ถ้าไม่ตั้ง magic link จะ redirect ผิด

1. กลับไป **Supabase Dashboard** → **Authentication** → **URL Configuration**
2. **Site URL**: ใส่ URL จาก Vercel เต็มๆ (เช่น `https://grind-tracker-jr.vercel.app`)
3. **Redirect URLs**: เพิ่ม URL เดิม + ลงท้ายด้วย `/**`

```
https://grind-tracker-jr.vercel.app
https://grind-tracker-jr.vercel.app/**
```

4. กด **Save**

---

## ✅ ลองใช้

1. เปิด URL ของ Vercel
2. กรอกอีเมล → กด **ส่ง Magic Link**
3. เช็คอีเมล (Inbox / Spam) → กดลิงก์ในอีเมล
4. ถูก redirect กลับเข้าแอป → เริ่มเพิ่มสินค้าได้เลย 🎉

---

## 🔄 อยากแก้ Code ทีหลัง?

1. แก้ไฟล์ใน GitHub (กด pencil icon ในหน้าไฟล์)
2. **Commit changes**
3. Vercel จะ auto-deploy ภายใน ~30 วินาที — ไม่ต้องทำอะไร

---

## 🐛 Troubleshooting

| ปัญหา | แก้ |
|---|---|
| เห็น "ยังไม่ได้ตั้งค่า Supabase" | กลับไป Step 2, ตรวจว่าใส่ key ถูก |
| Magic link ส่งแล้วแต่ไม่ได้รับ | เช็ค Spam folder + ใน Supabase → Auth → Logs |
| คลิก magic link แล้วเด้งหน้า login ใหม่ | Step 5 ยังไม่ได้ทำ — ตั้ง Redirect URL |
| เพิ่มสินค้าแล้ว error | เช็คว่า `schema.sql` รันผ่านครบใน Step 1.2 |
| ข้อมูลไม่เซฟ | เปิด browser console (F12) ดู error |

---

## 💡 Tips

- **ลบสินค้าใน Supabase manual**: Dashboard → Table Editor → products
- **Backup ข้อมูล**: Dashboard → Database → Backups (auto daily บน free tier)
- **เปลี่ยน domain**: Vercel → Project Settings → Domains → Add custom domain (ฟรี)
- **เก็บประวัติยอดขายรายเดือน**: ตอนนี้เวอร์ชันนี้ reset ทับ — ถ้าอยากเก็บ history ค่อย add table ใหม่

---

## 📊 Tech Details

```
Frontend:  Vanilla JS + HTML + CSS  (no build step)
Backend:   Supabase Postgres
Auth:      Supabase Auth (Magic Link, no password)
Storage:   image_data column (base64, compressed to ~50KB)
Hosting:   Vercel Edge Network (CDN ทั่วโลก)
Cost:      ฿0/month
           - Supabase: 500MB DB + 50K MAU free
           - Vercel: 100GB bandwidth free
```

---

Made with 🌑 by JR Academy
