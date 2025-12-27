# How to Add Core Data Model (After Xcode Opens)

Since Xcode crashes when the Core Data model is referenced, we'll add it manually through Xcode's GUI once the project opens.

## Steps to Add Core Data Model:

1. **Open the project in Xcode** (it should open now without the Core Data model)

2. **Add the Data Model file:**
   - In Xcode's Project Navigator (left sidebar), right-click on the **"Models"** folder
   - Select **"Add Files to 'DailyTrackerApp'..."**
   - Navigate to: `DailyTrackerApp/Models/`
   - Select the folder **"DataModel.xcdatamodeld.temp"**
   - Rename it to **"DataModel.xcdatamodeld"** (remove .temp)
   - OR: Create a new Data Model file:
     - Right-click "Models" folder
     - New File → Data Model
     - Name it "DataModel"

3. **If you use the existing model:**
   - Rename `DataModel.xcdatamodeld.temp` to `DataModel.xcdatamodeld`
   - Then add it to the project using "Add Files to..."

4. **Verify the entities are there:**
   - Click on DataModel.xcdatamodeld in the project navigator
   - You should see FoodEntryEntity and WorkoutEntryEntity with all their attributes

5. **Build the project** - it should work now!

## Alternative: Use SwiftData Instead

If Core Data continues to cause issues, we can refactor to use SwiftData, which is Apple's modern alternative and doesn't require a .xcdatamodeld file. Let me know if you want to do this!

