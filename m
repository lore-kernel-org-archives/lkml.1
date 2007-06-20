Return-Path: <linux-kernel-owner+w=401wt.eu-S1760610AbXFTTu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760610AbXFTTu1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 15:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756216AbXFTTuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 15:50:20 -0400
Received: from 24-75-174-210-st.chvlva.adelphia.net ([24.75.174.210]:50759
	"EHLO sanosuke.troilus.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756269AbXFTTuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 15:50:19 -0400
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
From: Michael Poole <mdpoole@troilus.org>
Date: Wed, 20 Jun 2007 15:50:18 -0400
In-Reply-To: <Pine.LNX.4.64.0706201234230.30395@asgard.lang.hm> (david@lang.hm's message of "Wed\, 20 Jun 2007 12\:40\:20 -0700 \(PDT\)")
Message-ID: <87k5tys8w5.fsf@graviton.dyn.troilus.org>
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
>>> this is very much NOT true. if you take the source the provide you can
>>> compile a kernel that will run on the tivo, the only thing you have to
>>> do (on some models) is to change the bios to skip the step that checks
>>> if the kernel has been tampered with.
>>
>> If we are opining whether Tivo provided complete source code for their
>> Linux kernel images, the requirement to change non-GPLed software as a
>> condition to exercise GPL-protected rights speaks for itself.
>
> no, the GPL protected rights don't say anything about the hardware the
> system runs on.
>
> you are saying that the GPL now controls what the BIOS software is
> allowed to do or not allowed to do.

Please retract that claim.  I have said no such thing, and have
avoided saying anything that I thought might be misconstrued in that
direction.

To be absolutely clear: My complaints with Tivo as a hardware or BIOS
vendor are moral and pragmatic, not legal.  My complaint with Tivo as
a distributor of Linux is what hinges on legal issues.

> that's a seperate body of code that is in no way derived from the
> linux kernel (even the anti-tampering functions would work equally
> well with other Operating systems and are in no way linux
> specific). it's no even loaded on the same media (the BIOS is in
> flash/rom on the botherboard, the OS is on the hard drive)
>
> and note that the software that is checked to make sure that it hasn't
> been changed includes much more then the kernel. it checks the kernel
> and the initrd.

Not legally relevant.

>> Out of curiosity, what do you have to do on models besides those?  Are
>> newer models more or less restrictive in what they run?  If newer
>> models are more restrictive, I think that also speaks to whether Tivo
>> thinks it is conveying complete source code.
>
> newer models do tend to be more restrictive, but they also tend to
> connect to more propriatary networks (satellite or cable)

What they connect to is also not relevant.  That imples that because a
vendor has been issued or licensed patents, they are not obliged to
follow the GPL -- that the vendor has other obligations that supercede
the GPL's license claims.  GPL section 7 addresses that situation.

Michael Poole
