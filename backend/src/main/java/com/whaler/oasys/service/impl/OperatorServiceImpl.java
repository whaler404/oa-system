package com.whaler.oasys.service.impl;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.flowable.engine.FormService;
import org.flowable.engine.RuntimeService;
import org.flowable.engine.TaskService;
import org.flowable.form.api.FormInfo;
import org.flowable.form.model.FormField;
import org.flowable.form.model.SimpleFormModel;
import org.flowable.task.api.Task;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.whaler.oasys.mapper.OperatorMapper;
import com.whaler.oasys.model.entity.OperatorEntity;
import com.whaler.oasys.model.exception.ApiException;
import com.whaler.oasys.model.vo.FormFieldVo;
import com.whaler.oasys.model.vo.FormVo;
import com.whaler.oasys.model.vo.OperatorVo;
import com.whaler.oasys.model.vo.TaskVo;
import com.whaler.oasys.security.UserContext;
import com.whaler.oasys.service.CategoryService;
import com.whaler.oasys.service.OperatorService;
import com.whaler.oasys.service.UserService;

@Service
public class OperatorServiceImpl
extends ServiceImpl<OperatorMapper,OperatorEntity>
implements OperatorService {
    @Autowired
    private RuntimeService runtimeService;
    @Autowired
    private TaskService taskService;
    @Autowired
    private FormService formService;
    @Autowired
    private UserService userService;
    @Autowired
    private CategoryService categoryService;

    @Override
    public int insertOperatorEntity(Long operatorId, String processinstanceId) {
        return this.baseMapper.insertOperatorEntity(operatorId, processinstanceId);
    }

    @Override
    public int deleteOperatorEntity(Long operatorId, String processinstanceId) {
        return this.baseMapper.deleteOperatorEntity(operatorId, processinstanceId);
    }

    @Override
    public OperatorVo selectByOperatorId(Long operatorId) {
        List<OperatorEntity> operatorEntities = this.baseMapper.selectByOperatorId(operatorId);
        OperatorVo operatorVo=new OperatorVo();
        operatorVo.setOperatorId(operatorId);
        operatorVo.setProcessinstanceIds(
            operatorEntities.stream()
            .map(OperatorEntity::getProcessinstanceId)
            .collect(Collectors.toSet())
        );
        return operatorVo;
    }

    @Override
    public List<TaskVo> listOperatorTasks() {
        Long permissionId=userService.getById(UserContext.getCurrentUserId()).getPermissionId();
        List<Task>operateAssignedTasks=taskService.createTaskQuery()
            .taskAssignee(Long.toString(permissionId)).list();
        
        List<String> categoryIds=categoryService.selectCategoryIdsByPermissionId(permissionId)
            .stream().map(categoryId->Long.toString(categoryId)).collect(Collectors.toList());
        
        List<Task>operateCandidateTasks=taskService.createTaskQuery()
            .taskCandidateGroupIn(categoryIds).list();

        operateAssignedTasks.addAll(operateCandidateTasks);
        List<TaskVo>taskVos=operateAssignedTasks.stream()
            .map(task->{
                TaskVo taskVo=new TaskVo();
                taskVo.setTaskId(task.getId());
                taskVo.setTaskName(task.getName());
                taskVo.setExecutionId(task.getExecutionId());
                taskVo.setDescription(task.getDescription());
                return taskVo;
            }).collect(Collectors.toList());
        return taskVos;
    }

    @Override
    public FormVo getStartForm(String taskId) {
        Task task=taskService.createTaskQuery().taskId(taskId).singleResult();
        if (task==null) {
            throw new ApiException("任务不存在");
        }
        String startFormTaskId=runtimeService.getVariable(task.getExecutionId(), "startFormTask").toString();
        
        FormInfo startFormInfo = taskService.getTaskFormModel(startFormTaskId);
        if(startFormInfo==null){
            throw new ApiException("表单不存在");
        }
        FormVo formVo=new FormVo();
        formVo.setFormKey(startFormInfo.getKey());
        formVo.setFormName(startFormInfo.getName());
        List<FormField>formFields=((SimpleFormModel)startFormInfo.getFormModel()).getFields();
        List<FormFieldVo>formFieldVos=formFields.stream().map(formField -> 
                new FormFieldVo()
                .setId(formField.getId())
                .setName(formField.getName())
                .setType(formField.getType())
                .setValue(formField.getValue())
                .setReadOnly(formField.isReadOnly())
                .setRequired(formField.isRequired())
            ).collect(Collectors.toList());
        formVo.setFormFields(formFieldVos);
        return formVo;
    }

    @Override
    public FormVo getTaskForm(String taskId) {
        Task task = taskService.createTaskQuery().taskId(taskId).singleResult();
        if (task == null) {
            throw new ApiException("任务不存在");
        }
        FormInfo formInfo = taskService.getTaskFormModel(task.getId());
        if(formInfo==null){
            throw new ApiException("表单不存在");
        }
        FormVo formVo=new FormVo();
        formVo.setFormKey(formInfo.getKey());
        formVo.setFormName(formInfo.getName());
        List<FormField>formFields=((SimpleFormModel)formInfo.getFormModel()).getFields();
        List<FormFieldVo>formFieldVos=formFields.stream().map(formField -> 
                new FormFieldVo()
                .setId(formField.getId())
                .setName(formField.getName())
                .setType(formField.getType())
                .setValue(formField.getValue())
                .setReadOnly(formField.isReadOnly())
                .setRequired(formField.isRequired())
            ).collect(Collectors.toList());
        formVo.setFormFields(formFieldVos);
        return formVo;
    }

    @Override
    public void finishOperatorTask(String taskId, Map<String, String> form) {
        Task task = taskService.createTaskQuery().taskId(taskId).singleResult();
        if (task == null) {
            throw new RuntimeException("任务不存在");
        }
        formService.submitTaskFormData(taskId, form);
    }
}