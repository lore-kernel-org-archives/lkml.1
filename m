Return-Path: <linux-kernel-owner+w=401wt.eu-S1754891AbYKVVn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891AbYKVVn7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 16:43:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbYKVVnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 16:43:49 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:43768 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969AbYKVVns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 16:43:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=YUxy+VmHaCQtQiVqtKJPPqU5dYokGH7Gs5Iki94G79I+h4cQT1QMlx1nPCfsR7EL0y
         8r/EAdtkjnPEgWFjvCjE+zvuUXLDvTxn44F4WiPQ9GcxAwfN3YBnLoVbZaj2XXEOhd9q
         3afBylXggDppzJJPBT+sNuBmTsmgoc5Jma15I=
Message-ID: <28f715610811221343s67ed9901nc80618774fcbdcf8@mail.gmail.com>
Date: Sat, 22 Nov 2008 22:43:46 +0100
From: "Daniel Perzynski" <daniel.perzynski@gmail.com>
To: linux-kernel@vger.kernel.org, linu-acpi@vger.kernel.org
Subject: Re: HP WMI laptop extras driver
Cc: mjg59@srcf.ucam.org
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again,

Below are messages collected for all special buttons of my laptop.

Nov 22 13:11:49 h3xu5 input: HP WMI hotkeys as /class/input/input9
quickplay button -> Nov 22 13:13:10 h3xu5 HP WMI: Unknown key pressed - 22142
quickplay dvd button  -> Nov 22 13:14:22 h3xu5 HP WMI: Unknown key
pressed - 220e6
quickplay TV button -> Nov 22 13:14:52 h3xu5 HP WMI: Unknown key pressed - 22181

previous track button -> Nov 22 13:15:50 h3xu5 HP WMI: Unknown key
pressed - 32192
stop button -> Nov 22 13:16:15 h3xu5 HP WMI: Unknown key pressed - 32191
play/pause button -> Nov 22 13:16:30 h3xu5 HP WMI: Unknown key pressed - 32190
next track  button -> Nov 22 13:16:46 h3xu5 HP WMI: Unknown key pressed - 32193

4 above buttons are working fine in x-windows

