Return-Path: <linux-kernel-owner+w=401wt.eu-S1757981AbYBNRX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757981AbYBNRX4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 12:23:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753341AbYBNRXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 12:23:48 -0500
Received: from twin.jikos.cz ([213.151.79.26]:51016 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753309AbYBNRXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 12:23:47 -0500
Date: Thu, 14 Feb 2008 18:23:37 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: =?ISO-8859-1?Q?Beno=EEt?= Dejean <benoit@placenet.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: One minute delay when booting 2.6.24.1
In-Reply-To: <1203009561.3170.17.camel@ibook>
Message-ID: <Pine.LNX.4.64.0802141822590.7699@twin.jikos.cz>
References: <200802091329.35851.tvrtko@ursulin.net> 
 <Pine.LNX.4.64.0802092301180.6917@fbirervta.pbzchgretzou.qr> 
 <200802120833.37955.tvrtko@ursulin.net> <1203009561.3170.17.camel@ibook>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1747641777-132358886-1203009817=:7699"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1747641777-132358886-1203009817=:7699
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Thu, 14 Feb 2008, Beno=EEt Dejean wrote:

> [   14.680874] input: HID 05ac:1000
> as /devices/pci0001:10/0001:10:1a.0/usb2/2-1/2-1:1.0/input/input5
> [   14.716702] input,hidraw0: USB HID v1.11 Keyboard [HID 05ac:1000] on
> usb-0001:10:1a.0-1
> [   14.742128] input: HID 05ac:1000
> as /devices/pci0001:10/0001:10:1a.0/usb2/2-1/2-1:1.1/input/input6
> [   14.780009] input,hidraw1: USB HID v1.11 Mouse [HID 05ac:1000] on
> usb-0001:10:1a.0-1
> [   14.786938] usbcore: registered new interface driver usbhid
> [   14.793692] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
> [   48.279840] hda: UDMA/100 mode selected
> [   49.471289] Adding 1506444k swap on /dev/hda4.  Priority:-1 extents:1
> across:1506444k
> [   50.955529] [drm] Initialized drm 1.1.0 20060810
> [   51.006960] [drm] Initialized radeon 1.28.0 20060524 on minor 0
> [   51.057858] adt746x: version 1 (supported)
> [   51.064397] adt746x: Thermostat bus: 1, address: 0x2e, limit_adjust:
> 0, fan_speed: -1
> [   51.070993] sensor 0: PWR/MEMORY BOTTOMSIDE
> [   51.077649] sensor 1: CPU BOTTOMSIDE
> [   51.084210] sensor 2: GPU ON DIE

Could you please show the output with 'initcall_debug'?

--=20
Jiri Kosina
---1747641777-132358886-1203009817=:7699--
