import requests
from bs4 import BeautifulSoup
import pandas as pd

# Página principal
base_url = "https://admision.unmsm.edu.pe/Website20251/"
main_url = base_url + "A.html"  # cualquiera de las letras funciona para obtener los enlaces

# Obtener los enlaces a cada subpágina
resp = requests.get(main_url)
soup = BeautifulSoup(resp.text, 'html.parser')

# Extraer todos los enlaces de letras (A, B, C, ...)
links = soup.select("a")
letras_links = [base_url + link['href'] for link in links if link.get("href", "").endswith(".html")]

# Guardamos todas las tablas
todas_las_tablas = []

for url in letras_links:
    try:
        tablas = pd.read_html(url)
        for tabla in tablas:
            todas_las_tablas.append(tabla)
        print(f"✅ Tabla extraída de: {url}")
    except Exception as e:
        print(f"❌ Error con {url}: {e}")

# Combinar todas las tablas en una sola (si tienen la misma estructura)
df_total = pd.concat(todas_las_tablas, ignore_index=True)

# Guardar en un archivo CSV
df_total.to_csv("postulantes_unmsm_2025.csv", index=False, encoding="utf-8-sig")
print("🎉 Todas las tablas fueron extraídas y guardadas en 'postulantes_unmsm_2025.csv'")
