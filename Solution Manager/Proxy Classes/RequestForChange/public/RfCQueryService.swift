// # Proxy Compiler 18.9.4-973a4d-20181128

import Foundation
import SAPOData

open class RfCQueryService: EntityValue {
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    private static var objectID_: Property = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCQueryService.property(withName: "ObjectId")

    private static var processType_: Property = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCQueryService.property(withName: "ProcessType")

    private static var ticket_: Property = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCQueryService.property(withName: "Ticket")

    private static var description_: Property = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCQueryService.property(withName: "Description")

    private static var createdAt_: Property = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCQueryService.property(withName: "CreatedAt")

    private static var createdBy_: Property = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCQueryService.property(withName: "CreatedBy")

    private static var changeManager_: Property = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCQueryService.property(withName: "ChangeManager")

    private static var landscape_: Property = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCQueryService.property(withName: "Landscape")

    private static var correction_: Property = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCQueryService.property(withName: "Correction")

    private static var system_: Property = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCQueryService.property(withName: "System")

    private static var soldToParty_: Property = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCQueryService.property(withName: "SoldToParty")

    private static var requester_: Property = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCQueryService.property(withName: "Requester")

    private static var requestedStart_: Property = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCQueryService.property(withName: "RequestedStart")

    private static var requestedEnd_: Property = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCQueryService.property(withName: "RequestedEnd")

    private static var dueBy_: Property = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCQueryService.property(withName: "DueBy")

    private static var changeCycle_: Property = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCQueryService.property(withName: "ChangeCycle")

    private static var phase_: Property = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCQueryService.property(withName: "Phase")

    private static var type__: Property = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCQueryService.property(withName: "Type")

    private static var id_: Property = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCQueryService.property(withName: "Id")

    private static var landscapeCycle_: Property = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCQueryService.property(withName: "LandscapeCycle")

    private static var branch_: Property = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCQueryService.property(withName: "Branch")

    private static var developmentClose_: Property = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCQueryService.property(withName: "DevelopmentClose")

    private static var goLiveDate_: Property = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCQueryService.property(withName: "GoLiveDate")

    private static var longDescription_: Property = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCQueryService.property(withName: "LongDescription")

    private static var status_: Property = ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCQueryService.property(withName: "Status")

    public init(withDefaults: Bool = true) {
        super.init(withDefaults: withDefaults, type: ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCQueryService)
    }

    open class func array(from: EntityValueList) -> Array<RfCQueryService> {
        return ArrayConverter.convert(from.toArray(), Array<RfCQueryService>())
    }

    open class var branch: Property {
        get {
            objc_sync_enter(RfCQueryService.self)
            defer { objc_sync_exit(RfCQueryService.self) }
            do {
                return RfCQueryService.branch_
            }
        }
        set(value) {
            objc_sync_enter(RfCQueryService.self)
            defer { objc_sync_exit(RfCQueryService.self) }
            do {
                RfCQueryService.branch_ = value
            }
        }
    }

    open var branch: String? {
        get {
            return StringValue.optional(self.optionalValue(for: RfCQueryService.branch))
        }
        set(value) {
            self.setOptionalValue(for: RfCQueryService.branch, to: StringValue.of(optional: value))
        }
    }

    open class var changeCycle: Property {
        get {
            objc_sync_enter(RfCQueryService.self)
            defer { objc_sync_exit(RfCQueryService.self) }
            do {
                return RfCQueryService.changeCycle_
            }
        }
        set(value) {
            objc_sync_enter(RfCQueryService.self)
            defer { objc_sync_exit(RfCQueryService.self) }
            do {
                RfCQueryService.changeCycle_ = value
            }
        }
    }

    open var changeCycle: String? {
        get {
            return StringValue.optional(self.optionalValue(for: RfCQueryService.changeCycle))
        }
        set(value) {
            self.setOptionalValue(for: RfCQueryService.changeCycle, to: StringValue.of(optional: value))
        }
    }

