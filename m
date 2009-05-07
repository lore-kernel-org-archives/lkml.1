Return-Path: <linux-kernel-owner+w=401wt.eu-S1762481AbZEGVv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762481AbZEGVv0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 17:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751444AbZEGVvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 17:51:18 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39996 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbZEGVvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 17:51:17 -0400
Date: Thu, 7 May 2009 23:51:12 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Nigel Cunningham <nigel@tuxonice.net>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, tuxonice-devel@lists.tuxonice.net
Subject: Re: [RFC] TuxOnIce
Message-ID: <20090507215112.GC14611@elf.ucw.cz>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net> <20090507120948.GA1531@ucw.cz> <200905071942.54936.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905071942.54936.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-05-07 19:42:54, Rafael J. Wysocki wrote:
> On Thursday 07 May 2009, Pavel Machek wrote:
> > Hi!
> > 
> > > I'd like to submit TuxOnIce for review, with a view to seeking to get it
> > > merged, perhaps in 2.6.31 or .32 (depending upon what needs work before
> > > it can be merged) and the willingness of those who matter.
...
> > To summarise disadvantages:
> > 
> > - only core has 8000 LoC
> > - it does stuff that can be easily done in userspace
> >      (and that todays distros _do_ in userspace).
> > - it duplicates uswsusp functionality.
> > - compared to [u]swsusp, it received little testing
> 
> Actually, I see advantages of working together versus fighting flame wars.
> Please stop that, I'm not going to take part in it this time.

Ok, so what do you propose? Merging tuxonice into 2.6.32, resulting in
having swsusp,uswsusp *and* tuxonice to maintain? I hope not.

If we are talking about improving mainline to allow tuxonice
functionality... then yes, that sounds reasonable.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
