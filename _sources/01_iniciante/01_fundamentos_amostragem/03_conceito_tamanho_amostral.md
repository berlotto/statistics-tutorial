# Tamanho da Amostra: A Intuição Antes da Fórmula

> **"Melhor uma amostra pequena e representativa do que um Big Data enviesado."**
>
> Uma dúvida universal: *"Quantas pessoas preciso entrevistar?"*. Antes de calcularmos isso (que exige conceitos de variância que veremos no Módulo 2), precisamos destruir um mito perigoso: achar que dados massivos corrigem um desenho ruim.

---

## 1. O Mito do N Gigante (Big Data Fallacy)

Imagine que você quer saber a altura média dos brasileiros.
*   **Cenário A:** Você mede 10.000 jogadores de basquete.
*   **Cenário B:** Você sorteia aleatoriamente 50 pessoas de várias cidades e profissões.

O **Cenário A** tem $N=10.000$. O **Cenário B** tem $N=50$.
Qual é melhor? O **Cenário B**.

Aumentar o tamanho da amostra ($n$) **reduz o erro aleatório** (a incerteza), mas **não corrige o erro sistemático** (o viés). Se sua amostra é torta, aumentar o $n$ só faz você ter **mais certeza da resposta errada** (o que chamamos de ser "Precisamente Incorreto").

---

## 2. A Lei dos Grandes Números
A intuição estatística diz: **"Conforme $n$ cresce, a média da amostra converge para a média real da população."**

Mas note a condição: *Conforme n cresce*. Não precisamos da população inteira. A partir de um certo ponto, adicionar mais dados traz um ganho marginal de precisão muito pequeno.

*   Ir de $n=10$ para $n=100$ reduz brutalmente a incerteza.
*   Ir de $n=10.000$ para $n=20.000$ muda quase nada na margem de erro, mas dobra o custo.

---

## 3. Prática em Python: A Convergência Visual

Vamos provar a Lei dos Grandes Números e ver "quanto é suficiente" para estabilizar uma média.

```python
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

np.random.seed(42)

# 1. A Verdade Real (População)
# Imagine uma população com média 50 e desvio padrão 10
populacao_real = np.random.normal(loc=50, scale=10, size=100000)
media_real = np.mean(populacao_real)

print(f"Média VERDADEIRA da População: {media_real:.4f}")

# 2. Simulação: Coletando amostras de tamanhos crescentes
tamanhos_amostra = [5, 10, 30, 50, 100, 500, 1000, 5000]
resultados = []

for n in tamanhos_amostra:
    # Sorteamos n indivíduos aleatoriamente
    amostra = np.random.choice(populacao_real, size=n, replace=False)
    media_amostra = np.mean(amostra)
    erro = media_amostra - media_real
    resultados.append({'n': n, 'media_estimada': media_amostra, 'erro': erro})

df_res = pd.DataFrame(resultados)
print("\n--- Impacto do Tamanho da Amostra na Precisão ---")
print(df_res)

# 3. Visualizando a Estabilização
# Vamos simular 100 sorteios para cada tamanho de N para ver a dispersão
tamanhos_plot = range(10, 2000, 10)
medias_simuladas = []

for n in tamanhos_plot:
    # Pegamos apenas 1 amostra de tamanho n por vez aqui para o plot
    amostra = np.random.choice(populacao_real, size=n, replace=False)
    medias_simuladas.append(np.mean(amostra))

plt.figure(figsize=(10, 6))
plt.plot(tamanhos_plot, medias_simuladas, color='skyblue', label='Média da Amostra', alpha=0.8)
plt.axhline(y=media_real, color='red', linestyle='--', linewidth=2, label='Média Real')
plt.xlabel('Tamanho da Amostra (n)')
plt.ylabel('Média Estimada')
plt.title('Lei dos Grandes Números: A Convergência')
plt.legend()
plt.grid(True, alpha=0.3)
# plt.show() # Descomente se rodar localmente
```

### Interpretação do Experimento
Ao rodar este código, você verá que:
1.  Com $n=10$, a média oscila violentamente (pode dar 45 ou 55).
2.  Com $n=30$ ou $50$, ela já começa a ficar muito perto do 50.
3.  Depois de $n=500$, a linha vira quase uma reta sobre a média real.

**Conclusão Prática:** Muitas vezes, uma amostra de $n=400$ ou $n=1000$ já nos dá uma margem de erro excelente (aprox. 5% e 3% respectivamente) para populações de *milhões* de habitantes. Não é intuitivo, mas é matemático: o tamanho necessário depende da **variabilidade** dos dados, não do tamanho da população total.

*Veremos o cálculo exato dessa margem no Módulo 8.*
