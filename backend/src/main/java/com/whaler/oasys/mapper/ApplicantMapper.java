package com.whaler.oasys.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.whaler.oasys.model.entity.ApplicantEntity;

@Repository
@Mapper
public interface ApplicantMapper
extends BaseMapper<ApplicantEntity> {
    /**
     * 插入申请人实体信息。
     * 
     * @param processInstanceId 流程实例ID，用于标识具体的流程实例。
     * @param operatorId 操作人ID，标识进行此操作的用户。
     * 
     * @return 返回插入的记录数。
     */
    int insertApplicantEntity(
        @Param("applicantId") Long applicantId,
        @Param("processinstanceId") String processinstanceId
    );

    /**
     * 删除申请人实体。
     * 
     * @param applicantId 申请人的唯一标识符，类型为Long。
     * @param processinstanceId 流程实例的唯一标识符，类型为String。
     * @return 返回操作影响的行数，类型为int。通常，如果删除成功，返回值应为1。
     */
    int deleteApplicantEntity(
        @Param("applicantId") Long applicantId,
        @Param("processinstanceId") String processinstanceId
    );

    /**
     * 根据申请人ID查询申请人实体列表。
     * 
     * @param applicantId 申请人的唯一标识符。
     * @return 返回一个申请人实体列表，如果申请人不存在，则返回空列表。
     */
    List<ApplicantEntity> selectByApplicantId(Long applicantId);
}