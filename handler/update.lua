local VERSION = 10

addEventHandler( "onResourceStart", resourceRoot,
	function ( )
        if not hasObjectPermissionTo(getThisResource(), "resource."..getResourceName(getThisResource())..".fetchRemote", false ) then
           outputDebugString("This resource needs permission to 'fetchRemote' for update automatically", 2)
           return
        end
        fetchRemote("https://api.github.com/repos/clawsuit/dxLibrary/releases/latest", 
        	function(data, status)
           		assert(status == 0 and data, resource.name..": Can't fetch 'api.github.com' for new releases! ( Status code: "..tostring(status).." ) " )

	            data = fromJSON( data )

	            if data then

	            	local dataTag = tostring( data[ "tag_name" ] )
                	local dataVersion = tonumber( ( dataTag:gsub("v",""):gsub("%.","") ) )                	

                	if dataVersion > VERSION then
                
                        fetchRemote(data["zipball_url"], 
                              	
                           	function(data, status)
                                assert(status == 0 and data, resource.name..": Can't download latest release ("..dataTag..") from Github! (Status code: "..tostring(status)..")")
                                local zip = fileCreate("releases/dxLibrary-"..dataTag..'.zip')
                                if zip then
                                    fileWrite(zip, data)
                                    fileClose(zip)
                                    iprint(resource.name..": New release ("..dataTag..") available on Github! Automatically downloaded into 'releases' directory inside "..resource.name..", just replace the old one!")
                                end
                            end
                        )                      

                	end

	            end

        	end
        )
		
	end
)

