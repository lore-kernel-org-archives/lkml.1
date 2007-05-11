Return-Path: <linux-kernel-owner+w=401wt.eu-S1763014AbXEKS7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763014AbXEKS7o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 14:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762738AbXEKS7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 14:59:34 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3119 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754173AbXEKS7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 14:59:33 -0400
Date: Fri, 11 May 2007 18:23:30 +0000
From: Pavel Machek <pavel@ucw.cz>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [Fastboot] restoring x86 BIOS state before reboot
Message-ID: <20070511182329.GJ4052@ucw.cz>
References: <20070406154628.GG12005@jukie.net> <m1zm4rd676.fsf@ebiederm.dsl.xmission.com> <20070429094135.GA10948@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070429094135.GA10948@suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > It may also be worth investigating if it is possible to bypass
> > the part of windows that uses BIOS calls.  I really don't have
> > a clue how a modern windows systems boots.
> 
> I think ReactOS has a bootlader that can also boot Windows, or at
> least they are close to booting the Windows kernel. That bootloader
> could be then used for booting Windows without BIOS calls.
> 
> I also heard that the 100-$-Laptop should now be able to use Windows.
> As it's using LinuxBIOS, this could also be interesting. However,
> maybe Microsoft simply modifies a special Windows for this, or they
> integrate a ClosedSource part in that LinuxBIOS, I don't know ... :-(

I do not think OLPC is using linuxBIOS these days. What they have
certainly looks like Sun's ROM monitor.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
