Return-Path: <linux-kernel-owner+w=401wt.eu-S1758961AbXFOVqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758961AbXFOVqh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 17:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758329AbXFOVqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 17:46:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46181 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756954AbXFOVqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 17:46:03 -0400
To: Daniel Hazelton <dhazelton@enter.net>
Cc: "Jesper Juhl" <jesper.juhl@gmail.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Chris Friesen" <cfriesen@nortel.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Greg KH" <greg@kroah.com>, "debian developer" <debiandev@gmail.com>,
       david@lang.hm, "Tarkan Erimer" <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <466A3EC6.6030706@netone.net.tr>
	<200706150308.20148.dhazelton@enter.net>
	<or1wgd102n.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706151715.55218.dhazelton@enter.net>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Fri, 15 Jun 2007 18:45:16 -0300
In-Reply-To: <200706151715.55218.dhazelton@enter.net> (Daniel Hazelton's message of "Fri\, 15 Jun 2007 17\:15\:54 -0400")
Message-ID: <orfy4sx577.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 15, 2007, Daniel Hazelton <dhazelton@enter.net> wrote:

> On Friday 15 June 2007 15:37:04 Alexandre Oliva wrote:
>> On Jun 15, 2007, Daniel Hazelton <dhazelton@enter.net> wrote:
>> > On Friday 15 June 2007 02:59:31 Jesper Juhl wrote:
>> >> it doesn't say anything about being able to run a compiled version
>> >> of that source on any specific hardware.
>> >
>> > And you are correct. It is also clear, thanks to language directly
>> > in the GPLv2 itself, that there is no "intent" of the license to
>> > cover that situation.
>> 
>> You're again confusing legal terms with the intent.  The legal terms
>> provide an indication of the intent, but the preamble, along with the
>> free software definition it alludes to, do an even better job at that.

> And the preamble, not being part of the active portion of the license, has 
> absolutely *ZERO* bearing. Just as it is not the *intent* of RMS, the FSF or 
> *ANY* person (or legal entity) that had a hand in crafting the GPLv2 or GPLv3 
> which is looked at when determining the "intent" of the license. It is the 
> intent of the person and/or "legal entity" that has placed their work under 
> said license.

No disagreement.  You keep forgetting that I'm not here to say what
Linux licensing means or doesn't mean.

I'm here to point out that GPLv3 does not break the spirit of the GPL.

> What is so hard to understand about that ?

/echo

> (Note that, since the "signing" of the TiVO kernel is part of the
> installation they *should* be including the script that does the
> signing. However, since the SHA1 key that is part of the signing
> process is *not* a "script" (even in the loosest possible definition
> of the term) they do not have to provide it.)

It's not build script, it's just regular source code, indeed.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
