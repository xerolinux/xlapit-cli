mod cli;
mod command;
mod script;
mod prompt;

use clap::Parser;
use colored::Colorize;
use piglog::prelude::*;
use fspp::*;

use script::*;
use prompt::*;
use command::run_command_silent;

enum ExitCode {
    Success,
    Fail,
}

enum Script {
    SystemSetup,
    Drivers,
    Distrobox,
    RecommendedPackages,
    Customization,
    Service,
    Gaming,
}

impl Script {
    pub fn script_name(&self) -> String {
        return match *self {
            Self::SystemSetup => "tool_init",
            Self::Drivers => "drivers",
            Self::Distrobox => "dbox",
            Self::Customization => "customization",
            Self::Gaming => "gaming",
            Self::RecommendedPackages => "pkgs",
            Self::Service => "service",
        }.to_string();
    }
}

fn main() {
    match app() {
        ExitCode::Success => (),
        ExitCode::Fail => std::process::exit(1),
    };
}

fn app() -> ExitCode {
    // Parse CLI arguments.
    let args = cli::Cli::parse();

    if args.minimal && args.verbose {
        piglog::fatal!("Are you trying to create an explosion or something? (Don't use --verbose and --minimal together!)");

        return ExitCode::Fail;
    }

    std::env::set_var("CLEAR_TERMINAL", match args.do_not_clear { true => "0", false => "1" });

    if let Some(command) = args.command {
        match command {
            cli::Commands::Api { command } => {
                match command {
                    cli::APICommand::Prompt { text } => {
                        eprintln!("{}", prompt(&text));
                    },
                    cli::APICommand::BoolPrompt { text, fallback } => {
                        match bool_question(&text, fallback) {
                            true => (),
                            false => return ExitCode::Fail,
                        };
                    },
                    cli::APICommand::Echo { msg, mode } => {
                        piglog::log_core_print(msg, mode);
                    },
                    cli::APICommand::GenericEcho { msg } => {
                        piglog::log_generic_print(msg);
                    },
                };

                return ExitCode::Success;
            },
        };
    }

    let scripts = Path::new(&args.scripts_path.unwrap_or("/usr/share/xero-scripts".to_string()));

    if scripts.exists() == false {
        piglog::fatal!("The directory ({}) containing all the scripts does not exist!", scripts.to_string().bright_red().bold());

        return ExitCode::Fail;
    }

    // Export environment variable.
    std::env::set_var("SCRIPTS_PATH", scripts.to_string());

    // Options.
    let options = vec![
        ("System Setup", Script::SystemSetup),
        ("System Drivers", Script::Drivers),
        ("Distrobox & Docker", Script::Distrobox),
        ("System Customization", Script::Customization),
        ("Game Launchers/Tweaks", Script::Gaming),
        ("Recommended System Packages", Script::RecommendedPackages),
        ("System Troubleshooting & Tweaks", Script::Service),
    ];

    // ASCII logo.
    let logo1 = vec![
        "██╗  ██╗███████╗██████╗  █████╗ ",
        "╚██╗██╔╝██╔════╝██╔══██╗██╔══██╗",
        " ╚███╔╝ █████╗  ██████╔╝██║  ██║",
        " ██╔██╗ ██╔══╝  ██╔══██╗██║  ██║",
        "██╔╝╚██╗███████╗██║  ██║╚█████╔╝",
        "╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝ ╚════╝ ",
    ];

    let logo2 = vec![
        "██╗     ██╗███╗  ██╗██╗   ██╗██╗  ██╗",
        "██║     ██║████╗ ██║██║   ██║╚██╗██╔╝",
        "██║     ██║██╔██╗██║██║   ██║ ╚███╔╝ ",
        "██║     ██║██║╚████║██║   ██║ ██╔██╗ ",
        "███████╗██║██║ ╚███║╚██████╔╝██╔╝╚██╗",
        "╚══════╝╚═╝╚═╝  ╚══╝ ╚═════╝ ╚═╝  ╚═╝",
    ];

    let username = match std::env::var("USER") {
        Ok(o) => o,
        Err(_) => "<< FAILED TO GET USERNAME >>".to_string(),
    };

    let mut first_iteration = true;

    // Main program loop.
    loop {
        // Print the logo.
        for i in 0..logo1.len() {
            print!("{}", logo1[i].magenta());
            println!("{}", logo2[i].blue());
        }

        println!("");

        if first_iteration {
            // Make sure there is an AUR helper on the system.
            match detect_aur_helper() {
                Some(_) => (),
                None => return ExitCode::Fail,
            };

            println!("");
        }

        // Print out all the options.
        println!("Welcome, {username}! What would you like to do today?\n");
        for (i, j) in options.iter().enumerate() {
            piglog::generic!("{} {} {}", (i + 1).to_string().bright_cyan().bold(), ":".bright_black().bold(), j.0.bright_green().bold());
        }
        println!("");

        // Select option.
        let mut selected: Option<usize> = None;
        while selected == None {
            let answer = prompt("Please select option (by number). Close window to quit");
            let answer = answer.trim();

            match answer.parse::<usize>() {
                Ok(o) => selected = Some(o),
                Err(_) => piglog::error!("Couldn't parse into a number, please try again!"),
            };

            if let Some(sel) = selected {
                if sel == 0 {
                    piglog::error!("Number must be above 0!");

                    selected = None;
                }

                else if sel > options.len() {
                    piglog::error!("Number must not exceed the amount of options!");

                    selected = None;
                }
            }
        }

        // Converting selected to the index of the options array.
        let selected: usize = selected.unwrap() - 1;

        // Run option.
        let option = options.get(selected).unwrap();

        user_run_script(&option.1.script_name());

        clear_terminal();

        first_iteration = false;
    }
}

