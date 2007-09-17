Return-Path: <linux-kernel-owner+w=401wt.eu-S1758740AbXIQTY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758740AbXIQTY7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 15:24:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758528AbXIQTXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 15:23:45 -0400
Received: from diehard.n-r-g.com ([62.48.3.9]:28559 "EHLO diehard.n-r-g.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758665AbXIQTXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 15:23:44 -0400
Date: Mon, 17 Sep 2007 21:23:41 +0200
From: Claudio Jeker <cjeker@diehard.n-r-g.com>
To: Theodore Tso <tytso@mit.edu>, Adrian Bunk <bunk@kernel.org>,
       "Can E. Acar" <can.acar@pro-g.com.tr>, misc@openbsd.org,
       linux-kernel@vger.kernel.org, Daniel Hazelton <dhazelton@enter.net>,
       Eben Moglen <moglen@softwarefreedom.org>,
       Lawrence Lessig <lessig_from_web@pobox.com>,
       "Bradley M. Kuhn" <bkuhn@softwarefreedom.org>,
       Matt Norwood <norwood@softwarefreedom.org>
Subject: Re: Wasting our Freedom
Message-ID: <20070917192341.GB30119@diehard.n-r-g.com>
Mail-Followup-To: Claudio Jeker <cjeker@diehard.n-r-g.com>,
	Theodore Tso <tytso@mit.edu>, Adrian Bunk <bunk@kernel.org>,
	"Can E. Acar" <can.acar@pro-g.com.tr>, misc@openbsd.org,
	linux-kernel@vger.kernel.org, Daniel Hazelton <dhazelton@enter.net>,
	Eben Moglen <moglen@softwarefreedom.org>,
	Lawrence Lessig <lessig_from_web@pobox.com>,
	"Bradley M. Kuhn" <bkuhn@softwarefreedom.org>,
	Matt Norwood <norwood@softwarefreedom.org>
References: <46ED7A8F.1020304@pro-g.com.tr> <20070916195909.GA18232@stusta.de> <20070916203926.GA17863@schlund.de> <20070916211208.GC5502@thunk.org> <20070917125554.GB13179@diehard.n-r-g.com> <20070917133458.GA18360@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070917133458.GA18360@thunk.org>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2007 at 09:34:58AM -0400, Theodore Tso wrote:
> On Mon, Sep 17, 2007 at 02:55:54PM +0200, Claudio Jeker wrote:
> > Wohoho! Slow here please. NDA have nothing to do with licenses and
> > especially with copyright. NetApp even though their stuff is under their
> > copyright and license does hopefully not modify the copyrights of imported
> > BSD/ISC code. That would be against the law and I hope their leagal
> > departement is smart enough to not do this mistake especially because the
> > BSD license those not hinder them in any way.
> 
> Yes, NDA doesn't have anything to do with license and copyrights, and
> I never said that NetApp is modfying a copyright; but they *are*
> putting a proprietary copyright license on their modifications ---
> which is exactly what the Linux wireless developers had proposed to do
> (modulo mistakes about removing copyright notices and attribution
> which have already been acknowledged and fixed), except instead of
> using a proprietary license which means you'll never see the WAFL
> sources (at least without signing an NDA and acknowledging their
> proprietary copyright license over their changes), it will be under a
> GPL license with which you have philosophical differences, but still
> allows you to see the source.
> 

You assume a lot about what NetApp did. While they can use BSD licensed
code in their system without any issue they can not slam a new copyright
on that code unless the changes create a derivative work.
If you just do an adaption of the code you have no right to add an
additional copyright. You need to make substantial extensions to the
original work. Now adapting code to make it run under linux is in my
opinion not a substantial work. It can be compared to translate a book to
a different language -- which neither allows you to assign copyright on
the result.
I very much doubt that WAFL is a simple adaption of UFS/FFS. So it should
be clear that this work has it's own copyright. Maybe some parts of their
code is using BSD work that they just adapted. On that code they can not
add an additional copyright as the modifications are not substantial
enough.

> > Finally most companies know they benefit from open source and give often
> > the code changes most likely bugfixes to this imported code back.
> > Unlike most GPL people we're happy with that especially we do not require
> > them to release any of their own code. Sure their WAFL file system is cool
> > but even in my wildest dreams I would not require them to publish their
> > code just because the used some of my code.
> 
> So why are you complaining when people want to use some of your code
> and put the combined work under a mixed BSD/GPL license?  You can't
> use WAFL; you can't use the GPL'ed enhancements.  What's the
> difference between those two cases?  Somehow a mixed BSD/Proprietary
> license is better?
> 

Because they put their copyright plus license on code that they barely
modified. If they would have added substantial work into the OpenHAL code
and by doing that creating something new I would not say much.

All the comercial code I have ever seen did not do this stunt of adding a
new copyright and license to barely modified files. Perhaps the "evil"
companies have more ethics or better understanding of copyright.

-- 
:wq Claudio
