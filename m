Return-Path: <linux-kernel-owner+w=401wt.eu-S934458AbZGQLap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934458AbZGQLap (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 07:30:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934450AbZGQLao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 07:30:44 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55469 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934448AbZGQLao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 07:30:44 -0400
Date: Fri, 17 Jul 2009 13:30:37 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <greg@kroah.com>
Cc: swetland@google.com, malchev@google.com,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: HTC Dream: qdsp support for staging
Message-ID: <20090717113037.GA2192@elf.ucw.cz>
References: <20090710083709.GA6418@elf.ucw.cz> <20090716230042.GB3609@kroah.com> <20090717010157.GA2002@elf.ucw.cz> <20090717011211.GA16704@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090717011211.GA16704@kroah.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-07-16 18:12:11, Greg KH wrote:
> On Fri, Jul 17, 2009 at 03:01:57AM +0200, Pavel Machek wrote:
> > On Thu 2009-07-16 16:00:42, Greg KH wrote:
> > > On Fri, Jul 10, 2009 at 10:37:10AM +0200, Pavel Machek wrote:
> > > > From: Iliyan Malchev <ibm@android.com>
> > > > 
> > > > QDSP code is neccessarry for communication with some hardware
> > > > components on HTC Dream, including camera hardware. It also drives DSP
> > > > coproccessor.
> > > > 
> > > > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> > > 
> > > Please don't compress patches :(
> > 
> > I had to -- in order to fit to lkml maillist limits.
> 
> I have no such limits :)

Ok, first 3 patches of resend should be on the way. One of them is
300K, so I hope it gets through.

> > Would it be possible to just apply the 3 patches, with me supplying
> > Kconfig/Makefile hooks in patch #4? That's sometimes used to
> > aid bisectability, and it would save me quite a lot of work (and
> > possible mistakes) that way.
> 
> Yes, that would be fine.  Care to send all 4, I've purged the old ones
> from my queue.

Thanks!
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
