Return-Path: <linux-kernel-owner+w=401wt.eu-S1756152AbXJGT4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152AbXJGT4S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 15:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754388AbXJGT4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 15:56:11 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:47115 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381AbXJGT4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 15:56:10 -0400
Date: Sun, 7 Oct 2007 21:56:09 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Willy Tarreau <w@1wt.eu>
cc: Rene Herman <rene.herman@keyaccess.nl>, Ingo Molnar <mingo@elte.hu>,
       Oleg Verych <olecom@flower.upol.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Medve Emilian-EMMEDVE1 <Emilian.Medve@freescale.com>,
       Helge Deller <deller@gmx.de>
Subject: Re: "Re: [PATCH 0/2] Colored kernel output (run2)" + "`Subject:'
 usage"
In-Reply-To: <20071007191309.GS10199@1wt.eu>
Message-ID: <Pine.LNX.4.64.0710072123460.16301@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710062005190.5969@fbirervta.pbzchgretzou.qr>
 <20071006195105.GE22435@flower.upol.cz> <20071006194820.GA30579@elte.hu>
 <20071006210349.GG22435@flower.upol.cz> <20071007060706.GA18768@elte.hu>
 <20071007111035.GO22435@flower.upol.cz> <20071007161255.GA22102@elte.hu>
 <470929D8.80003@keyaccess.nl> <20071007191309.GS10199@1wt.eu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 7 2007 21:13, Willy Tarreau wrote:
>There are two distinct populations :
>  - those [...]
>    who would never have imagined that pressing Escape
>    during the boot of windows 3.1/95 provided them with the full text
>    messages.

This is news to me. DOS always showed messages, and under Win95,
it was either F8 or removing logo.sys. I did troubleshoot it ;-)

>  - those who are troubleshooting their system [...]
>
>I personally fit in the second category.
>
>I would say that while I'm not particularly fond of flashy colors
>everywhere

I have to agree so really. Just because there's a color option for 
everything does not mean one should use it.

In fact, I moved away[2] from the default Midnight Commander styling 
because it's just - as Dave calls it - salad colors[1].

Some is good, as long as it is not excessive. While I could imagine that 
Knoppix will abuse the feature and use vt.printk_color=9,9,9,9,11,10,12, 
this is not what serious people would do.

[1] http://tinyurl.com/yr9zgq
[2] http://tinyurl.com/234ba3

>, I think that being able to use colors to indicate particular
>actions in progress or conditions can be a good thing. RAID errors,
>devices disabled due to command-line parameters,
