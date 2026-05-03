import { useState, useRef, useMemo, useEffect } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Trophy, Star, Zap, Edit2 } from "lucide-react";
import { toast } from "sonner";
import { useProfile } from "@/hooks/useProfile";
import type { UpdateProfileData, UpdateVisibilityData } from "@/types/profile";

const AVAILABLE_EMOJIS = [
  "👩", "👩‍🦰", "👩‍🦱", "👩‍🦲", "👩‍🦳", "👨", "👨‍🦰", "👨‍🦱", "👨‍🦲", "👨‍🦳",
  "👧", "👦", "👴", "👵", "👨‍💼", "👩‍💼", "👨‍⚕️", "👩‍⚕️", "👨‍🍳", "👩‍🍳",
  "👨‍💻", "👩‍💻", "👨‍🎓", "👩‍🎓", "👨‍🎨", "👩‍🎨", "🧑‍🚀", "🧑‍🎬", "🧑‍🎤", "😊"
];

const LoadingSkeleton = () => (
  <div className="p-6 lg:p-8 min-h-screen bg-[color:var(--background)] flex flex-col gap-6 animate-pulse">
    <div className="grid grid-cols-1 lg:grid-cols-3 gap-6 mb-8">
      <div className="h-96 bg-[color:var(--surface2)] rounded-lg" />
      <div className="lg:col-span-2 space-y-6">
        <div className="h-48 bg-[color:var(--surface2)] rounded-lg" />
        <div className="h-48 bg-[color:var(--surface2)] rounded-lg" />
      </div>
    </div>
    <div className="h-64 bg-[color:var(--surface2)] rounded-lg" />
  </div>
);

