Return-Path: <linux-kernel-owner+w=401wt.eu-S1754806AbYHNWiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806AbYHNWiO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 18:38:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751490AbYHNWh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 18:37:58 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:55489 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbYHNWh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 18:37:57 -0400
Date: Fri, 15 Aug 2008 00:39:18 +0200
From: Pavel Machek <pavel@suse.cz>
To: "Press, Jonathan" <Jonathan.Press@ca.com>
Cc: tvrtko.ursulin@sophos.com, Arjan van de Ven <arjan@infradead.org>,
       Adrian Bunk <bunk@kernel.org>, davecb@sun.com, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       malware-list@lists.printk.net, Mihai Don??u <mdontu@bitdefender.com>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to alinuxinterfaceforon
	access scanning
Message-ID: <20080814223918.GC6370@elf.ucw.cz>
References: <20080813125638.GB6995@ucw.cz> <20080813135207.CC08C3765BC@pmx1.sophos.com> <20080814125410.GA2262@elf.ucw.cz> <2629CC4E1D22A64593B02C43E855530304AE4BE3@USILMS12.ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2629CC4E1D22A64593B02C43E855530304AE4BE3@USILMS12.ca.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Okay, so goal of libmalware.so is to "not allow data in the black list
> > to pass through Linux server". Threat model is windows machines trying
> > to copy infected files through the server. 
> 
> That's only part of the threat model.

Yes, that's the part libmalware.so proposal solves. Given scary number
of 0 Linux viruses in wild, it seems to solve the problem pretty well.

> > it actually _works_, 100% of time, for apps using it.
> 
> Again that's a big condition.

Yep, so... why don't you propose something better? I'm pretty sure
100% reliable scanning is impossible without modifying applications,
but hey, you can prove me wrong.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
