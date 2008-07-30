Return-Path: <linux-kernel-owner+w=401wt.eu-S1761898AbYG3MTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761898AbYG3MTm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 08:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761541AbYG3MTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 08:19:23 -0400
Received: from harold.telenet-ops.be ([195.130.133.65]:33064 "EHLO
	harold.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761099AbYG3MTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 08:19:22 -0400
Date: Wed, 30 Jul 2008 14:19:18 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Karsten Keil <kkeil@suse.de>
cc: David Woodhouse <dwmw2@infradead.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, Andreas Eversberg <jolly@eversberg.eu>
Subject: Re: [PATCH] Remove broken hfcmulti driver.
In-Reply-To: <20080730095512.GA26361@pingi.kke.suse.de>
Message-ID: <Pine.LNX.4.64.0807301417170.3316@anakin>
References: <1217410068.27925.189.camel@pmac.infradead.org>
 <20080730095512.GA26361@pingi.kke.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2008, Karsten Keil wrote:
> > diff --git a/drivers/isdn/hardware/mISDN/Kconfig b/drivers/isdn/hardware/mISDN/Kconfig
> > index 1479348..f62dc87 100644
> > --- a/drivers/isdn/hardware/mISDN/Kconfig
> > +++ b/drivers/isdn/hardware/mISDN/Kconfig

    [snip]

Please don't quote big diffs when you don't comment on them.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
