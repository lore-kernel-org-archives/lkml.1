Return-Path: <linux-kernel-owner+w=401wt.eu-S1759956AbXGJS7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759956AbXGJS7R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 14:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754113AbXGJS7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 14:59:07 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:57030 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754505AbXGJS7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 14:59:06 -0400
Date: Tue, 10 Jul 2007 20:59:07 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: Liunx power consumption on laptops -- Enormous progress in the last few months
Message-ID: <20070710185907.GA7139@elf.ucw.cz>
References: <468D4D82.8030009@linux.intel.com> <468E6F0C.1090601@redhat.com> <468E6F4C.8000601@linux.intel.com> <468E83CE.8090800@redhat.com> <46927679.9020005@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46927679.9020005@tmr.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2007-07-09 13:55:05, Bill Davidsen wrote:
> Chuck Ebbert wrote:
> >On 07/06/2007 12:35 PM, Arjan van de Ven wrote:
> >>>Where is the ondemand-fix.patch? I can't find any link to it.
> >>just click on it in the graph ;_
> >>
> >>it's also http://www.linuxpowertop.org/patches/ondemand-fix.patch (which
> >>is submitted already to the maintainers)
> >>
> >
> >Ah, OK, that one just went into the latest Fedora 7 kernel.
> >
> All this information makes it obvious that even though upgrades are 
> painful (given slow laptop disks, *really* painful), it looks as if 
> there are major benefits to be gained.
> 
> Thanks for sharing the information.
> 
> As improved as USB drivers are, I assume that unloading the drivers is 
> still desirable if no USB hardware is in use.

That should be no longer neccessary, IIRC.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
