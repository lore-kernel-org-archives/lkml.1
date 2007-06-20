Return-Path: <linux-kernel-owner+w=401wt.eu-S1758353AbXFTSzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758353AbXFTSzO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 14:55:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751087AbXFTSy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 14:54:58 -0400
Received: from terminus.zytor.com ([192.83.249.54]:51682 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbXFTSy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 14:54:57 -0400
Message-ID: <467977F7.2040506@zytor.com>
Date: Wed, 20 Jun 2007 11:54:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Michael Poole <mdpoole@troilus.org>
CC: Tomas Neme <lacrymology@gmail.com>,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br>	<alpine.LFD.0.98.0706171630150.14121@woody.linux-foundation.org>	<orlkeidryp.fsf@oliva.athome.lsd.ic.unicamp.br>	<alpine.LFD.0.98.0706181104570.14121@woody.linux-foundation.org>	<ork5u1awtq.fsf@oliva.athome.lsd.ic.unicamp.br>	<alpine.LFD.0.98.0706181232230.3593@woody.linux-foundation.org>	<or7iq1atex.fsf@oliva.athome.lsd.ic.unicamp.br>	<alpine.LFD.0.98.0706181344080.3593@woody.linux-foundation.org>	<orhcp4algt.fsf@oliva.athome.lsd.ic.unicamp.br>	<9a8748490706201034j43139301w5a18c172d688c724@mail.gmail.com>	<2e6659dd0706201110x20fa5c28n5d6fc094e9f5c832@mail.gmail.com> <871wg6trnx.fsf@graviton.dyn.troilus.org>
In-Reply-To: <871wg6trnx.fsf@graviton.dyn.troilus.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Poole wrote:
> Tomas Neme writes:
> 
>> I have been following this discussion for the last week or so, and
>> what I haven't been able to figure out is what the hell is the big
>> deal with TiVO doing whatever they want to with their stupid design.
>> They made a design, they build a machine, they sell it as is, and
>> provide source code for GPL'ed software... what's your problem?
> 
> It's simple: they don't provide _complete_ source code.  They keep the
> source code for the part of their Linux kernel images that provides
> the functionality "runs on Tivo DVRs".  The GPL requires that
> distributors of binary versions provide complete source code, not just
> the parts of source code that are convenient.
> 

If true, that's a clear violation of the GPLv2, but it's very different
from preventing the loading of modified images on their hardware (which
appears to be permitted by v2.)

	-hpa
