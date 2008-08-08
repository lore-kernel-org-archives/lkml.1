Return-Path: <linux-kernel-owner+w=401wt.eu-S1757808AbYHHLcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757808AbYHHLcc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 07:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754817AbYHHLcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 07:32:24 -0400
Received: from edna.telenet-ops.be ([195.130.132.58]:41359 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754666AbYHHLcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 07:32:24 -0400
Date: Fri, 8 Aug 2008 13:32:21 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: JosephChan@via.com.tw
cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 1/13 v2] viafb: viafb.modes, viafb.txt
In-Reply-To: <C80EF34A3D2E494DBAF9AC29C7AE4EB8078B698D@exchtp03.taipei.via.com.tw>
Message-ID: <Pine.LNX.4.64.0808081331130.420@anakin>
References: <C80EF34A3D2E494DBAF9AC29C7AE4EB8078B698D@exchtp03.taipei.via.com.tw>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Aug 2008, JosephChan@via.com.tw wrote:
> +    4. VX800 2D accelerator hasn't been supported in this driver yet. When
> +       using driver on VX800, one should add parameter "viafb_accel=0" to
> +       disable 2D accelerator.

Can't the driver detect this automatically, and disable the 2D
accelerator when running on a VX800?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