cinema button -> Nov 22 13:21:14 h3xu5 HP WMI: Unknown key pressed - 2218b
synaptics touchpad button off/on:
Nov 22 13:21:28 h3xu5 atkbd.c: Unknown key pressed (translated set 2,
code 0xd8 on isa0060/serio0).
Nov 22 13:21:28 h3xu5 atkbd.c: Use 'setkeycodes e058 <keycode>' to
make it known.
Nov 22 13:21:40 h3xu5 atkbd.c: Unknown key pressed (translated set 2,
code 0xd9 on isa0060/serio0).
Nov 22 13:21:40 h3xu5 atkbd.c: Use 'setkeycodes e059 <keycode>' to
make it known.
wifi button off
Nov 22 13:22:26 h3xu5 usb 3-2: USB disconnect, address 3
Nov 22 13:22:26 h3xu5 btusb_intr_complete: hci0 urb ffff88013e1252c0
failed to resubmit (19)
Nov 22 13:22:26 h3xu5 btusb_send_frame: hci0 urb ffff88013e1252c0
submission failed
Nov 22 13:22:26 h3xu5 hcid[3607]: HCI dev 0 down
Nov 22 13:22:26 h3xu5 hcid[3607]: Stopping security manager 0
Nov 22 13:22:26 h3xu5 hcid[3607]: Device hci0 has been disabled
Nov 22 13:22:27 h3xu5 hcid[3607]: HCI dev 0 unregistered
Nov 22 13:22:27 h3xu5 hcid[3607]: Unregister path: /org/bluez/hci0
Nov 22 13:22:27 h3xu5 hcid[3607]: Device hci0 has been removed
Nov 22 13:22:29 h3xu5 hcid[3607]: Can't remove GN bridge
Nov 22 13:22:29 h3xu5 hcid[3607]: Unregistered manager path
Nov 22 13:22:29 h3xu5 hcid[3607]: Unregistered manager path
Nov 22 13:22:29 h3xu5 hcid[3607]: Unregistered manager path
Nov 22 13:22:29 h3xu5 hcid[3607]: Stopping SDP server
Nov 22 13:22:29 h3xu5 hcid[3607]: Exit
wifi button on
Nov 22 13:23:01 h3xu5 usb 3-2: new full speed USB device using
uhci_hcd and address 4
Nov 22 13:23:01 h3xu5 usb 3-2: configuration #1 chosen from 1 choice
Nov 22 13:23:01 h3xu5 hcid[17796]: Bluetooth HCI daemon
Nov 22 13:23:01 h3xu5 hcid[17796]: Parsing /etc/bluetooth/main.conf
failed: No such file or directory
Nov 22 13:23:02 h3xu5 hcid[17796]: Starting SDP server
Nov 22 13:23:02 h3xu5 hcid[17796]: Parsing /etc/bluetooth/network.conf
failed: No such file or directory
Nov 22 13:23:02 h3xu5 hcid[17796]: Can't create GN bridge
Nov 22 13:23:02 h3xu5 hcid[17796]: Registered manager path:/org/bluez/network
Nov 22 13:23:02 h3xu5 hcid[17796]: Registered input manager
path:/org/bluez/input
Nov 22 13:23:02 h3xu5 hcid[17796]: Parsing /etc/bluetooth/audio.conf
failed: No such file or directory
Nov 22 13:23:02 h3xu5 hcid[17796]: Unix socket created: 16
Nov 22 13:23:02 h3xu5 hcid[17796]: Registered manager path:/org/bluez/audio
Nov 22 13:23:02 h3xu5 hcid[17796]: Starting experimental netlink support
Nov 22 13:23:02 h3xu5 hcid[17796]: Failed to find Bluetooth netlink family
Nov 22 13:23:02 h3xu5 hcid[17796]: Can't init plugin
/usr/lib64/bluetooth/plugins/netlink.so
Nov 22 13:23:02 h3xu5 hcid[17796]: Registered manager path:/org/bluez/serial
Nov 22 13:23:02 h3xu5 hcid[17796]: HCI dev 0 registered
Nov 22 13:23:02 h3xu5 hcid[17796]: HCI dev 0 up
Nov 22 13:23:02 h3xu5 hcid[17796]: Device hci0 has been added
Nov 22 13:23:02 h3xu5 hcid[17796]: Starting security manager 0
Nov 22 13:23:02 h3xu5 hcid[17796]: Device hci0 has been activated

As I understand wifi on/off is supported already by hp-wmi driver

sound mute button -> Nov 22 13:23:28 h3xu5 HP WMI: Unknown key pressed - 32190
volume up -> Nov 22 13:24:02 h3xu5 HP WMI: Unknown key pressed - 32190
volume down -> Nov 22 13:24:04 h3xu5 HP WMI: Unknown key pressed - 32190

above 3 are working fine in x-windows

bass/treble switch button -> Nov 22 13:25:06 h3xu5 HP WMI: Unknown key
pressed - 22199
bass/treble up button:
Nov 22 13:26:18 h3xu5 HP WMI: Unknown key pressed - 22197
Nov 22 13:26:18 h3xu5 atkbd.c: Unknown key pressed (translated set 2,
code 0xbe on isa0060/serio0).
Nov 22 13:26:18 h3xu5 atkbd.c: Use 'setkeycodes e03e <keycode>' to
make it known.
bass/treble down button:
Nov 22 13:26:21 h3xu5 HP WMI: Unknown key pressed - 22198
Nov 22 13:26:21 h3xu5 atkbd.c: Unknown key pressed (translated set 2,
code 0xbf on isa0060/serio0).
Nov 22 13:26:21 h3xu5 atkbd.c: Use 'setkeycodes e03f <keycode>' to
make it known.
cd eject button -> Nov 22 13:26:45 h3xu5 HP WMI: Unknown key pressed - 0


If you have any question please let me know.

Regards,
