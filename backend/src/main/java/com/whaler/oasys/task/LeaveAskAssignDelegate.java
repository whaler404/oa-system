package com.whaler.oasys.task;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;
import java.util.stream.Collector;
import java.util.stream.Collectors;

import org.apache.commons.collections4.CollectionUtils;
import org.flowable.engine.TaskService;
import org.flowable.engine.delegate.DelegateExecution;
import org.flowable.engine.delegate.JavaDelegate;
import org.flowable.task.api.Task;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.BeanDefinition;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import com.alibaba.fastjson.JSONArray;
import com.whaler.oasys.model.vo.CategoryVo;
import com.whaler.oasys.service.CategoryService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component("LeaveAskAssignDelegate")
@Scope(BeanDefinition.SCOPE_PROTOTYPE)
public class LeaveAskAssignDelegate
implements JavaDelegate{
    @Autowired
    private CategoryService categoryService;
    @Autowired
    private TaskService taskService;

    @Override
    public void execute(DelegateExecution execution){
        String applicantDepartment=(String)execution.getVariable("applicantDepartment");
        Long categoryId= categoryService.selectByCategoryName(applicantDepartment).getCategoryId();
        List<Long>permissionIds1=categoryService.selectByCategoryId(categoryId).getPermissionIds();
        List<Long>permissionIds2=categoryService.selectByCategoryId(11L).getPermissionIds();
        List<Long>permissionIds3=categoryService.selectByCategoryId(12L).getPermissionIds();

        List<Long> leaders = CollectionUtils.intersection(permissionIds1, permissionIds2).stream().collect(Collectors.toList());
        List<Long> managers = CollectionUtils.intersection(permissionIds1, permissionIds3).stream().collect(Collectors.toList());
        String strLeaders=JSONArray.toJSON(leaders).toString();
        strLeaders=strLeaders.substring(1, strLeaders.length()-1);
        String strManagers=JSONArray.toJSON(managers).toString();
        strManagers=strManagers.substring(1, strManagers.length()-1);
        log.info("leaders:{}",strLeaders);
        log.info("managers:{}",strManagers);

        execution.setVariable("leader", strLeaders);
        execution.setVariable("manager", strManagers);
    }
}
