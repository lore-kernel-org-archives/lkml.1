Return-Path: <linux-kernel-owner+w=401wt.eu-S1757926AbXHOH6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757926AbXHOH6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 03:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754267AbXHOH6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 03:58:11 -0400
Received: from hoboe1bl1.telenet-ops.be ([195.130.137.72]:36416 "EHLO
	hoboe1bl1.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbXHOH6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 03:58:09 -0400
Date: Wed, 15 Aug 2007 09:58:06 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, jgarzik@pobox.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] remove Documentation/networking/net-modules.txt
In-Reply-To: <20070814212604.GW18945@stusta.de>
Message-ID: <Pine.LNX.4.64.0708150957480.5158@anakin>
References: <20070814212604.GW18945@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Aug 2007, Adrian Bunk wrote:
> According to git, the only one who touched this file during the last
> 5 years was me when removing drivers...
> 
> modinfo offers less ancient information.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

For the m68k net drivers:

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
