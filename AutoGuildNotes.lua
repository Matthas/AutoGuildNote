-- Create a frame for your addon
local frame = CreateFrame("Frame", "MyAddonFrame", UIParent, "BasicFrameTemplateWithInset")
frame:SetSize(600, 400)  -- Increase the size of the frame
frame:SetPoint("CENTER")
frame:Hide()
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)

-- Add a title to the frame
frame.title = frame:CreateFontString(nil, "OVERLAY")
frame.title:SetFontObject("GameFontHighlight")
frame.title:SetPoint("TOP", frame.TitleBg, "TOP", 0, -5)
frame.title:SetText("My Addon")

-- Create an edit box for text input
local editBox = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
editBox:SetSize(560, 300)  -- Make the edit box almost the entire size of the frame
editBox:SetPoint("TOP", frame, "TOP", 0, -50)
editBox:SetMultiLine(true)  -- Allow multiple lines of text
editBox:SetAutoFocus(false)
editBox:SetMaxLetters(0)  -- Remove the character limit

-- Create a button
local button = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
button:SetSize(400, 40)  -- Increase the size of the button
button:SetPoint("BOTTOM", frame, "BOTTOM", 0, 20)
button:SetText("Set Officer Note")
button:SetNormalFontObject("GameFontNormalLarge")
button:SetHighlightFontObject("GameFontHighlightLarge")
button:SetFrameStrata("HIGH")

-- Function to handle button click
local function handleButtonClick()
    local text = editBox:GetText()
    local firstLine = text:match("[^\r\n]+")
    if firstLine then
        local player, action = firstLine:match("([^;]+);([^;]+)")
        if player and action then
            for i = 1, GetNumGuildMembers() do
                local name = GetGuildRosterInfo(i)
                if name == player then
                    GuildRosterSetOfficerNote(i, action)
                    print("Officer note updated for player:", player)
                    -- Remove the first line from the edit box
                    local remainingText = text:sub(#firstLine + 2)  -- +2 to remove the newline character
                    editBox:SetText(remainingText)
                    return
                end
            end
            print("Player not found:", player)
        else
            print("Invalid format:", firstLine)
        end
    else
        print("No text found")
    end
end

-- Button click event
button:SetScript("OnClick", handleButtonClick)

-- Slash command to open the frame
SLASH_MYADDON1 = "/AGN"
SlashCmdList["MYADDON"] = function()
    if frame:IsShown() then
        frame:Hide()
    else
        frame:Show()
    end
end
