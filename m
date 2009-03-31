Return-Path: <linux-kernel-owner+w=401wt.eu-S1760530AbZCaAzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760530AbZCaAzl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 20:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754880AbZCaAzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 20:55:32 -0400
Received: from mail.vyatta.com ([76.74.103.46]:60339 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752251AbZCaAzc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 20:55:32 -0400
Date: Mon, 30 Mar 2009 17:55:24 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Rob Landley <rob@landley.net>,
       Phillip Lougher <phillip@lougher.demon.co.uk>,
       linux-kernel@vger.kernel.org, squashfs-devel@lists.sourceforge.net
Subject: Re: Squashfs 4.0 tools
Message-ID: <20090330175524.4e8f802e@nehalam>
In-Reply-To: <10f740e80903290202h1f36b370ga39721536d52a90@mail.gmail.com>
References: <20090323180808.2c2ef1a7@nehalam>
	<49C847C6.4030904@lougher.demon.co.uk>
	<200903281727.52929.rob@landley.net>
	<10f740e80903290202h1f36b370ga39721536d52a90@mail.gmail.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Mar 2009 11:02:19 +0200
Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> On Sun, Mar 29, 2009 at 00:27, Rob Landley <rob@landley.net> wrote:
> > P.S I notice a squashfs-devel mailing list cc'd here, but there's no link to
> > it from the squashfs.org page.  Buried in the middle of a lot of text is a
> > link to the sourceforge squashfs project page, which has a link to "forums"
> > which are not the same as mailing lists.
> 
> There should be a link to it somewhere on the SF project page...
> 
> > But it might be nice to at least _hint_ about its existence on the web page.
> > The main page's "contact" section is your personal email and nothing else...
> 
> Yep. Fortunately we also have MAINTAINERS ;-)
> 
> | SQUASHFS FILE SYSTEM
> | P:      Phillip Lougher
> | M:      phillip@lougher.demon.co.uk
> | L:      squashfs-devel@lists.sourceforge.net (subscribers-only)
> | W:      http://squashfs.org.uk
> | S:      Maintained
> 
> Gr{oetje,eeting}s,
> 
> 						Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
> 							    -- Linus Torvalds

I built it from cvs (imported into git), and it works okay.
