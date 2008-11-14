Return-Path: <linux-kernel-owner+w=401wt.eu-S1752443AbYKNOQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443AbYKNOQh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 09:16:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750877AbYKNOQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 09:16:29 -0500
Received: from wilson.telenet-ops.be ([195.130.132.42]:41875 "EHLO
	wilson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbYKNOQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 09:16:28 -0500
Date: Fri, 14 Nov 2008 15:16:25 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Can you add the staging tree to -next?
In-Reply-To: <20081114185016.0097d4eb.sfr@canb.auug.org.au>
Message-ID: <Pine.LNX.4.64.0811141515470.26818@anakin>
References: <20081112235600.GA27554@kroah.com> <Pine.LNX.4.64.0811140825410.11953@anakin>
 <20081114185016.0097d4eb.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2008, Stephen Rothwell wrote:
> On Fri, 14 Nov 2008 08:42:48 +0100 (CET) Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> >
> > Apart from the patches you receive against -next, is there any other
> > advantage, giving staging is disabled?
> 
> Others compile linux-next with all sorts of configs, so we hopefully will
> see any build failures.  In fact, Greg might even built it with staging
> enabled :-)
> 
> We will also see any merge conflicts (though there probably won't be
> many).
> 
> I may also see if I can arrange for a build in each architecture with
> staging enabled in my infrastructure here, but it may take a little while.

I build them for m68k anyway, but due to timezone differences, you usually find
(and sometimes even fix ;-) the problems long before I notice them.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
