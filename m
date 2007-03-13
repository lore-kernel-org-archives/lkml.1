Return-Path: <linux-kernel-owner+w=401wt.eu-S1751629AbXCMNKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629AbXCMNKa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 09:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753252AbXCMNKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 09:10:30 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:5583 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbXCMNK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 09:10:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=R2nuEp/roULM3HqLC1o5gN8k6FRwB9aMzzg4yLFirooUQE9vcGjxr1bRjuKPEAXeWbejr3KVRDIRoex5yb8A5WhO2dnfS1dY9pEeZ7RxszbhZ5MSr1SuKPifoFO/l/WMeCCb8b3WJXaTeQeiLqnasOilpbv0bCB0As/6UxBgYS4=
Message-ID: <b14e81f00703130610r409290cex39e9bfa340f7dcbd@mail.gmail.com>
Date: Tue, 13 Mar 2007 09:10:27 -0400
From: "michael chang" <thenewme91@gmail.com>
To: "Willy Tarreau" <w@1wt.eu>
Subject: Re: [ck] Re: RSDL v0.30 cpu scheduler for mainline kernels
Cc: "Con Kolivas" <kernel@kolivas.org>, ck@vds.kolivas.org,
       "David Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
In-Reply-To: <20070313043206.GN943@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703121058.11966.kernel@kolivas.org>
	 <20070312.164652.108743760.davem@davemloft.net>
	 <200703131405.23482.kernel@kolivas.org> <20070313043206.GN943@1wt.eu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/13/07, Willy Tarreau <w@1wt.eu> wrote:
> On Tue, Mar 13, 2007 at 02:05:23PM +1100, Con Kolivas wrote:
> > On Tuesday 13 March 2007 10:46, David Miller wrote:
> > > From: Con Kolivas <kernel@kolivas.org>
> > > Date: Mon, 12 Mar 2007 10:58:11 +1100
> > >
> > > > http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc3-sched-rsdl-0.
> > > >30.patch
> > >
> > > FWIW, this boots and seems to work well on sparc64.  Tested
> > > on UP SunBlade1500 and 24cpu Niagara T1000.
> >
> > Very nice. Thanks for the feedback and I'm sorry you have to work with such
> > lousy hardware.
>
> BTW, I don't know if you say this as a joke, but those are not necessarily
> lousy hardware. Sun does lousy hardware when they put Sparcs in PCs (ultra5,
> ultra10, blade100). But their servers generally are nice with large memory
> busses and very scalable SMP architectures.
>

Considering that Con's general mass target for his -ck patchset is
single-cored x86/PC-compatable system such as a Celeron or a
single-core Athlon with 32-256 MB RAM, (disclaimer: this is an
assumption) I think he is being rather sarcastic. The only other way
to interpret this is that those machines are totally different from
what Con uses for development, and as such, maybe Con'd find them
"lousy" because if something DID go wrong, it would be less obvious
he'd figure it out right away. But I think it's a joke, guys. >.>

-- 
~Mike
 - Just the crazy copy cat.
