// # Proxy Compiler 18.9.4-973a4d-20181128

import Foundation
import SAPOData

public class ZREQUESTFORCHANGESRVEntitiesMetadata {
    private static var document_: CSDLDocument = ZREQUESTFORCHANGESRVEntitiesMetadata.resolve()

    public static var document: CSDLDocument {
        get {
            objc_sync_enter(ZREQUESTFORCHANGESRVEntitiesMetadata.self)
            defer { objc_sync_exit(ZREQUESTFORCHANGESRVEntitiesMetadata.self) }
            do {
                return ZREQUESTFORCHANGESRVEntitiesMetadata.document_
            }
        }
        set(value) {
            objc_sync_enter(ZREQUESTFORCHANGESRVEntitiesMetadata.self)
            defer { objc_sync_exit(ZREQUESTFORCHANGESRVEntitiesMetadata.self) }
            do {
                ZREQUESTFORCHANGESRVEntitiesMetadata.document_ = value
            }
        }
    }

    private static func resolve() -> CSDLDocument {
        try! ZREQUESTFORCHANGESRVEntitiesFactory.registerAll()
        ZREQUESTFORCHANGESRVEntitiesMetadataParser.parsed.hasGeneratedProxies = true
        return ZREQUESTFORCHANGESRVEntitiesMetadataParser.parsed
    }

    public class EntityTypes {
        private static var rfCApprove_: EntityType = ZREQUESTFORCHANGESRVEntitiesMetadataParser.parsed.entityType(withName: "ZREQUEST_FOR_CHANGE_SRV.RfCApprove")

        private static var rfCQueryService_: EntityType = ZREQUESTFORCHANGESRVEntitiesMetadataParser.parsed.entityType(withName: "ZREQUEST_FOR_CHANGE_SRV.RfCQueryService")

        public static var rfCApprove: EntityType {
            get {
                objc_sync_enter(ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.self)
                defer { objc_sync_exit(ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.self) }
                do {
                    return ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCApprove_
                }
            }
            set(value) {
                objc_sync_enter(ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.self)
                defer { objc_sync_exit(ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.self) }
                do {
                    ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCApprove_ = value
                }
            }
        }

        public static var rfCQueryService: EntityType {
            get {
                objc_sync_enter(ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.self)
                defer { objc_sync_exit(ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.self) }
                do {
                    return ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCQueryService_
                }
            }
            set(value) {
                objc_sync_enter(ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.self)
                defer { objc_sync_exit(ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.self) }
                do {
                    ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCQueryService_ = value
                }
            }
        }
    }

    public class EntitySets {
        private static var rfCApproveSet_: EntitySet = ZREQUESTFORCHANGESRVEntitiesMetadataParser.parsed.entitySet(withName: "RfCApproveSet")

        private static var rfCQueryServiceSet_: EntitySet = ZREQUESTFORCHANGESRVEntitiesMetadataParser.parsed.entitySet(withName: "RfCQueryServiceSet")

        public static var rfCApproveSet: EntitySet {
            get {
                objc_sync_enter(ZREQUESTFORCHANGESRVEntitiesMetadata.EntitySets.self)
                defer { objc_sync_exit(ZREQUESTFORCHANGESRVEntitiesMetadata.EntitySets.self) }
                do {
                    return ZREQUESTFORCHANGESRVEntitiesMetadata.EntitySets.rfCApproveSet_
                }
            }
            set(value) {
                objc_sync_enter(ZREQUESTFORCHANGESRVEntitiesMetadata.EntitySets.self)
                defer { objc_sync_exit(ZREQUESTFORCHANGESRVEntitiesMetadata.EntitySets.self) }
                do {
                    ZREQUESTFORCHANGESRVEntitiesMetadata.EntitySets.rfCApproveSet_ = value
                }
            }
        }

        public static var rfCQueryServiceSet: EntitySet {
            get {
                objc_sync_enter(ZREQUESTFORCHANGESRVEntitiesMetadata.EntitySets.self)
                defer { objc_sync_exit(ZREQUESTFORCHANGESRVEntitiesMetadata.EntitySets.self) }
                do {
                    return ZREQUESTFORCHANGESRVEntitiesMetadata.EntitySets.rfCQueryServiceSet_
                }
            }
            set(value) {
                objc_sync_enter(ZREQUESTFORCHANGESRVEntitiesMetadata.EntitySets.self)
                defer { objc_sync_exit(ZREQUESTFORCHANGESRVEntitiesMetadata.EntitySets.self) }
                do {
                    ZREQUESTFORCHANGESRVEntitiesMetadata.EntitySets.rfCQueryServiceSet_ = value
                }
            }
        }
    }
}
