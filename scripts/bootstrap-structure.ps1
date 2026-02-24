# scripts/bootstrap-structure.ps1
# Run from repo root: powershell -ExecutionPolicy Bypass -File .\scripts\bootstrap-structure.ps1

$ErrorActionPreference = "Stop"

function Ensure-Dir([string]$Path) {
  if (-not (Test-Path -LiteralPath $Path)) {
    New-Item -ItemType Directory -Path $Path | Out-Null
  }
}

function Ensure-File([string]$Path, [string]$Content = "") {
  if (-not (Test-Path -LiteralPath $Path)) {
    $parent = Split-Path -Parent $Path
    if ($parent -and (-not (Test-Path -LiteralPath $parent))) { Ensure-Dir $parent }
    if ($Content -eq "") {
      New-Item -ItemType File -Path $Path | Out-Null
    } else {
      Set-Content -Path $Path -Value $Content -Encoding UTF8
    }
  }
}

# Folders
$dirs = @(
  "public\resume",
  "public\images\projects",
  "public\icons",
  "src\app\(site)\projects",
  "src\app\(site)\experiences",
  "src\components\layout",
  "src\components\effects",
  "src\components\cards",
  "src\components\common",
  "src\components\sections",
  "src\content",
  "src\contexts",
  "src\hooks",
  "src\lib",
  "src\utils",
  "docs",
  "tests"
)

$dirs | ForEach-Object { Ensure-Dir $_ }

# Minimal Next.js App Router files
Ensure-File "jsconfig.json" @'
{
  "compilerOptions": {
    "baseUrl": ".",
    "paths": { "@/*": ["src/*"] }
  }
}
'@

Ensure-File "src\app\globals.css" @'
/* Global styles */
:root { color-scheme: light dark; }
body { margin: 0; font-family: system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif; }
'@

Ensure-File "src\app\layout.jsx" @'
import "./globals.css";

export const metadata = {
  title: "Portfolio",
  description: "Personal site"
};

export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
'@

Ensure-File "src\app\(site)\layout.jsx" @'
import Navbar from "@/components/layout/Navbar";
import Footer from "@/components/layout/Footer";

export default function SiteLayout({ children }) {
  return (
    <>
      <Navbar />
      <main>{children}</main>
      <Footer />
    </>
  );
}
'@

Ensure-File "src\app\(site)\page.jsx" @'
export default function HomePage() {
  return <div style={{ padding: 24 }}>Home</div>;
}
'@

Ensure-File "src\app\(site)\projects\page.jsx" @'
export default function ProjectsPage() {
  return <div style={{ padding: 24 }}>Projects</div>;
}
'@

Ensure-File "src\app\(site)\experiences\page.jsx" @'
export default function ExperiencesPage() {
  return <div style={{ padding: 24 }}>Experiences</div>;
}
'@

# Component placeholders (so imports resolve)
Ensure-File "src\components\layout\Navbar.jsx" @'
export default function Navbar() {
  return (
    <header style={{ padding: 16, borderBottom: "1px solid rgba(0,0,0,0.1)" }}>
      Navbar
    </header>
  );
}
'@

Ensure-File "src\components\layout\Footer.jsx" @'
export default function Footer() {
  return (
    <footer style={{ padding: 16, borderTop: "1px solid rgba(0,0,0,0.1)" }}>
      Footer
    </footer>
  );
}
'@

# Keep empty dirs in git when needed
$gitkeep = @(
  "public\images\projects\.gitkeep",
  "public\icons\.gitkeep",
  "public\resume\.gitkeep",
  "src\content\.gitkeep",
  "src\contexts\.gitkeep",
  "src\hooks\.gitkeep",
  "src\lib\.gitkeep",
  "src\utils\.gitkeep",
  "docs\.gitkeep",
  "tests\.gitkeep"
)
$gitkeep | ForEach-Object { Ensure-File $_ "" }

Write-Host "Done. Skeleton structure created (no overwrites)." -ForegroundColor Green