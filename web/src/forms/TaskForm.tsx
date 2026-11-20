import { useState } from 'react'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { getErrorMessages } from '../api/client'
import { Alert, Button, Field, Input, Select, Textarea } from '../components/ui'
import { useMembersQuery, useProjectsQuery } from '../hooks/queries'
import { taskSchema, type TaskValues } from '../lib/schemas'
import {
  TASK_PRIORITY_LABELS,
  TASK_STATUS_LABELS,
  TaskPriority,
  TaskStatus,
  type Task,
  type TaskPriority as Priority,
  type TaskStatus as Status,
} from '../types/api'

interface Props {
  task?: Task
  defaultProjectId?: number
  /** Proje değiştirilemesin (proje sayfasından ya da düzenlemeden açıldığında). */
  lockProject?: boolean
  onSubmit: (values: TaskValues) => Promise<unknown>
  onCancel: () => void
}

export function TaskForm({ task, defaultProjectId, lockProject, onSubmit, onCancel }: Props) {
  const [serverErrors, setServerErrors] = useState<string[]>([])
  const { data: projects = [] } = useProjectsQuery()

  const {
    register,
    handleSubmit,
    watch,
    setValue,
    formState: { errors, isSubmitting },
  } = useForm<TaskValues>({
    resolver: zodResolver(taskSchema),
    defaultValues: {
      projectId: task?.projectId ?? defaultProjectId ?? (undefined as unknown as number),
      title: task?.title ?? '',
      description: task?.description ?? '',
      assignedUserId: task?.assignedUserId ?? '',
      priority: task?.priority ?? TaskPriority.Medium,
      status: task?.status ?? TaskStatus.New,
      startDate: task?.startDate?.slice(0, 10) ?? '',
      dueDate: task?.dueDate.slice(0, 10) ?? '',
    },
  })

  const projectId = watch('projectId')
  const { data: members = [], isLoading: membersLoading } = useMembersQuery(Number(projectId) || NaN)
  const assigned = watch('assignedUserId')

  const submit = handleSubmit(async (values) => {
    setServerErrors([])
    try {
      await onSubmit(values)
    } catch (error) {
      setServerErrors(getErrorMessages(error))
    }
  })

  // Düzenlerken mevcut atanan kişi (üyelikten çıkarılmış olsa bile) seçenek olarak kalsın
  const memberOptions = members.map((m) => ({ id: m.userId, name: m.fullName }))
  if (assigned && !memberOptions.some((m) => m.id === assigned) && task) {
    memberOptions.push({ id: task.assignedUserId, name: 'Mevcut atanan kişi' })
  }

  return (
    <form onSubmit={submit} className="space-y-4" noValidate>
      <Alert messages={serverErrors} />

      <Field label="Başlık" htmlFor="task-title" required error={errors.title?.message}>
        <Input id="task-title" {...register('title')} placeholder="Örn. Giriş ekranını tamamla" />
      </Field>

      <Field label="Açıklama" htmlFor="task-description" error={errors.description?.message}>
        <Textarea id="task-description" {...register('description')} />
      </Field>

      <div className="grid gap-4 sm:grid-cols-2">
        <Field label="Proje" htmlFor="task-project" required error={errors.projectId?.message}>
          <Select
            id="task-project"
            disabled={lockProject}
            {...register('projectId', {
              valueAsNumber: true,
              onChange: () => setValue('assignedUserId', ''),
            })}
          >
            <option value="">Proje seçin</option>
            {projects.map((p) => (
              <option key={p.id} value={p.id}>
                {p.name}
              </option>
            ))}
          </Select>
        </Field>

        <Field
          label="Atanan kişi"
          htmlFor="task-assignee"
          required
          error={errors.assignedUserId?.message}
          hint={projectId && !membersLoading && members.length === 0 ? 'Projede henüz üye yok.' : 'Yalnızca proje üyeleri seçilebilir.'}
        >
          <Select id="task-assignee" disabled={!projectId} {...register('assignedUserId')}>
            <option value="">{membersLoading ? 'Yükleniyor...' : 'Kişi seçin'}</option>
            {memberOptions.map((m) => (
              <option key={m.id} value={m.id}>
                {m.name}
              </option>
            ))}
          </Select>
        </Field>

        <Field label="Öncelik" htmlFor="task-priority" error={errors.priority?.message}>
          <Select id="task-priority" {...register('priority', { valueAsNumber: true })}>
            {(Object.keys(TASK_PRIORITY_LABELS) as unknown as Priority[]).map((key) => (
              <option key={key} value={key}>
                {TASK_PRIORITY_LABELS[key]}
              </option>
            ))}
          </Select>
        </Field>

        {task && (
          <Field label="Durum" htmlFor="task-status" error={errors.status?.message}>
            <Select id="task-status" {...register('status', { valueAsNumber: true })}>
              {(Object.keys(TASK_STATUS_LABELS) as unknown as Status[]).map((key) => (
                <option key={key} value={key}>
                  {TASK_STATUS_LABELS[key]}
                </option>
              ))}
            </Select>
          </Field>
        )}

        <Field label="Başlangıç tarihi" htmlFor="task-start" error={errors.startDate?.message}>
          <Input id="task-start" type="date" {...register('startDate')} />
        </Field>

        <Field label="Bitiş tarihi" htmlFor="task-due" required error={errors.dueDate?.message}>
          <Input id="task-due" type="date" {...register('dueDate')} />
        </Field>
      </div>

      <div className="flex justify-end gap-2 pt-2">
        <Button variant="secondary" onClick={onCancel}>
          Vazgeç
        </Button>
        <Button type="submit" loading={isSubmitting}>
          {task ? 'Kaydet' : 'Görevi oluştur'}
        </Button>
      </div>
    </form>
  )
}