export default function Profile() {
  const { profile, pointsHistory, loading, error, handleSaveProfile, handleToggleVisibility } = useProfile();
  const [selectedEmoji, setSelectedEmoji] = useState("👩‍💼");
  const [showEmojiPicker, setShowEmojiPicker] = useState(false);
  const [formData, setFormData] = useState<UpdateProfileData>({
    name: "",
    email: "",
    cargo: "",
  });
  const [isSaving, setIsSaving] = useState(false);
  const pickerRef = useRef<HTMLDivElement>(null);

  // Atualizar formData quando o perfil carregar
  useEffect(() => {
    if (profile) {
      setFormData({
        name: profile.name,
        email: profile.email,
        cargo: profile.cargo || "",
      });
    }
  }, [profile]);

  const handleEmojiSelect = (emoji: string) => {
    setSelectedEmoji(emoji);
    setShowEmojiPicker(false);
    toast.success("Avatar atualizado com sucesso!");
  };

  const handleSave = async () => {
    try {
      setIsSaving(true);
      await handleSaveProfile(formData);
    } finally {
      setIsSaving(false);
    }
  };

  const handleToggle = async (key: keyof UpdateVisibilityData) => {
    if (!profile) return;
    const newValue = !(profile.visibility_settings[key] ?? true);
    await handleToggleVisibility(key, newValue);
  };

  const stats = useMemo(() => {
    if (!profile) return [];
    return [
      { 
        label: "Pontos", 
        value: profile.total_points.toLocaleString("pt-BR"), 
        icon: "⭐", 
        color: "text-yellow-400" 
      },
      { 
        label: "Ranking", 
        value: `#${profile.ranking_position}`, 
        icon: "🏆", 
        color: "text-purple-400" 
      },
      { 
        label: "Selos", 
        value: profile.badges_count.toString(), 
        icon: "🎖️", 
        color: "text-green-400" 
      },
      { 
        label: "Tarefas", 
        value: profile.tasks_count.toString(), 
        icon: "⚡", 
        color: "text-blue-400" 
      },
    ];
  }, [profile]);

  const visibilityItems = useMemo(() => {
    if (!profile) return [];
    return [
      { 
        key: "show_in_ranking" as const,
        icon: Trophy, 
        label: "Aparecer no ranking", 
        desc: "Outros podem ver sua posição no ranking geral",
        isActive: profile.visibility_settings.show_in_ranking 
      },
      { 
        key: "public_points" as const,
        icon: Star, 
        label: "Pontuação pública", 
        desc: "Mostrar seus pontos no perfil público",
        isActive: profile.visibility_settings.public_points 
      },
      { 
        key: "feed_achievements" as const,
        icon: Zap, 
        label: "Feed de conquistas", 
        desc: "Compartilhar suas conquistas no feed de equipe",
        isActive: profile.visibility_settings.feed_achievements 
      },
    ];
  }, [profile]);

  if (loading) {
    return <LoadingSkeleton />;
  }

  if (error || !profile) {
    return (
      <div className="p-6 lg:p-8 min-h-screen bg-[color:var(--background)] flex items-center justify-center">
        <Card className="border-red-500/50 bg-red-500/10 max-w-md w-full">
          <CardContent className="pt-6">
            <p className="text-red-400 text-center font-semibold">
              {error || "Erro ao carregar perfil"}
            </p>
          </CardContent>
        </Card>
      </div>
    );
  }

  return (
    <div className="p-6 lg:p-8 min-h-screen bg-[color:var(--background)] flex flex-col">
      {/* BLOCO 1 - Hero Card + Dados Pessoais + Visibilidade */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6 mb-8 flex-grow">
        {/* HERO CARD - Coluna Esquerda */}
        <Card className="border-[color:var(--border)] bg-[color:var(--card)] lg:col-span-1 relative overflow-hidden flex flex-col">
          {/* Glow Background */}
          <div className="absolute -top-20 -right-20 w-40 h-40 bg-gradient-to-br from-purple-500/20 to-transparent rounded-full blur-3xl" />
          
          <CardContent className="p-6 relative z-10 flex-1 flex flex-col">
            {/* Avatar com Picker */}
            <div className="mb-6 flex justify-center relative">
              <div className="relative">
                <div className="w-32 h-32 rounded-2xl bg-gradient-primary flex items-center justify-center text-6xl border-4 border-purple-500/30 shadow-lg">
                  {selectedEmoji}
                </div>
                <button
                  onClick={() => setShowEmojiPicker(!showEmojiPicker)}
                  className="absolute bottom-2 right-2 bg-purple-500 hover:bg-purple-600 text-white rounded-full p-2 transition-colors"
                  title="Editar avatar"
                >
                  <Edit2 className="w-4 h-4" />
                </button>
              </div>

              {/* Emoji Picker Inline */}
              {showEmojiPicker && (
                <div
                  ref={pickerRef}
                  className="absolute top-40 left-1/2 -translate-x-1/2 bg-[color:var(--surface2)] border border-[color:var(--border)] rounded-[1rem] p-4 w-72 z-50 shadow-lg animate-in fade-in scale-95"
                >
                  <div className="grid grid-cols-6 gap-2 max-h-48 overflow-y-auto">
                    {AVAILABLE_EMOJIS.map((emoji) => (
                      <button
                        key={emoji}
                        onClick={() => handleEmojiSelect(emoji)}
                        className="text-3xl hover:bg-[color:var(--surface)] rounded-lg p-2 transition-colors"
                      >
                        {emoji}
                      </button>
                    ))}
                  </div>
                </div>
              )}

              {/* Badge de Nível */}
              {profile.nivel && (
                <div className="absolute -top-3 -right-3 bg-purple-500 px-3 py-1 rounded-full text-xs font-bold text-white">
                  Nível {profile.nivel}
                </div>
              )}
            </div>

            {/* Nome */}
            <h2 className="text-2xl font-heading font-bold text-foreground text-center mb-2">
              {profile.name}
            </h2>

            {/* Cargo como Pill */}
            <div className="flex justify-center mb-6">
              <span className="inline-flex items-center rounded-full bg-blue-500/20 px-3 py-1 text-xs font-bold text-blue-400 border border-blue-500/30">
                {profile.cargo || "Sem cargo"}
              </span>
            </div>

            {/* Stats Grid 2x2 */}
            <div className="grid grid-cols-2 gap-3 mb-6">
              {stats.map((stat, i) => (
                <div key={i} className="rounded-lg bg-[color:var(--surface2)] p-3 text-center border border-[color:var(--border)]">
                  <div className={`text-2xl font-heading font-bold ${stat.color} mb-1`}>
                    {stat.value}
                  </div>
                  <div className="text-xs text-[color:var(--muted)] font-semibold">{stat.label}</div>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>

        {/* COLUNA DIREITA - 2 Cards Empilhados */}
        <div className="lg:col-span-2 space-y-6 flex flex-col">
          {/* Card Dados Pessoais */}
          <Card className="border-[color:var(--border)] bg-[color:var(--card)]">
            <CardHeader>
              <CardTitle className="font-heading">Dados Pessoais</CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="grid sm:grid-cols-2 gap-4">
                <div className="space-y-2">
                  <Label className="text-xs font-semibold text-[color:var(--muted)] uppercase">Nome</Label>
                  <Input
                    value={formData.name || ""}
                    onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                    className="rounded-lg bg-[color:var(--surface2)] border-[color:var(--border)]"
                  />
                </div>
                <div className="space-y-2">
                  <Label className="text-xs font-semibold text-[color:var(--muted)] uppercase">Email</Label>
                  <Input
                    value={formData.email || ""}
                    onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                    type="email"
                    className="rounded-lg bg-[color:var(--surface2)] border-[color:var(--border)]"
                  />
                </div>
              </div>
              <div className="grid sm:grid-cols-2 gap-4">
                <div className="space-y-2">
                  <Label className="text-xs font-semibold text-[color:var(--muted)] uppercase">Cargo</Label>
                  <Input
                    value={formData.cargo || ""}
                    onChange={(e) => setFormData({ ...formData, cargo: e.target.value })}
                    className="rounded-lg bg-[color:var(--surface2)] border-[color:var(--border)]"
                  />
                </div>
                <div className="space-y-2">
                  <Label className="text-xs font-semibold text-[color:var(--muted)] uppercase">Equipe</Label>
                  <Input
                    value={profile.equipe}
                    readOnly
                    className="rounded-lg bg-[color:var(--surface2)] border-[color:var(--border)] opacity-60 cursor-not-allowed"
                  />
                </div>
              </div>
              <Button
                onClick={handleSave}
                disabled={isSaving}
                className="w-full bg-gradient-primary text-white rounded-lg font-bold disabled:opacity-50"
              >
                {isSaving ? "Salvando..." : "Salvar alterações"}
              </Button>
            </CardContent>
          </Card>

          {/* Card Visibilidade */}
          <Card className="border-[color:var(--border)] bg-[color:var(--card)] flex-1 flex flex-col">
            <CardHeader>
              <CardTitle className="font-heading">Visibilidade</CardTitle>
            </CardHeader>
            <CardContent className="flex-1 flex flex-col">
              <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
                {visibilityItems.map((item) => {
                  const Icon = item.icon;
                  return (
                    <button
                      key={item.key}
                      onClick={() => handleToggle(item.key)}
                      className={`rounded-lg border p-4 transition-all ${
                        item.isActive
                          ? "border-purple-500/50 bg-purple-500/10"
                          : "border-[color:var(--border)] bg-[color:var(--surface2)]"
                      }`}
                    >
                      <div className="flex items-start justify-between mb-2">
                        <Icon className={`w-5 h-5 ${item.isActive ? "text-purple-400" : "text-[color:var(--muted)]"}`} />
                        <span className={`inline-flex items-center rounded-full px-2 py-0.5 text-xs font-bold ${
                          item.isActive
                            ? "bg-green-500/20 text-green-400"
                            : "bg-gray-500/20 text-gray-400"
                        }`}>
                          {item.isActive ? "Ativo" : "Inativo"}
                        </span>
                      </div>
                      <h4 className="text-sm font-bold text-foreground mb-1 text-left">{item.label}</h4>
                      <p className="text-xs text-[color:var(--muted)] text-left">{item.desc}</p>
                    </button>
                  );
                })}
              </div>
            </CardContent>
          </Card>
        </div>
      </div>

      {/* BLOCO 2 - Histórico de Pontos */}
      <Card className="border-[color:var(--border)] bg-[color:var(--card)] w-full">
        <CardHeader>
          <CardTitle className="font-heading">📋 Histórico de Pontos</CardTitle>
        </CardHeader>
        <CardContent>
          {pointsHistory.length === 0 ? (
            <p className="text-center text-[color:var(--muted)] py-8">Nenhum histórico de pontos disponível</p>
          ) : (
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              {pointsHistory.map((entry) => {
                const date = new Date(entry.created_at);
                const formattedDate = date.toLocaleDateString("pt-BR");
                
                return (
                  <div key={entry.id} className="rounded-lg border border-[color:var(--border)] bg-[color:var(--surface2)] p-4">
                    <div className="flex items-start gap-3 mb-3">
                      <div className="w-10 h-10 rounded-full bg-purple-500/20 flex items-center justify-center text-lg flex-shrink-0">
                        ⭐
                      </div>
                      <div className="flex-1">
                        <p className="text-sm font-bold text-foreground">{entry.task_title}</p>
                        <p className="text-xs text-[color:var(--muted)]">{formattedDate}</p>
                      </div>
                    </div>
                    <div className="text-right">
                      <p className="text-lg font-heading font-bold text-purple-400">+{entry.points} ⭐</p>
                    </div>
                  </div>
                );
              })}
            </div>
          )}
        </CardContent>
      </Card>
    </div>
  );
}
