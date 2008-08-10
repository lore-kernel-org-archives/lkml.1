Return-Path: <linux-kernel-owner+w=401wt.eu-S1754363AbYHJU1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363AbYHJU1f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 16:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753487AbYHJU11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 16:27:27 -0400
Received: from harold.telenet-ops.be ([195.130.133.65]:58120 "EHLO
	harold.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475AbYHJU10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 16:27:26 -0400
Date: Sun, 10 Aug 2008 22:27:23 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Adrian Bunk <bunk@kernel.org>
cc: zippel@linux-m68k.org, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <david-b@pacbell.net>
Subject: Re: [9/17] m68k: use bcd2bin/bin2bcd
In-Reply-To: <20080808163448.GP14495@cs181140183.pp.htv.fi>
Message-ID: <Pine.LNX.4.64.0808102227020.10672@anakin>
References: <20080808163448.GP14495@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Aug 2008, Adrian Bunk wrote:
> This patch changes m68k to use the new bcd2bin/bin2bcd functions instead 
> of the obsolete BCD_TO_BIN/BIN_TO_BCD/BCD2BIN/BIN2BCD macros.
> 
> It also remove local bcd2bin/bin2bcd implementations
> in favor of the global ones.

Thanks, queued for 2.6.28.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
