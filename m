Return-Path: <linux-kernel-owner+w=401wt.eu-S1754774AbXIQNCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774AbXIQNCu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 09:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753471AbXIQNCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 09:02:39 -0400
Received: from diehard.n-r-g.com ([62.48.3.9]:19481 "EHLO diehard.n-r-g.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058AbXIQNCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 09:02:38 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Sep 2007 09:02:38 EDT
Date: Mon, 17 Sep 2007 14:55:54 +0200
From: Claudio Jeker <cjeker@diehard.n-r-g.com>
To: Theodore Tso <tytso@mit.edu>, Adrian Bunk <bunk@kernel.org>,
       "Can E. Acar" <can.acar@pro-g.com.tr>, misc@openbsd.org,
       linux-kernel@vger.kernel.org, Daniel Hazelton <dhazelton@enter.net>,
       Eben Moglen <moglen@softwarefreedom.org>,
       Lawrence Lessig <lessig_from_web@pobox.com>,
       "Bradley M. Kuhn" <bkuhn@softwarefreedom.org>,
       Matt Norwood <norwood@softwarefreedom.org>
Subject: Re: Wasting our Freedom
Message-ID: <20070917125554.GB13179@diehard.n-r-g.com>
Mail-Followup-To: Claudio Jeker <cjeker@diehard.n-r-g.com>,
	Theodore Tso <tytso@mit.edu>, Adrian Bunk <bunk@kernel.org>,
	"Can E. Acar" <can.acar@pro-g.com.tr>, misc@openbsd.org,
	linux-kernel@vger.kernel.org, Daniel Hazelton <dhazelton@enter.net>,
	Eben Moglen <moglen@softwarefreedom.org>,
	Lawrence Lessig <lessig_from_web@pobox.com>,
	"Bradley M. Kuhn" <bkuhn@softwarefreedom.org>,
	Matt Norwood <norwood@softwarefreedom.org>
References: <46ED7A8F.1020304@pro-g.com.tr> <20070916195909.GA18232@stusta.de> <20070916203926.GA17863@schlund.de> <20070916211208.GC5502@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070916211208.GC5502@thunk.org>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 16, 2007 at 05:12:08PM -0400, Theodore Tso wrote:
> On Sun, Sep 16, 2007 at 10:39:26PM +0200, Hannah Schroeter wrote:
> > >The most questionable legal advice in this thread was by Theo de Raadt 
> > >who claimed choosing one licence for _dual-licenced_ code was illegal...
> > 
> > JFTR, I do *not* think that that assessment was questionable. Unless the
> > dual-licensing *explicitly* allows relicensing, relicensing is forbidden
> > by copyright law. The dual-licensing allows relicensing only if that's
> > *explicitly* stated, either in the statement offering the alternative, or
> > in one of the licenses.
> > 
> > Neither GPL nor BSD/ISC allow relicensing in their well-known wordings.
> > 
> > If you think that's questionable, you should at least provide arguments
> > (and be ready to have your interpretation of the law and the licenses
> > tested before court).
> 
> Hannah,
> 
> What is going on whenever someone changes a code is that they make a
> "derivative work".  Whether or not you can even make a derivative
> work, and under what terms the derivitive work can be licensed, is
> strictly up to the license of the original.  For example, the BSD
> license says:
> 
>   Redistribution and use in source and binary forms, with or without
>   modification, are permitted provided that the following conditions
>   are met....
> 
> Note the "with or without modification".  This is what allows people
> to change BSD licensed code and redistribute said changes.  The
> conditions specified by the BSD license do not mention anything about
> licening terms --- just that if you meet these three conditions, you
> are allowed to redistribute them.  So for example, this is what allows
> Network Appliances to take BSD code, change it, and add a restrictive,
> proprietary copyright.
> 
> So for code which is single-licensed under a BSD license, someone can
> create a new derived work, and redistribute it under a more
> restrictive license --- either one as restrictive as NetApp's (where
> no one is allowed to get binary unless they are a NetApp customer, or
> source only after signing an NDA), or a GPL license.  It is not a
> relicencing, per se, since the original version of the file is still
> available under the original copyright; it is only the derived work
> which is under the more restrictive copyright.   
> 

Wohoho! Slow here please. NDA have nothing to do with licenses and
especially with copyright. NetApp even though their stuff is under their
copyright and license does hopefully not modify the copyrights of imported
BSD/ISC code. That would be against the law and I hope their leagal
departement is smart enough to not do this mistake especially because the
BSD license those not hinder them in any way.

Now comes the funny part, as the BSD code in NetApp is available
from public sources -- for example from OpenBSD -- it is actually not
covered by the NDA. NDAs can only cover information that is not
publicly available -- you can only forbit disclosure of information that
is secret in the first place.

Finally most companies know they benefit from open source and give often
the code changes most likely bugfixes to this imported code back.
Unlike most GPL people we're happy with that especially we do not require
them to release any of their own code. Sure their WAFL file system is cool
but even in my wildest dreams I would not require them to publish their
code just because the used some of my code.
-- 
:wq Claudio
