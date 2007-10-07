Return-Path: <linux-kernel-owner+w=401wt.eu-S1755351AbXJGT2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbXJGT2y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 15:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753307AbXJGT2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 15:28:46 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:40993 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385AbXJGT2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 15:28:46 -0400
Message-ID: <47093322.1030200@keyaccess.nl>
Date: Sun, 07 Oct 2007 21:27:30 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Ingo Molnar <mingo@elte.hu>, Oleg Verych <olecom@flower.upol.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Medve Emilian-EMMEDVE1 <Emilian.Medve@freescale.com>,
       Helge Deller <deller@gmx.de>
Subject: Re: "Re: [PATCH 0/2] Colored kernel output (run2)" + "`Subject:'
 usage"
References: <Pine.LNX.4.64.0710062005190.5969@fbirervta.pbzchgretzou.qr> <20071006195105.GE22435@flower.upol.cz> <20071006194820.GA30579@elte.hu> <20071006210349.GG22435@flower.upol.cz> <20071007060706.GA18768@elte.hu> <20071007111035.GO22435@flower.upol.cz> <20071007161255.GA22102@elte.hu> <470929D8.80003@keyaccess.nl> <Pine.LNX.4.64.0710072053300.16301@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0710072053300.16301@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Neem contact op met support@home.nl voor meer informatie
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2007 08:58 PM, Jan Engelhardt wrote:

> On Oct 7 2007 20:47, Rene Herman wrote:

>>>> Coloring isn't useful. If it was, it would be implemented ~16 years
>>>> ago.
>>> Congratulations, this is the most stupid argument i've ever read on lkml.
>> "Ay. World is finished. Everyone can go home and watch Friends reruns now."
>>
>> But well, there actually have been worse arguments given that VGA console is
>> getting less and less important.
>> [...]
>> Sure, that in itself needn't necesarily be of concern to anyone who,
>> err, is not concerned but any such colouring feature appearing when
>> there's only a smathering of people left that still cares about the VGA
>> console in the first place really isn't all _that_ far out as an
>> argument...
> 
> In case you have not noticed, the coloring also applies to FB. As far as
> I can oversee, it's only "missing" for serial and PROMs.

Must say I did concentrate on VGA, but the [...] bit in the quote above was 
about how everything I encountered put up a bootsplash hiding _everything_ 
and about booting into X immediately, not about FB...

I saw you remark on FB console in a reply to Alan just now and I quite agree 
with you. The (current) FB console is slow and I'll add "dumb" myself. When 
you have a 1280x1024 screen available, you get to do cool things like put up 
nice little windows and exclamation mark icons on errors, not just pretend 
you're really 132x50 (or whatever).

Alan's sketched more generic markup/unification would be The Way Forward it 
seems. Given that TWF is mostly defined as "That Which Is Not" (and how it 
seems to have a tendency to defend that status vigorously) telling me/us to 
shelve that objection for 10 years might be okay -- but generally I'm having 
a fairly hard time getting excited about printk colourizing.

Rene.

