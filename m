Return-Path: <linux-kernel-owner+w=401wt.eu-S933162AbXBEUPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933162AbXBEUPN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 15:15:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933160AbXBEUPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 15:15:13 -0500
Received: from europa.telenet-ops.be ([195.130.137.75]:60425 "EHLO
	europa.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933122AbXBEUPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 15:15:11 -0500
Date: Mon, 5 Feb 2007 21:15:07 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: linux-m68k@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2.6.20] arch M68K: user ARRAY_SIZE macro when appropriate
In-Reply-To: <20070205024341.GO18118@Ahmed>
Message-ID: <Pine.LNX.4.64.0702052114120.26055@anakin>
References: <20070205024341.GO18118@Ahmed>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Feb 2007, Ahmed S. Darwish wrote:
> A patch to use ARRAY_SIZE macro already defined in linux/kernel.h
> 
> Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
> ---
> Patch isn't compile checked since I have no m68k machine at hand.

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