    open class var changeManager: Property {
        get {
            objc_sync_enter(RfCQueryService.self)
            defer { objc_sync_exit(RfCQueryService.self) }
            do {
                return RfCQueryService.changeManager_
            }
        }
        set(value) {
            objc_sync_enter(RfCQueryService.self)
            defer { objc_sync_exit(RfCQueryService.self) }
            do {
                RfCQueryService.changeManager_ = value
            }
        }
    }

    open var changeManager: String? {
        get {
            return StringValue.optional(self.optionalValue(for: RfCQueryService.changeManager))
        }
        set(value) {
            self.setOptionalValue(for: RfCQueryService.changeManager, to: StringValue.of(optional: value))
        }
    }

    open func copy() -> RfCQueryService {
        return CastRequired<RfCQueryService>.from(self.copyEntity())
    }

    open class var correction: Property {
        get {
            objc_sync_enter(RfCQueryService.self)
            defer { objc_sync_exit(RfCQueryService.self) }
            do {
                return RfCQueryService.correction_
            }
        }
        set(value) {
            objc_sync_enter(RfCQueryService.self)
            defer { objc_sync_exit(RfCQueryService.self) }
            do {
                RfCQueryService.correction_ = value
            }
        }
    }

    open var correction: String? {
        get {
            return StringValue.optional(self.optionalValue(for: RfCQueryService.correction))
        }
        set(value) {
            self.setOptionalValue(for: RfCQueryService.correction, to: StringValue.of(optional: value))
        }
    }

    open class var createdAt: Property {
        get {
            objc_sync_enter(RfCQueryService.self)
            defer { objc_sync_exit(RfCQueryService.self) }
            do {
                return RfCQueryService.createdAt_
            }
        }
        set(value) {
            objc_sync_enter(RfCQueryService.self)
            defer { objc_sync_exit(RfCQueryService.self) }
            do {
                RfCQueryService.createdAt_ = value
            }
        }
    }

    open var createdAt: LocalDateTime? {
        get {
            return LocalDateTime.castOptional(self.optionalValue(for: RfCQueryService.createdAt))
        }
        set(value) {
            self.setOptionalValue(for: RfCQueryService.createdAt, to: value)
        }
    }

    open class var createdBy: Property {
        get {
            objc_sync_enter(RfCQueryService.self)
            defer { objc_sync_exit(RfCQueryService.self) }
            do {
                return RfCQueryService.createdBy_
            }
        }
        set(value) {
            objc_sync_enter(RfCQueryService.self)
            defer { objc_sync_exit(RfCQueryService.self) }
            do {
                RfCQueryService.createdBy_ = value
            }
        }
    }

    open var createdBy: String? {
        get {
            return StringValue.optional(self.optionalValue(for: RfCQueryService.createdBy))
        }
        set(value) {
            self.setOptionalValue(for: RfCQueryService.createdBy, to: StringValue.of(optional: value))
        }
    }

    open class var description: Property {
        get {
            objc_sync_enter(RfCQueryService.self)
            defer { objc_sync_exit(RfCQueryService.self) }
            do {
                return RfCQueryService.description_
            }
        }
        set(value) {
            objc_sync_enter(RfCQueryService.self)
            defer { objc_sync_exit(RfCQueryService.self) }
            do {
                RfCQueryService.description_ = value
            }
        }
    }

    open var description: String? {
        get {
            return StringValue.optional(self.optionalValue(for: RfCQueryService.description))
        }
        set(value) {
            self.setOptionalValue(for: RfCQueryService.description, to: StringValue.of(optional: value))
        }
    }

    open class var developmentClose: Property {
        get {
            objc_sync_enter(RfCQueryService.self)
            defer { objc_sync_exit(RfCQueryService.self) }
            do {
                return RfCQueryService.developmentClose_
            }
        }
        set(value) {
            objc_sync_enter(RfCQueryService.self)
            defer { objc_sync_exit(RfCQueryService.self) }
            do {
                RfCQueryService.developmentClose_ = value
            }
        }
    }

    open var developmentClose: LocalDateTime? {
        get {
            return LocalDateTime.castOptional(self.optionalValue(for: RfCQueryService.developmentClose))
        }
        set(value) {
            self.setOptionalValue(for: RfCQueryService.developmentClose, to: value)
        }
    }

