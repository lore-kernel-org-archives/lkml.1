Return-Path: <linux-kernel-owner+w=401wt.eu-S1754798AbYDBLbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798AbYDBLbM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 07:31:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753046AbYDBLa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 07:30:58 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:45515 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040AbYDBLa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 07:30:58 -0400
Date: Wed, 2 Apr 2008 13:31:32 +0200
From: Pavel Machek <pavel@suse.cz>
To: Michael Meyer <mike65134@yahoo.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: performance differences: "maxcpus=1" vs. "echo 0 >
	/sys/devices/system/cpu/cpu1/online"
Message-ID: <20080402113132.GA3181@elf.ucw.cz>
References: <20080329212203.GB2153@elf.ucw.cz> <548290.15521.qm@web25803.mail.ukl.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <548290.15521.qm@web25803.mail.ukl.yahoo.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Ok, and your chip is too old to have "Enhanced Dynamic Acceleration
> > Technology" (Intel, can't you use some reasonable names?!)... both
> > would explain effects you see, and it is neither...
> 
> It is too old to have that. I bought it at the beginning of 2007 and it
> is from the first line of Core 2 Duo processors (released in summer
> 2006). I think "Enhanced Dynamic Acceleration Technology" is only
> available recently.
> 
> > You could try implementing deep sleep (C4) state for cpu hotplug....
> 
> I have to confess that I sneaked unto LKML illegitimately, as I am not
> a kernel hacker.

You can still play one, and submit a patch. Over internet, noone can
tell if you are hacker or not ;-). I would be happy to help with good
advice ;-).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
