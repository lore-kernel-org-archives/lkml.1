Return-Path: <linux-kernel-owner+w=401wt.eu-S1757575AbXJGXDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575AbXJGXDS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 19:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754624AbXJGXDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 19:03:10 -0400
Received: from smtp1.betherenow.co.uk ([87.194.0.68]:56753 "EHLO
	smtp1.bethere.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019AbXJGXDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 19:03:09 -0400
X-Greylist: delayed 1345 seconds by postgrey-1.27 at vger.kernel.org; Sun, 07 Oct 2007 19:03:09 EDT
From: Alistair John Strachan <alistair@devzero.co.uk>
To: Willy Tarreau <w@1wt.eu>
Subject: Re: "Re: [PATCH 0/2] Colored kernel output (run2)" + "`Subject:' usage"
Date: Sun, 7 Oct 2007 23:40:40 +0100
User-Agent: KMail/1.9.7
Cc: Rene Herman <rene.herman@keyaccess.nl>, Ingo Molnar <mingo@elte.hu>,
       Oleg Verych <olecom@flower.upol.cz>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Medve Emilian-EMMEDVE1 <Emilian.Medve@freescale.com>,
       Helge Deller <deller@gmx.de>
References: <Pine.LNX.4.64.0710062005190.5969@fbirervta.pbzchgretzou.qr> <470929D8.80003@keyaccess.nl> <20071007191309.GS10199@1wt.eu>
In-Reply-To: <20071007191309.GS10199@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710072340.40828.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 07 October 2007 20:13:09 you wrote:
> On Sun, Oct 07, 2007 at 08:47:52PM +0200, Rene Herman wrote:
> > On 10/07/2007 06:12 PM, Ingo Molnar wrote:
> > >* Oleg Verych <olecom@flower.upol.cz> wrote:
> > >>Coloring isn't useful. If it was, it would be implemented ~16 years
> > >>ago.
> > >
> > >Congratulations, this is the most stupid argument i've ever read on
> > >lkml.
> >
> > "Ay. World is finished. Everyone can go home and watch Friends reruns
> > now."
> >
> > But well, there actually have been worse arguments given that VGA console
> > is getting less and less important. I recently did a perusal of
> > alternative distributions and didn't find a single one that didn't
> > default to having a splash screen hide the kernel during boot (and if I'm
> > not mistaken, only one of them provided me with the option during
> > installation to not boot into X immediately afterwards).
>
> I don't recall having seen any splash screen on Slackware. And fortunately,
> the mainstream distros still provide the option to boot in text mode.

Debian defaultly doesn't use framebuffer or any kind of splash screen.

Splash screens are clearly cosmetic, and it's kind of shameful (imo) that 
important messages explaining real problems are obscured from view by 
functionless splash screens.

Personally, I think muddying the vga colour argument with splash screen stuff 
is bogus, they're very functionally separable ideas. A coloured oops seems to 
be a good way of telling novice users what information is relevant to their 
bug report.

-- 
Cheers,
Alistair.

137/1 Warrender Park Road, Edinburgh, UK.
