Return-Path: <linux-kernel-owner+w=401wt.eu-S1758627AbXFTUIM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758627AbXFTUIM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 16:08:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759055AbXFTUH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 16:07:59 -0400
Received: from 24-75-174-210-st.chvlva.adelphia.net ([24.75.174.210]:34010
	"EHLO sanosuke.troilus.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758512AbXFTUH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 16:07:58 -0400
To: david@lang.hm
Cc: "H. Peter Anvin" <hpa@zytor.com>, Tomas Neme <lacrymology@gmail.com>,
       "Linux-Kernel\@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706171630150.14121@woody.linux-foundation.org>
	<orlkeidryp.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706181104570.14121@woody.linux-foundation.org>
	<ork5u1awtq.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706181232230.3593@woody.linux-foundation.org>
	<or7iq1atex.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706181344080.3593@woody.linux-foundation.org>
	<orhcp4algt.fsf@oliva.athome.lsd.ic.unicamp.br>
	<9a8748490706201034j43139301w5a18c172d688c724@mail.gmail.com>
	<2e6659dd0706201110x20fa5c28n5d6fc094e9f5c832@mail.gmail.com>
	<871wg6trnx.fsf@graviton.dyn.troilus.org> <467977F7.2040506@zytor.com>
	<Pine.LNX.4.64.0706201200550.30395@asgard.lang.hm>
	<87sl8ms9z5.fsf@graviton.dyn.troilus.org>
	<Pine.LNX.4.64.0706201234230.30395@asgard.lang.hm>
	<87k5tys8w5.fsf@graviton.dyn.troilus.org>
	<Pine.LNX.4.64.0706201253120.30395@asgard.lang.hm>
From: Michael Poole <mdpoole@troilus.org>
Date: Wed, 20 Jun 2007 16:07:57 -0400
In-Reply-To: <Pine.LNX.4.64.0706201253120.30395@asgard.lang.hm> (david@lang.hm's message of "Wed\, 20 Jun 2007 12\:58\:55 -0700 \(PDT\)")
Message-ID: <87645is82q.fsf@graviton.dyn.troilus.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm writes:

> On Wed, 20 Jun 2007, Michael Poole wrote:
>
>> Please retract that claim.  I have said no such thing, and have
>> avoided saying anything that I thought might be misconstrued in that
>> direction.
>>
>> To be absolutely clear: My complaints with Tivo as a hardware or BIOS
>> vendor are moral and pragmatic, not legal.  My complaint with Tivo as
>> a distributor of Linux is what hinges on legal issues.
>
> but if the GPL doesn't control the BIOS how in the world are you
> saying that the fact that the GPL covers the kernel makes what the
> BIOS does wrong (even if the kernel was covered by GPLv3)?

I do not say that the BIOS is doing anything (legally) wrong.  The
wrong act is distributing the binary kernel image without distributing
complete source code for it.

>>> that's a seperate body of code that is in no way derived from the
>>> linux kernel (even the anti-tampering functions would work equally
>>> well with other Operating systems and are in no way linux
>>> specific). it's no even loaded on the same media (the BIOS is in
>>> flash/rom on the botherboard, the OS is on the hard drive)
>>>
>>> and note that the software that is checked to make sure that it hasn't
>>> been changed includes much more then the kernel. it checks the kernel
>>> and the initrd.
>>
>> Not legally relevant.
>
> I disagree. it's very relevant if your argument is that becouse the
> checksum if a checksum of the kernel that the license for the kernel
> somehow controlls what can be done with it.

To the extent that it is relevant, it strengthens the argument against
Tivo: they are tying together many works of authorship, including some
GPLed works, in a way that makes them effectively inseparable.  This
is beyond "mere aggregation" on a distribution medium, and tends to
implicate *all* parts of the whole as GPL encumbered.

Michael Poole
