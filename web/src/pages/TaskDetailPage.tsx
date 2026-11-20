import { useRef, useState } from 'react'
import { Link, useNavigate, useParams } from 'react-router-dom'
import { useMutation, useQueryClient } from '@tanstack/react-query'
import { Download, Paperclip, Pencil, Trash2 } from 'lucide-react'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { useAuth } from '../auth/AuthContext'
import { attachmentsApi, commentsApi, tasksApi } from '../api/endpoints'
import { getErrorMessage, getErrorMessages } from '../api/client'
import { Alert, Avatar, Button, Card, EmptyState, ErrorState, PageHeader, Select, Spinner, Textarea } from '../components/ui'
import { ConfirmDialog, Modal } from '../components/Modal'
import { PriorityBadge, StatusBadge } from '../components/badges'
import { useToast } from '../components/Toast'
import { TaskForm } from '../forms/TaskForm'
import { qk, useAttachmentsQuery, useCommentsQuery, useProjectQuery, useTaskQuery, useUserName } from '../hooks/queries'
import { toTaskUpdateInput } from '../lib/taskInput'
import { formatDate, formatDateTime, formatFileSize, isOverdue } from '../lib/format'
import { commentSchema, validateUpload, type CommentValues } from '../lib/schemas'
import { TASK_STATUS_LABELS, type TaskAttachment, type TaskStatus } from '../types/api'

