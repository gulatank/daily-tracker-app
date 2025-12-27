# Product Backlog

## Future Enhancements

### Food Database & Error Handling

**Status**: Backlog  
**Priority**: Medium  
**Complexity**: High

#### Problem
Currently, when foods are not found in the database:
- They are saved with 0 calories
- User has no way to add nutritional information
- No way to update database with Indian foods and pronunciation variants

#### Requirements

1. **Manual Input for Unknown Foods**
   - When food is not found, allow user to manually enter:
     - Calories
     - Protein, Carbs, Fats
     - Fiber, Sugar, Sodium (optional)
   - Save to custom/user database
   - App should acknowledge and remember these entries

2. **Database Update Capability**
   - Ability to add new foods to database
   - Support for pronunciation variants/aliases for Indian foods
     - Example: "roti", "roti", "chapati" all map to same food
   - Support for regional name variations
   - Bulk import capability for Indian food database

3. **Fuzzy Matching Improvements**
   - Better handling of pronunciation differences
   - Handle common transcription errors
   - Support for phonetic matching

#### Technical Considerations

- **Storage**: Need to decide between:
  - Separate user database file (custom_foods.json)
  - Extend existing FoodDatabaseService with persistent storage
  - Hybrid approach (user foods + system foods)

- **UI Components Needed**:
  - Manual entry form/sheet
  - Database management view (Settings or separate)
  - Food entry/edit interface

- **Data Structure**:
  - Pronunciation aliases mapping
  - User-defined foods with full nutrient profiles
  - Merge logic for user + system databases

#### Notes
- Indian food database requires extensive research and data collection
- Pronunciation variants are complex (regional accents, transcription errors)
- Consider integration with external APIs (USDA, etc.) for validation

#### Related Files
- `DailyTrackerApp/Services/FoodDatabaseService.swift` - Main database service
- `DailyTrackerApp/Views/RecordingView.swift` - Where unknown foods are currently handled
- `DailyTrackerApp/Models/FoodEntry.swift` - Food entry model

---

## Other Backlog Items

_(Add future items here)_

