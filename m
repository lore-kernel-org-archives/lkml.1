Return-Path: <linux-kernel-owner+w=401wt.eu-S1756794AbXJGWE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794AbXJGWE1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 18:04:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbXJGWEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 18:04:21 -0400
Received: from barikada.upol.cz ([158.194.242.200]:54823 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328AbXJGWEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 18:04:20 -0400
Date: Mon, 8 Oct 2007 00:18:29 +0200
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Rene Herman <rene.herman@keyaccess.nl>, Willy Tarreau <w@1wt.eu>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Medve Emilian-EMMEDVE1 <Emilian.Medve@freescale.com>,
       Helge Deller <deller@gmx.de>
Subject: Re: syntax highlighting, emacs ([PATCH 0/2] Colored kernel output (run2))
Message-ID: <20071007221829.GU22435@flower.upol.cz>
References: <20071007060706.GA18768@elte.hu> <20071007111035.GO22435@flower.upol.cz> <20071007161255.GA22102@elte.hu> <470929D8.80003@keyaccess.nl> <20071007191309.GS10199@1wt.eu> <Pine.LNX.4.64.0710072123460.16301@fbirervta.pbzchgretzou.qr> <47093AFB.8000805@keyaccess.nl> <Pine.LNX.4.64.0710072203570.16301@fbirervta.pbzchgretzou.qr> <20071007205024.GT22435@flower.upol.cz> <Pine.LNX.4.64.0710072238050.16301@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710072238050.16301@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 07, 2007 at 10:43:46PM +0200, Jan Engelhardt wrote:
> 
> On Oct 7 2007 22:50, Oleg Verych wrote:
> >
> >In fact mc config (ini) section is a better way.
> 
> Yes, for the default colors. But /usr/share/mc/syntax/ specifies
> more of them.

Syntax highlighting, OK.

Kind of funny thing with it. One for shell in `mcedit` is much nicer, but
`emacs` is more powerful as editor(R). But both have highlighting
problems with non trivial scripts (quoiting, data here, etc). I don't
know if it will ever be fixed :).

Comprehensive highlighting of contents of diffs (or even _patched_
sources) is XXII century feature.

Anyway if anybody have anything to look onto, like more Linux C types,
bogus coding style highlighting, i'll be glad to test. And any
emacs hacks, that gurus are using will be very appreciated.

[0] emacs setup and fontlocking <ftp://flower.upol.cz/emacs/>

> >I use default blue (which is very annoying)
> 
> If blue were annoying, it would not be the default Windows background
> (since Windows 2000). Then again, it's personal preference,

Emacs have black background by default. I changed foreground to green,
and it is much nicer for long runs. Blue (or any bright) background
isn't comfortable, i think.

> so I suppose you have a red/green desktop wallpaper for X11?

Black background mostly. If you know classic blackbox wm (version <=
0.62), then Rancor(80%) and Artwiz(20%) my all time styles. But i use
no X for quite some time now.
____
