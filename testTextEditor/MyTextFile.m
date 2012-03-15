//
//  MyTextFile.m
//  testTextEditor
//
//  Created by  on 12-03-14.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyTextFile.h"

//L'instance du singleton
static MyTextFile *monInstancce = nil;

//Nom du fichier qui est une constante statique
static NSString *const fileSaveName = @"save.txt";

//String contenant le path
static NSString *filePath = nil;

//Créé un interace 'private'
@interface MyTextFile (hidden)

- (void) initialization;

- (NSString *) filePath;
- (void)saveToDisk;
- (void)loadFromDisk;

- (void)freeMemory;
- (void)applicationWillReceiveFreeMemory:(NSNotification *) n;

-(void)verifErreur:(NSError *)err;

@end

@implementation MyTextFile (hidden)

- (void) initialization
{
    //Recupere le centre de notification
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    //S'abonne aux événements à surveillé
    [nc addObserver:self 
           selector:@selector(applicationWillReceiveFreeMemory:) 
               name:UIApplicationDidReceiveMemoryWarningNotification 
             object:nil];
    [nc addObserver:self 
           selector:@selector(applicationWillReceiveFreeMemory:) 
               name:UIApplicationWillTerminateNotification 
             object:nil];
    [nc addObserver:self 
           selector:@selector(applicationWillReceiveFreeMemory:) 
               name:UIApplicationWillResignActiveNotification
             object:nil];
}

- (NSString *) filePath
{
    //S'assure d'abord que la variable filePath n'est pas déja initialiser, puisqu'ellee st static si elle l'est deja il est inutile de rechercher encore le chemin
    if (!filePath) {
        //Récupéré la hiérarchie de fichier de l'utilisateur dans un tableau
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        //S'assure que le tableau est renvoyer et qu'il y a plus d'un chemin
        if (path && [path count] > 0) {
            //Récupére le premier chemin contenu dans le tableau
            NSString *docPath = [path objectAtIndex:0];
            //Créee le chemin complet du fichier a l'aide du chemin trouver et du nom de fichier désiré
            filePath = [docPath stringByAppendingPathComponent:fileSaveName];
            
            //Si un résultat est trouver ne pas oublier de le retenie
            if (filePath) {
                [filePath retain];
            }
        }
    }
    return filePath;
}

- (void)saveToDisk
{
    //Variable pouvant contenir une erreur éventuelle
    NSError *err = nil;
    
    //S'assure que la variable contant le texte contient bien du texte a sauvegarder
    if (self.text) {
        [self.text writeToFile:[self filePath] 
                    atomically:YES 
                      encoding:NSUTF8StringEncoding 
                         error:&err];
    }
    
    //Vérifier si il y a eu une erreur
    [self verifErreur:err];
}

- (void)loadFromDisk
{
    //Libere le texte déja présent
    self.text = nil;
    
    //Variable pouvant contenir une erreur éventuelle
    NSError *err = nil;
    
    //Récupére les gestionnaire de fichier, qui est partage
    NSFileManager *monFileManage = [NSFileManager defaultManager];
    
    //Nous l'interogons pour savoir si une fichier a charger existe
    if ([monFileManage fileExistsAtPath:filePath]) {
        self.text = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&err];
    }
    
    //Vérifier si il y a eu une erreur
    [self verifErreur:err];
}

//Sauvegarde sur le disque et mets le texte a nil
- (void)freeMemory
{
    NSLog(@"Memory Free");
    
    [self saveToDisk];
    self.text = nil;
}

- (void)applicationWillReceiveFreeMemory:(NSNotification *) n
{
    [self freeMemory];
}

-(void) verifErreur:(NSError *)err
{
    //Vérifie si erreur il y a
    if (err) {
        NSLog(@"Erreur : %@", [err localizedDescription]);
    }
}

@end

@implementation MyTextFile

@synthesize text;

- (NSString *)text
{
    //Vérifie si il y a du texte, si tels n'est pas le cas le charge à partir du disque ou du mon tente
    if (!text) {
        [self loadFromDisk];
    }
    
    //Retourne le text
    return text;
}

#pragma mark -
#pragma mark Singleton

//Pour obtenir l'instance unique
+ (MyTextFile *) sharedInstance
{
    if (!monInstancce) {
        monInstancce = [[super allocWithZone:NULL] init];
        //Appel l'initialisation pour effectuer les abonnements
        [monInstancce initialization];
    }
    
    return monInstancce;
}

//Redéfinir allocWitchZoe
+ (id)allocWithZone:(NSZone *)zone
{
    return [[self sharedInstance] retain];
}

//Retourne sa propre instance lors d'une copy
- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

//Retain aussi retourne sa propre instance
- (id) retain
{
    return self;
}

//Le Retain count retourne le max d'un integer
- (NSUInteger)retainCount
{
    return NSUIntegerMax;
}

//Le relase ne fait rien (oneway ? je sais pas pourquoi)
- (oneway void)release
{
    
}

//l'autorelese retourne sa propre instance
-(id)autorelease
{
    return self;
}

@end
