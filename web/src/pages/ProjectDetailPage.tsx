import { useState } from 'react'
import { Link, useNavigate, useParams } from 'react-router-dom'
import { useMutation, useQueryClient } from '@tanstack/react-query'
import { Pencil, Plus, Trash2, UserMinus, UserPlus } from 'lucide-react'
import { useAuth } from '../auth/AuthContext'
import { projectsApi, tasksApi } from '../api/endpoints'
import { getErrorMessage, getErrorMessages } from '../api/client'
import { Alert, Avatar, Button, Card, EmptyState, ErrorState, PageHeader, ProgressBar, Select, Spinner } from '../components/ui'
import { ConfirmDialog, Modal } from '../components/Modal'
import { PriorityBadge, ProjectStatusBadge, RoleBadge, StatusBadge } from '../components/badges'
import { useToast } from '../components/Toast'
import { ProjectForm } from '../forms/ProjectForm'
import { TaskForm } from '../forms/TaskForm'
import { qk, useDashboardQuery, useMembersQuery, useProjectQuery, useTasksQuery, useUserName, useUsersQuery } from '../hooks/queries'
import { toTaskCreateInput } from '../lib/taskInput'
import { deriveProjectStatus } from '../lib/projectStatus'
import { formatDate, isOverdue } from '../lib/format'
import { ProjectRole } from '../types/api'