    open class var dueBy: Property {
        get {
            objc_sync_enter(RfCQueryService.self)
            defer { objc_sync_exit(RfCQueryService.self) }
            do {
                return RfCQueryService.dueBy_
            }
        }
        set(value) {
            objc_sync_enter(RfCQueryService.self)
            defer { objc_sync_exit(RfCQueryService.self) }
            do {
                RfCQueryService.dueBy_ = value
            }
        }
    }

    open var dueBy: LocalDateTime? {
        get {
            return LocalDateTime.castOptional(self.optionalValue(for: RfCQueryService.dueBy))
        }
        set(value) {
            self.setOptionalValue(for: RfCQueryService.dueBy, to: value)
        }
    }

    open class var goLiveDate: Property {
        get {
            objc_sync_enter(RfCQueryService.self)
            defer { objc_sync_exit(RfCQueryService.self) }
            do {
                return RfCQueryService.goLiveDate_
            }
        }
        set(value) {
            objc_sync_enter(RfCQueryService.self)
            defer { objc_sync_exit(RfCQueryService.self) }
            do {
                RfCQueryService.goLiveDate_ = value
            }
        }
    }

    open var goLiveDate: LocalDateTime? {
        get {
            return LocalDateTime.castOptional(self.optionalValue(for: RfCQueryService.goLiveDate))
        }
        set(value) {
            self.setOptionalValue(for: RfCQueryService.goLiveDate, to: value)
        }
    }

    open class var id: Property {
        get {
            objc_sync_enter(RfCQueryService.self)
            defer { objc_sync_exit(RfCQueryService.self) }
            do {
                return RfCQueryService.id_
            }
        }
        set(value) {
            objc_sync_enter(RfCQueryService.self)
            defer { objc_sync_exit(RfCQueryService.self) }
            do {
                RfCQueryService.id_ = value
            }
        }
    }

    open var id: String? {
        get {
            return StringValue.optional(self.optionalValue(for: RfCQueryService.id))
        }
        set(value) {
            self.setOptionalValue(for: RfCQueryService.id, to: StringValue.of(optional: value))
        }
    }

    open override var isProxy: Bool {
        return true
    }

    open class func key(objectID: String?, processType: String?) -> EntityKey {
        return EntityKey().with(name: "ObjectId", value: StringValue.of(optional: objectID)).with(name: "ProcessType", value: StringValue.of(optional: processType))
    }

    open class var landscape: Property {
        get {
            objc_sync_enter(RfCQueryService.self)
            defer { objc_sync_exit(RfCQueryService.self) }
            do {
                return RfCQueryService.landscape_
            }
        }
        set(value) {
            objc_sync_enter(RfCQueryService.self)
            defer { objc_sync_exit(RfCQueryService.self) }
            do {
                RfCQueryService.landscape_ = value
            }
        }
    }

    open var landscape: String? {
        get {
            return StringValue.optional(self.optionalValue(for: RfCQueryService.landscape))
        }
        set(value) {
            self.setOptionalValue(for: RfCQueryService.landscape, to: StringValue.of(optional: value))
        }
    }

    open class var landscapeCycle: Property {
        get {
            objc_sync_enter(RfCQueryService.self)
            defer { objc_sync_exit(RfCQueryService.self) }
            do {
                return RfCQueryService.landscapeCycle_
            }
        }
        set(value) {
            objc_sync_enter(RfCQueryService.self)
            defer { objc_sync_exit(RfCQueryService.self) }
            do {
                RfCQueryService.landscapeCycle_ = value
            }
        }
    }

    open var landscapeCycle: String? {
        get {
            return StringValue.optional(self.optionalValue(for: RfCQueryService.landscapeCycle))
        }
        set(value) {
            self.setOptionalValue(for: RfCQueryService.landscapeCycle, to: StringValue.of(optional: value))
        }
    }

