Return-Path: <linux-kernel-owner+w=401wt.eu-S1755904AbXFMUMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904AbXFMUMU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 16:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752969AbXFMUMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 16:12:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45722 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbXFMUMC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 16:12:02 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       "david\@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <466A3EC6.6030706@netone.net.tr>
	<18026.16739.228277.938421@notabene.brown>
	<20070609071231.GL2649@lug-owl.de> <466BB9B0.5030908@netone.net.tr>
	<Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm>
	<466BCBBC.90305@netone.net.tr>
	<Pine.LNX.4.64.0706100301520.6675@asgard.lang.hm>
	<f24d23310706100355j3af7e12fq2e0e345402e48ca2@mail.gmail.com>
	<20070610160531.GA12179@kroah.com>
	<f24d23310706121107y2ef218a4wc1c8f9a52fc9bdd7@mail.gmail.com>
	<20070612184110.GB7980@kroah.com>
	<orir9smp3u.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706131223051.14121@woody.linux-foundation.org>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Wed, 13 Jun 2007 17:11:16 -0300
In-Reply-To: <alpine.LFD.0.98.0706131223051.14121@woody.linux-foundation.org> (Linus Torvalds's message of "Wed\, 13 Jun 2007 12\:25\:05 -0700 \(PDT\)")
Message-ID: <or7iq7mx7f.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 13, 2007, Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, 13 Jun 2007, Alexandre Oliva wrote:

>> On Jun 12, 2007, Greg KH <greg@kroah.com> wrote:
>> 
>> > (see previous long thread about v3 and why the kernel developers
>> > hate it, it all still applys to the final draft.)
>> 
>> You mean all the misunderstandings? ;-)

> I see the smiley, but I hate it how the FSF thinks others are morons and 
> cannot read or think for themselves.

Look, there was room for misunderstandings in earlier drafts of the
license.  Based on the public comments, the wording was improved.  I'd
like to think the issues that arose from misunderstandings of the
earlier drafts are no longer an issue.  Is it not so?

Keeping on making false claims about the license drafts can be one of
two things: misunderstandings, out of ambiguity in the text or
preconceptions, or ill intentions.  I'd rather believe it's the
former.

Now, of course you can look at the licenses and decide that you never
agreed with the spirit of the GPL in the first place, and that GPLv2
models better your intentions than GPLv3.

Your assessment about sharing of code between Linux and OpenSolaris
very much makes it seem like that the spirit of sharing, of letting
others run, study, modify and share the code as long as they respect
others' freedoms, has never been what moved you.  Rather, you seem to
perceive the GPL as demanding some form of payback, of contribution,
rather than the respect for others' freedoms that it requires.  In
fact, you said something along these lines yourself many months ago.

With this different frame of mind, it is not surprising at all that
you don't find GPLv3 a better license.  With different goals in mind,
reasonable people can reach different conclusions.  But claiming that
GPLv3 is changing the spirit of the license, or that it prohibits
certain kinds of software, is plain false.  In fact, the spirit has
always been described in its preamble, and it didn't change at all:
it's all about respecting others' freedoms.

Sure, this evokes a number of other nice behaviors in various players,
and it's clear to me that it's in these other nice behaviors that you
seek when you choose GPLv2.  There's nothing inherently wrong in that.

However, it seems to me that GPLv3 would do an even better job at
serving these goals than GPLv2, even if the holes v3 plugs that
enabled players to disrespect others' freedoms might steer away the
participants who are not willing to contribute, to really be part of
your community.  It's not like you lose much.

But the new defenses against disrespect for freedoms introduced in
GPLv3 may turn out to be very helpful, not only in protecting your
community from external threats, but also in strengthening
participation, as the benefits of participation outweight the
perceived costs of respecting others' freedoms.

It sure seems to me that trading some threats and non-contributors for
some more-committed participants is a good idea.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
