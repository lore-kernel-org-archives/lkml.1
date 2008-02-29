Return-Path: <linux-kernel-owner+w=401wt.eu-S933336AbYB2VAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933336AbYB2VAP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 16:00:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756269AbYB2U77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 15:59:59 -0500
Received: from c60.cesmail.net ([216.154.195.49]:12683 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755903AbYB2U77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 15:59:59 -0500
Subject: Re: [PATCH 2.6.25] module: allow ndiswrapper to use
	GPL-only	symbols
From: Pavel Roskin <proski@gnu.org>
To: David Newall <davidn@davidnewall.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Zan Lynx <zlynx@acm.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       Jon Masters <jcm@jonmasters.org>, Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <47C86DCA.5080706@davidnewall.com>
References: <1204236662.3612.6.camel@dv>
	 <alpine.LFD.1.00.0802281525170.5780@woody.linux-foundation.org>
	 <20080229012012.ajlsk4pow8wkkgss@webmail.spamcop.net>
	 <alpine.LFD.1.00.0802290807110.17889@woody.linux-foundation.org>
	 <1204304352.6767.21.camel@localhost>
	 <alpine.LFD.1.00.0802290906520.17889@woody.linux-foundation.org>
	 <1204305609.21719.16.camel@dv>
	 <alpine.LFD.1.00.0802290929590.17889@woody.linux-foundation.org>
	 <1204313978.2316.8.camel@dv> <20080229201711.GF3234@tuxdriver.com>
	 <47C86DCA.5080706@davidnewall.com>
Content-Type: text/plain
Date: Fri, 29 Feb 2008 15:59:57 -0500
Message-Id: <1204318797.2316.29.camel@dv>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-03-01 at 07:10 +1030, David Newall wrote:
> John W. Linville wrote:
> > On Fri, Feb 29, 2008 at 02:39:38PM -0500, Pavel Roskin wrote:
> >   
> >> I doubt ndiswrapper will ever be ported to the
> >> userspace.  It's much more likely that some other approach will be used.
> >>     
> >
> > Maybe it should be -- that might solve a lot of problems
> 
> Maybe it's time to rename it from "ndiswrapper" to "NdisWrapper".
> 
> How stupid do you have to be to not see that it will be fixed in any way
> necessary.

I'm quite sure that something like that is going to be the short term
fix.  Still, it would be nice to have a more long term solution, the one
that tries to resolve the tensions rather than hide them.  I'm not sure
it's possible, but just trying to negotiate could help find
understanding.

-- 
Regards,
Pavel Roskin
