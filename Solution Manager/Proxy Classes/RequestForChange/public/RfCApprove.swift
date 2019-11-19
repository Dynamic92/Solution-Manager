// # Proxy Compiler 18.9.4-973a4d-20181128

import Foundation
import SAPOData

open class RfCApprove: EntityValue {
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    private static var objectID_: Property = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCApprove.property(withName: "ObjectId")

    private static var processType_: Property = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCApprove.property(withName: "ProcessType")

    private static var operationType_: Property = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCApprove.property(withName: "OperationType")

    private static var comments_: Property = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCApprove.property(withName: "Comments")

    private static var success_: Property = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCApprove.property(withName: "Success")

    private static var errorMessage_: Property = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCApprove.property(withName: "ErrorMessage")

    public init(withDefaults: Bool = true) {
        super.init(withDefaults: withDefaults, type: ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCApprove)
    }

    open class func array(from: EntityValueList) -> Array<RfCApprove> {
        return ArrayConverter.convert(from.toArray(), Array<RfCApprove>())
    }

    open class var comments: Property {
        get {
            objc_sync_enter(RfCApprove.self)
            defer { objc_sync_exit(RfCApprove.self) }
            do {
                return RfCApprove.comments_
            }
        }
        set(value) {
            objc_sync_enter(RfCApprove.self)
            defer { objc_sync_exit(RfCApprove.self) }
            do {
                RfCApprove.comments_ = value
            }
        }
    }

    open var comments: String? {
        get {
            return StringValue.optional(self.optionalValue(for: RfCApprove.comments))
        }
        set(value) {
            self.setOptionalValue(for: RfCApprove.comments, to: StringValue.of(optional: value))
        }
    }

    open func copy() -> RfCApprove {
        return CastRequired<RfCApprove>.from(self.copyEntity())
    }

    open class var errorMessage: Property {
        get {
            objc_sync_enter(RfCApprove.self)
            defer { objc_sync_exit(RfCApprove.self) }
            do {
                return RfCApprove.errorMessage_
            }
        }
        set(value) {
            objc_sync_enter(RfCApprove.self)
            defer { objc_sync_exit(RfCApprove.self) }
            do {
                RfCApprove.errorMessage_ = value
            }
        }
    }

    open var errorMessage: String? {
        get {
            return StringValue.optional(self.optionalValue(for: RfCApprove.errorMessage))
        }
        set(value) {
            self.setOptionalValue(for: RfCApprove.errorMessage, to: StringValue.of(optional: value))
        }
    }

    open override var isProxy: Bool {
        return true
    }

    open class func key(objectID: String?, processType: String?, operationType: String?) -> EntityKey {
        return EntityKey().with(name: "ObjectId", value: StringValue.of(optional: objectID)).with(name: "ProcessType", value: StringValue.of(optional: processType)).with(name: "OperationType", value: StringValue.of(optional: operationType))
    }

    open class var objectID: Property {
        get {
            objc_sync_enter(RfCApprove.self)
            defer { objc_sync_exit(RfCApprove.self) }
            do {
                return RfCApprove.objectID_
            }
        }
        set(value) {
            objc_sync_enter(RfCApprove.self)
            defer { objc_sync_exit(RfCApprove.self) }
            do {
                RfCApprove.objectID_ = value
            }
        }
    }

    open var objectID: String? {
        get {
            return StringValue.optional(self.optionalValue(for: RfCApprove.objectID))
        }
        set(value) {
            self.setOptionalValue(for: RfCApprove.objectID, to: StringValue.of(optional: value))
        }
    }

    open var old: RfCApprove {
        return CastRequired<RfCApprove>.from(self.oldEntity)
    }

    open class var operationType: Property {
        get {
            objc_sync_enter(RfCApprove.self)
            defer { objc_sync_exit(RfCApprove.self) }
            do {
                return RfCApprove.operationType_
            }
        }
        set(value) {
            objc_sync_enter(RfCApprove.self)
            defer { objc_sync_exit(RfCApprove.self) }
            do {
                RfCApprove.operationType_ = value
            }
        }
    }

    open var operationType: String? {
        get {
            return StringValue.optional(self.optionalValue(for: RfCApprove.operationType))
        }
        set(value) {
            self.setOptionalValue(for: RfCApprove.operationType, to: StringValue.of(optional: value))
        }
    }

    open class var processType: Property {
        get {
            objc_sync_enter(RfCApprove.self)
            defer { objc_sync_exit(RfCApprove.self) }
            do {
                return RfCApprove.processType_
            }
        }
        set(value) {
            objc_sync_enter(RfCApprove.self)
            defer { objc_sync_exit(RfCApprove.self) }
            do {
                RfCApprove.processType_ = value
            }
        }
    }

    open var processType: String? {
        get {
            return StringValue.optional(self.optionalValue(for: RfCApprove.processType))
        }
        set(value) {
            self.setOptionalValue(for: RfCApprove.processType, to: StringValue.of(optional: value))
        }
    }

    open class var success: Property {
        get {
            objc_sync_enter(RfCApprove.self)
            defer { objc_sync_exit(RfCApprove.self) }
            do {
                return RfCApprove.success_
            }
        }
        set(value) {
            objc_sync_enter(RfCApprove.self)
            defer { objc_sync_exit(RfCApprove.self) }
            do {
                RfCApprove.success_ = value
            }
        }
    }

    open var success: Bool? {
        get {
            return BooleanValue.optional(self.optionalValue(for: RfCApprove.success))
        }
        set(value) {
            self.setOptionalValue(for: RfCApprove.success, to: BooleanValue.of(optional: value))
        }
    }
}