    open class var longDescription: Property {
        get {
            objc_sync_enter(RfCQueryService.self)
            defer { objc_sync_exit(RfCQueryService.self) }
            do {
                return RfCQueryService.longDescription_
            }
        }
        set(value) {
            objc_sync_enter(RfCQueryService.self)
            defer { objc_sync_exit(RfCQueryService.self) }
            do {
                RfCQueryService.longDescription_ = value
            }
        }
    }

    open var longDescription: String? {
        get {
            return StringValue.optional(self.optionalValue(for: RfCQueryService.longDescription))
        }
        set(value) {
            self.setOptionalValue(for: RfCQueryService.longDescription, to: StringValue.of(optional: value))
        }
    }

    open class var objectID: Property {
        get {
            objc_sync_enter(RfCQueryService.self)
            defer { objc_sync_exit(RfCQueryService.self) }
            do {
                return RfCQueryService.objectID_
            }
        }
        set(value) {
            objc_sync_enter(RfCQueryService.self)
            defer { objc_sync_exit(RfCQueryService.self) }
            do {
                RfCQueryService.objectID_ = value
            }
        }
    }

    open var objectID: String? {
        get {
            return StringValue.optional(self.optionalValue(for: RfCQueryService.objectID))
        }
        set(value) {
            self.setOptionalValue(for: RfCQueryService.objectID, to: StringValue.of(optional: value))
        }
    }

    open var old: RfCQueryService {
        return CastRequired<RfCQueryService>.from(self.oldEntity)
    }

    open class var phase: Property {
        get {
            objc_sync_enter(RfCQueryService.self)
            defer { objc_sync_exit(RfCQueryService.self) }
            do {
                return RfCQueryService.phase_
            }
        }
        set(value) {
            objc_sync_enter(RfCQueryService.self)
            defer { objc_sync_exit(RfCQueryService.self) }
            do {
                RfCQueryService.phase_ = value
            }
        }
    }

    open var phase: String? {
        get {
            return StringValue.optional(self.optionalValue(for: RfCQueryService.phase))
        }
        set(value) {
            self.setOptionalValue(for: RfCQueryService.phase, to: StringValue.of(optional: value))
        }
    }

    open class var processType: Property {
        get {
            objc_sync_enter(RfCQueryService.self)
            defer { objc_sync_exit(RfCQueryService.self) }
            do {
                return RfCQueryService.processType_
            }
        }
        set(value) {
            objc_sync_enter(RfCQueryService.self)
            defer { objc_sync_exit(RfCQueryService.self) }
            do {
                RfCQueryService.processType_ = value
            }
        }
    }

    open var processType: String? {
        get {
            return StringValue.optional(self.optionalValue(for: RfCQueryService.processType))
        }
        set(value) {
            self.setOptionalValue(for: RfCQueryService.processType, to: StringValue.of(optional: value))
        }
    }

    open class var requestedEnd: Property {
        get {
            objc_sync_enter(RfCQueryService.self)
            defer { objc_sync_exit(RfCQueryService.self) }
            do {
                return RfCQueryService.requestedEnd_
            }
        }
        set(value) {
            objc_sync_enter(RfCQueryService.self)
            defer { objc_sync_exit(RfCQueryService.self) }
            do {
                RfCQueryService.requestedEnd_ = value
            }
        }
    }

    open var requestedEnd: LocalDateTime? {
        get {
            return LocalDateTime.castOptional(self.optionalValue(for: RfCQueryService.requestedEnd))
        }
        set(value) {
            self.setOptionalValue(for: RfCQueryService.requestedEnd, to: value)
        }
    }

    open class var requestedStart: Property {
        get {
            objc_sync_enter(RfCQueryService.self)
            defer { objc_sync_exit(RfCQueryService.self) }
            do {
                return RfCQueryService.requestedStart_
            }
        }
        set(value) {
            objc_sync_enter(RfCQueryService.self)
            defer { objc_sync_exit(RfCQueryService.self) }
            do {
                RfCQueryService.requestedStart_ = value
            }
        }
    }

    open var requestedStart: LocalDateTime? {
        get {
            return LocalDateTime.castOptional(self.optionalValue(for: RfCQueryService.requestedStart))
        }
        set(value) {
            self.setOptionalValue(for: RfCQueryService.requestedStart, to: value)
        }
    }

