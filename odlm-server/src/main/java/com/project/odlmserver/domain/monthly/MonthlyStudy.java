package com.project.odlmserver.domain.monthly;

import jakarta.persistence.EmbeddedId;
import jakarta.persistence.Entity;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Entity
public class MonthlyStudy implements Serializable {

    @EmbeddedId
    private MonthlyStudyId id; // 복합 키
    private Long time;
}
