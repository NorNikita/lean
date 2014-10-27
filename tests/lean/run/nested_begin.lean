import logic data.nat.basic
open nat

inductive vector (A : Type) : nat → Type :=
vnil  : vector A zero,
vcons : Π {n : nat}, A → vector A n → vector A (succ n)

namespace vector
  definition no_confusion_type {A : Type} {n : nat} (P : Type) (v₁ v₂ : vector A n) : Type :=
  cases_on v₁
    (cases_on v₂
      (P → P)
      (λ n₂ h₂ t₂, P))
    (λ n₁ h₁ t₁, cases_on v₂
      P
      (λ n₂ h₂ t₂, (Π (H : n₁ = n₂), h₁ = h₂ → eq.rec_on H t₁ = t₂ → P) → P))


  definition no_confusion {A : Type} {n : nat} {P : Type} {v₁ v₂ : vector A n} : v₁ = v₂ → no_confusion_type P v₁ v₂ :=
  assume H₁₂ : v₁ = v₂,
    begin
       show no_confusion_type P v₁ v₂, from
       have aux : v₁ = v₁ → no_confusion_type P v₁ v₁, from
        take H₁₁,
          begin
            apply (cases_on v₁),
              exact (assume h : P, h),

              intros (n, a, v, h),
              apply (h rfl),
              repeat (apply rfl)
          end,
        eq.rec_on H₁₂ aux H₁₂
    end

  theorem vcons.inj₁ {A : Type} {n : nat} (a₁ a₂ : A) (v₁ v₂ : vector A n) : vcons a₁ v₁ = vcons a₂ v₂ → a₁ = a₂ :=
  begin
     intro h, apply (no_confusion h), intros, assumption
  end

  theorem vcons.inj₂ {A : Type} {n : nat} (a₁ a₂ : A) (v₁ v₂ : vector A n) : vcons a₁ v₁ = vcons a₂ v₂ → v₁ = v₂ :=
  begin
    intro h, apply (no_confusion h), intros, eassumption
  end
end vector