    open class var requester: Property {
        get {
            objc_sync_enter(RfCQueryService.self)
            defer { objc_sync_exit(RfCQueryService.self) }
            do {
                return RfCQueryService.requester_
            }
        }
        set(value) {
            objc_sync_enter(RfCQueryService.self)
            defer { objc_sync_exit(RfCQueryService.self) }
            do {
                RfCQueryService.requester_ = value
            }
        }
    }

    open var requester: String? {
        get {
            return StringValue.optional(self.optionalValue(for: RfCQueryService.requester))
        }
        set(value) {
            self.setOptionalValue(for: RfCQueryService.requester, to: StringValue.of(optional: value))
        }
    }

    open class var soldToParty: Property {
        get {
            objc_sync_enter(RfCQueryService.self)
            defer { objc_sync_exit(RfCQueryService.self) }
            do {
                return RfCQueryService.soldToParty_
            }
        }
        set(value) {
            objc_sync_enter(RfCQueryService.self)
            defer { objc_sync_exit(RfCQueryService.self) }
            do {
                RfCQueryService.soldToParty_ = value
            }
        }
    }

    open var soldToParty: String? {
        get {
            return StringValue.optional(self.optionalValue(for: RfCQueryService.soldToParty))
        }
        set(value) {
            self.setOptionalValue(for: RfCQueryService.soldToParty, to: StringValue.of(optional: value))
        }
    }

    open class var status: Property {
        get {
            objc_sync_enter(RfCQueryService.self)
            defer { objc_sync_exit(RfCQueryService.self) }
            do {
                return RfCQueryService.status_
            }
        }
        set(value) {
            objc_sync_enter(RfCQueryService.self)
            defer { objc_sync_exit(RfCQueryService.self) }
            do {
                RfCQueryService.status_ = value
            }
        }
    }

    open var status: String? {
        get {
            return StringValue.optional(self.optionalValue(for: RfCQueryService.status))
        }
        set(value) {
            self.setOptionalValue(for: RfCQueryService.status, to: StringValue.of(optional: value))
        }
    }

    open class var system: Property {
        get {
            objc_sync_enter(RfCQueryService.self)
            defer { objc_sync_exit(RfCQueryService.self) }
            do {
                return RfCQueryService.system_
            }
        }
        set(value) {
            objc_sync_enter(RfCQueryService.self)
            defer { objc_sync_exit(RfCQueryService.self) }
            do {
                RfCQueryService.system_ = value
            }
        }
    }

    open var system: String? {
        get {
            return StringValue.optional(self.optionalValue(for: RfCQueryService.system))
        }
        set(value) {
            self.setOptionalValue(for: RfCQueryService.system, to: StringValue.of(optional: value))
        }
    }

    open class var ticket: Property {
        get {
            objc_sync_enter(RfCQueryService.self)
            defer { objc_sync_exit(RfCQueryService.self) }
            do {
                return RfCQueryService.ticket_
            }
        }
        set(value) {
            objc_sync_enter(RfCQueryService.self)
            defer { objc_sync_exit(RfCQueryService.self) }
            do {
                RfCQueryService.ticket_ = value
            }
        }
    }

    open var ticket: String? {
        get {
            return StringValue.optional(self.optionalValue(for: RfCQueryService.ticket))
        }
        set(value) {
            self.setOptionalValue(for: RfCQueryService.ticket, to: StringValue.of(optional: value))
        }
    }

    open class var type_: Property {
        get {
            objc_sync_enter(RfCQueryService.self)
            defer { objc_sync_exit(RfCQueryService.self) }
            do {
                return RfCQueryService.type__
            }
        }
        set(value) {
            objc_sync_enter(RfCQueryService.self)
            defer { objc_sync_exit(RfCQueryService.self) }
            do {
                RfCQueryService.type__ = value
            }
        }
    }

    open var type_: String? {
        get {
            return StringValue.optional(self.optionalValue(for: RfCQueryService.type_))
        }
        set(value) {
            self.setOptionalValue(for: RfCQueryService.type_, to: StringValue.of(optional: value))
        }
    }
}
