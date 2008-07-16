Return-Path: <linux-kernel-owner+w=401wt.eu-S1760524AbYGPOsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760524AbYGPOsW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 10:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757520AbYGPOsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 10:48:05 -0400
Received: from nelson.telenet-ops.be ([195.130.133.66]:45699 "EHLO
	nelson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757457AbYGPOsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 10:48:04 -0400
Date: Wed, 16 Jul 2008 16:47:59 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
cc: linux-kernel@vger.kernel.org, Roman Zippel <zippel@linux-m68k.org>,
       linux-m68k@vger.kernel.org
Subject: Re: [PATCH] dio: use dio_match_device()
In-Reply-To: <20080705112217.GD17071@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0807161647430.7399@anakin>
References: <20080705112217.GD17071@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Jul 2008, Akinobu Mita wrote:
> dio_bus_match() can use dio_match_device().

Thanks, queued for 2.6.27

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
