Return-Path: <linux-kernel-owner+w=401wt.eu-S1755870AbYFZHTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870AbYFZHTU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 03:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753548AbYFZHTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 03:19:11 -0400
Received: from harold.telenet-ops.be ([195.130.133.65]:58983 "EHLO
	harold.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbYFZHTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 03:19:09 -0400
Date: Thu, 26 Jun 2008 09:19:07 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Adrian Bunk <bunk@kernel.org>
cc: zippel@linux-m68k.org, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: Re: [2.6 patch] remove the dead ATARI_SCC{,_DMA} options
In-Reply-To: <20080625162536.GH10285@cs181140183.pp.htv.fi>
Message-ID: <Pine.LNX.4.64.0806260918550.30924@anakin>
References: <20080625162536.GH10285@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jun 2008, Adrian Bunk wrote:
> It seems the driver was removed back in kernel 2.3 but the options were 
> forgotten.
> 
> Reported-by: Robert P. J. Day <rpjday@crashcourse.ca>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

(queued for 2.6.27)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
