Return-Path: <linux-kernel-owner+w=401wt.eu-S1759817AbXH1JcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759817AbXH1JcO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 05:32:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759338AbXH1Jbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 05:31:49 -0400
Received: from asia.telenet-ops.be ([195.130.137.74]:33086 "EHLO
	asia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759324AbXH1Jbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 05:31:47 -0400
Date: Tue, 28 Aug 2007 11:31:45 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] Remove final traces of long-deprecated "ramdisk" kernel
 parm.
In-Reply-To: <Pine.LNX.4.64.0708281130460.26867@anakin>
Message-ID: <Pine.LNX.4.64.0708281131360.26867@anakin>
References: <Pine.LNX.4.64.0708280233390.19913@localhost.localdomain>
 <Pine.LNX.4.64.0708281130460.26867@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Aug 2007, Geert Uytterhoeven wrote:
> On Tue, 28 Aug 2007, Robert P. J. Day wrote:
> > Since the "ramdisk" kernel parameter has been officially deprecated
> > since at least 2.6.18, might as well finally get rid of it.
> > 
> > Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> 
> m68k part is
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Oops, I meant
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
