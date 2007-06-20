Return-Path: <linux-kernel-owner+w=401wt.eu-S1756070AbXFTTde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070AbXFTTde (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 15:33:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753124AbXFTTd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 15:33:26 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:58632
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbXFTTdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 15:33:25 -0400
Date: Wed, 20 Jun 2007 12:33:34 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Michael Poole <mdpoole@troilus.org>
cc: Tomas Neme <lacrymology@gmail.com>,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
In-Reply-To: <87wsxysaad.fsf@graviton.dyn.troilus.org>
Message-ID: <Pine.LNX.4.64.0706201232290.30395@asgard.lang.hm>
References: <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br>
 <alpine.LFD.0.98.0706181104570.14121@woody.linux-foundation.org>
 <ork5u1awtq.fsf@oliva.athome.lsd.ic.unicamp.br>
 <alpine.LFD.0.98.0706181232230.3593@woody.linux-foundation.org>
 <or7iq1atex.fsf@oliva.athome.lsd.ic.unicamp.br>
 <alpine.LFD.0.98.0706181344080.3593@woody.linux-foundation.org>
 <orhcp4algt.fsf@oliva.athome.lsd.ic.unicamp.br>
 <9a8748490706201034j43139301w5a18c172d688c724@mail.gmail.com>
 <2e6659dd0706201110x20fa5c28n5d6fc094e9f5c832@mail.gmail.com>
 <871wg6trnx.fsf@graviton.dyn.troilus.org> <2e6659dd0706201205i52e0b836oe642e2b442e425d7@mail.gmail.com>
 <87wsxysaad.fsf@graviton.dyn.troilus.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jun 2007, Michael Poole wrote:

> Tomas Neme writes:
>
>>> It's simple: they don't provide _complete_ source code.  They keep the
>>> source code for the part of their Linux kernel images that provides
>>> the functionality "runs on Tivo DVRs".  The GPL requires that
>>
>> http://en.wikipedia.org/wiki/Tivoization does not agree that this is
>> the problem but rather "TiVo circumvented this goal by making their
>> products run programs only if the program's digital signature matches
>> those authorised by the manufacturer of the TiVo."
>>
>> I'm downloading the sources now.. if they compile, then you're lying
>> to me, right? Moreover, if I compile them as is, and I can run them on
>> a TiVo (let's say upgrading the machine's kernel) then you're even
>> more so..
>
> Whether the sources you download from Tivo compile says very little.
> It certainly does not mean I am wrong.  I could give you binary for
> version A and sources for version B -- and the sources would compile.
>
> The kernel you build from the source code that Tivo distributes must
> be accepted by Tivo's hardware without making other modifications (to
> Tivo's hardware or bootloader).  If that is possible, I will retract
> what I said.  If it is not possible, they are omitting part of the
> program's source code:

no, saying that the result must be acceptable to other software (in this 
case the software running in the BIOS) is not part of the source code.

David Lang

>    A "computer program" is a set of statements or instructions to be
>    used directly or indirectly in a computer in order to bring about
>    a certain result.
>    -- US Code, Title 17, Section 101
>
> Michael Poole
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
