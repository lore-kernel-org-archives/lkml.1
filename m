Return-Path: <linux-kernel-owner+w=401wt.eu-S1758151AbZGRKlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758151AbZGRKlh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 06:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758080AbZGRKlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 06:41:35 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41387 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758079AbZGRKlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 06:41:35 -0400
Date: Sat, 18 Jul 2009 12:41:26 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <greg@kroah.com>
Cc: swetland@google.com, malchev@google.com,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: HTC Dream for staging
Message-ID: <20090718104126.GC11381@elf.ucw.cz>
References: <20090710083709.GA6418@elf.ucw.cz> <20090716230042.GB3609@kroah.com> <20090717010157.GA2002@elf.ucw.cz> <20090717011211.GA16704@kroah.com> <20090717120657.GB2192@elf.ucw.cz> <20090717134620.GB1315@kroah.com> <20090717135743.GB19854@elf.ucw.cz> <20090717141440.GA16660@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090717141440.GA16660@kroah.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-07-17 07:14:40, Greg KH wrote:
> On Fri, Jul 17, 2009 at 03:57:43PM +0200, Pavel Machek wrote:
> > On Fri 2009-07-17 06:46:20, Greg KH wrote:
> > > On Fri, Jul 17, 2009 at 02:06:57PM +0200, Pavel Machek wrote:
> > > > Hi!
> > > > 
> > > > I guess I'm confused. I seem to recall that HTC Dream camera support
> > > > was marged into staging, but I can't see it in
> > > > http://git.kernel.org/?p=linux/kernel/git/gregkh/staging-2.6.git;a=summary
> > > > . Is my memory wrong am I looking at wrong tree?
> > > 
> > > I never merged it.
> > 
> > Ok, I guessed so. I sent it as patch #4, patch #5 adds makefile glue
> > for all that. They should be all in your inbox now.
> 
> I see 5 patches, but in the future, please number them to ensure that
> they are applied in the correct order.

Ok... And, sorry for all the trouble.

(BTW: I do not see the patches in the git tree, yet, and the tree is
labeled as "junk tree, please ignore". Should I just wait a bit? Or is
staging maintained outside of git? Or should the description be
updated?)

Thanks!
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