export function ProjectDetailPage() {
  const id = Number(useParams().id)
  const navigate = useNavigate()
  const { canManageProject, isManagerRole } = useAuth()
  const toast = useToast()
  const queryClient = useQueryClient()
  const project = useProjectQuery(id)
  const members = useMembersQuery(id)
  const tasks = useTasksQuery()
  const users = useUsersQuery()
  const dashboard = useDashboardQuery()
  const nameOf = useUserName()

  const [editing, setEditing] = useState(false)
  const [deleting, setDeleting] = useState(false)
  const [addingTask, setAddingTask] = useState(false)
  const [addingMember, setAddingMember] = useState(false)
  const [memberToAdd, setMemberToAdd] = useState('')
  const [memberErrors, setMemberErrors] = useState<string[]>([])
  const [removeTarget, setRemoveTarget] = useState<{ userId: string; name: string } | null>(null)

  const refreshAll = () => {
    void queryClient.invalidateQueries({ queryKey: qk.projects })
    void queryClient.invalidateQueries({ queryKey: qk.project(id) })
    void queryClient.invalidateQueries({ queryKey: qk.members(id) })
    void queryClient.invalidateQueries({ queryKey: qk.tasks })
    void queryClient.invalidateQueries({ queryKey: qk.dashboard })
  }

  const update = useMutation({
    mutationFn: (v: Parameters<typeof projectsApi.update>[1]) => projectsApi.update(id, v),
    onSuccess: () => {
      refreshAll()
      toast.success('Proje güncellendi.')
      setEditing(false)
    },
  })
  const remove = useMutation({
    mutationFn: () => projectsApi.remove(id),
    onSuccess: () => {
      refreshAll()
      toast.success('Proje silindi.')
      navigate('/projects', { replace: true })
    },
  })
  const createTask = useMutation({
    mutationFn: tasksApi.create,
    onSuccess: () => {
      refreshAll()
      toast.success('Görev oluşturuldu.')
      setAddingTask(false)
    },
  })
  const addMember = useMutation({
    mutationFn: (userId: string) => projectsApi.addMember(id, userId),
    onSuccess: () => {
      refreshAll()
      toast.success('Üye eklendi.')
      setAddingMember(false)
      setMemberToAdd('')
    },
    onError: (e) => setMemberErrors(getErrorMessages(e)),
  })
  const removeMember = useMutation({
    mutationFn: (userId: string) => projectsApi.removeMember(id, userId),
    onSuccess: () => {
      refreshAll()
      toast.success('Üye projeden çıkarıldı.')
      setRemoveTarget(null)
    },
  })

  if (project.isLoading || members.isLoading) return <Spinner />
  if (project.error || !project.data) return <ErrorState message={getErrorMessage(project.error)} onRetry={() => void project.refetch()} />

  const p = project.data
  const canManage = canManageProject(p)
  const projectTasks = (tasks.data ?? []).filter((t) => t.projectId === id)
  const progress = dashboard.data?.projects.find((x) => x.projectId === id)
  const activeMembers = (members.data ?? []).filter((m) => m.isActive)
  const candidates = (users.data ?? []).filter((u) => u.isActive && !activeMembers.some((m) => m.userId === u.id))

  return (
    <div>
      <PageHeader
        title={p.name}
        description={`${formatDate(p.startDate)} – ${formatDate(p.targetEndDate)} · Yönetici: ${nameOf(p.managerUserId)}`}
        actions={
          <>
            <ProjectStatusBadge status={deriveProjectStatus(progress)} />
            {isManagerRole && (
              <Button onClick={() => setAddingTask(true)}>
                <Plus className="h-4 w-4" aria-hidden /> Görev ekle
              </Button>
            )}
            {canManage && (
              <>
                <Button variant="secondary" onClick={() => setEditing(true)}>
                  <Pencil className="h-4 w-4" aria-hidden /> Düzenle
                </Button>
                <Button variant="danger" onClick={() => setDeleting(true)}>
                  <Trash2 className="h-4 w-4" aria-hidden /> Sil
                </Button>
              </>
            )}
          </>
        }
      />

      <Card className="mb-6 p-4">
        <p className="text-sm text-ink">{p.description || 'Açıklama girilmemiş.'}</p>
        <div className="mt-4">
          <div className="mb-1 flex justify-between text-xs text-muted">
            <span>İlerleme</span>
            <span>
              {progress ? `${progress.completedTasks}/${progress.totalTasks} görev · %${Math.round(progress.progressPercent)}` : '-'}
            </span>
          </div>
          <ProgressBar value={progress?.progressPercent ?? 0} />
        </div>
      </Card>

      <div className="grid gap-6 lg:grid-cols-3">
        <Card className="lg:col-span-2">
          <h2 className="border-b border-line p-4 font-semibold text-ink">Görevler ({projectTasks.length})</h2>
          {projectTasks.length === 0 ? (
            <EmptyState title="Bu projede görev yok" />
          ) : (
            <ul className="divide-y divide-line">
              {projectTasks.map((t) => (
                <li key={t.id}>
                  <Link to={`/tasks/${t.id}`} className="flex flex-wrap items-center gap-3 px-4 py-3 hover:bg-primary/5">
                    <div className="min-w-0 flex-1">
                      <p className="truncate font-medium text-ink">{t.title}</p>
                      <p className={`text-xs ${isOverdue(t) ? 'text-danger' : 'text-muted'}`}>
                        {nameOf(t.assignedUserId)} · Bitiş {formatDate(t.dueDate)}
                      </p>
                    </div>
                    <PriorityBadge priority={t.priority} />
                    <StatusBadge status={t.status} />
                  </Link>
                </li>
              ))}
            </ul>
          )}
        </Card>

        <Card>
          <div className="flex items-center justify-between border-b border-line p-4">
            <h2 className="font-semibold text-ink">Üyeler ({activeMembers.length})</h2>
            {canManage && (
              <Button size="sm" variant="secondary" onClick={() => { setMemberErrors([]); setAddingMember(true) }}>
                <UserPlus className="h-4 w-4" aria-hidden /> Ekle
              </Button>
            )}
          </div>
          {activeMembers.length === 0 ? (
            <EmptyState title="Üye yok" />
          ) : (
            <ul className="divide-y divide-line">
              {activeMembers.map((m) => (
                <li key={m.userId} className="flex items-center gap-3 px-4 py-3">
                  <Avatar name={m.fullName} size={32} />
                  <div className="min-w-0 flex-1">
                    <p className="truncate text-sm font-medium text-ink">{m.fullName}</p>
                    <p className="truncate text-xs text-muted">{m.email}</p>
                  </div>
                  {m.memberRole === ProjectRole.Manager ? (
                    <RoleBadge label="Yönetici" />
                  ) : (
                    canManage && (
                      <Button
                        size="sm"
                        variant="ghost"
                        aria-label={`${m.fullName} üyesini çıkar`}
                        onClick={() => setRemoveTarget({ userId: m.userId, name: m.fullName })}
                      >
                        <UserMinus className="h-4 w-4" aria-hidden />
                      </Button>
                    )
                  )}
                </li>
              ))}
            </ul>
          )}
        </Card>
      </div>

      <Modal open={editing} title="Projeyi düzenle" onClose={() => setEditing(false)}>
        <ProjectForm
          project={p}
          submitLabel="Kaydet"
          onSubmit={(v) => update.mutateAsync({ ...v, description: v.description || null })}
          onCancel={() => setEditing(false)}
        />
      </Modal>

      <Modal open={addingTask} title="Yeni görev" onClose={() => setAddingTask(false)} wide>
        <TaskForm
          defaultProjectId={id}
          lockProject
          onSubmit={(v) =>
            createTask.mutateAsync(toTaskCreateInput(v))
          }
          onCancel={() => setAddingTask(false)}
        />
      </Modal>

      <Modal open={addingMember} title="Üye ekle" onClose={() => setAddingMember(false)}>
        <div className="space-y-4">
          <Alert messages={memberErrors} />
          <Select aria-label="Kullanıcı" value={memberToAdd} onChange={(e) => setMemberToAdd(e.target.value)}>
            <option value="">Kullanıcı seçin</option>
            {candidates.map((u) => (
              <option key={u.id} value={u.id}>
                {u.fullName} ({u.email})
              </option>
            ))}
          </Select>
          <div className="flex justify-end gap-2">
            <Button variant="secondary" onClick={() => setAddingMember(false)}>
              Vazgeç
            </Button>
            <Button disabled={!memberToAdd} loading={addMember.isPending} onClick={() => addMember.mutate(memberToAdd)}>
              Ekle
            </Button>
          </div>
        </div>
      </Modal>

      <ConfirmDialog
        open={deleting}
        title="Projeyi sil"
        message="Bu proje ve içindeki görevler silinecek. Bu işlem geri alınamaz."
        loading={remove.isPending}
        error={remove.error ? getErrorMessage(remove.error) : undefined}
        onConfirm={() => remove.mutate()}
        onCancel={() => setDeleting(false)}
      />
      <ConfirmDialog
        open={!!removeTarget}
        title="Üyeyi çıkar"
        message={`${removeTarget?.name ?? ''} projeden çıkarılacak.`}
        confirmLabel="Çıkar"
        loading={removeMember.isPending}
        error={removeMember.error ? getErrorMessage(removeMember.error) : undefined}
        onConfirm={() => removeTarget && removeMember.mutate(removeTarget.userId)}
        onCancel={() => setRemoveTarget(null)}
      />
    </div>
  )
}
