package com.project.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;



@Entity
@Getter @Setter

public class Daily_study {
    @Id
    private date date;
}
