Return-Path: <linux-kernel-owner+w=401wt.eu-S1756822AbYHHPZH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822AbYHHPZH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 11:25:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752962AbYHHPY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 11:24:56 -0400
Received: from edna.telenet-ops.be ([195.130.132.58]:59058 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601AbYHHPYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 11:24:55 -0400
Date: Fri, 8 Aug 2008 17:24:53 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: JosephChan@via.com.tw
cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: RE: [PATCH 1/13 v2] viafb: viafb.modes, viafb.txt
In-Reply-To: <C80EF34A3D2E494DBAF9AC29C7AE4EB8285FD7@exchtp03.taipei.via.com.tw>
Message-ID: <Pine.LNX.4.64.0808081724210.420@anakin>
References: <C80EF34A3D2E494DBAF9AC29C7AE4EB8078B698D@exchtp03.taipei.via.com.tw>
 <Pine.LNX.4.64.0808081331130.420@anakin>
 <C80EF34A3D2E494DBAF9AC29C7AE4EB8285FD7@exchtp03.taipei.via.com.tw>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Aug 2008, JosephChan@via.com.tw wrote:
> It should be my carelessness. The check has been added in viafbdev.c already. 

OK.

> Do I need to re-send the patch for the documentation? Thanks for your reminding.

Please send an incremental patch. Andrew is good in folding ;-)

> From: Geert Uytterhoeven [mailto:geert@linux-m68k.org]
> Sent: Fri 8/8/2008 7:32 PM
> To: Joseph Chan
> Cc: linux-fbdev-devel@lists.sourceforge.net; linux-kernel@vger.kernel.org; akpm@linux-foundation.org
> Subject: Re: [PATCH 1/13 v2] viafb: viafb.modes, viafb.txt
> 
> 
> 
> On Fri, 8 Aug 2008, JosephChan@via.com.tw wrote:
> > +    4. VX800 2D accelerator hasn't been supported in this driver yet. When
> > +       using driver on VX800, one should add parameter "viafb_accel=0" to
> > +       disable 2D accelerator.
> 
> Can't the driver detect this automatically, and disable the 2D
> accelerator when running on a VX800?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
