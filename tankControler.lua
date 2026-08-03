component = require('component')

tanksAndRedstone = {
	{
		redstones = {
			addresses = {
			},
		},
		tanks = {
			addresses = {
			},
		},
	},
}

for index, value in ipairs(tanksAndRedstone) do
	tanksAndRedstone[index].redstones.components = {}
	for indexRedstone, valueRedstone in ipairs(tanksAndRedstone[index].redstones.addresses) do
		tanksAndRedstone[index].redstones.components[indexRedstone] = component.proxy(component.get(valueRedstone))
	end
	
	tanksAndRedstone[index].tanks.components = {}
	for indexTank, valueTank in ipairs(tanksAndRedstone[index].tanks.addresses) do
		tanksAndRedstone[index].tanks.components[indexTank] = component.proxy(component.get(valueTank))
	end
end

function redstoneOutput(Output, tableOfRedstones)
	for indexRedstone, valueRedstone in ipairs(tableOfRedstones) do
		for Side = 0, 5 do
			valueRedstone.setOutput(Side, Output)
		end
	end
end

-- Основной цикл

while true do
	os.execute('clear')
	for index, value in ipairs(tanksAndRedstone) do
		tanksAndRedstone[index].tanks.Data = {}
		AllStored = 0
		MaximumStored = 0
		for indexTank, valueTank in ipairs(tanksAndRedstone[index].tanks.components) do
			StoredNow, StoredMaximum, TypeOfStored = valueTank.getInfo()
			tanksAndRedstone[index].tanks.Data[indexTank] = {
				StoredNow = StoredNow,
				StoredMaximum = StoredMaximum,
				TypeOfStored = TypeOfStored,
			}
			AllStored = AllStored + StoredNow
			MaximumStored = MaximumStored + StoredMaximum
		end
		
		StoredAVG = AllStored/MaximumStored * 100
		if StoredAVG >= 80 then
			redstoneOutput(15, tanksAndRedstone[index].redstones.components)
		else
			redstoneOutput(0, tanksAndRedstone[index].redstones.components)
		end
		
		print("\nГруппа жидкостных хранилищ " .. index .. "\n  Средняя заполненность хранилищ: " .. string.format("%.2f" , StoredAVG) .. "%")
	end
	
	os.sleep(2.5)
end