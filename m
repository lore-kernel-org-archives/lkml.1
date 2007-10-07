Return-Path: <linux-kernel-owner+w=401wt.eu-S1757772AbXJGXLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757772AbXJGXLg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 19:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755417AbXJGXL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 19:11:28 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:46150 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755001AbXJGXL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 19:11:28 -0400
Message-ID: <47096752.2070107@keyaccess.nl>
Date: Mon, 08 Oct 2007 01:10:10 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Alistair John Strachan <alistair@devzero.co.uk>
CC: Willy Tarreau <w@1wt.eu>, Ingo Molnar <mingo@elte.hu>,
       Oleg Verych <olecom@flower.upol.cz>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Medve Emilian-EMMEDVE1 <Emilian.Medve@freescale.com>,
       Helge Deller <deller@gmx.de>
Subject: Re: "Re: [PATCH 0/2] Colored kernel output (run2)" + "`Subject:'
 usage"
References: <Pine.LNX.4.64.0710062005190.5969@fbirervta.pbzchgretzou.qr> <470929D8.80003@keyaccess.nl> <20071007191309.GS10199@1wt.eu> <200710072340.40828.alistair@devzero.co.uk>
In-Reply-To: <200710072340.40828.alistair@devzero.co.uk>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Neem contact op met support@home.nl voor meer informatie
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2007 12:40 AM, Alistair John Strachan wrote:

> Splash screens are clearly cosmetic, and it's kind of shameful (imo) that 
> important messages explaining real problems are obscured from view by 
> functionless splash screens.

They're not functionless. You (and I) might not care for the function, but 
their function is providing a "slick" bootup. That's why so many if not 
basically all distributions of recent origin use them. Go ask Ubuntu for 
example.

> Personally, I think muddying the vga colour argument with splash screen stuff 
> is bogus, they're very functionally separable ideas. A coloured oops seems to 
> be a good way of telling novice users what information is relevant to their 
> bug report.

But when they're hidden by a splash screen, you don't see them any better 
when they're red than when they're white. Splash screens were not mentioned 
as any sort of alternative, their prevalence was mentioned as indication 
that VGA console is only ever getting less important.

I find Alan's suggestion to provide the functionality the same way you'd 
provide for translated kernel messages (seeing as how there also are people 
that want those) much more sensible.

Rene.

