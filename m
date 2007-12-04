Return-Path: <linux-kernel-owner+w=401wt.eu-S1753131AbXLDLBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131AbXLDLBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 06:01:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752355AbXLDLB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 06:01:26 -0500
Received: from hoboe1bl1.telenet-ops.be ([195.130.137.72]:42332 "EHLO
	hoboe1bl1.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276AbXLDLBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 06:01:24 -0500
Date: Tue, 4 Dec 2007 12:01:20 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org, Andy Whitcroft <apw@shadowen.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] SC26XX: New serial driver for SC2681 uarts
In-Reply-To: <20071204082534.GA5938@alpha.franken.de>
Message-ID: <Pine.LNX.4.64.0712041201080.22756@anakin>
References: <20071202194346.36E3FDE4C4@solo.franken.de>
 <20071203155317.772231f9.akpm@linux-foundation.org>
 <20071203155746.2dc4506d@laptopd505.fenrus.org> <20071204082534.GA5938@alpha.franken.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Dec 2007, Thomas Bogendoerfer wrote:
> On Mon, Dec 03, 2007 at 03:57:46PM -0800, Arjan van de Ven wrote:
> > > > +#define SC26XX_MAJOR         204
> > > > +#define SC26XX_MINOR_START   205
> > > > +#define SC26XX_NR            2
> > 
> > did lanana assign these numbers officially?
> 
> I tried to numbers several months ago and didn't get any response :-(

What about a dynamic number?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
