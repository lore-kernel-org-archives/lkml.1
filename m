Return-Path: <linux-kernel-owner+w=401wt.eu-S1754954AbXIQNf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954AbXIQNf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 09:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbXIQNfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 09:35:20 -0400
Received: from thunk.org ([69.25.196.29]:53797 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752786AbXIQNfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 09:35:19 -0400
Date: Mon, 17 Sep 2007 09:34:58 -0400
From: Theodore Tso <tytso@mit.edu>
To: Claudio Jeker <cjeker@diehard.n-r-g.com>, Adrian Bunk <bunk@kernel.org>,
       "Can E. Acar" <can.acar@pro-g.com.tr>, misc@openbsd.org,
       linux-kernel@vger.kernel.org, Daniel Hazelton <dhazelton@enter.net>,
       Eben Moglen <moglen@softwarefreedom.org>,
       Lawrence Lessig <lessig_from_web@pobox.com>,
       "Bradley M. Kuhn" <bkuhn@softwarefreedom.org>,
       Matt Norwood <norwood@softwarefreedom.org>
Subject: Re: Wasting our Freedom
Message-ID: <20070917133458.GA18360@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Claudio Jeker <cjeker@diehard.n-r-g.com>,
	Adrian Bunk <bunk@kernel.org>,
	"Can E. Acar" <can.acar@pro-g.com.tr>, misc@openbsd.org,
	linux-kernel@vger.kernel.org, Daniel Hazelton <dhazelton@enter.net>,
	Eben Moglen <moglen@softwarefreedom.org>,
	Lawrence Lessig <lessig_from_web@pobox.com>,
	"Bradley M. Kuhn" <bkuhn@softwarefreedom.org>,
	Matt Norwood <norwood@softwarefreedom.org>
References: <46ED7A8F.1020304@pro-g.com.tr> <20070916195909.GA18232@stusta.de> <20070916203926.GA17863@schlund.de> <20070916211208.GC5502@thunk.org> <20070917125554.GB13179@diehard.n-r-g.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070917125554.GB13179@diehard.n-r-g.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2007 at 02:55:54PM +0200, Claudio Jeker wrote:
> Wohoho! Slow here please. NDA have nothing to do with licenses and
> especially with copyright. NetApp even though their stuff is under their
> copyright and license does hopefully not modify the copyrights of imported
> BSD/ISC code. That would be against the law and I hope their leagal
> departement is smart enough to not do this mistake especially because the
> BSD license those not hinder them in any way.

Yes, NDA doesn't have anything to do with license and copyrights, and
I never said that NetApp is modfying a copyright; but they *are*
putting a proprietary copyright license on their modifications ---
which is exactly what the Linux wireless developers had proposed to do
(modulo mistakes about removing copyright notices and attribution
which have already been acknowledged and fixed), except instead of
using a proprietary license which means you'll never see the WAFL
sources (at least without signing an NDA and acknowledging their
proprietary copyright license over their changes), it will be under a
GPL license with which you have philosophical differences, but still
allows you to see the source.

> Finally most companies know they benefit from open source and give often
> the code changes most likely bugfixes to this imported code back.
> Unlike most GPL people we're happy with that especially we do not require
> them to release any of their own code. Sure their WAFL file system is cool
> but even in my wildest dreams I would not require them to publish their
> code just because the used some of my code.

So why are you complaining when people want to use some of your code
and put the combined work under a mixed BSD/GPL license?  You can't
use WAFL; you can't use the GPL'ed enhancements.  What's the
difference between those two cases?  Somehow a mixed BSD/Proprietary
license is better?

    	    	     	  	  	- Ted
