// # Proxy Compiler 18.9.4-973a4d-20181128

import Foundation
import SAPOData

open class ZREQUESTFORCHANGESRVEntities<Provider: DataServiceProvider>: DataService<Provider> {
    public override init(provider: Provider) {
        super.init(provider: provider)
        self.provider.metadata = ZREQUESTFORCHANGESRVEntitiesMetadata.document
    }

    open func fetchRfCApprove(matching query: DataQuery, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) throws -> RfCApprove {
        let var_headers: HTTPHeaders = HTTPHeaders.emptyIfNull(headers: headers)
        let var_options: RequestOptions = try RequestOptions.noneIfNull(options: options)
        return try CastRequired<RfCApprove>.from(self.executeQuery(query.fromDefault(ZREQUESTFORCHANGESRVEntitiesMetadata.EntitySets.rfCApproveSet), headers: var_headers, options: var_options).requiredEntity())
    }

    open func fetchRfCApprove(matching query: DataQuery, headers: HTTPHeaders? = nil, options: RequestOptions? = nil, completionHandler: @escaping (RfCApprove?, Error?) -> Void) {
        self.addBackgroundOperationForFunction {
            do {
                let result: RfCApprove = try self.fetchRfCApprove(matching: query, headers: headers, options: options)
                self.completionQueue.addOperation {
                    completionHandler(result, nil)
                }
            } catch let error {
                self.completionQueue.addOperation {
                    completionHandler(nil, error)
                }
            }
        }
    }

    open func fetchRfCApproveSet(matching query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) throws -> Array<RfCApprove> {
        let var_query: DataQuery = DataQuery.newIfNull(query: query)
        let var_headers: HTTPHeaders = HTTPHeaders.emptyIfNull(headers: headers)
        let var_options: RequestOptions = try RequestOptions.noneIfNull(options: options)
        return try RfCApprove.array(from: self.executeQuery(var_query.fromDefault(ZREQUESTFORCHANGESRVEntitiesMetadata.EntitySets.rfCApproveSet), headers: var_headers, options: var_options).entityList())
    }

    open func fetchRfCApproveSet(matching query: DataQuery = DataQuery(), headers: HTTPHeaders? = nil, options: RequestOptions? = nil, completionHandler: @escaping (Array<RfCApprove>?, Error?) -> Void) {
        self.addBackgroundOperationForFunction {
            do {
                let result: Array<RfCApprove> = try self.fetchRfCApproveSet(matching: query, headers: headers, options: options)
                self.completionQueue.addOperation {
                    completionHandler(result, nil)
                }
            } catch let error {
                self.completionQueue.addOperation {
                    completionHandler(nil, error)
                }
            }
        }
    }

    open func fetchRfCQueryService(matching query: DataQuery, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) throws -> RfCQueryService {
        let var_headers: HTTPHeaders = HTTPHeaders.emptyIfNull(headers: headers)
        let var_options: RequestOptions = try RequestOptions.noneIfNull(options: options)
        return try CastRequired<RfCQueryService>.from(self.executeQuery(query.fromDefault(ZREQUESTFORCHANGESRVEntitiesMetadata.EntitySets.rfCQueryServiceSet), headers: var_headers, options: var_options).requiredEntity())
    }

    open func fetchRfCQueryService(matching query: DataQuery, headers: HTTPHeaders? = nil, options: RequestOptions? = nil, completionHandler: @escaping (RfCQueryService?, Error?) -> Void) {
        self.addBackgroundOperationForFunction {
            do {
                let result: RfCQueryService = try self.fetchRfCQueryService(matching: query, headers: headers, options: options)
                self.completionQueue.addOperation {
                    completionHandler(result, nil)
                }
            } catch let error {
                self.completionQueue.addOperation {
                    completionHandler(nil, error)
                }
            }
        }
    }

    open func fetchRfCQueryServiceSet(matching query: DataQuery? = nil, headers: HTTPHeaders? = nil, options: RequestOptions? = nil) throws -> Array<RfCQueryService> {
        let var_query: DataQuery = DataQuery.newIfNull(query: query)
        let var_headers: HTTPHeaders = HTTPHeaders.emptyIfNull(headers: headers)
        let var_options: RequestOptions = try RequestOptions.noneIfNull(options: options)
        return try RfCQueryService.array(from: self.executeQuery(var_query.fromDefault(ZREQUESTFORCHANGESRVEntitiesMetadata.EntitySets.rfCQueryServiceSet), headers: var_headers, options: var_options).entityList())
    }

    open func fetchRfCQueryServiceSet(matching query: DataQuery = DataQuery(), headers: HTTPHeaders? = nil, options: RequestOptions? = nil, completionHandler: @escaping (Array<RfCQueryService>?, Error?) -> Void) {
        self.addBackgroundOperationForFunction {
            do {
                let result: Array<RfCQueryService> = try self.fetchRfCQueryServiceSet(matching: query, headers: headers, options: options)
                self.completionQueue.addOperation {
                    completionHandler(result, nil)
                }
            } catch let error {
                self.completionQueue.addOperation {
                    completionHandler(nil, error)
                }
            }
        }
    }

    open override func refreshMetadata() throws {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        do {
            try ProxyInternal.refreshMetadata(service: self, fetcher: nil, options: ZREQUESTFORCHANGESRVEntitiesMetadataParser.options)
            ZREQUESTFORCHANGESRVEntitiesMetadataChanges.merge(metadata: self.metadata)
        }
    }

    @available(swift, deprecated: 4.0, renamed: "fetchRfCApproveSet")
    open func rfCApproveSet(query: DataQuery = DataQuery()) throws -> Array<RfCApprove> {
        return try self.fetchRfCApproveSet(matching: query)
    }

    @available(swift, deprecated: 4.0, renamed: "fetchRfCApproveSet")
    open func rfCApproveSet(query: DataQuery = DataQuery(), completionHandler: @escaping (Array<RfCApprove>?, Error?) -> Void) {
        self.fetchRfCApproveSet(matching: query, headers: nil, options: nil, completionHandler: completionHandler)
    }

    @available(swift, deprecated: 4.0, renamed: "fetchRfCQueryServiceSet")
    open func rfCQueryServiceSet(query: DataQuery = DataQuery()) throws -> Array<RfCQueryService> {
        return try self.fetchRfCQueryServiceSet(matching: query)
    }

    @available(swift, deprecated: 4.0, renamed: "fetchRfCQueryServiceSet")
    open func rfCQueryServiceSet(query: DataQuery = DataQuery(), completionHandler: @escaping (Array<RfCQueryService>?, Error?) -> Void) {
        self.fetchRfCQueryServiceSet(matching: query, headers: nil, options: nil, completionHandler: completionHandler)
    }
}
