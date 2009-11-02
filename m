Return-Path: <linux-kernel-owner+w=401wt.eu-S1753299AbZKBBSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299AbZKBBSq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 20:18:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752917AbZKBBSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 20:18:45 -0500
Received: from icculus.org ([67.106.77.212]:45648 "EHLO icculus.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752874AbZKBBSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 20:18:45 -0500
Date: Sun, 1 Nov 2009 20:17:50 -0500 (EST)
From: "Ryan C. Gordon" <icculus@icculus.org>
X-X-Sender: icculus@caridad.local
To: Rayson Ho <raysonlogin@gmail.com>
cc: =?ISO-8859-15?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
       linux-kernel@vger.kernel.org
Subject: Re: FatELF patches...
In-Reply-To: <73a01bf20911011408v5b6d335fj46c893a8e7d26ab4@mail.gmail.com>
Message-ID: <alpine.OSX.1.10.0911012017450.55434@caridad.local>
References: <alpine.DEB.2.00.0910271410510.16178@andre.icculuslan>  <1257103201.2865.6.camel@chumley> <yw1xy6mq0z2s.fsf@unicorn.mansr.com>  <alpine.OSX.1.10.0911011540400.53392@caridad.local>  <yw1xhbte0wx0.fsf@unicorn.mansr.com>
 <73a01bf20911011408v5b6d335fj46c893a8e7d26ab4@mail.gmail.com>
User-Agent: Alpine 1.10 (OSX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Adding code that might bring lawsuits to Linux developers,
> distributors, users is a BIG disadvantage.

I'm tracking down a lawyer to discuss the issue. I'm surprised there 
aren't a few hanging around here, honestly. I sent a request in to the 
SFLC, and if that doesn't pan out, I'll dig for coins in my car seat to 
pay a lawyer for a few hours of her time.

If it's a big deal, we'll figure out what to do from there. But let's not 
talk about the sky falling until we get to that point, please.

> "Given enough disc space, there's no reason you couldn't have one DVD
> .iso that installs an x86-64, x86, PowerPC, SPARC, and MIPS system"

I've had about a million people point out the boot loader thing. There's 
an x86/amd64 forest if you can see past the MIPS trees.

Still, I said there were different points that were more compelling for 
different individuals. I don't think this is the most compelling argument 
on that page, and I think there's a value in talking about theoretical 
benefits in addition to practical ones. Theoretical ones become practical 
the moment someone decides to roll out a company-internal distribution 
that works on all the workstations inside IBM or Google or whatever...even 
if Fedora would turn their nose up at the idea for a general-purpose 
release.

> IMO, the biggest problem users get is not with which hardware binary
> to download, but the incompatibly of different Linux kernels and glibc
> (the API/ABI).

These are concerns, too, but the kernel has been, in my experience, very 
good at binary compatibility with user space back as far as I can 
remember. glibc has had some painful progress, but since NPTL stabilized a 
long time ago, even this hasn't been bad at all.

Certainly one has to be careful--I would even use the word diligent--to 
maintain binary compatibility, but this was much more of a hurting for 
application developers a decade ago.

At least, that's been my experience.

--ryan.


