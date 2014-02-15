/*
 * SystemEvents.h
 */

#import <AppKit/AppKit.h>
#import <ScriptingBridge/ScriptingBridge.h>


@class SystemEventsApplication, SystemEventsDocument, SystemEventsWindow, SystemEventsDiskItem, SystemEventsUser, SystemEventsAppearancePreferencesObject, SystemEventsCDAndDVDPreferencesObject, SystemEventsInsertionPreference, SystemEventsDesktop, SystemEventsDockPreferencesObject, SystemEventsLoginItem, SystemEventsConfiguration, SystemEventsInterface, SystemEventsLocation, SystemEventsNetworkPreferencesObject, SystemEventsService, SystemEventsScreenSaver, SystemEventsScreenSaverPreferencesObject, SystemEventsSecurityPreferencesObject, SystemEventsAlias, SystemEventsDisk, SystemEventsDomain, SystemEventsClassicDomainObject, SystemEventsFile, SystemEventsFilePackage, SystemEventsFolder, SystemEventsLocalDomainObject, SystemEventsNetworkDomainObject, SystemEventsSystemDomainObject, SystemEventsUserDomainObject, SystemEventsFolderAction, SystemEventsScript, SystemEventsAction, SystemEventsAttribute, SystemEventsUIElement, SystemEventsBrowser, SystemEventsBusyIndicator, SystemEventsButton, SystemEventsCheckbox, SystemEventsColorWell, SystemEventsColumn, SystemEventsComboBox, SystemEventsDrawer, SystemEventsGroup, SystemEventsGrowArea, SystemEventsImage, SystemEventsIncrementor, SystemEventsList, SystemEventsMenu, SystemEventsMenuBar, SystemEventsMenuBarItem, SystemEventsMenuButton, SystemEventsMenuItem, SystemEventsOutline, SystemEventsPopOver, SystemEventsPopUpButton, SystemEventsProcess, SystemEventsApplicationProcess, SystemEventsDeskAccessoryProcess, SystemEventsProgressIndicator, SystemEventsRadioButton, SystemEventsRadioGroup, SystemEventsRelevanceIndicator, SystemEventsRow, SystemEventsScrollArea, SystemEventsScrollBar, SystemEventsSheet, SystemEventsSlider, SystemEventsSplitter, SystemEventsSplitterGroup, SystemEventsStaticText, SystemEventsTabGroup, SystemEventsTable, SystemEventsTextArea, SystemEventsTextField, SystemEventsToolbar, SystemEventsValueIndicator, SystemEventsWindow, SystemEventsPropertyListFile, SystemEventsPropertyListItem, SystemEventsAnnotation, SystemEventsQuickTimeData, SystemEventsAudioData, SystemEventsMovieData, SystemEventsQuickTimeFile, SystemEventsAudioFile, SystemEventsMovieFile, SystemEventsTrack, SystemEventsXMLAttribute, SystemEventsXMLData, SystemEventsXMLElement, SystemEventsXMLFile, SystemEventsPrintSettings;

enum SystemEventsSaveOptions {
	SystemEventsSaveOptionsYes = 'yes ' /* Save the file. */,
	SystemEventsSaveOptionsNo = 'no  ' /* Do not save the file. */,
	SystemEventsSaveOptionsAsk = 'ask ' /* Ask the user whether or not to save the file. */
};
typedef enum SystemEventsSaveOptions SystemEventsSaveOptions;

enum SystemEventsPrintingErrorHandling {
	SystemEventsPrintingErrorHandlingStandard = 'lwst' /* Standard PostScript error handling */,
	SystemEventsPrintingErrorHandlingDetailed = 'lwdt' /* print a detailed report of PostScript errors */
};
typedef enum SystemEventsPrintingErrorHandling SystemEventsPrintingErrorHandling;

