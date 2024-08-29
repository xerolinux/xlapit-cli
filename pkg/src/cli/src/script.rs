#![allow(dead_code)]

use piglog::prelude::*;
use colored::Colorize;
use fspp::Path;

use crate::prompt::bool_question;
use crate::command::run_command_silent;

// This is just a function for running a script in a user-friendly way.
pub fn user_run_script(script_name: &str) -> bool {
    match run_script(script_name) {
        true => return true,
        false => {
            let answer = bool_question("Would you like to try and run it again?", None);

            if answer {
                return user_run_script(script_name);
            }

            else {
                return false;
            }
        },
    };
}

pub fn run_script(script_name: &str) -> bool {
    let path = Path::new(&std::env::var("SCRIPTS_PATH").unwrap());

    println!("");
    piglog::info!("Running script: {}", script_name.bright_yellow().bold());
    println!("");

    if run_command_silent(&path.add_str(&format!("{script_name}.sh")).to_string()) {
        println!("");
        piglog::success!("Successfully ran script: {}", script_name.bright_green().bold());
        println!("");

        return true;
    } else {
        println!("");
        piglog::error!("Failed to run script: {}", script_name.bright_red().bold());
        println!("");

        return false;
    }
}
