Return-Path: <linux-kernel-owner+w=401wt.eu-S1757890AbYCNOgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757890AbYCNOgV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 10:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756593AbYCNOgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 10:36:08 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38853 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754133AbYCNOgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 10:36:07 -0400
Date: Fri, 14 Mar 2008 10:36:06 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tino Keitel <tino.keitel@gmx.de>
cc: Jiri Kosina <jkosina@suse.cz>, <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>
Subject: Re: broken access to a USB HID device after suspend
In-Reply-To: <20080314071712.GA15654@dose.home.local>
Message-ID: <Pine.LNX.4.44L0.0803141034260.4478-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Mar 2008, Tino Keitel wrote:

> On Fri, Mar 14, 2008 at 08:13:36 +0100, Tino Keitel wrote:
> 
> [...]
> 
> > Well, I still don't have USB_DEBUG or usbmon enabled, but I just got
> > that error again. I pulled the power plug from the LCD and replugged
> > it, without success. Then I did a suspend/resume cycle, and it worked.
> 
> Forgot to mention: yesterday it was working, and the computer was
> suspended overnight, without a reboot inbetween.

I suspect the suspend/resume connection is misleading you, that it has 
nothing to do with the real problem.

Have you tried using the LCD device with a different computer?  It's 
worth a try, just to rule out the possibility that something is wrong 
with your computer's USB hardware.

Alan Stern

