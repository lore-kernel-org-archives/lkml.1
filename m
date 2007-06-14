Return-Path: <linux-kernel-owner+w=401wt.eu-S1753461AbXFNTs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461AbXFNTs7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 15:48:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750698AbXFNTsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 15:48:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56315 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750695AbXFNTsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 15:48:50 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sean <seanlkml@sympatico.ca>, Adrian Bunk <bunk@stusta.de>,
       Valdis.Kletnieks@vt.edu, Daniel Hazelton <dhazelton@enter.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <466A3EC6.6030706@netone.net.tr>
	<200706132140.13490.dhazelton@enter.net>
	<20070614020827.GO3588@stusta.de>
	<200706132243.14651.dhazelton@enter.net>
	<20070614025640.GQ3588@stusta.de>
	<9578.1181793617@turing-police.cc.vt.edu>
	<20070614152034.GS3588@stusta.de>
	<alpine.LFD.0.98.0706140850470.14121@woody.linux-foundation.org>
	<20070614131409.9a5800dc.seanlkml@sympatico.ca>
	<alpine.LFD.0.98.0706141026150.14121@woody.linux-foundation.org>
	<orzm32cr8v.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706141153550.14121@woody.linux-foundation.org>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Thu, 14 Jun 2007 16:46:36 -0300
In-Reply-To: <alpine.LFD.0.98.0706141153550.14121@woody.linux-foundation.org> (Linus Torvalds's message of "Thu\, 14 Jun 2007 12\:03\:26 -0700 \(PDT\)")
Message-ID: <or1wgeco9v.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 14, 2007, Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, 14 Jun 2007, Alexandre Oliva wrote:
>> 
>> Is there anything other than TiVOization to justify these statements?

> Do you need anything else?

No, I'm quite happy that this is all.

> But if by the question you mean "would you think the GPLv3 is fine without 
> the new language in section 6 about the 'consumer devices'", then the 
> answer is that yes, I think that the current GPLv3 draft looks fine apart 
> from that.

Then would you consider relicensing Linux under GPLv3 + additional
permission for Tivoization?

>> Also, can you elaborate on what you mean about 'giving back in kind'?
>> (I suspect this is related with the tit-for-tat reasoning, that you've
>> failed to elaborate on before)

> I've *not* failed to elaborate on that before. Not at all. 

> Just google for

> 	torvalds tit-for-tat

> and you'll see a lot of my previous postings. Trying to claim that this is 
> somehow "new" is ludicrous.

I didn't.  But I've provided evidence that your prior musings on this
topic were wrong.  I wanted to give you an opportunity to review your
position under this new light.  I see you haven't changed it at all.

> Giving back "in kind" is obvious. I give you source code to do with as you 
> see fit. I just expect you to give back in kind: source code for me to do 
> with as I see fit, under the same license I gave you source code.

> How hard is that to accept?

Forgive me if I find this a bit hard, because that's *not* what the
GPL says.

Where do you think the GPL say that you get the source code back?

> I don't ask for money. I don't ask for sexual favors. I don't ask for 
> access to the hardware you design and sell. I just ask for the thing I 
> gave you: source code that I can use myself.

See, that's not what the license says.

The license says what you ask for is respect for other users'
freedoms.  Nothing whatsoever for you.  Only for users.

Freedom is in "in kind" payment, and it's not even a retribution, a
payback: it's payforward, or paysideways.

Do you understand why I find your reasoning hard to accept?

> And no, it's not a new concept. Neither is the fact that I've never agreed 
> with the FSF's agenda about "freedom" (as defined by _them_ - I have a 
> notion of "freedom" myself, and the FSF doesn't get to define it for me).

We don't have to agree on our individual definitions of freedom.  But
we're talking about a specific license that assigns a specific meaning
to the term "freedoms", and that's all this is about.

> I don't call Linux "Free Software". I haven't called it that for close to 
> ten years! Because I think the term "Open Source" is a lot better.

I can appreciate that you think it's better, but unfortunately it
appears to be playing a significant role in confusing your
interpretation of the GPL.  The GPL is not just about making the
source code visible, or even modifyable by others.  It's about
respecting others' freedoms.  No matter how badly you prefer Open
Source over Free Software, how badly you'd rather disregard the
freedoms in the spirit and in the legal terms of the GPL, you chose a
license designed to protect those freedoms, not only the ability to
see and modify source code.

>> The only thing the GPL demands is respect for others' freedoms, as in,
>> "I, the author, respect your freedoms, so you, the licensee, must
>> respect others' freedoms as well".  Is this the "in kind" you're
>> talking about?  Or are you mistaken about the actual meaning of even
>> GPLv2?

> I just ask that you give the software back in a usable form. That's
> all I ask for.

I'm afraid that's not what the GPLv2 says.  There's no provision
whatsoever about giving anything back.  Not in the spirit, not in the
legal terms.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
