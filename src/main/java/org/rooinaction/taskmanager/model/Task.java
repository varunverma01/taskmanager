package org.rooinaction.taskmanager.model;
import org.springframework.roo.addon.javabean.RooJavaBean;
import org.springframework.roo.addon.jpa.activerecord.RooJpaActiveRecord;
import org.springframework.roo.addon.tostring.RooToString;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import org.springframework.beans.factory.annotation.Value;

@RooJavaBean
@RooToString
@RooJpaActiveRecord
public class Task {

    /**
     */
    @NotNull
    @Size(max = 40)
    private String description;

    /**
     */
    @Value("false")
    private Boolean completed;
}
