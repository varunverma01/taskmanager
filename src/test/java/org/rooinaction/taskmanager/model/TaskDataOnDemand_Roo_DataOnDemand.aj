// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package org.rooinaction.taskmanager.model;

import java.security.SecureRandom;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Random;
import javax.validation.ConstraintViolation;
import javax.validation.ConstraintViolationException;
import org.rooinaction.taskmanager.model.Task;
import org.rooinaction.taskmanager.model.TaskDataOnDemand;
import org.rooinaction.taskmanager.repository.TaskRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

privileged aspect TaskDataOnDemand_Roo_DataOnDemand {
    
    declare @type: TaskDataOnDemand: @Component;
    
    private Random TaskDataOnDemand.rnd = new SecureRandom();
    
    private List<Task> TaskDataOnDemand.data;
    
    @Autowired
    TaskRepository TaskDataOnDemand.taskRepository;
    
    public Task TaskDataOnDemand.getNewTransientTask(int index) {
        Task obj = new Task();
        setCompleted(obj, index);
        setDescription(obj, index);
        return obj;
    }
    
    public void TaskDataOnDemand.setCompleted(Task obj, int index) {
        Boolean completed = Boolean.TRUE;
        obj.setCompleted(completed);
    }
    
    public void TaskDataOnDemand.setDescription(Task obj, int index) {
        String description = "description_" + index;
        if (description.length() > 40) {
            description = description.substring(0, 40);
        }
        obj.setDescription(description);
    }
    
    public Task TaskDataOnDemand.getSpecificTask(int index) {
        init();
        if (index < 0) {
            index = 0;
        }
        if (index > (data.size() - 1)) {
            index = data.size() - 1;
        }
        Task obj = data.get(index);
        Long id = obj.getId();
        return taskRepository.findOne(id);
    }
    
    public Task TaskDataOnDemand.getRandomTask() {
        init();
        Task obj = data.get(rnd.nextInt(data.size()));
        Long id = obj.getId();
        return taskRepository.findOne(id);
    }
    
    public boolean TaskDataOnDemand.modifyTask(Task obj) {
        return false;
    }
    
    public void TaskDataOnDemand.init() {
        int from = 0;
        int to = 10;
        data = taskRepository.findAll(new org.springframework.data.domain.PageRequest(from / to, to)).getContent();
        if (data == null) {
            throw new IllegalStateException("Find entries implementation for 'Task' illegally returned null");
        }
        if (!data.isEmpty()) {
            return;
        }
        
        data = new ArrayList<Task>();
        for (int i = 0; i < 10; i++) {
            Task obj = getNewTransientTask(i);
            try {
                taskRepository.save(obj);
            } catch (final ConstraintViolationException e) {
                final StringBuilder msg = new StringBuilder();
                for (Iterator<ConstraintViolation<?>> iter = e.getConstraintViolations().iterator(); iter.hasNext();) {
                    final ConstraintViolation<?> cv = iter.next();
                    msg.append("[").append(cv.getRootBean().getClass().getName()).append(".").append(cv.getPropertyPath()).append(": ").append(cv.getMessage()).append(" (invalid value = ").append(cv.getInvalidValue()).append(")").append("]");
                }
                throw new IllegalStateException(msg.toString(), e);
            }
            taskRepository.flush();
            data.add(obj);
        }
    }
    
}
