local VERSION = 100

addEventHandler( "onResourceStart", resourceRoot,
	function ( )
        fetchRemote("https://api.github.com/repos/clawsuit/dxLibrary/releases/latest", 
        	function(data, status)
           		assert(status == 0 and data, "dxLib: Can't fetch 'api.github.com' for new releases! ( Status code: "..tostring(status).." ) " )

	            data = fromJSON( data )

	            if data then

	            	local dataTag = tostring( data[ "tag_name" ] )
                	local dataVersion = tonumber( ( dataTag:gsub("v",""):gsub("%.","") ) )                	

                	if dataVersion > VERSION then
                
                        fetchRemote(asset["tarball_url"], 
                              	
                           	function(data, status)
                                assert(status == 0 and data, "dxLib: Can't download latest release ("..dataTag..") from Github! (Status code: "..tostring(status)..")")
                                local zip = fileCreate("dxLibrary")
                                if zip then
                                    fileWrite(zip, data)
                                    fileClose(zip)
                                    iprint("dxLib: New release ("..dataTag..") available on Github! Automatically downloaded into 'releases' directory inside pAttach, just replace the old one!")
                                end
                            end
                        )                
                        -- end        

                	end

	            end

        	end
        )
		
	end
)