export function TaskDetailPage() {
  const id = Number(useParams().id)
  const navigate = useNavigate()
  const { user, isManagerRole } = useAuth()
  const toast = useToast()
  const queryClient = useQueryClient()
  const task = useTaskQuery(id)
  const project = useProjectQuery(task.data?.projectId ?? NaN)
  const comments = useCommentsQuery(id)
  const attachments = useAttachmentsQuery(id)
  const nameOf = useUserName()
  const fileInput = useRef<HTMLInputElement>(null)
  const [editing, setEditing] = useState(false)
  const [deleting, setDeleting] = useState(false)
  const [uploadErrors, setUploadErrors] = useState<string[]>([])

  const refresh = () => {
    void queryClient.invalidateQueries({ queryKey: qk.task(id) })
    void queryClient.invalidateQueries({ queryKey: qk.tasks })
    void queryClient.invalidateQueries({ queryKey: qk.dashboard })
  }

  const changeStatus = useMutation({
    mutationFn: (s: TaskStatus) => tasksApi.updateStatus(id, s),
    onSuccess: () => {
      refresh()
      toast.success('Durum güncellendi.')
    },
    onError: (e) => toast.error(getErrorMessage(e)),
  })
  const update = useMutation({
    mutationFn: (v: Parameters<typeof tasksApi.update>[1]) => tasksApi.update(id, v),
    onSuccess: () => {
      refresh()
      toast.success('Görev güncellendi.')
      setEditing(false)
    },
  })
  const remove = useMutation({
    mutationFn: () => tasksApi.remove(id),
    onSuccess: () => {
      refresh()
      toast.success('Görev silindi.')
      navigate('/tasks', { replace: true })
    },
  })
  const addComment = useMutation({
    mutationFn: (content: string) => commentsApi.create(id, content),
    onSuccess: () => void queryClient.invalidateQueries({ queryKey: qk.comments(id) }),
  })
  const upload = useMutation({
    mutationFn: (file: File) => attachmentsApi.upload(id, file),
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: qk.attachments(id) })
      toast.success('Dosya yüklendi.')
    },
    onError: (e) => setUploadErrors(getErrorMessages(e)),
  })

  const {
    register,
    handleSubmit,
    reset,
    formState: { errors, isSubmitting },
  } = useForm<CommentValues>({ resolver: zodResolver(commentSchema), defaultValues: { content: '' } })

  const submitComment = handleSubmit(async (v) => {
    try {
      await addComment.mutateAsync(v.content)
      reset()
    } catch (e) {
      toast.error(getErrorMessage(e))
    }
  })

  const onFile = (file: File | undefined) => {
    if (!file) return
    setUploadErrors([])
    const problem = validateUpload(file)
    if (problem) {
      setUploadErrors([problem])
    } else {
      upload.mutate(file)
    }
    if (fileInput.current) fileInput.current.value = ''
  }

  const download = async (a: TaskAttachment) => {
    try {
      await attachmentsApi.download(a)
    } catch (e) {
      toast.error(getErrorMessage(e))
    }
  }

  if (task.isLoading) return <Spinner />
  if (task.error || !task.data) return <ErrorState message={getErrorMessage(task.error)} onRetry={() => void task.refetch()} />

  const t = task.data
  const canChangeStatus = isManagerRole || t.assignedUserId === user?.userId

  return (
    <div>
      <PageHeader
        title={t.title}
        description={project.data ? `Proje: ${project.data.name}` : undefined}
        actions={
          <>
            {isManagerRole && (
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

      <div className="grid gap-6 lg:grid-cols-3">
        <div className="space-y-6 lg:col-span-2">
          <Card className="p-4">
            <div className="mb-3 flex flex-wrap items-center gap-2">
              <StatusBadge status={t.status} />
              <PriorityBadge priority={t.priority} />
              {isOverdue(t) && <span className="text-xs font-medium text-danger">Gecikti</span>}
            </div>
            <p className="whitespace-pre-wrap text-sm text-ink">{t.description || 'Açıklama girilmemiş.'}</p>
          </Card>

          <Card className="p-4">
            <h2 className="mb-3 font-semibold text-ink">Yorumlar ({comments.data?.length ?? 0})</h2>
            {comments.isLoading ? (
              <Spinner />
            ) : comments.error ? (
              <ErrorState message={getErrorMessage(comments.error)} onRetry={() => void comments.refetch()} />
            ) : (comments.data ?? []).length === 0 ? (
              <EmptyState title="Henüz yorum yok" />
            ) : (
              <ul className="space-y-4">
                {comments.data?.map((c) => (
                  <li key={c.id} className="flex gap-3">
                    <Avatar name={nameOf(c.userId)} size={28} />
                    <div className="min-w-0">
                      <p className="text-sm">
                        <span className="font-medium text-ink">{nameOf(c.userId)}</span>{' '}
                        <span className="text-xs text-muted">{formatDateTime(c.createdDate)}</span>
                      </p>
                      <p className="whitespace-pre-wrap text-sm text-ink">{c.content}</p>
                    </div>
                  </li>
                ))}
              </ul>
            )}
            <form onSubmit={submitComment} className="mt-4 space-y-2" noValidate>
              <Textarea aria-label="Yorum" placeholder="Yorum yaz..." {...register('content')} />
              {errors.content && <p className="text-xs text-danger">{errors.content.message}</p>}
              <div className="flex justify-end">
                <Button type="submit" loading={isSubmitting}>
                  Yorum ekle
                </Button>
              </div>
            </form>
          </Card>
        </div>

        <div className="space-y-6">
          <Card className="space-y-3 p-4 text-sm">
            <div>
              <label htmlFor="status-select" className="mb-1 block text-xs text-muted">
                Durum
              </label>
              <Select
                id="status-select"
                value={t.status}
                disabled={!canChangeStatus || changeStatus.isPending}
                onChange={(e) => changeStatus.mutate(Number(e.target.value) as TaskStatus)}
              >
                {Object.entries(TASK_STATUS_LABELS).map(([k, label]) => (
                  <option key={k} value={k}>
                    {label}
                  </option>
                ))}
              </Select>
            </div>
            <dl className="space-y-2">
              <Row label="Atanan" value={nameOf(t.assignedUserId)} />
              <Row label="Oluşturan" value={nameOf(t.createdByUserId)} />
              <Row label="Başlangıç" value={formatDate(t.startDate)} />
              <Row label="Bitiş" value={formatDate(t.dueDate)} />
              <Row label="Tamamlanma" value={formatDate(t.completedDate)} />
              <Row label="Oluşturulma" value={formatDateTime(t.createdDate)} />
            </dl>
            <Link to={`/projects/${t.projectId}`} className="block text-primary hover:underline">
              Projeye git
            </Link>
          </Card>

          <Card className="p-4">
            <div className="mb-3 flex items-center justify-between">
              <h2 className="font-semibold text-ink">Ekler ({attachments.data?.length ?? 0})</h2>
              <Button size="sm" variant="secondary" loading={upload.isPending} onClick={() => fileInput.current?.click()}>
                <Paperclip className="h-4 w-4" aria-hidden /> Yükle
              </Button>
              <input
                ref={fileInput}
                type="file"
                hidden
                aria-label="Dosya seç"
                onChange={(e) => onFile(e.target.files?.[0])}
              />
            </div>
            <Alert messages={uploadErrors} />
            {(attachments.data ?? []).length === 0 ? (
              <p className="py-3 text-center text-sm text-muted">Ek yok.</p>
            ) : (
              <ul className="divide-y divide-line">
                {attachments.data?.map((a) => (
                  <li key={a.id} className="flex items-center gap-2 py-2 text-sm">
                    <div className="min-w-0 flex-1">
                      <p className="truncate text-ink">{a.originalFileName}</p>
                      <p className="text-xs text-muted">
                        {formatFileSize(a.fileSize)} · {nameOf(a.uploadedByUserId)}
                      </p>
                    </div>
                    <Button size="sm" variant="ghost" aria-label={`${a.originalFileName} indir`} onClick={() => void download(a)}>
                      <Download className="h-4 w-4" aria-hidden />
                    </Button>
                  </li>
                ))}
              </ul>
            )}
          </Card>
        </div>
      </div>

      <Modal open={editing} title="Görevi düzenle" onClose={() => setEditing(false)} wide>
        <TaskForm
          task={t}
          lockProject
          onSubmit={(v) =>
            update.mutateAsync(toTaskUpdateInput(v))
          }
          onCancel={() => setEditing(false)}
        />
      </Modal>
      <ConfirmDialog
        open={deleting}
        title="Görevi sil"
        message="Bu görev silinecek. Bu işlem geri alınamaz."
        loading={remove.isPending}
        error={remove.error ? getErrorMessage(remove.error) : undefined}
        onConfirm={() => remove.mutate()}
        onCancel={() => setDeleting(false)}
      />
    </div>
  )
}

function Row({ label, value }: { label: string; value: string }) {
  return (
    <div className="flex justify-between gap-3">
      <dt className="text-muted">{label}</dt>
      <dd className="text-right text-ink">{value}</dd>
    </div>
  )
}
