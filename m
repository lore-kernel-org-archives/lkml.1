Return-Path: <linux-kernel-owner+w=401wt.eu-S1757815AbYDXLM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757815AbYDXLM3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 07:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751933AbYDXLMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 07:12:20 -0400
Received: from harold.telenet-ops.be ([195.130.133.65]:60881 "EHLO
	harold.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbYDXLMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 07:12:19 -0400
Date: Thu, 24 Apr 2008 13:12:16 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: linux-next: Tree for April 24
In-Reply-To: <20080424193023.862cacd7.sfr@canb.auug.org.au>
Message-ID: <Pine.LNX.4.64.0804241311330.7107@anakin>
References: <20080424173626.bcd088e7.sfr@canb.auug.org.au>
 <Pine.LNX.4.64.0804240942300.10239@vixen.sonytel.be>
 <20080424193023.862cacd7.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Apr 2008, Stephen Rothwell wrote:
> On Thu, 24 Apr 2008 09:45:57 +0200 (CEST) Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> >
> > For m68k, I've added multi_defconfig, to build a kernel for all supported m68k
> > platforms, excluding Sun 3 (Sun 3 kernels are incompatible with all other m68k
> > platforms).
> > 
> > Hence if you would build multi_defconfig and sun3_defconfig, you cover all of
> > our platforms and drivers.
> 
> Done.  Thanks.

BTW, the results of today all seem to are unaccessible?

E.g. http://kisskb.ellerman.id.au/kisskb/buildresult/25192/

    Forbidden

    You don't have permission to access /kisskb/buildresult/25195/ on this
    server.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
