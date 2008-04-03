Return-Path: <linux-kernel-owner+w=401wt.eu-S1761976AbYDCT7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761976AbYDCT7P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 15:59:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757607AbYDCT66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 15:58:58 -0400
Received: from smtp2e.orange.fr ([80.12.242.111]:53999 "EHLO smtp2e.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757514AbYDCT65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 15:58:57 -0400
X-Greylist: delayed 7551 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Apr 2008 15:58:57 EDT
X-ME-UUID: 20080403195855818.C7DD17000091@mwinf2e02.orange.fr
Subject: Re: ASUS ScreenDuo
From: Xavier Bestel <xavier.bestel@free.fr>
To: david@lang.hm
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.10.0804031303210.22292@asgard.lang.hm>
References: <Pine.LNX.4.44L0.0804031506300.7376-100000@iolanthe.rowland.org>
	 <1207251545.24007.3.camel@bip.parateam.prv>
	 <alpine.DEB.1.10.0804031303210.22292@asgard.lang.hm>
Content-Type: text/plain
Date: Thu, 03 Apr 2008 21:58:52 +0200
Message-Id: <1207252732.24007.5.camel@bip.parateam.prv>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On jeu, 2008-04-03 at 13:04 -0700, david@lang.hm wrote:
> On Thu, 3 Apr 2008, Xavier Bestel wrote:
> 
> > On jeu, 2008-04-03 at 15:07 -0400, Alan Stern wrote:
> >> On Thu, 3 Apr 2008, Xavier Bestel wrote:
> >>
> >>> On jeu, 2008-04-03 at 11:37 -0400, Alan Stern wrote:
> >>>> On Thu, 3 Apr 2008, Xavier Bestel wrote:
> >>>>
> >>>>> Hi,
> >>>>>
> >>>>> I have an ASUS motherboard with an USB gadget, the ASUS ScreenDUO. It's
> >>>>> an independant little lcd screen with buttons, apparently it runs some
> >>>>> kind of OS because it can access the net (e.g. to retrieve RSS) even
> >>>>> when the computer is off - I guess they mean soft-off.
> >>>>>
> >>>>> Well, all that is theory because it's under Vista, which I don't have.
> >>>>> Under Linux the ScreenDUO is kind-of recognized: it says it's a mass
> >>>>> storage device, but I can't mount it (the kernel says it's bound to sdc,
> >>>>> but sdc doesn't exist).
> >>>>> I'd like to access it. Does anyone know how that thing works ?
> >>>>
> >>>> What does usbmon show when you modprobe usb-storage?  (The instructions
> >>>> for usbmon are in the kernel source file Documentation/usb/usbmon.txt.)
> >>
> >> ...
> >>
> >> The ScreenDUO is reporting that no medium is present.  Maybe it needs
> >> you to insert some sort of flash memory card before it will work as a
> >> mass-storage device.
> >
> > Ah. Apparently it just waits for some driver from the Windows side (no
> > way to insert anything in there).
> > I guess it'll just be another useless piece of electronics at home.
> 
> for future use, what was it that made everyone decide that this is going 
> to show up as a storage device?
> 
> with a screen and buttons I would have guessed a HID of some sort.

Maybe it waits for a firmware or something first.

	Xav


