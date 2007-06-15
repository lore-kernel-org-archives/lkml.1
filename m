Return-Path: <linux-kernel-owner+w=401wt.eu-S1758961AbXFOXGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758961AbXFOXGq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 19:06:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758152AbXFOXGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 19:06:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37328 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758048AbXFOXGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 19:06:34 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Daniel Hazelton <dhazelton@enter.net>, Jesper Juhl <jesper.juhl@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Chris Friesen <cfriesen@nortel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <466A3EC6.6030706@netone.net.tr>
	<200706150308.20148.dhazelton@enter.net>
	<or1wgd102n.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706151715.55218.dhazelton@enter.net>
	<orfy4sx577.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070615215734.GB16371@elte.hu>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Fri, 15 Jun 2007 20:06:06 -0300
In-Reply-To: <20070615215734.GB16371@elte.hu> (Ingo Molnar's message of "Fri\, 15 Jun 2007 23\:57\:34 +0200")
Message-ID: <orabv0x1gh.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 15, 2007, Ingo Molnar <mingo@elte.hu> wrote:

> * Alexandre Oliva <aoliva@redhat.com> wrote:

>> >> You're again confusing legal terms with the intent.  The legal 
>> >> terms provide an indication of the intent, but the preamble, along 
>> >> with the free software definition it alludes to, do an even better 
>> >> job at that.

>> > And the preamble, not being part of the active portion of the 
>> > license, has absolutely *ZERO* bearing. Just as it is not the 
>> > *intent* of RMS, the FSF or *ANY* person (or legal entity) that had 
>> > a hand in crafting the GPLv2 or GPLv3 which is looked at when 
>> > determining the "intent" of the license. It is the intent of the 
>> > person and/or "legal entity" that has placed their work under said 
>> > license.

>> No disagreement.  You keep forgetting that I'm not here to say what 
>> Linux licensing means or doesn't mean.

> it is _you_ forgetting to read what you wrote just 1 mail ago above. 
> _Read_ it:

>   "The legal terms provide an indication of the intent, but the 
>    preamble, along with the free software definition it alludes to, do 
>    an even better job at that.".

You still don't seem to get the difference between spirit and letter,
and the difference between author of the license and licensor of the
software (I guess I wasn't clear about this).

When I talk about the spirit of the GPL, I'm talking about how its
authors designed it, how they described their motivations in the
preamble, in the Free Software Definition, in speeches explaining it,
etc.

When I talked about the meaning of the Linux licensing above, I'm
talking about the intent of the Linux authors when choosing the GPLv2.

They aren't necessarily the same.

Some Linux authors may have read the preamble and understood something
else.  Some may have simply skipped it, and focused in the legal
terms.  Some even understood the legal terms in different senses.  But
they have all agreed to license their code under GPLv2, whatever the
motivations each one of them had, and none of them has to match the
spirit of the GPL.


Now, the spirit of the GPL, the intent behind its design, is something
that may be entirely different.  And when I say that GPLv3 didn't
change the spirit of the GPL, I'm saying that from the perspective of
someone who understands very deeply the philosphy and motivations
behind it.


Please understand that these are two separate issues.  That the spirit
doesn't change, and that you don't share that spirit, or that you
didn't think that was the spirit, doesn't justify a claim that the
revision is changing the spirit.  It's not.  The spirit is, and has
always been, to defend users' freedoms (the 4 freedoms of the Free
Software definition), such that Free Software remains Free.


The fact that they can be different means that GPLv3 may not match the
goals you had when you chose GPLv2 for your contributions.  That's
unfortunate.  But this doesn't mean that GPLv3 is changing the spirit
of the GPL.  It's merely exposing that your goals don't match the
spirit of the GPL.  There's nothing wrong about this, GPLv2 is not a
bad license, just like the LGPLv2 is not a bad license.  They just
don't defend users' freedoms as well as GPLv3 will do.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
