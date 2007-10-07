Return-Path: <linux-kernel-owner+w=401wt.eu-S1757240AbXJGWLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240AbXJGWLa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 18:11:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754874AbXJGWLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 18:11:23 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:44321 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397AbXJGWLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 18:11:22 -0400
Date: Mon, 8 Oct 2007 00:11:21 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Oleg Verych <olecom@flower.upol.cz>
cc: Rene Herman <rene.herman@keyaccess.nl>, Willy Tarreau <w@1wt.eu>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Medve Emilian-EMMEDVE1 <Emilian.Medve@freescale.com>,
       Helge Deller <deller@gmx.de>
Subject: Re: syntax highlighting, emacs ([PATCH 0/2] Colored kernel output
 (run2))
In-Reply-To: <20071007221829.GU22435@flower.upol.cz>
Message-ID: <Pine.LNX.4.64.0710080005370.16301@fbirervta.pbzchgretzou.qr>
References: <20071007060706.GA18768@elte.hu> <20071007111035.GO22435@flower.upol.cz>
 <20071007161255.GA22102@elte.hu> <470929D8.80003@keyaccess.nl>
 <20071007191309.GS10199@1wt.eu> <Pine.LNX.4.64.0710072123460.16301@fbirervta.pbzchgretzou.qr>
 <47093AFB.8000805@keyaccess.nl> <Pine.LNX.4.64.0710072203570.16301@fbirervta.pbzchgretzou.qr>
 <20071007205024.GT22435@flower.upol.cz> <Pine.LNX.4.64.0710072238050.16301@fbirervta.pbzchgretzou.qr>
 <20071007221829.GU22435@flower.upol.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 8 2007 00:18, Oleg Verych wrote:
>
>Kind of funny thing with it. One for shell in `mcedit` is much nicer, but
>`emacs` is more powerful as editor(R). But both have highlighting
>problems with non trivial scripts (quoiting, data here, etc). I don't
>know if it will ever be fixed :).

No, it will never get fixed. I use two editors on a day-to-day basis,
and that is mcedit and joe. No fixed rule on which to use. It goes as
far that I have the same syntax highlighting (almost) on both.
Because one thing in one editor is cumbersome in the other.
Perhaps if there was one editor with the hotkeys of *both* (yes,
means duplicates), maybe then I'd be satisfied.

>Emacs have black background by default. I changed foreground to green,
>and it is much nicer for long runs. Blue (or any bright) background
>isn't comfortable, i think.

Actually, blue is perceived as one of the darkest colors by the human
eye. There is a reason that the RGB -> grayscale transformation uses
the following weighting: r=76 g=154 b=26.
