Return-Path: <linux-kernel-owner+w=401wt.eu-S1765391AbYAaSxO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765391AbYAaSxO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 13:53:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753991AbYAaSw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 13:52:58 -0500
Received: from monty.telenet-ops.be ([195.130.132.56]:38720 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795AbYAaSw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 13:52:57 -0500
Date: Thu, 31 Jan 2008 19:52:53 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Chris Wedgwood <cw@f00f.org>
cc: Adrian Bunk <bunk@kernel.org>, Arjan van de Ven <arjan@infradead.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Sam Ravnborg <sam@ravnborg.org>, davem@davemloft.net,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH] kill hotplug init/exit section annotations
In-Reply-To: <20080131183222.GA3412@puku.stupidest.org>
Message-ID: <Pine.LNX.4.64.0801311951450.22762@anakin>
References: <1201729295.3292.94.camel@localhost.localdomain>
 <20080130223219.GT29368@does.not.exist> <20080131074436.GA31966@uranus.ravnborg.org>
 <1201795051.3131.13.camel@localhost.localdomain> <20080131081120.27505dc0@laptopd505.fenrus.org>
 <20080131162141.GC19700@cs181133002.pp.htv.fi> <20080131090749.72781689@laptopd505.fenrus.org>
 <20080131171436.GG19700@cs181133002.pp.htv.fi> <20080131174526.GA2488@puku.stupidest.org>
 <20080131175543.GH19700@cs181133002.pp.htv.fi> <20080131183222.GA3412@puku.stupidest.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2008, Chris Wedgwood wrote:
> On Thu, Jan 31, 2008 at 07:55:43PM +0200, Adrian Bunk wrote:
> > Who was talking about laptops?
> 
> If laptops are mostly MP these days, then 'desktops' and 'servers'
> certainly are --- so pretty much everyone needs CPU hotplug.

<irony>
Thank you for giving an exhaustive list of classes of machines Linux runs on!
</irony>

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
