Return-Path: <linux-kernel-owner+w=401wt.eu-S932548AbXFSC2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932548AbXFSC2q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 22:28:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761181AbXFSC2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 22:28:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53480 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760820AbXFSC2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 22:28:37 -0400
To: Johannes Stezenbach <js@linuxtv.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>, Bernd Schmidt <bernds_cb1@t-online.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Daniel Hazelton <dhazelton@enter.net>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <4673CA7C.5040207@t-online.de>
	<orlkejrg4o.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070616181902.GB21478@ftp.linux.org.uk>
	<or1wgbras9.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706161952280.14121@woody.linux-foundation.org>
	<orabuzkw0i.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706171157400.14121@woody.linux-foundation.org>
	<or3b0qgy8r.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070618155016.GA31892@linuxtv.org>
	<or645lcdg7.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070618232549.GA22170@linuxtv.org>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Mon, 18 Jun 2007 23:27:12 -0300
In-Reply-To: <20070618232549.GA22170@linuxtv.org> (Johannes Stezenbach's message of "Tue\, 19 Jun 2007 01\:25\:49 +0200")
Message-ID: <orr6o88yrj.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 18, 2007, Johannes Stezenbach <js@linuxtv.org> wrote:

> On Mon, Jun 18, 2007, Alexandre Oliva wrote:

>> People talk a lot about TiVo here, but do they the faintest idea of
>> how the conversations with TiVo are proceeding?  I thought so...

> Oh, if you know something we don't, could you please fill us in?

Honestly, I don't know either.  But I get an impression that there are
conversations underway.

> And who was it who coined the "Tivoization" term, thus putting
> TiVo into focus?

AFAIK TiVo invented the practice, did they not deserve the credit?

> Hm, you only talk about people who already use free software,
> but I tried to make you aware of the importance of
> _promoting_ free software, i.e. winning new people and
> companies for the free software idea.

Aah, I see.  Indeed, I'd missed that aspect.  Sorry about that.

My take on it is that bringing free loaders in doesn't help us much,
and bringing them in in a way that they don't learn the essential
aspects of the community will hurt the community in the long run.

So they must become aware that respecting others' freedoms is not only
the right thing to do, from a moral and ethical standpoint, but also
that this is precisely what enables our community to thrive, and to
enable everyone to get the best out of the software we cooperate to
develop.

> I think the majority of embedded devices still run proprietary
> RTOSes, and the majority of desktops still run Windows or Mac OS.
> Don't you want to change that?

Sure.  But getting those companies to adopt Free Software in a way
that turns it into non-Free Software doesn't change that in any way.

Of course we might get some additional contributions here and there,
but then more and more users would still be stuck, unable or limited
in the ways and incentives they have to participate in our community.
Permitting this is very short-sighted.  It might bring us apparent
advantages in the short run, but the more such disrespects there are,
the more there will be, and the fewer users will be able to become
developers.  In the end, this may kill the whole process, in a tragedy
of the commons.  In the article linked below, I argue this very point,
comparing how the demand for respecting users' freedoms is what keeps
the free-loaders away and makes the GPL the most cost-effective
license for software development, compared with permissive licenses
and non-Free licenses.  The very same arguments apply to a comparison
between a license that permits tivoization and one that doesn't,
because the latter is more likely to have more contributors to share
the load, and both equally reduce the likelihood of unmergeable forks.
http://www.lsd.ic.unicamp.br/~oliva/papers/free-software/BMind.pdf

> if you raise the entry barrier too high, they won't get started at
> all.

I acknowledge this argument, but I hear the same arguments against the
GPLv2, claiming the barrier is too high, and it's not from people who
believe that tivoization is already prohibited.

> They are aware of the trend towards Linux, but are afraid that the
> obligations of the GPL might be impractical for them.  Then they
> only have the choice to not use Linux, or to use "creative
> workarounds".

Or to respect users' freedoms, enabling/motivating those users to
become developers in our community.

> It's true that what these companies do might have little direct
> benefit for users buying their products, however the long term
> benefits of getting the people in these companies exposed to free
> software ideas, and in contact with the free software community, can
> only be positive

As long as they understand how the community works, be it from the
moral and ethical standpoint, be it from the pragmatic standpoint.  In
both cases, the end result is that they learn that, when they share
and cooperating, respecting users freedoms (enabling and providing
incentive for them to improve the software), everybody wins,
themselves included.

>> So you see, the picture of anti-tivozation is not as bleak as people
>> try to frame it.  In fact, it's not bleak at all.  If one out of 10,
>> maybe even 1 out of 100 vendors start respecting users' freedoms, when
>> faced with anti-tivoization provisions, the community will already win
>> big time, because each vendor is likely to have thousands of
>> customers, some of which will use the freedoms to serve the goals of
>> the community, in the very terms the community claims to care about.

> Does this multiplicator also apply to new companies
> which start using free software for their products?

Of course, even more so!  Then you win not only the contributions from
the user, but also from the company itself, which you didn't have
before.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
