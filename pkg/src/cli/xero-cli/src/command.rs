#![allow(dead_code)]

use piglog::prelude::*;
use colored::Colorize;

pub fn run_command(command: &str) -> bool {
    piglog::info!("Running command: '{}'", command.bright_yellow());

    return run_command_silent(command);
}

pub fn run_command_silent(command: &str) -> bool {
    return match std::process::Command::new("bash").args(["-c", command]).status() {
        Ok(o) => o,
        Err(_e) => return false,
    }.success();
}
