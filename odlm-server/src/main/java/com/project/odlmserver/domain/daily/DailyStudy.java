package com.project.odlmserver.domain.daily;

import com.project.odlmserver.domain.monthly.MonthlyStudyId;
import jakarta.persistence.EmbeddedId;
import jakarta.persistence.Entity;
import lombok.*;

import java.io.Serializable;

@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Entity
public class DailyStudy implements Serializable { // JPA에서 복합키는 Serializable 객체로 별도로 저장해야함

    @EmbeddedId
    private DailyStudyId id; // 복합 키

    private Long time;
}
