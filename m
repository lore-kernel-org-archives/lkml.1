Return-Path: <linux-kernel-owner+w=401wt.eu-S1757577AbXFDPN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577AbXFDPN7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 11:13:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755041AbXFDPNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 11:13:51 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:52643 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755017AbXFDPNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 11:13:51 -0400
Date: Mon, 4 Jun 2007 17:13:43 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Indan Zupancic <indan@nul.nu>
Cc: Jiri Kosina <jikos@jikos.cz>, kernel list <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
Subject: Re: 2.6.22-rc[23]: blinking capslock led, stuck keys?
Message-ID: <20070604151343.GE2059@elf.ucw.cz>
References: <20070604112426.GA2707@elf.ucw.cz> <Pine.LNX.4.64.0706041434040.29896@twin.jikos.cz> <20070604130903.GC1971@elf.ucw.cz> <Pine.LNX.4.64.0706041511010.29896@twin.jikos.cz> <2204.81.207.0.53.1180969821.squirrel@secure.samage.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2204.81.207.0.53.1180969821.squirrel@secure.samage.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Are you sure that it's this dummy blink driver that makes the kernel
> > stuck? I can't see how it could be causing any hogs - see commit f038f9.
> 
> To make it clear, I'm not using the blink driver and get the stuck
> key problem too. (And also a warpy PS/2 mouse.)
> 
> Wildly guessing: As the problem doesn't seem to be widespread,
> perhaps it's suspend to ram related. I'll try running a while without
> suspending and see if it crops up too then.

It is not suspend related -- at least on my machine anyway.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
