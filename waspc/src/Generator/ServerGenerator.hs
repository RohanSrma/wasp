module Generator.ServerGenerator
    ( genServer
    ) where

import qualified Path as P

import StrongPath (Path, Rel, File)
import qualified StrongPath as SP
import Wasp (Wasp)
import CompileOptions (CompileOptions)
import Generator.FileDraft (FileDraft)
import Generator.ServerGenerator.Common (asTmplFile, asServerFile)
import qualified Generator.ServerGenerator.Common as C


genServer :: Wasp -> CompileOptions -> [FileDraft]
genServer wasp _ = concat
    [ [genReadme wasp]
    , [genPackageJson wasp]
    , [genNpmrc wasp]
    , [genNvmrc wasp]
    , [genGitignore wasp]
    , genSrcDir wasp
    ]

genReadme :: Wasp -> FileDraft
genReadme _ = C.copyTmplAsIs (asTmplFile [P.relfile|README.md|])

genPackageJson :: Wasp -> FileDraft
genPackageJson _ = C.copyTmplAsIs (asTmplFile [P.relfile|package.json|])

genNpmrc :: Wasp -> FileDraft
genNpmrc _ = C.makeTemplateFD (asTmplFile [P.relfile|npmrc|])
                              (asServerFile [P.relfile|.npmrc|])
                              Nothing

genNvmrc :: Wasp -> FileDraft
genNvmrc _ = C.makeTemplateFD (asTmplFile [P.relfile|nvmrc|])
                              (asServerFile [P.relfile|.nvmrc|])
                              Nothing

genGitignore :: Wasp -> FileDraft
genGitignore _ = C.makeTemplateFD (asTmplFile [P.relfile|gitignore|])
                                  (asServerFile [P.relfile|.gitignore|])
                                  Nothing

asTmplSrcFile :: P.Path P.Rel P.File -> Path (Rel C.ServerTemplatesSrcDir) File
asTmplSrcFile = SP.fromPathRelFile

genSrcDir :: Wasp -> [FileDraft]
genSrcDir wasp = concat
    [ [C.copySrcTmplAsIs $ asTmplSrcFile [P.relfile|app.js|]]
    , [C.copySrcTmplAsIs $ asTmplSrcFile [P.relfile|server.js|]]
    , genRoutesDir wasp
    ]

genRoutesDir :: Wasp -> [FileDraft]
genRoutesDir _ =
    -- TODO(martin): We will probably want to extract "routes" path here same as we did with "src", to avoid hardcoding,
    -- but I did not bother with it yet since it is used only here for now.
    [ C.copySrcTmplAsIs $ asTmplSrcFile [P.relfile|routes/index.js|]
    ]



