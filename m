Return-Path: <linux-kernel-owner+w=401wt.eu-S1754010AbYJBWSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbYJBWSf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 18:18:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752235AbYJBWS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 18:18:27 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:49115 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143AbYJBWS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 18:18:26 -0400
Date: Fri, 3 Oct 2008 00:20:03 +0200
From: Pavel Machek <pavel@suse.cz>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Steven Noonan <steven@uplinklabs.net>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: make MAINTAINERS slightly easier to search
Message-ID: <20081002222003.GA1857@elf.ucw.cz>
References: <20081002081428.GA2022@elf.ucw.cz> <f488382f0810020208u5761a84p5cac040503f55917@mail.gmail.com> <20081002085820.3568934d.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081002085820.3568934d.randy.dunlap@oracle.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-10-02 08:58:20, Randy Dunlap wrote:
> On Thu, 2 Oct 2008 02:08:20 -0700 Steven Noonan wrote:
> 
> > On Thu, Oct 2, 2008 at 1:14 AM, Pavel Machek <pavel@suse.cz> wrote:
> > > ...shall we add rule that subsystems will have "subsystem" in the name
> > > so that search does not list all the drivers, first?
> > >
> > > Signed-off-by: Pavel Machek <pavel@suse.cz>
> > > Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
> > >
> > >
> > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > index 3596d17..7345707 100644
> > > --- a/MAINTAINERS
> > > +++ b/MAINTAINERS
> > > @@ -3825,7 +3825,7 @@ L:        linux-kernel@vger.kernel.org
> > >  W:     http://tifmxx.berlios.de/
> > >  S:     Maintained
> > >
> > > -SOUND
> > > +SOUND SUBSYSTEM (ADVANCED LINUX SOUND SYSTEM, ALSA)
> > 
> > Advanced Linux Sound System = ALSS? How about switching it to
> > 'ADVANCED LINUX SOUND ARCHITECTURE', which fits the original acronym?
> > :)
> 
> Yes, concur.  Thanks.

Fixed in my tree. Who is maintainer of MAINTAINERS file? ;-).

								Pavel   

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
