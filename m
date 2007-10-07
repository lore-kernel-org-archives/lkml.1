Return-Path: <linux-kernel-owner+w=401wt.eu-S1754909AbXJGStS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909AbXJGStS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 14:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752313AbXJGStI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 14:49:08 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:59625 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbXJGStH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 14:49:07 -0400
Message-ID: <470929D8.80003@keyaccess.nl>
Date: Sun, 07 Oct 2007 20:47:52 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Oleg Verych <olecom@flower.upol.cz>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Medve Emilian-EMMEDVE1 <Emilian.Medve@freescale.com>,
       Helge Deller <deller@gmx.de>
Subject: Re: "Re: [PATCH 0/2] Colored kernel output (run2)" + "`Subject:'
 usage"
References: <Pine.LNX.4.64.0710062005190.5969@fbirervta.pbzchgretzou.qr> <20071006195105.GE22435@flower.upol.cz> <20071006194820.GA30579@elte.hu> <20071006210349.GG22435@flower.upol.cz> <20071007060706.GA18768@elte.hu> <20071007111035.GO22435@flower.upol.cz> <20071007161255.GA22102@elte.hu>
In-Reply-To: <20071007161255.GA22102@elte.hu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Neem contact op met support@home.nl voor meer informatie
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2007 06:12 PM, Ingo Molnar wrote:

> * Oleg Verych <olecom@flower.upol.cz> wrote:

>> Coloring isn't useful. If it was, it would be implemented ~16 years
>> ago.
> 
> Congratulations, this is the most stupid argument i've ever read on 
> lkml.

"Ay. World is finished. Everyone can go home and watch Friends reruns now."

But well, there actually have been worse arguments given that VGA console is 
getting less and less important. I recently did a perusal of alternative 
distributions and didn't find a single one that didn't default to having a 
splash screen hide the kernel during boot (and if I'm not mistaken, only one 
of them provided me with the option during installation to not boot into X 
immediately afterwards).

Sure, that in itself needn't necesarily be of concern to anyone who, err, is 
not concerned but any such colouring feature appearing when there's only a 
smathering of people left that still cares about the VGA console in the 
first place really isn't all _that_ far out as an argument...

Rene.
