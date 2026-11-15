# SLCG Screens

A slideshow for ceremonies in Second Life. A speaker clicks through images on a small screen at the podium, which we call the **teleprompter**. Two big **display screens** in the hall show the same image at the same moment.

Only the people you choose can change the images, so nobody in the crowd can click through by accident.

## What's included

| File | What it's for |
|---|---|
| [lsl/teleprompter.lsl](lsl/teleprompter.lsl) | The script for the podium screen with the Forward and Back buttons. |
| [lsl/display_screen.lsl](lsl/display_screen.lsl) | The script for each big screen. Use the same script in every one. |

## Setting it up

You only need to do this once.

1. **Rez the teleprompter**, the podium screen with the two buttons.
2. **Add the teleprompter script.** Right-click the teleprompter, choose **Edit**, and open the **Content** tab. Drag `teleprompter.lsl` from your inventory into the Content tab.
3. **Add your images.** Drag the images from your inventory into the same Content tab. The first image appears on the teleprompter straight away. See [Your images](#your-images) for how to put them in order.
4. **Add the speakers list.** In the Content tab, click **New Note**. Rename the notecard to exactly `Speakers` (with a capital S), then open it and type in the names. See [Who can change the images](#who-can-change-the-images).
5. **Rez the big screens** where you want them, no more than 100 metres from the teleprompter.
6. **Add the screen script to each big screen.** Edit each one and drag `display_screen.lsl` into its Content tab. The screen shows the current image straight away.

The teleprompter and the big screens must all **belong to the same person**. A screen ignores any teleprompter that belongs to someone else, so two sets of screens in the same area won't interfere with each other.

## During the ceremony

- Click the **Forward** button to show the next image.
- Click the **Back** button to go back one image.
- After the last image, Forward goes back to the first one. Back on the first image goes to the last one.

Clicks from anyone who isn't allowed simply do nothing.

## Your images

- Images play in **alphabetical order by name**. Start each name with a number so the order is clear: `01 Opening`, `02 Ensign Smith - Promotion`, `03 Lt Jones - Award`, and so on. Use `01`, not `1`, or `10` would come before `2`.
- To **add, remove or reorder** images, change them in the teleprompter's Content tab. The screens update on their own.
- Use images **you uploaded yourself**. If an image came from someone else and you can't copy, modify and transfer it, the big screens can't show it. In that case, put a copy of the same image, with exactly the same name, in each big screen's Content tab as well.

## Who can change the images

The owner of the teleprompter can always change the images. Anyone else must be listed in the `Speakers` notecard inside the teleprompter.

Write **one person per line**. Any of these work:

- **Username**, for example `serg.rachter`, or just `jane` for newer accounts.
- **Full name**, for example `Serg Rachter` or `Jane Resident`.

Capital letters don't matter. Lines that start with `#` are ignored, so you can use them for notes.

**Display names don't work.** Anyone can change their display name to anything, so the list uses each person's real account name. To find someone's username, open their profile. It's the name shown under their display name.

Save the notecard and the new list takes effect immediately. If there is no `Speakers` notecard, only the owner can change the images.

Example notecard:

```
# Graduation speakers
serg.rachter
David Greybeard
jane
```

## If something isn't working

| Problem | What to check |
|---|---|
| A speaker clicks but nothing changes | Their name is spelled correctly in the notecard, it's their username or full name and not their display name, and the notecard is named exactly `Speakers`. |
| A big screen doesn't change | The screen is within 100 metres of the teleprompter and has the same owner. Try **Reset Scripts** on the screen: select it, then choose **Build > Scripts > Reset Scripts**. |
| A big screen shows a different image | Reset its scripts as above. It will pick up the current image. |
| The image appears on the wrong part of the screen or button | The face numbers need changing. See below. |
| The teleprompter shows nothing | It has no images in its Content tab yet. |

## Settings (for the builder)

These are set at the top of each script. Open the script from the Content tab, change the number, and click **Save**.

| Setting | Script | Current value | What it does |
|---|---|---|---|
| `FACE_FORWARD` | teleprompter | `2` | The part of the teleprompter that works as the Forward button. |
| `FACE_BACK` | teleprompter | `4` | The part of the teleprompter that works as the Back button. |
| `FACE_DISPLAY` | teleprompter | `0` | The part of the teleprompter that shows the image. |
| `FACE_SCREEN` | display screen | `1` | The part of the big screen that shows the image. |
| `CHANNEL` | both | `-730917` | The private channel the teleprompter and screens talk on. It must be the same in both scripts. |
| `PREFIX` | both | `SLCGSCR` | A label on every message. It must be the same in both scripts. |
| `SPEAKERS_NOTECARD` | teleprompter | `Speakers` | The name of the speakers notecard. |

**Face numbers.** Each surface of a model has a number, starting at 0. For a mesh, the numbers follow the order of the materials when the model was made, so the person who made the mesh can tell you which is which. If the model changes, these numbers may need updating.

**Channel.** Avatars can't type on a negative channel, so nobody can control the screens from chat. If you set up a second, separate set of screens with the same owner, give that set a different channel in both of its scripts.
