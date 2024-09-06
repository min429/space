package com.project.odlmserver.domain.daily;

import jakarta.persistence.Embeddable;
import lombok.*;

import java.io.Serializable;
import java.time.LocalDate;

@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Embeddable
public class DailyStudyId implements Serializable { // 복합키를 위한 클래스
    private Long userId;
    private Long day;
}
