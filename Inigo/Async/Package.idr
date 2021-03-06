module Inigo.Async.Package

import Inigo.Async.Base
import Inigo.Async.CloudFlare.KV
import Inigo.Async.FS
import Inigo.Async.Promise
import Inigo.Package.Package
import Inigo.Package.PackageIndex

currConfFile : String
currConfFile = "./Inigo.toml"

||| Gets a package from the "packages" KV
export
getPackage : String -> Promise (Either String Package)
getPackage package =
  map parsePackage (read "packages" package)

||| Returns an index with all packages
export
index : Promise (Either String PackageIndex)
index =
  map parsePackageIndex (read "packages" "index")

export
readPackage : String -> Promise Package
readPackage packageFile =
  do
    contents <- fs_readFile packageFile
    Right package <- lift $ parsePackage contents
      | Left err => reject ("Error reading package: " ++ err)
    pure package

export
currPackage : Promise Package
currPackage =
  do
    contents <- fs_readFile currConfFile
    Right package <- lift $ parsePackage contents
      | Left err => reject ("Error reading package: " ++ err)
    pure package
