Return-Path: <linux-kernel-owner+w=401wt.eu-S1752029Ab0AAPSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab0AAPSU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 10:18:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883Ab0AAPST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 10:18:19 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50906 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab0AAPST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 10:18:19 -0500
Date: Fri, 1 Jan 2010 16:18:18 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Brian Swetland <swetland@google.com>, Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Iliyan Malchev <malchev@google.com>, linux-kernel@codeaurora.org,
       Greg KH <greg@kroah.com>
Subject: Re: tree with htc dream support
Message-ID: <20100101151818.GI3944@atrey.karlin.mff.cuni.cz>
References: <20091227093537.GD11737@elf.ucw.cz> <20091227201514.GA29174@elf.ucw.cz> <a55d774e0912271220p1d102b1dr398e0524c9386702@mail.gmail.com> <20091227203704.GK11737@elf.ucw.cz> <20091227211322.GB29174@elf.ucw.cz> <a55d774e0912271646m1b82687cy427083e64e91e323@mail.gmail.com> <20091227101824.GB1478@ucw.cz> <a55d774e0912281224y7360dfdbu8a251743026bdd28@mail.gmail.com> <20091228204848.GB1637@ucw.cz> <1262049913.17445.27.camel@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262049913.17445.27.camel@desktop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > >> > Switch smd code to the version in staging. Something to apply to
> > > >> > dream/ tree I'd say... and yes, it still works.
> > > >>
> > > >> I think we might want to consider leaving at least the core smd code
> > > >> under mach-msm.
> > > >
> > > > In the long run, I agree.
> > > >
> > > > In the short run... the code is staging quality, so it should be in
> > > > staging... and you'll not have to mainain so huge diff. (-20 kLoc).
> > > 
> > > The core smd stuff is really not that large.  The central smd.[ch] are
> > > about 1300 lines, and proc_comm.[ch] are about 400 lines.  Is it
> > > possible to get some review/feedback as to what's "staging quality"
> > > about this code so we can clean it up?  I'd rather just fix the
> > > issues
> > 
> > Just submit it to Daniel W., ccing rmk and l-a-k, and I'm sure you'll
> > get feedback.
> 
> I have it in my tree already .. My tree has some duplication over
> staging, for instance the rpc code is mostly in my tree, as is the smd
> code.

Do you expect you can just merge those for 2.6.34? That would be
great.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
