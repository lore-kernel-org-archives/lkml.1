Return-Path: <linux-kernel-owner+w=401wt.eu-S965032AbYBGVbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965032AbYBGVbl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:31:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755586AbYBGVbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 16:31:24 -0500
Received: from an-out-0708.google.com ([209.85.132.240]:40261 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935212AbYBGVbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 16:31:23 -0500
Message-ID: <fa686aa40802071331l16b40bacm4a7ca01a7219f1fb@mail.gmail.com>
Date: Thu, 7 Feb 2008 14:31:21 -0700
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: Xilinx: hwicap driver comments
Cc: jirislaby@gmail.com, stephen.neuendorffer@xilinx.com,
       linux-kernel@vger.kernel.org, paulus@samba.org, galak@gate.crashing.org,
       benh@kernel.crashing.org, torvalds@linux-foundation.org
In-Reply-To: <20080207132106.ec5ebf1d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47AB6552.7040503@gmail.com>
	 <20080207124203.147ce300.akpm@linux-foundation.org>
	 <fa686aa40802071254p172103f0w423f4591583ca3ef@mail.gmail.com>
	 <20080207132106.ec5ebf1d.akpm@linux-foundation.org>
X-Google-Sender-Auth: afbd728283273fe8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/7/08, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 7 Feb 2008 13:54:06 -0700
> "Grant Likely" <grant.likely@secretlab.ca> wrote:
> >
> > It went through my tree.  Paul pulls from Josh Boyer's tree for
> > powerpc-4xx patches, and Josh pulls from mine for xilinx virtex
> > powerpc 405 patches.
> >
> > My screw up, sorry I broke the rules.  What is the best way to resolve this?
> >
>
> Well I think we'd like to see the patches appear in Paul's tree well before
> the merge window if poss - that way they'll get a little bit of tyre-kicking
> and perhaps review via -mm.  Kamalesh and I (at least) do perform build-
> and runtime testing of powerpc.

Fair enough.  I can do so in the future.

> I would request that Paul copy myself and the main mailing list on pull
> requests.
>
> It seems wrong that the signoff trail for that patch didn't actually
> reflect reality - it should have had both Josh's and Paul's signoffs.  That
> would require that the changelog be altered during git->git transfers which
> I expect is just incompatible with the way git works (as far as I dimly
> understand it).
>
> It never hurts to send a patch to lkml even if you believe it isn't of
> general interest.  People will pass an idle eye across it, and things might
> get picked up, yielding improvements.  Plus more people know about its
> existence.  Probably this is more the case for something which resides
> under drivers/char/ than with something which resides in arch/powerpc/...

ok

Cheers,
g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
