Return-Path: <linux-kernel-owner+w=401wt.eu-S935753AbXGMHK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935753AbXGMHK5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 03:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760063AbXGMHKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 03:10:47 -0400
Received: from europa.telenet-ops.be ([195.130.137.75]:57942 "EHLO
	europa.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756098AbXGMHKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 03:10:46 -0400
Date: Fri, 13 Jul 2007 09:10:42 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Adrian Bunk <bunk@stusta.de>
Cc: Jens Axboe <jens.axboe@oracle.com>, Boaz Harrosh <bharrosh@panasas.com>,
       linux-kernel@vger.kernel.org, jgarzik@pobox.com, netdev@vger.kernel.org,
       zippel@linux-m68k.org, linux-m68k@vger.kernel.org
Subject: Re: [2.6 patch] more ACSI removal
In-Reply-To: <20070712234553.GR3492@stusta.de>
Message-ID: <Pine.LNX.4.64.0707130909170.8296@anakin>
References: <20070712234553.GR3492@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jul 2007, Adrian Bunk wrote:
> This patch removes some code that became dead code after the ATARI_ACSI 
> removal.

When was it removed? Nobody seems to have informed the m68k people...

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
