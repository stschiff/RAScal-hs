module Main where

import           Data.Version        (showVersion)
import qualified Options.Applicative as OP
import           Paths_RAScal_hs   (version)
import           Poseidon.Package    (PackageReadOptions (..),
                                      defaultPackageReadOptions,
                                      readPoseidonPackageCollection)
import           System.IO           (hPutStrLn, stderr)

data CommandLineOptions = CommandLineOptions
    { _optBaseDirs :: [FilePath]
    }

main :: IO ()
main = do
    CommandLineOptions baseDirs <- OP.customExecParser p optParserInfo
    let pacReadOpts = defaultPackageReadOptions {_readOptStopOnDuplicates = True, _readOptIgnoreChecksums = True}
    allPackages <- readPoseidonPackageCollection pacReadOpts baseDirs
    hPutStrLn stderr ("Loaded " ++ show (length allPackages) ++ " packages")
  where
    p = OP.prefs OP.showHelpOnEmpty
    optParserInfo = OP.info (OP.helper <*> versionOption <*> optParser) (
        OP.briefDesc <>
        OP.progDesc "rascal computes RAS statistics for Poseidon-packaged genotype data")
    versionOption = OP.infoOption (showVersion version) (OP.long "version" <> OP.help "Show version")

optParser :: OP.Parser CommandLineOptions
optParser = CommandLineOptions <$> parseBasePaths

parseBasePaths :: OP.Parser [FilePath]
parseBasePaths = OP.some (OP.strOption (OP.long "baseDir" <>
    OP.short 'd' <>
    OP.metavar "DIR" <>
    OP.help "a base directory to search for Poseidon Packages (could be a Poseidon repository)"))
