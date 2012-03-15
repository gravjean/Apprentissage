//
//  ViewController.m
//  testTextEditor
//
//  Created by  on 12-03-14.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

#import "ViewControllerUtilitaire.h"

#import "MyTextView.h"

#import "MyTextFile.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize txtContenu;

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (txtContenu) {
        [txtContenu becomeFirstResponder];
    }
    
    //Crée la nouvelle item qui doit etre dans le menu
    UIMenuItem *newItem = [[UIMenuItem alloc] initWithTitle:@"Strong" action:@selector(setStrong:)];
    
    //Récupéré le controlleur menu parlagé
    UIMenuController *menuPartager = [UIMenuController sharedMenuController];
    
    //Ajouter le nouvelle items
    [menuPartager setMenuItems:[NSArray arrayWithObject:newItem]];
    
    //Libéré le menu
    menuPartager = nil;
}

- (void) viewWillAppear:(BOOL)animated
{
    if (!maVueUtilitaire) 
    {
        maVueUtilitaire = [[ViewControllerUtilitaire alloc] init];
        
        self.txtContenu.inputAccessoryView = maVueUtilitaire.view;
        maVueUtilitaire.textView = self.txtContenu;
    }
    
    self.txtContenu.text = [MyTextFile sharedInstance].text;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    //Abonne notre fiche au événement affichant et masquand le clavier
    [nc addObserver:self 
            selector:@selector(keyboardWillShowOrHide:) 
               name:UIKeyboardWillShowNotification 
             object:nil];
    
    [nc addObserver:self 
           selector:@selector(keyboardWillShowOrHide:) 
               name:UIKeyboardWillHideNotification 
             object:nil];
}

- (CGRect)keyboardRect:(NSNotification *) n
{
    //Variable contenant le resultat, est initialiser a un rectancle zero
    CGRect tmpResult = CGRectZero;
    
    //Récupére du dictionnaire les informations sur l'utilisateur
    NSDictionary *userInfo = [n userInfo];
    
    //Si les infos existe
    if (userInfo) 
    {
        //Récuprere le rectancle représentant le clavier afficher
        NSValue *valeurRectancle = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        
        //Si les information sur le clavier existe
        if (valeurRectancle) 
        {
            //Retourne un rectancle modifier en fonction de la vue
            tmpResult = [self.view convertRect:[valeurRectancle CGRectValue] fromView:nil];
        }
    }
    
    //Retourne le résultat
    return tmpResult;
}

- (NSTimeInterval)keybordAnimationTimming:(NSNotification *) n
{
    //Variable contenant le resultat, est initialiser a 0
    NSTimeInterval tmpResult = 0;
    
    //Récupére du dictionnaire les informations sur l'utilisateur
    NSDictionary *userInfo = [n userInfo];
    
    //Si les infos existe
    if (userInfo) 
    {
        //Récuprere le rectancle représentant le clavier afficher
        NSValue *valeurTemps = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        
        //Si ce temps existe
        if (valeurTemps) 
        {
            //Récupére la valeur de ce temps .....
            [valeurTemps getValue:&tmpResult];
        }
    }
    
    return tmpResult;
}

- (UIViewAnimationCurve) keyboardAnnimationCurve:(NSNotification *) n
{
    //Variable contenant le resultat, est initialiser a 0
    UIViewAnimationCurve tmpResult = 0;
    
    //Récupére du dictionnaire les informations sur l'utilisateur
    NSDictionary *userInfo = [n userInfo];
    
    //Si les infos existe
    if (userInfo) 
    {
        //Récuprere le rectancle représentant le clavier afficher
        NSValue *valeurCurve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
        
        //Si ce temps existe
        if (valeurCurve)
        {
            //Récupére la valeur de ce temps .....
            [valeurCurve getValue:&tmpResult];
        }
    }
    
    return tmpResult;
}


- (void) keyboardWillShowOrHide:(NSNotification *) n
{
    isKeyboardShow = !isKeyboardShow;
    
   //Récupére les dimention du clavier afficher
    CGRect frameKeyboard = [self keyboardRect:n];
    
    //Le height du frame étant en lecteur seule nous le recupéron dans une variable temporaire
    CGRect tmpFrameText = self.txtContenu.frame;
    //Nous effectuons la modification du heigh
    if (isKeyboardShow) {
        tmpFrameText.size.height -= frameKeyboard.size.height;
    }
    else {
        tmpFrameText.size.height += frameKeyboard.size.height;
    }
    
    //Nous devons maintenant géré l'annimation de ce redimentionnement
    //Active le set donnant la possibilité d'annimation
    [UIView setAnimationsEnabled:YES];
    //Debut de l'annimation
    [UIView beginAnimations:@"showOrHideKeyboard" 
                    context:nil];
    //Decidé la durée de l'annimation grace a la fonction keyboardAnimationTimming
    [UIView setAnimationDuration:[self keybordAnimationTimming:n]];
    //Fait de meme pour l'annimation curve
    [UIView setAnimationCurve:[self keyboardAnnimationCurve:n]];
    
    //Nous réassignon son nouveau frame au textView
    self.txtContenu.frame = tmpFrameText;
    
    //Commiter l'annimation
    [UIView commitAnimations];
}

- (void)viewDidUnload
{
    [self setTxtContenu:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc removeObserver:self];
}

- (void) dealloc
{
    [maVueUtilitaire release];
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

//Fonction obtenue en tant que délégate permettant de vérifié quand le texte change
-(void)textViewDidChange:(UITextView *)textView
{
    [MyTextFile sharedInstance].text = self.txtContenu.text;
}

@end