enum SystemEventsSaveableFileFormat {
	SystemEventsSaveableFileFormatText = 'ctxt' /* Text File Format */
};
typedef enum SystemEventsSaveableFileFormat SystemEventsSaveableFileFormat;

enum SystemEventsScrollPageBehaviors {
	SystemEventsScrollPageBehaviorsJumpToHere = 'tohr' /* jump to here */,
	SystemEventsScrollPageBehaviorsJumpToNextPage = 'nxpg' /* jump to next page */
};
typedef enum SystemEventsScrollPageBehaviors SystemEventsScrollPageBehaviors;

enum SystemEventsFontSmoothingStyles {
	SystemEventsFontSmoothingStylesAutomatic = 'autm' /* automatic */,
	SystemEventsFontSmoothingStylesLight = 'lite' /* light */,
	SystemEventsFontSmoothingStylesMedium = 'medi' /* medium */,
	SystemEventsFontSmoothingStylesStandard = 'stnd' /* standard */,
	SystemEventsFontSmoothingStylesStrong = 'strg' /* strong */
};
typedef enum SystemEventsFontSmoothingStyles SystemEventsFontSmoothingStyles;

enum SystemEventsAppearances {
	SystemEventsAppearancesBlue = 'blue' /* blue */,
	SystemEventsAppearancesGraphite = 'grft' /* graphite */
};
typedef enum SystemEventsAppearances SystemEventsAppearances;

enum SystemEventsHighlightColors {
	SystemEventsHighlightColorsBlue = 'blue' /* blue */,
	SystemEventsHighlightColorsGold = 'gold' /* gold */,
	SystemEventsHighlightColorsGraphite = 'grft' /* graphite */,
	SystemEventsHighlightColorsGreen = 'gren' /* green */,
	SystemEventsHighlightColorsOrange = 'orng' /* orange */,
	SystemEventsHighlightColorsPurple = 'prpl' /* purple */,
	SystemEventsHighlightColorsRed = 'red ' /* red */,
	SystemEventsHighlightColorsSilver = 'slvr' /* silver */
};
typedef enum SystemEventsHighlightColors SystemEventsHighlightColors;

enum SystemEventsDhac {
	SystemEventsDhacAskWhatToDo = 'dhas' /* ask what to do */,
	SystemEventsDhacIgnore = 'dhig' /* ignore */,
	SystemEventsDhacOpenApplication = 'dhap' /* open application */,
	SystemEventsDhacRunAScript = 'dhrs' /* run a script */
};
typedef enum SystemEventsDhac SystemEventsDhac;

enum SystemEventsDpls {
	SystemEventsDplsBottom = 'bott' /* bottom */,
	SystemEventsDplsLeft = 'left' /* left */,
	SystemEventsDplsRight = 'righ' /* right */
};
typedef enum SystemEventsDpls SystemEventsDpls;

enum SystemEventsDpef {
	SystemEventsDpefGenie = 'geni' /* genie */,
	SystemEventsDpefScale = 'scal' /* scale */
};
typedef enum SystemEventsDpef SystemEventsDpef;

enum SystemEventsEdfm {
	SystemEventsEdfmApplePhotoFormat = 'dfph' /* Apple Photo format */,
	SystemEventsEdfmAppleShareFormat = 'dfas' /* AppleShare format */,
	SystemEventsEdfmAudioFormat = 'dfau' /* audio format */,
	SystemEventsEdfmHighSierraFormat = 'dfhs' /* High Sierra format */,
	SystemEventsEdfmISO9660Format = 'df96' /* ISO 9660 format */,
	SystemEventsEdfmMacOSExtendedFormat = 'dfh+' /* Mac OS Extended format */,
	SystemEventsEdfmMacOSFormat = 'dfhf' /* Mac OS format */,
	SystemEventsEdfmMSDOSFormat = 'dfms' /* MSDOS format */,
	SystemEventsEdfmNFSFormat = 'dfnf' /* NFS format */,
	SystemEventsEdfmProDOSFormat = 'dfpr' /* ProDOS format */,
	SystemEventsEdfmQuickTakeFormat = 'dfqt' /* QuickTake format */,
	SystemEventsEdfmUDFFormat = 'dfud' /* UDF format */,
	SystemEventsEdfmUFSFormat = 'dfuf' /* UFS format */,
	SystemEventsEdfmUnknownFormat = 'df$$' /* unknown format */,
	SystemEventsEdfmWebDAVFormat = 'dfwd' /* WebDAV format */
};
typedef enum SystemEventsEdfm SystemEventsEdfm;

