// SLCG Screens — Teleprompter v1.2 (see README.md)

integer FACE_FORWARD = 2;           // button face: next image
integer FACE_BACK    = 4;           // button face: previous image
integer FACE_DISPLAY = 0;           // face that shows the image

integer CHANNEL      = -730917;     // must match display_screen.lsl
string  PREFIX       = "SLCGSCR";   // must match display_screen.lsl

string  SPEAKERS_NOTECARD = "Speakers";

integer gIndex = 0;                 // image being shown
list    gSpeakers;                  // names and UUIDs allowed to change images
list    gLoading;                   // speakers list while the notecard is read
key     gQuery = NULL_KEY;          // current notecard read
integer gLine;                      // notecard line being read

// Lower case, "." as space, no trailing " resident", so name spellings compare equal.
string normalise(string s)
{
    s = llToLower(llStringTrim(s, STRING_TRIM));
    s = llDumpList2String(llParseString2List(s, ["."], []), " ");
    integer len = llStringLength(s);
    if (len > 9 && llGetSubString(s, len - 9, -1) == " resident")
        s = llGetSubString(s, 0, len - 10);
    return s;
}

// Start reading the speakers notecard; no notecard means owner only.
loadSpeakers()
{
    gLoading = [];
    gQuery = NULL_KEY;
    if (llGetInventoryType(SPEAKERS_NOTECARD) != INVENTORY_NOTECARD)
    {
        gSpeakers = [];
        return;
    }
    gLine = 0;
    gQuery = llGetNotecardLine(SPEAKERS_NOTECARD, gLine);
}

// A texture's UUID when readable (full-perm), otherwise its name.
string textureRef(string name)
{
    key k = llGetInventoryKey(name);
    if (k == NULL_KEY) return name;
    return (string)k;
}

// Show the current image, wrapping at either end, and tell the screens.
show()
{
    integer count = llGetInventoryNumber(INVENTORY_TEXTURE);
    if (count == 0) return;
    if (gIndex >= count) gIndex = 0;
    if (gIndex < 0)      gIndex = count - 1;

    string tex = textureRef(llGetInventoryName(INVENTORY_TEXTURE, gIndex));
    llSetTexture(tex, FACE_DISPLAY);
    llShout(CHANNEL, PREFIX + "|SHOW|" + tex);
}

// The owner and anyone on the speakers notecard may change images.
integer allowed(key av)
{
    if (av == llGetOwner()) return TRUE;
    if (llListFindList(gSpeakers, [(string)av]) != -1) return TRUE;
    if (llListFindList(gSpeakers, [normalise(llGetUsername(av))]) != -1) return TRUE;
    if (llListFindList(gSpeakers, [normalise(llKey2Name(av))]) != -1) return TRUE;
    return FALSE;
}

default
{
    state_entry()
    {
        llListen(CHANNEL, "", NULL_KEY, PREFIX + "|SYNC");
        gIndex = 0;
        show();
        loadSpeakers();
    }

    touch_start(integer n)
    {
        integer i;
        for (i = 0; i < n; ++i)
        {
            integer face = llDetectedTouchFace(i);
            if ((face == FACE_FORWARD || face == FACE_BACK) && allowed(llDetectedKey(i)))
            {
                if (face == FACE_FORWARD) ++gIndex;
                else --gIndex;
                show();
            }
        }
    }

    // A screen that was just rezzed or reset asks for the current image.
    listen(integer channel, string name, key id, string msg)
    {
        if (llGetOwnerKey(id) != llGetOwner()) return;
        show();
    }

    dataserver(key query, string data)
    {
        if (query != gQuery) return;    // reply to an older read
        if (data == EOF)
        {
            gSpeakers = gLoading;
            gLoading = [];
            gQuery = NULL_KEY;
            return;
        }
        data = llStringTrim(data, STRING_TRIM);
        if (data != "" && llGetSubString(data, 0, 0) != "#")
        {
            if ((key)data) gLoading += [llToLower(data)];
            else gLoading += [normalise(data)];
        }
        gQuery = llGetNotecardLine(SPEAKERS_NOTECARD, ++gLine);
    }

    changed(integer change)
    {
        if (change & CHANGED_OWNER) llResetScript();
        if (change & CHANGED_INVENTORY)    // images added/removed or notecard saved
        {
            show();
            loadSpeakers();
        }
    }
}