fn clear_terminal() -> bool {
    let clear: bool = match std::env::var("CLEAR_TERMINAL") {
        Ok(o) => match o.as_str() {
            "0" => false,
            _ => true,
        },
        Err(_) => true,
    };

    if clear {
        return run_command_silent("clear");
    }

    else {
        return true;
    }
}

fn select_aur_helper(aur_helper: &str) {
    piglog::info!("AUR helper selected: {}", aur_helper.bright_yellow().bold());

    std::env::set_var("AUR_HELPER", aur_helper);
}

fn detect_aur_helper() -> Option<String> {
    let args = cli::Cli::parse();

    if let Some(aur_helper) = args.aur_helper {
        if binary_exists(&aur_helper) {
            select_aur_helper(&aur_helper);

            return Some(aur_helper);
        }

        else {
            return None;
        }
    }

    // Detect AUR helper.
    let aur_helpers = vec![
        "yay",
        "paru",
    ];

    let mut aur_helper_detected: Option<&str> = None;
    for i in aur_helpers.iter() {
        if binary_exists(i) {
            aur_helper_detected = Some(i);

            break;
        }
    }

    if aur_helper_detected == None {
        piglog::fatal!("Failed to detect an AUR helper! (From pre-made list):");

        for i in aur_helpers.iter() {
            piglog::generic!("{i}");
        }

        piglog::note!("If your AUR helper of choice is not listed here, you can manually specify it with the '--aur-helper <insert binary name>' flag!");
        piglog::note!("Example: xero-cli --aur-helper paru");
        piglog::note!("This flag also forces the use of the AUR helper, so you can skip the detection phase completely!");

        return None;
    }

    if let Some(aur_helper) = aur_helper_detected {
        select_aur_helper(aur_helper);

        return Some(aur_helper.to_string());
    }

    return None;
}

fn binary_exists(binary: &str) -> bool {
    let args = cli::Cli::parse();

    if let Ok(o) = std::env::var("PATH") {
        let paths: Vec<Path> = o.trim().split(":").map(|x| Path::new(x)).collect();

        if args.verbose {
            piglog::info!("Searching for binary: {}", binary.bright_yellow().bold());
        }

        for i in paths.iter() {
            if args.verbose {
                piglog::generic!("Searching in: {}", i.to_string().magenta());
            }

            let path = i.add_str(binary);

            if path.exists() {
                if args.minimal == false {
                    piglog::success!("Found '{}' in: {}", binary.bright_yellow().bold(), i.to_string().bright_green());
                }

                return true;
            }
        }
    }

    if args.verbose {
        piglog::error!("Did not find binary! Seeing if absolute path exists...");
    }

    if Path::new(binary).exists() {
        if args.verbose {
            piglog::success!("Binary: {}", binary.bright_green());
        }

        return true;
    }

    if args.verbose {
        piglog::error!("Could not find binary: {}", binary.bright_red().bold());
    }

    return false;
}