enum SystemEventsEMds {
	SystemEventsEMdsCommandDown = 'Kcmd' /* command down */,
	SystemEventsEMdsControlDown = 'Kctl' /* control down */,
	SystemEventsEMdsOptionDown = 'Kopt' /* option down */,
	SystemEventsEMdsShiftDown = 'Ksft' /* shift down */
};
typedef enum SystemEventsEMds SystemEventsEMds;

enum SystemEventsEMky {
	SystemEventsEMkyCommand = 'eCmd' /* command */,
	SystemEventsEMkyControl = 'eCnt' /* control */,
	SystemEventsEMkyOption = 'eOpt' /* option */,
	SystemEventsEMkyShift = 'eSft' /* shift */
};
typedef enum SystemEventsEMky SystemEventsEMky;

enum SystemEventsPrmd {
	SystemEventsPrmdNormal = 'norm' /* normal */,
	SystemEventsPrmdSlideShow = 'pmss' /* slide show */
};
typedef enum SystemEventsPrmd SystemEventsPrmd;

enum SystemEventsMvsz {
	SystemEventsMvszCurrent = 'cust' /* current */,
	SystemEventsMvszDouble = 'doub' /* double */,
	SystemEventsMvszHalf = 'half' /* half */,
	SystemEventsMvszNormal = 'norm' /* normal */,
	SystemEventsMvszScreen = 'fits' /* screen */
};
typedef enum SystemEventsMvsz SystemEventsMvsz;

enum SystemEventsEnum {
	SystemEventsEnumStandard = 'lwst' /* Standard PostScript error handling */,
	SystemEventsEnumDetailed = 'lwdt' /* print a detailed report of PostScript errors */
};
typedef enum SystemEventsEnum SystemEventsEnum;



/*
 * Standard Suite
 */

// The application's top-level scripting object.
@interface SystemEventsApplication : SBApplication

- (SBElementArray *) documents;
- (SBElementArray *) windows;

@property (copy, readonly) NSString *name;  // The name of the application.
@property (readonly) BOOL frontmost;  // Is this the active application?
@property (copy, readonly) NSString *version;  // The version number of the application.

- (id) open:(id)x;  // Open a document.
- (void) print:(id)x withProperties:(SystemEventsPrintSettings *)withProperties printDialog:(BOOL)printDialog;  // Print a document.
- (void) quitSaving:(SystemEventsSaveOptions)saving;  // Quit the application.
- (BOOL) exists:(id)x;  // Verify that an object exists.
- (void) abortTransaction;  // Discard the results of a bounded update session with one or more files.
- (NSInteger) beginTransaction;  // Begin a bounded update session with one or more files.
- (void) endTransaction;  // Apply the results of a bounded update session with one or more files.
//- (SystemEventsFile *) open:(id)x;  // Open disk item(s) with the appropriate application.
- (void) logOut;  // Log out the current user
- (void) restart;  // Restart the computer
- (void) shutDown;  // Shut Down the computer
- (void) sleep;  // Put the computer to sleep
- (SystemEventsUIElement *) clickAt:(NSArray *)at;  // cause the target process to behave as if the UI element were clicked
- (void) keyCode:(id)x using:(id)using_;  // cause the target process to behave as if key codes were entered
- (void) keystroke:(NSString *)x using:(id)using_;  // cause the target process to behave as if keystrokes were entered

@end

