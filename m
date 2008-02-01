Return-Path: <linux-kernel-owner+w=401wt.eu-S1761581AbYBAVWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761581AbYBAVWe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 16:22:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761295AbYBAVWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 16:22:22 -0500
Received: from monty.telenet-ops.be ([195.130.132.56]:33764 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761012AbYBAVWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 16:22:20 -0500
X-Greylist: delayed 95363 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Feb 2008 16:22:19 EST
Date: Fri, 1 Feb 2008 22:22:13 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux arch <linux-arch@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Are Section mismatches out of control?
In-Reply-To: <20080201134041.GC13349@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0802012221400.28712@anakin>
References: <20080201104718.GA11717@uranus.ravnborg.org>
 <20080201030329.9b760777.akpm@linux-foundation.org> <1201864894.23523.117.camel@brick>
 <Pine.LNX.4.64.0802011325080.18111@anakin> <20080201134041.GC13349@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Feb 2008, Sam Ravnborg wrote:
> On Fri, Feb 01, 2008 at 02:30:44PM +0100, Geert Uytterhoeven wrote:
> > BTW, on m68k I get ca. 160 of them. Most seem to originate in
> > drivers/isdn/. Doesn't look unsurmountable compared to the number of
> > other compile warnings fixed during the last few years ;-)
> 
> Can you try the patchset I will post in a minute.
> Would be nice to know if you see additional warnings as I got
> isdn clean here with x86 - 64 bit - allyesconfig.

Sure. Where can I find that patchset? I didn't see it on lkml so far,
except for the [0/5] email.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
