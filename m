Return-Path: <linux-kernel-owner+w=401wt.eu-S1756522AbZFHOeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522AbZFHOeu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 10:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755350AbZFHOem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 10:34:42 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48168 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754837AbZFHOem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 10:34:42 -0400
Date: Mon, 8 Jun 2009 07:48:45 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Michael S. Zick" <lkml@morethan.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Harald Welte <HaraldWelte@viatech.com>
Subject: Re: Linux 2.6.30-rc8 [also: VIA Support]
Message-ID: <20090608054845.GA1377@ucw.cz>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <200906040958.46018.lkml@morethan.org> <alpine.LFD.2.01.0906040817090.4880@localhost.localdomain> <200906041037.50461.lkml@morethan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906041037.50461.lkml@morethan.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-06-04 10:37:46, Michael S. Zick wrote:
> On Thu June 4 2009, you wrote:
> > 
> > On Thu, 4 Jun 2009, Michael S. Zick wrote:
> > > 
> > > Well, that one isn't anything to brag about"
> > 
> > So what's the problem on that machine? Is the VIA C7-M (or some random 
> > device in it) just buggy and it eventually hangs, or what? Has _any_ 
> > kernel ever worked on that machine for longer than an hour or two?
> > 
> 
> It is not (directly) the C7-M - it might be the chipset CX700.
> 
> I have a small pool (5 or so actively reporting) testers -
> 
> On the Everex Cloudbook (C7-M/CX700) I have gotten a record
> of 4h45 minutes of up-time on some, locally patched, builds.
> The same is reported on other Everex Cloudbooks.
> 
> On the Sylvania gBook (also C7-M/CX700) the user reports
> 10s of minutes as their record up-time.
> 
> H.W. got hold of one of the companies demo-boards but I
> haven't heard back from him yet on his experiences.
> 
> On the HP-2133 (C7-M/CN896) the uptime is unknown - -
> only greater than 12 hours (it has never/ever deadlocked).

IIRC I did way longer tests than 12 hours on hp2133... it worked ok.

The other 'via from hell' machine would last overnight with cca 50%
probability.

								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
