Return-Path: <linux-kernel-owner+w=401wt.eu-S1760733AbYDCTH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760733AbYDCTH5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 15:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756424AbYDCTHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 15:07:45 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42935 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756333AbYDCTHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 15:07:44 -0400
Date: Thu, 3 Apr 2008 15:07:43 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Xavier Bestel <xavier.bestel@free.fr>
cc: linux-usb@vger.kernel.org, <linux-kernel@vger.kernel.org>
Subject: Re: ASUS ScreenDuo
In-Reply-To: <1207245175.24007.0.camel@bip.parateam.prv>
Message-ID: <Pine.LNX.4.44L0.0804031506300.7376-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Apr 2008, Xavier Bestel wrote:

> On jeu, 2008-04-03 at 11:37 -0400, Alan Stern wrote:
> > On Thu, 3 Apr 2008, Xavier Bestel wrote:
> > 
> > > Hi,
> > > 
> > > I have an ASUS motherboard with an USB gadget, the ASUS ScreenDUO. It's
> > > an independant little lcd screen with buttons, apparently it runs some
> > > kind of OS because it can access the net (e.g. to retrieve RSS) even
> > > when the computer is off - I guess they mean soft-off.
> > > 
> > > Well, all that is theory because it's under Vista, which I don't have.
> > > Under Linux the ScreenDUO is kind-of recognized: it says it's a mass
> > > storage device, but I can't mount it (the kernel says it's bound to sdc,
> > > but sdc doesn't exist).
> > > I'd like to access it. Does anyone know how that thing works ?
> > 
> > What does usbmon show when you modprobe usb-storage?  (The instructions 
> > for usbmon are in the kernel source file Documentation/usb/usbmon.txt.)

...

The ScreenDUO is reporting that no medium is present.  Maybe it needs 
you to insert some sort of flash memory card before it will work as a 
mass-storage device.

Alan Stern

