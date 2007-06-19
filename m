Return-Path: <linux-kernel-owner+w=401wt.eu-S1760524AbXFSSU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760524AbXFSSU2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 14:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756918AbXFSSUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 14:20:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42547 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754030AbXFSSUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 14:20:14 -0400
To: Johannes Stezenbach <js@linuxtv.org>
Cc: Manu Abraham <abraham.manu@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>, Bernd Schmidt <bernds_cb1@t-online.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Daniel Hazelton <dhazelton@enter.net>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <alpine.LFD.0.98.0706161952280.14121@woody.linux-foundation.org>
	<orabuzkw0i.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706171157400.14121@woody.linux-foundation.org>
	<or3b0qgy8r.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070618155016.GA31892@linuxtv.org>
	<or645lcdg7.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070618232549.GA22170@linuxtv.org>
	<orr6o88yrj.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070619102817.GA24588@linuxtv.org> <4677B943.2060601@gmail.com>
	<20070619131053.GA25272@linuxtv.org>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Tue, 19 Jun 2007 15:19:02 -0300
In-Reply-To: <20070619131053.GA25272@linuxtv.org> (Johannes Stezenbach's message of "Tue\, 19 Jun 2007 15\:10\:53 +0200")
Message-ID: <ork5tz3izt.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 19, 2007, Johannes Stezenbach <js@linuxtv.org> wrote:

> (Where "free loaders" is a term introduced by Alexandre, not by me.)

It's actually from game theory.  Or something sufficiently mangled by
translation back and forth between English and Portuguese.  I think
the original is actually free riders.  My bad.

> The GPLv2 is a sufficient tool to defend free software
> against those that don't even grasp tit-for-tat.

It's not.  It doesn't even demand tit-for-tat.  This is a
*consequence* of the player understanding the spirit.  You can't
convince a person who doesn't believe in these ideas by pointing at
the license and saying "see, look, you're going to get contributions
back", because there are no such guarantees in the license.  And
that's how it should be.

> But it has to be their decision, IMHO it's wrong to force them.

Agreed.  Nobody is forcing anyone to use GPLed software.  Nobody is
forcing anyone to accept existing software under the GPLv3.

What every GPL stands to do is to defend the freedoms of users,
respecting the wishes of the authors expressed through the GPL that
the free software mains free.  Of course, authors who use the GPL for
other purposes may differ, but whether or not their claims that the
GPL advances their stances bear any resemblance with reality is
irrelevant.  This doesn't change what the GPL stands to do in any way,
it only changes what they expect the GPL to accomplish.  And whether
they're right or wrong in their expectations is besides the point.

> The GPLv3 tries to be a tool to defend against those that
> don't subscribe to the full Free Software Definition.

Not quite.  There appears to be an occurrence of a very common mistake
in your message.  Please forgive the long digression to try to dispell
it.

Many people think that the GPL is what the Free Software Definition is
all about, that Free Software somehow implies GPL, or some other
misunderstandings (to be read without a condescending tone ;-)

Free Software, and in particular the Free Software Definition, talks
about *respecting* users' freedoms.  There are many Free Software
licenses that accomplish this.

Some are very liberal in this sense.  They let you do whatever you
want with the code.  Even use it to disrespect users' freedoms.

Others are not so liberal.  They go *beyond* the Free Software
Definition, i.e., beyond merely respecting users' freedoms.  They
require agreement from recipients to not disrespect some users'
freedoms with the software, in some specific ways.  In addition to
*respecting* some freedoms, they *defend* some freedoms.

Others take the stance of defending all the four users' freedoms,
requiring agreement to not disrespect any users' freedoms with the
software, and to pass on this requirement, such that that software is
never used to disrespect users' freedoms.  These are called copyleft
licenses.

GPL is just one among all copyleft licenses, that are just some among
all licenses that defend some users' freedoms, that are just some
among all licenses that abide by the Free Software definition.  It
just so happens that it's the most widely-used Free Software license.


Think of it this way (if you understand open source but don't know
much of its history): the Open Source Definition is a rewritten
version of the Free Software Definition, intended to retain the same
meaning, but with a different focus.  That's why, as a general rule,
Free Software licenses are Open Source licenses, and Open Source
licenses are Free Software licenses.  AFAIK there is only one known
exception, and that's the open-source license Reciprocal Public
License, which goes to show that the Open Source definition is not
equivalent to the Free Software definition.

The differences are held to be in the motivations behind each of the
movements.  While Free Software takes the respect for the freedoms as
a moral issue (it's the right thing to do), Open Source takes it as a
pragmatic issue (it's better for everyone).  As luck would have it,
the pragmatic benefits are a consequence of the respect for users'
freedoms.

And more, pragmatists who see value in ensuring that the software
remains open source (which any OSI board member will insist that is
far more than merely keeping the source code open) are perceiving a
consequence of ensuring that the software remains Free, of defending
the freedoms of all users of the software.


Sure, there are other pragmatists that don't even care about the
software remaining open source, but only about the source code
remaining available.  We still have a lot in common with them, and we
can happily work together in projects under a number of licenses in
which our goals overlap.

It's not like everyone needs to move to GPLv3.  It's that there would
be moral and practical benefits for everyone if everyone did.  But if
those who don't want to don't, nothing is really lost.  It's just that
both Free Software and Open Source Software advocates who care not
only about abiding by their definitions, but also about defending and
advancing their goals (i.e., not willing to see their software being
used against their goals, and wanting to see more software like that),
don't get an advance in these defenses without the relicensing.

That's unfortunate, but it's not the end of the world.  Nobody can,
should or will force any copyright holder to adopt the GPLv3.  Any
claims to the contrary are emotional reactions to peer pressure, which
very clearly exists, since there are indeed numerous people who want
to advance their goals and would like to use the GPLv3 as a tool.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
