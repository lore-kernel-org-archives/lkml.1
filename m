Return-Path: <linux-kernel-owner+w=401wt.eu-S1751908AbXB0VhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908AbXB0VhW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 16:37:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751909AbXB0VhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 16:37:22 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:53081 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751908AbXB0VhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 16:37:21 -0500
Date: Tue, 27 Feb 2007 22:23:01 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Oliver Neukum <oneukum@suse.de>
Cc: kernel list <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: 2.6.21-rc1: mmc reader no longer works, usb oops
Message-ID: <20070227212300.GA1717@elf.ucw.cz>
References: <20070227103620.GA8205@elf.ucw.cz> <200702271146.53414.oneukum@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702271146.53414.oneukum@suse.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > MMC card reader in x60 no longer works in -rc1. (Will have to check if
> > it worked before s2ram).

It is broken even without s2ram.

> > When playing with usb-serial, I got this oops (upon trying to start
> > minicom /dev/ttyUSB0 while linux gadget on the other end was
> > crashing).
> 
> Does this help?

Will test, but... I do not know how reproducible the bug is.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
