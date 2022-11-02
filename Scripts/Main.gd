extends Node 

var cash_count = 0 # This is how much cash the player starts with.

var multiplier_level = 1 # This is the multiplier level that the player starts with.
var multiplier_price = 100 # This is the starting multiplier upgrade price.

var auto_click_delay = 16 # This is the auto click delay that the player starts with.
var auto_click_price = 25 # This is the starting auto click upgrade price.

var luck_level = 10000 # This is the luck level  that the player starts with.
var luck_price = 100 # This is the starting auto click upgrade price.

var level = 1 # This defines the starting level of the player.

var multiplier_price_increase = 2 # This is how much the price of the multiplier upgrade will be multiplied by each time it is used.
var auto_click_price_increase = 3 # This is how much the price of the auto click upgrade will be multiplied by each time it is used.
var luck_price_increase = 3 # This is how much the price of the luck upgrade will be multiplied by each time it is used.



func _ready(): # This function is executed when the scene loads.
	get_tree().root.get_node("Control").get_node("AutoClickDelayDisplay").text = "Auto Click Delay: " + str(auto_click_delay) + "s" # Update the auto click delay display.
	get_tree().root.get_node("Control").get_node("MultiplierDisplay").text = "Multiplier: " + str(multiplier_level) + "x" # Update the multiplier level display.
	get_tree().root.get_node("Control").get_node("LuckDisplay").text = "Luck: " + str(100*(1/luck_level)) + "%" # Update the luck level display.
	get_tree().root.get_node("Control").get_node("LevelDisplay").text = "Level: " + str(level) # Update the level display.
	auto_clicker() # Start the autoclicker function.
	

func _process(delta): # This function is executed every frame.
	get_tree().root.get_node("Control").get_node("MoneyDisplay").text = "$" + str(cash_count) # Update the cash display.
	get_tree().root.get_node("Control").get_node("AutoClickDelayDisplay").text = "Auto Click Delay: " + str(auto_click_delay) + "s" # Update the auto click delay display.
	
	if (cash_count > 2147483647): # If the user gets enough money, advance them to the next level with more difficult pricing.
		# Reset to the starting conditions.
		level = level + 1
		cash_count = 0
		multiplier_level = 1
		multiplier_price = 100
		auto_click_delay = 16
		auto_click_price = 25
		luck_level = 10000
		luck_price = 100
		
		# Increase the pricing for each upgrade.
		multiplier_price_increase = multiplier_price_increase + 1
		auto_click_price_increase = auto_click_price_increase + 1
		luck_price_increase = luck_price_increase + 1
		
		# Reset the displays
		get_tree().root.get_node("Control").get_node("AutoClickDelayDisplay").text = "Auto Click Delay: " + str(auto_click_delay) + "s" # Update the auto click delay display.
		get_tree().root.get_node("Control").get_node("MultiplierDisplay").text = "Multiplier: " + str(multiplier_level) + "x" # Update the multiplier level display.
		get_tree().root.get_node("Control").get_node("LuckDisplay").text = "Luck: " + str(100*(1/luck_level)) + "%" # Update the luck level display
		get_tree().root.get_node("Control").get_node("LevelDisplay").text = "Level: " + str(level) # Update the level display.
		get_tree().root.get_node("Control").get_node("MultiplierUpgradeLabel").text = "$" + str(multiplier_price) # Update the multiplier price display.
		get_tree().root.get_node("Control").get_node("AutoClickerUpgradeLabel").text = "$" + str(auto_click_price) # Update the auto clicker upgrade price display.
		get_tree().root.get_node("Control").get_node("LuckUpgradeLabel").text = "$" + str(luck_price) # Update the luck upgrade price display.


func auto_clicker():
	yield(get_tree().create_timer(auto_click_delay), "timeout") # Wait before clicking.
	
	if ((randi() % int(luck_level)) == 1): # Give the user a chance of a bonus based on their luck.
		cash_count = cash_count * 2 # Double the user's cash.
	cash_count = cash_count + (multiplier_level * 1) # Add money according to the multiplier.
	
	auto_clicker() # Restart the autoclicker.

func _on_CashButton_pressed(): # This function runs when the user presses the cash button.
	cash_count = cash_count + (multiplier_level * 1) # Add money according to the multiplier.
	
	if ((randi() % int(luck_level)) == 1): # Give the user a chance of a bonus based on their luck.
		cash_count = cash_count * 2 # Double the user's cash.

	
func _on_MultiplierPurchaseButton_pressed():
	if (cash_count >= multiplier_price): # Check to make sure the user has enough money to make this purchase.
		cash_count = cash_count - multiplier_price # Subtract the price of the multiplier upgrade from the user's cash.
		multiplier_level = multiplier_level * 2 # Increase the multiplier level.
		multiplier_price = multiplier_price * multiplier_price_increase # Increase the multiplier price.

		get_tree().root.get_node("Control").get_node("MultiplierDisplay").text = "Multiplier: " + str(multiplier_level) + "x" # Update the multiplier level display.
		get_tree().root.get_node("Control").get_node("MultiplierUpgradeLabel").text = "$" + str(multiplier_price) # Update the multiplier price display.


func _on_AutoClickerPurchase_pressed():
	if (cash_count >= auto_click_price): # Check to make sure the user has enough money to make this purchase.
		cash_count = cash_count - auto_click_price # Subtract the price of the auto click upgrade from the user's cash.
		auto_click_delay = auto_click_delay * 0.5 # Decrease the auto clicker interval.
		auto_click_price = auto_click_price * auto_click_price_increase # Increase the auto clicker upgrade price.

		get_tree().root.get_node("Control").get_node("AutoClickDelayDisplay").text = "Auto Click Delay: " + str(auto_click_delay) + "s" # Update the auto click delay display.
		get_tree().root.get_node("Control").get_node("AutoClickerUpgradeLabel").text = "$" + str(auto_click_price) # Update the auto clicker upgrade price display.


func _on_LuckPurchaseButton_pressed():
	if (cash_count >= luck_price): # Check to make sure the user has enough money to make this purchase.
		if (luck_level * 0.5 > 2): # Check to make sure the luck level isn't already maxed out.
			cash_count = cash_count - luck_price # Subtract the price of the luck upgrade from the user's cash.
			luck_level = luck_level * 0.5 # Increase the luck level.
			luck_price = luck_price * luck_price_increase # Increase the luck upgrade price.

			get_tree().root.get_node("Control").get_node("LuckDisplay").text = "Luck: " + str(100*(1/luck_level)) + "%" # Update the luck level display.
			get_tree().root.get_node("Control").get_node("LuckUpgradeLabel").text = "$" + str(luck_price) # Update the luck upgrade price display.
		else:
			luck_level = 2
			get_tree().root.get_node("Control").get_node("LuckUpgradeLabel").text = "Maxed" # Update the luck upgrade price display.
			get_tree().root.get_node("Control").get_node("LuckDisplay").text = "Luck: 50%" # Update the luck level display.
