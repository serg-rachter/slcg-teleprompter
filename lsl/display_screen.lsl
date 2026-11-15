// SLCG Screens — Display Screen v1.2 (see README.md)

integer FACE_SCREEN = 1;            // face that shows the image

integer CHANNEL     = -730917;      // must match teleprompter.lsl
string  PREFIX      = "SLCGSCR";    // must match teleprompter.lsl

default
{
    state_entry()
    {
        llListen(CHANNEL, "", NULL_KEY, "");
        llShout(CHANNEL, PREFIX + "|SYNC");    // ask for the current image
    }

    on_rez(integer param)
    {
        llResetScript();
    }

    listen(integer channel, string name, key id, string msg)
    {
        if (llGetOwnerKey(id) != llGetOwner()) return;    // only our own teleprompter

        string head = PREFIX + "|SHOW|";
        if (llSubStringIndex(msg, head) != 0) return;

        string tex = llGetSubString(msg, llStringLength(head), -1);
        if ((key)tex || llGetInventoryType(tex) == INVENTORY_TEXTURE)
            llSetTexture(tex, FACE_SCREEN);
    }

    changed(integer change)
    {
        if (change & CHANGED_OWNER) llResetScript();
    }
}
