// # Proxy Compiler 18.9.4-973a4d-20181128

import Foundation
import SAPOData

internal class ZREQUESTFORCHANGESRVEntitiesFactory {
    static func registerAll() throws {
        ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCApprove.registerFactory(ObjectFactory.with(create: { RfCApprove(withDefaults: false) }, createWithDecoder: { d in try RfCApprove(from: d) }))
        ZREQUESTFORCHANGESRVEntitiesMetadata.EntityTypes.rfCQueryService.registerFactory(ObjectFactory.with(create: { RfCQueryService(withDefaults: false) }, createWithDecoder: { d in try RfCQueryService(from: d) }))
        ZREQUESTFORCHANGESRVEntitiesStaticResolver.resolve()
    }
}
