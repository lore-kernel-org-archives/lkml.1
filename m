Return-Path: <linux-kernel-owner+w=401wt.eu-S1755495AbXIQJVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495AbXIQJVE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 05:21:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753331AbXIQJUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 05:20:52 -0400
Received: from mxintern.schlund.de ([212.227.126.201]:51797 "EHLO
	mxintern.schlund.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333AbXIQJUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 05:20:51 -0400
Date: Mon, 17 Sep 2007 11:20:19 +0200
From: Hannah Schroeter <hannah@schlund.de>
To: Adrian Bunk <bunk@kernel.org>
Cc: "Can E. Acar" <can.acar@pro-g.com.tr>, misc@openbsd.org,
       linux-kernel@vger.kernel.org, Daniel Hazelton <dhazelton@enter.net>,
       Eben Moglen <moglen@softwarefreedom.org>,
       Lawrence Lessig <lessig_from_web@pobox.com>,
       "Bradley M. Kuhn" <bkuhn@softwarefreedom.org>,
       Matt Norwood <norwood@softwarefreedom.org>
Subject: Re: Wasting our Freedom
Message-ID: <20070917092019.GC23002@schlund.de>
Mail-Followup-To: Adrian Bunk <bunk@kernel.org>,
	"Can E. Acar" <can.acar@pro-g.com.tr>, misc@openbsd.org,
	linux-kernel@vger.kernel.org, Daniel Hazelton <dhazelton@enter.net>,
	Eben Moglen <moglen@softwarefreedom.org>,
	Lawrence Lessig <lessig_from_web@pobox.com>,
	"Bradley M. Kuhn" <bkuhn@softwarefreedom.org>,
	Matt Norwood <norwood@softwarefreedom.org>
References: <46ED7A8F.1020304@pro-g.com.tr> <20070916195909.GA18232@stusta.de> <20070916203926.GA17863@schlund.de> <20070916211351.GB18232@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070916211351.GB18232@stusta.de>
Organization: Schlund + Partner AG
X-UI-Msg-Verification: a99afcdbc225d2ec870be9ffafa5cc86
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Sun, Sep 16, 2007 at 11:13:51PM +0200, Adrian Bunk wrote:
>On Sun, Sep 16, 2007 at 10:39:26PM +0200, Hannah Schroeter wrote:
>> On Sun, Sep 16, 2007 at 09:59:09PM +0200, Adrian Bunk wrote:
>> >On Sun, Sep 16, 2007 at 11:48:47AM -0700, Can E. Acar wrote:
>> >>...
>> >> First, these developers got questionable advice from senior Linux kernel
>> >> developers, and SLFC (which is closely related to FSF) in the process.

>> >The most questionable legal advice in this thread was by Theo de Raadt 
>> >who claimed choosing one licence for _dual-licenced_ code was illegal...

>> JFTR, I do *not* think that that assessment was questionable. Unless the
>> dual-licensing *explicitly* allows relicensing, relicensing is forbidden
>> by copyright law. The dual-licensing allows relicensing only if that's
>> *explicitly* stated, either in the statement offering the alternative, or
>> in one of the licenses.

>Dual licenced code by definition explicitely states that you can choose 
>the licence - otherwise it wouldn't be called dual-licenced.

It does state you can choose which terms to follow, indeed, of course.
But that does *not* imply removing the other terms altogether.

>> Neither GPL nor BSD/ISC allow relicensing in their well-known wordings.

>Noone said otherwise.

Removing the terms you choose not to follow in one instance *is*
relicensing.

>> If you think that's questionable, you should at least provide arguments
>> (and be ready to have your interpretation of the law and the licenses
>> tested before court).

>The licence in question was:

><--  snip  -->

>/*-
> * Copyright (c) 2002-2004 Sam Leffler, Errno Consulting
> * All rights reserved.
> *
> * Redistribution and use in source and binary forms, with or without
> * modification, are permitted provided that the following conditions
> * are met:
> * 1. Redistributions of source code must retain the above copyright
> *    notice, this list of conditions and the following disclaimer,
> *    without modification.
> * 2. Redistributions in binary form must reproduce at minimum a disclaimer
> *    similar to the "NO WARRANTY" disclaimer below ("Disclaimer") and any
> *    redistribution must be conditioned upon including a substantially
> *    similar Disclaimer requirement for further binary redistribution.
> * 3. Neither the names of the above-listed copyright holders nor the names
> *    of any contributors may be used to endorse or promote products derived
> *    from this software without specific prior written permission.
> *
> * Alternatively, this software may be distributed under the terms of the
> * GNU General Public License ("GPL") version 2 as published by the Free
> * Software Foundation.
> *
> * NO WARRANTY
> * ...

><--  snip  -->

>Theo claimed it would "break the law" [1] to choose the GPL for
>_this_ code. [2]

I re-read Theo's mail and still think the factual issues Theo states are
probably right. Value judgements like "you should give code back" (when
the license doesn't require it) are of course debatable (I tend to agree
with Theo there too, but it's no mandatory requirement of course).

Theo did *not* claim it breaks the law if you choose to obey by the
terms of the GPL in said dual-licensing. Theo *did* claim (in my eyes,
probably rightfully, and if it should ever be needed with respect to
code related to OpenBSD, I could try to give a few bucks in support of
having that claim legally verified) it's illegal to remove the license
you chose to not follow in one instance of redistribution. IIRC the
softwarefreedom.org people involved agreed with Theo's assessment in
that instance.

>[...]

>> But the BSDl does not allow you to relicense the original code, even
>> while it allows you to license copyrightable additions/modifications
>> under different terms with few restrictions.

>> However, you say "regarding ethics" and just go back to the legal level.
>> Is it really ethical, if you consider both Linux and OpenBSD part of one
>> OSS "community", to share things only in one direction? To take the
>> reverse engineered HAL but to not allow OpenBSD to take some
>> modifications back?

>Is it really ethical to use a licence that does not require to give 
>back, but then demand that something has to be given back?

IMO Theo didn't demand (as in try to enforce with legal pressure), but
state it'd be the *morally* right thing to do even if *not* legally
required (which isn't debated).

>Why don't you use a licence that expresses your intentions in a legally 
>binding way?

Because BSD people don't want to enforce it in every thinkable case. And
BSD people don't want to enforce it using as much text as the GPL needs.

But still I think it'd be the (morally!) right thing to do with respect
to the Atheros HAL even if *not* legally bound to do so.

>[...]

>But the truth is a bit less harsh:

>In reality most Linux kernel developers might not mind to give back - 
>and e.g. much of the ACPI code is BSD/GPL dual-licenced, and there 
>doesn't seem to be any problem with this.

*nods* Why not the same for the Atheros code?

>But Theo's wrong accusations regarding dual licenced code might not be
>the best way for starting a fruitful collaboration...

As said above, the accusations, if you read them correctly, were not
wrong, but spot on right. Unless someone proves that dual-licensing as
in "you may follow terms A or terms B at your choice" implicitly implies
being allowed to remove A altogether should you choose B.

>[...]

Kind regards,

Hannah.
