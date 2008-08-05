Return-Path: <linux-kernel-owner+w=401wt.eu-S1760779AbYHERQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760779AbYHERQk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 13:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757716AbYHERQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 13:16:29 -0400
Received: from winston.telenet-ops.be ([195.130.137.75]:47805 "EHLO
	winston.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620AbYHERQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 13:16:28 -0400
Date: Tue, 5 Aug 2008 19:16:25 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Sam Ravnborg <sam@ravnborg.org>, linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: kbuild now support arch/$ARCH/include - time for ARCHs to convert
In-Reply-To: <200808051418.05324.rusty@rustcorp.com.au>
Message-ID: <Pine.LNX.4.64.0808051916010.28683@anakin>
References: <20080728200500.GA14284@uranus.ravnborg.org>
 <200808051418.05324.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Aug 2008, Rusty Russell wrote:
> On Tuesday 29 July 2008 06:05:00 Sam Ravnborg wrote:
> > is is suggested to move the arch specific files under arch/
> > and for the header files this is arch/$ARCH/include.
> 
> Well, it would have been nice to take the opportunity to separate user-visible 
> header files and non-user-visible files.  We could have left the user-visible 
> ones in place, for example: diffstat would then show when you were frobbing 
> the userspace interface.
> 
> But I'm guessing noone wants even more marginal-value churn right now.
> Rusty.

That actually sounds like a good idea to me!
Can we do the same with the <linux/*.h> ones?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
