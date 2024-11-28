extends Node

var playerBody : CharacterBody2D
var playerWeaponEquip: bool

var playerDamageTaken = 0
var playerHealth = 100
var playerAlive : bool 
var playerDamageZone : Area2D
var playerDamageAmount : int
var playerHitbox : Area2D

var batDamageZone = Area2D
var batDamageAmount : int

var msDamageZone : Area2D
var msDamageAmount : int 

var skDamageZone : Area2D
var skDamageAmount : int

var gbDamageZone : Area2D
var gbDamageAmount : int 

var high_score = 0 
var current_score : int
var previous_score : int
