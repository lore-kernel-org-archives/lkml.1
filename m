Return-Path: <linux-kernel-owner+w=401wt.eu-S1761410AbXFTTxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761410AbXFTTxi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 15:53:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757525AbXFTTx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 15:53:29 -0400
Received: from 24-75-174-210-st.chvlva.adelphia.net ([24.75.174.210]:37959
	"EHLO sanosuke.troilus.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756162AbXFTTx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 15:53:28 -0400
To: david@lang.hm
Cc: Tomas Neme <lacrymology@gmail.com>,
       "Linux-Kernel\@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706181104570.14121@woody.linux-foundation.org>
	<ork5u1awtq.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706181232230.3593@woody.linux-foundation.org>
	<or7iq1atex.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706181344080.3593@woody.linux-foundation.org>
	<orhcp4algt.fsf@oliva.athome.lsd.ic.unicamp.br>
	<9a8748490706201034j43139301w5a18c172d688c724@mail.gmail.com>
	<2e6659dd0706201110x20fa5c28n5d6fc094e9f5c832@mail.gmail.com>
	<871wg6trnx.fsf@graviton.dyn.troilus.org>
	<2e6659dd0706201205i52e0b836oe642e2b442e425d7@mail.gmail.com>
	<87wsxysaad.fsf@graviton.dyn.troilus.org>
	<Pine.LNX.4.64.0706201232290.30395@asgard.lang.hm>
	<87odjas9f7.fsf@graviton.dyn.troilus.org>
	<Pine.LNX.4.64.0706201241060.30395@asgard.lang.hm>
From: Michael Poole <mdpoole@troilus.org>
Date: Wed, 20 Jun 2007 15:53:27 -0400
In-Reply-To: <Pine.LNX.4.64.0706201241060.30395@asgard.lang.hm> (david@lang.hm's message of "Wed\, 20 Jun 2007 12\:45\:24 -0700 \(PDT\)")
Message-ID: <87fy4ms8qw.fsf@graviton.dyn.troilus.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm writes:

> On Wed, 20 Jun 2007, Michael Poole wrote:
>
>> david@lang.hm writes:
>>
>>> no, saying that the result must be acceptable to other software (in
>>> this case the software running in the BIOS) is not part of the source
>>> code.
>>
>> Why not?  The digital signature is a statement (which translates
>> roughly to "Tivo approves this") to be used in a computer in order to
>> bring about a certain result.  That result is making it boot on the
>> PVR.  Source code simply means the original forms or inputs used to
>> generate machine-readable statements.
>
> but the signature isn't part of the kernel, and the code that checks
> the signature is completely independant. and finally the PVR functions
> are not part of the kernel (and not under the GPL in any case)
>
> if your argument was true then Oracle releasing a database appliance
> would require Oracle to give you the source to their database since
> it's part of 'bringing about a certain result' namely operating as a
> database server.

>From the kernel's COPYING file:

   NOTE! This copyright does *not* cover user programs that use kernel
 services by normal system calls - this is merely considered normal use
 of the kernel, and does *not* fall under the heading of "derived work".

See also the portion below.

> if your argument was true then releasing a GPL package for windows
> would require that the windows kernel source be released, after it
> it's nessasary for 'brining about a certain result' namely letting
> your code run.

>From section 3 of the GPL:

  However, as a special exception, the source code distributed need
  not include anything that is normally distributed (in either source
  or binary form) with the major components (compiler, kernel, and so
  on) of the operating system on which the executable runs, unless
  that component itself accompanies the executable.

> these are both nonsense results.

.. which is why they are recognized to be different.

Michael Poole
