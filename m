Return-Path: <linux-kernel-owner+w=401wt.eu-S1752758AbYHKMOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758AbYHKMOy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 08:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbYHKMOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 08:14:46 -0400
Received: from wilson.telenet-ops.be ([195.130.132.42]:37545 "EHLO
	wilson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbYHKMOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 08:14:46 -0400
Date: Mon, 11 Aug 2008 14:14:43 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: JosephChan@via.com.tw
cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: RE: [PATCH 1/13 v2] viafb: viafb.modes, viafb.txt
In-Reply-To: <C80EF34A3D2E494DBAF9AC29C7AE4EB8078F49C6@exchtp03.taipei.via.com.tw>
Message-ID: <Pine.LNX.4.64.0808111413510.1500@anakin>
References: <C80EF34A3D2E494DBAF9AC29C7AE4EB8078F49C6@exchtp03.taipei.via.com.tw>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Joseph,

On Mon, 11 Aug 2008, JosephChan@via.com.tw wrote:
> > Please send an incremental patch.
> Do you mean that I can send a signle patch for fixing this issue. (v2 -> v3)

Yes.

> And the subject of this mail should be " [PATCH 1/13 v3] viafb: viafb.modes, viafb.txt"

Please also add `fix for' to the subject, so Andrew, sees its
incremental.

> -----Original Message-----
> From: geert@linux-m68k.org [mailto:geert@linux-m68k.org] 
> Sent: Friday, August 08, 2008 11:25 PM
> To: Joseph Chan
> Cc: linux-fbdev-devel@lists.sourceforge.net; linux-kernel@vger.kernel.org; akpm@linux-foundation.org
> Subject: RE: [PATCH 1/13 v2] viafb: viafb.modes, viafb.txt
> 
> On Fri, 8 Aug 2008, JosephChan@via.com.tw wrote:
> > It should be my carelessness. The check has been added in viafbdev.c already. 
> 
> OK.
> 
> > Do I need to re-send the patch for the documentation? Thanks for your reminding.
> 
> Please send an incremental patch. Andrew is good in folding ;-)
> 
> > On Fri, 8 Aug 2008, JosephChan@via.com.tw wrote:
> > > +    4. VX800 2D accelerator hasn't been supported in this driver yet. When
> > > +       using driver on VX800, one should add parameter "viafb_accel=0" to
> > > +       disable 2D accelerator.
> > 
> > Can't the driver detect this automatically, and disable the 2D 
> > accelerator when running on a VX800?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
