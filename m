Return-Path: <linux-kernel-owner+w=401wt.eu-S1754714AbZAIKfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714AbZAIKfA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 05:35:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751825AbZAIKew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 05:34:52 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34459 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbZAIKev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 05:34:51 -0500
Date: Fri, 9 Jan 2009 11:36:58 +0100
From: Pavel Machek <pavel@suse.cz>
To: Oliver Neukum <oliver@neukum.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Regression] USB wakeup problem on Toshiba Portege R500
Message-ID: <20090109103658.GE3396@elf.ucw.cz>
References: <200901080835.39639.rjw@sisk.pl> <200901081748.58962.oliver@neukum.org> <20090109101840.GD3396@elf.ucw.cz> <200901091126.57094.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901091126.57094.oliver@neukum.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-01-09 11:26:55, Oliver Neukum wrote:
> Am Friday 09 January 2009 11:18:41 schrieb Pavel Machek:
> > laptops normally wake up lid open... (and you still have a
> > powerbutton; plus I'm not aware of any laptops with usb keyboard --
> > are apples crazy enough to do that?)
> 
> Yes, they are. Do they wake if you hit the power button or close and
> reopen the lid? If so, I am satisfied and have no problem with reverting.

I think so, yes.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
