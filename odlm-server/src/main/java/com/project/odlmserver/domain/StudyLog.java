package com.project.odlmserver.domain;

import lombok.*;
import java.time.LocalDateTime;

@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class StudyLog {

    private Long userId;
    private LocalDateTime dateTime;
    private StudyLogType type;

    public enum StudyLogType {
        START,
        END
    }
}
