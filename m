Return-Path: <linux-kernel-owner+w=401wt.eu-S1757135AbYB1I4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757135AbYB1I4a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 03:56:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753741AbYB1I4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 03:56:19 -0500
Received: from winston.telenet-ops.be ([195.130.137.75]:55241 "EHLO
	winston.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbYB1I4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 03:56:18 -0500
Date: Thu, 28 Feb 2008 09:56:13 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: gorcunov@gmail.com
cc: linux-m68k@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       sam@ravnborg.org
Subject: Re: [RFC 03/10] m68k: vmlinux-std/sun3.lds.S cleanup - use PAGE_SIZE
 macro
In-Reply-To: <20080227210002.959847618@gmail.com>
Message-ID: <Pine.LNX.4.64.0802280955010.21581@anakin>
References: <20080227205831.150784453@gmail.com> <20080227210002.959847618@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2008, gorcunov@gmail.com wrote:
> This patch includes page.h header into liker script that
> allow us to use PAGE_SIZE macro instead of numeric constant
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Atari kernel built and booted on Aranym.
Sun-3 kernel built.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
