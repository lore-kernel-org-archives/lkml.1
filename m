Return-Path: <linux-kernel-owner+w=401wt.eu-S933919AbXHAPGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933919AbXHAPGW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 11:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932619AbXHAPGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 11:06:12 -0400
Received: from neon.samage.net ([85.17.153.66]:48752 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932852AbXHAPGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 11:06:11 -0400
Message-ID: <46850.81.207.0.53.1185980760.squirrel@secure.samage.net>
In-Reply-To: <46B09190.1070201@gmail.com>
References: <1185827130.26459.16.camel@xtower.fri>
    <6bffcb0e0707301549t6be3cd97y27726f5421bb7680@mail.gmail.com>
    <20070801064816.GC10134@elte.hu> <p73abtbpk2s.fsf@bingen.suse.de>
    <46B06815.10200@gmail.com>
    <46470.81.207.0.53.1185971693.squirrel@secure.samage.net>
    <46B0818F.10204@gmail.com>
    <49653.81.207.0.53.1185973640.squirrel@secure.samage.net>
    <46B08B95.2010405@kvitka.net> <46B09190.1070201@gmail.com>
Date: Wed, 1 Aug 2007 17:06:00 +0200 (CEST)
Subject: Re: Linux Kernel cfs scheduler and xorg kbd
From: "Indan Zupancic" <indan@nul.nu>
To: "Rene Herman" <rene.herman@gmail.com>
Cc: teresa@kvitka.net, "Andi Kleen" <andi@firstfloor.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       "CK Mailinglist" <ck@vds.kolivas.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -1.8
X-Scan-Signature: ba572e8a3bde05b4b19613c12a9e49fc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, August 1, 2007 15:58, Rene Herman wrote:
> On 08/01/2007 03:33 PM, <:::.. TeresaII ..:::> wrote:
>
>> Problem is, that i can't reproduce it after last reboot.
>> Can this be different on each reboot ? Any idea ?
>>
>> About another kernel: i only had -ck kernels since last year or more, i
>> can remember i had same behavier atleast 6 month ago, or maybe more. But
>> it wasn't that hard and it dissapiered self after some time.
>
> Hmm.
>
>> Now on first run of 2.6.22.1-cfs-v19.1 i got it again. And realy bad. It
>> was even very hard to write report mail.
>
> I notice by the way that you are also using Thunderbird 2.0 -- that was my
> own suspect; I had just switched from Thunderbird 1.5.
>
>> I did reboot, day after that it was back, but not that hard. And now
>> rebooted yesterday and cant reproduce it at all.
>
> I believe that at least for now we can safely remove this from any list of
> possible CFS regresssions. I'll sit on it and see what I can find out
> when/if my stuck delete happens again.
>
> Indan -- under what circumstances/programs did you experience what?

Different programs, different keys "stuck", so hard to tell. The amount
the pressed key is repeated differs too, from double to hundreds.

As an apparently separate problem my mouse warps once in a while too,
and that's not totally fixed yet, neither with that locking patch. Throw in
that two of my USB ports stopped working after a rare power outage, I
didn't totally trust my hardware any more, hence my initial reluctance to
report these problems.

We could have independent problems with more or less the same symptoms,
at least Teresa's problem seems much worse than ours, and if you and Ingo
only experience a stuck delete key, it might be something else.

Greetings,

Indan


