// # Proxy Compiler 18.9.4-973a4d-20181128

import Foundation
import SAPOData

internal class ZREQUESTFORCHANGESRVEntitiesMetadataChanges {
    static func merge(metadata: CSDLDocument) {
        metadata.hasGeneratedProxies = true
        ZREQUESTFORCHANGESRVEntitiesMetadata.document = metadata
        ZREQUESTFORCHANGESRVEntitiesMetadataChanges.merge1(metadata: metadata)
        try! ZREQUESTFORCHANGESRVEntitiesFactory.registerAll()
    }

    private static func merge1(metadata: CSDLDocument) {
        Ignore.valueOf_any(metadata)
        if !ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCApprove.isRemoved {
            ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCApprove = metadata.entityType(withName: "ZREQUEST_FOR_CHANGE_SRV.RfCApprove")
        }
        if !ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCQueryService.isRemoved {
            ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCQueryService = metadata.entityType(withName: "ZREQUEST_FOR_CHANGE_SRV.RfCQueryService")
        }
        if !ZREQUESTFORCHANGESRVEntitiesMetadata.EntitySets.rfCApproveSet.isRemoved {
            ZREQUESTFORCHANGESRVEntitiesMetadata.EntitySets.rfCApproveSet = metadata.entitySet(withName: "RfCApproveSet")
        }
        if !ZREQUESTFORCHANGESRVEntitiesMetadata.EntitySets.rfCQueryServiceSet.isRemoved {
            ZREQUESTFORCHANGESRVEntitiesMetadata.EntitySets.rfCQueryServiceSet = metadata.entitySet(withName: "RfCQueryServiceSet")
        }
        if !RfCApprove.objectID.isRemoved {
            RfCApprove.objectID = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCApprove.property(withName: "ObjectId")
        }
        if !RfCApprove.processType.isRemoved {
            RfCApprove.processType = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCApprove.property(withName: "ProcessType")
        }
        if !RfCApprove.operationType.isRemoved {
            RfCApprove.operationType = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCApprove.property(withName: "OperationType")
        }
        if !RfCApprove.comments.isRemoved {
            RfCApprove.comments = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCApprove.property(withName: "Comments")
        }
        if !RfCApprove.success.isRemoved {
            RfCApprove.success = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCApprove.property(withName: "Success")
        }
        if !RfCApprove.errorMessage.isRemoved {
            RfCApprove.errorMessage = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCApprove.property(withName: "ErrorMessage")
        }
        if !RfCQueryService.objectID.isRemoved {
            RfCQueryService.objectID = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCQueryService.property(withName: "ObjectId")
        }
        if !RfCQueryService.processType.isRemoved {
            RfCQueryService.processType = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCQueryService.property(withName: "ProcessType")
        }
        if !RfCQueryService.ticket.isRemoved {
            RfCQueryService.ticket = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCQueryService.property(withName: "Ticket")
        }
        if !RfCQueryService.description.isRemoved {
            RfCQueryService.description = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCQueryService.property(withName: "Description")
        }
        if !RfCQueryService.createdAt.isRemoved {
            RfCQueryService.createdAt = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCQueryService.property(withName: "CreatedAt")
        }
        if !RfCQueryService.createdBy.isRemoved {
            RfCQueryService.createdBy = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCQueryService.property(withName: "CreatedBy")
        }
        if !RfCQueryService.changeManager.isRemoved {
            RfCQueryService.changeManager = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCQueryService.property(withName: "ChangeManager")
        }
        if !RfCQueryService.landscape.isRemoved {
            RfCQueryService.landscape = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCQueryService.property(withName: "Landscape")
        }
        if !RfCQueryService.correction.isRemoved {
            RfCQueryService.correction = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCQueryService.property(withName: "Correction")
        }
        if !RfCQueryService.system.isRemoved {
            RfCQueryService.system = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCQueryService.property(withName: "System")
        }
        if !RfCQueryService.soldToParty.isRemoved {
            RfCQueryService.soldToParty = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCQueryService.property(withName: "SoldToParty")
        }
        if !RfCQueryService.requester.isRemoved {
            RfCQueryService.requester = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCQueryService.property(withName: "Requester")
        }
        if !RfCQueryService.requestedStart.isRemoved {
            RfCQueryService.requestedStart = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCQueryService.property(withName: "RequestedStart")
        }
        if !RfCQueryService.requestedEnd.isRemoved {
            RfCQueryService.requestedEnd = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCQueryService.property(withName: "RequestedEnd")
        }
        if !RfCQueryService.dueBy.isRemoved {
            RfCQueryService.dueBy = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCQueryService.property(withName: "DueBy")
        }
        if !RfCQueryService.changeCycle.isRemoved {
            RfCQueryService.changeCycle = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCQueryService.property(withName: "ChangeCycle")
        }
        if !RfCQueryService.phase.isRemoved {
            RfCQueryService.phase = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCQueryService.property(withName: "Phase")
        }
        if !RfCQueryService.type_.isRemoved {
            RfCQueryService.type_ = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCQueryService.property(withName: "Type")
        }
        if !RfCQueryService.id.isRemoved {
            RfCQueryService.id = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCQueryService.property(withName: "Id")
        }
        if !RfCQueryService.landscapeCycle.isRemoved {
            RfCQueryService.landscapeCycle = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCQueryService.property(withName: "LandscapeCycle")
        }
        if !RfCQueryService.branch.isRemoved {
            RfCQueryService.branch = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCQueryService.property(withName: "Branch")
        }
        if !RfCQueryService.developmentClose.isRemoved {
            RfCQueryService.developmentClose = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCQueryService.property(withName: "DevelopmentClose")
        }
        if !RfCQueryService.goLiveDate.isRemoved {
            RfCQueryService.goLiveDate = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCQueryService.property(withName: "GoLiveDate")
        }
        if !RfCQueryService.longDescription.isRemoved {
            RfCQueryService.longDescription = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCQueryService.property(withName: "LongDescription")
        }
        if !RfCQueryService.status.isRemoved {
            RfCQueryService.status = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCQueryService.property(withName: "Status")
        }
    }
}
