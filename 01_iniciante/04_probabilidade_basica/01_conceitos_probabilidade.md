# Conceitos de Probabilidade e Teorema de Bayes

> **"A intuição humana falha miseravelmente quando $P(A|B)$ é confundido com $P(B|A)$."**
>
> Um teste positivo de uma doença rara significa que você tem a doença? Provavelmente não. Vamos entender porquê.

---

## 1. O Básico
*   **Espaço Amostral ($\Omega$):** Todos os resultados possíveis (ex: Dado de 6 faces).
*   **Evento ($A$):** Um subconjunto de interesse (ex: Sair número par). $\frac{3}{6} = 0.5$.
*   **Eventos Independentes:** O resultado de um não afeta o outro (Jogar uma moeda duas vezes).
*   **Eventos Dependentes:** Tirar uma carta do baralho sem reposição. A segunda carta depende da primeira.

---

## 2. Probabilidade Condicional $P(A|B)$
A chance de A acontecer **dado que B já aconteceu**.
$$ P(A|B) = \frac{P(A \cap B)}{P(B)} $$

Exemplo clínico:
*   $P(\text{Câncer})$: Probabilidade de ter câncer na população.
*   $P(\text{Câncer}|\text{Fumante})$: Probabilidade de ter câncer **dado que** a pessoa fuma. É muito maior.

---

## 3. O Teorema de Bayes (A Cura da Cegueira)
Bayes nos permite **atualizar** nossa crença inicial (Prior) com nova evidência (Likelihood) para chegar numa nova crença (Posterior).

$$ P(A|B) = \frac{P(B|A) \cdot P(A)}{P(B)} $$

*   $A$: Hipótese (Ex: Paciente tem a doença).
*   $B$: Evidência (Ex: Teste positivo).

### O Exemplo Clássico (Falso Positivo)
*   Doença rara afeta 1% da população ($P(D) = 0.01$).
*   Teste tem 90% de precisão (Se doente, 99% chance de positivo. Se saudável, 1% de chance de falso positivo).
*   Marta testou positivo. **Ela tem a doença?**
    *   Intuição: "Sim, 99% de certeza!"
    *   Realidade: Aprox. 50%.

Por quê? Porque a base de pessoas saudáveis é enorme. 1% de falso positivo em uma multidão gera **muitos** falso-positivos, que competem com os poucos doentes verdadeiros.

---

## 4. Prática em Python: Bayes na Mão

```python
def teorema_bayes(prior, sensibilidade, especificidade):
    # P(D): Prior (Prevalência)
    # P(Pos|D): Sensibilidade
    # P(Pos|~D): 1 - Especificidade (Falso Positivo)
    
    p_doenca = prior
    p_saudavel = 1 - prior
    
    p_pos_dado_doenca = sensibilidade
    p_pos_dado_saudavel = 1 - especificidade
    
    # Probabilidade Total de Teste Positivo (Evidência Total)
    p_positivo = (p_doenca * p_pos_dado_doenca) + (p_saudavel * p_pos_dado_saudavel)
    
    # Bayes: P(Doença | Positivo)
    posterior = (p_pos_dado_doenca * p_doenca) / p_positivo
    
    return posterior

# Cenário 1: Doença Rara (1%)
res1 = teorema_bayes(prior=0.01, sensibilidade=0.99, especificidade=0.99)
print(f"Chance Real (Doença Rara): {res1:.2%}") 
# Resultado: 50%. Chocante para muitos.

# Cenário 2: Epidemia (Prior sobe para 20%)
res2 = teorema_bayes(prior=0.20, sensibilidade=0.99, especificidade=0.99)
print(f"Chance Real (Epidemia): {res2:.2%}")
# Resultado: 96%. O contexto (Prior) muda tudo!
```

**Lição:** Nunca interprete um P-valor ou um resultado de teste sem considerar a **Probabilidade A Priori** (o contexto, a prevalência, a plausibilidade biológica).
