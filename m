Return-Path: <linux-kernel-owner+w=401wt.eu-S1755999AbXJGTzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999AbXJGTzF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 15:55:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753990AbXJGTyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 15:54:55 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:56089 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbXJGTyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 15:54:54 -0400
Message-ID: <47093942.3090104@keyaccess.nl>
Date: Sun, 07 Oct 2007 21:53:38 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Ingo Molnar <mingo@elte.hu>, Oleg Verych <olecom@flower.upol.cz>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Medve Emilian-EMMEDVE1 <Emilian.Medve@freescale.com>,
       Helge Deller <deller@gmx.de>
Subject: Re: "Re: [PATCH 0/2] Colored kernel output (run2)" + "`Subject:'
 usage"
References: <Pine.LNX.4.64.0710062005190.5969@fbirervta.pbzchgretzou.qr> <20071006195105.GE22435@flower.upol.cz> <20071006194820.GA30579@elte.hu> <20071006210349.GG22435@flower.upol.cz> <20071007060706.GA18768@elte.hu> <20071007111035.GO22435@flower.upol.cz> <20071007161255.GA22102@elte.hu> <470929D8.80003@keyaccess.nl> <20071007191309.GS10199@1wt.eu>
In-Reply-To: <20071007191309.GS10199@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Neem contact op met support@home.nl voor meer informatie
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2007 09:13 PM, Willy Tarreau wrote:

> On Sun, Oct 07, 2007 at 08:47:52PM +0200, Rene Herman wrote:

>> But well, there actually have been worse arguments given that VGA console 
>> is getting less and less important. I recently did a perusal of alternative 
>> distributions and didn't find a single one that didn't default to having a 
>> splash screen hide the kernel during boot (and if I'm not mistaken, only 
>> one of them provided me with the option during installation to not boot 
>> into X immediately afterwards).
> 
> I don't recall having seen any splash screen on Slackware.

Indeed, but that's the distribution I use and considered switching away 
from. Just my luck eh? :-\

> There are two distinct populations :
>   - those who are afraid of boot messages and prefer "splash" screens.
>     Those people are most common users, grown in non-IT environments. They
>     are happy to see a big logo on their BIOS to hide important boot errors,
>     and they are the ones who would never have imagined that pressing Escape
>     during the boot of windows 3.1/95 provided them with the full text
>     messages. Basically, they want to ensure they will never have to worry
>     about things they don't understand.

Nor want to understand, often.

>   - those who are troubleshooting their system in the early stages (kernel,
>     filesystems, network, services, ...). These ones *need* boot messages.
>     And there, depending on the hardware, sometimes the FB is better because
>     it shows larger lines, sometimes it's worse because the scrollback is
>     limited by too low memory.
> 
> I personally fit in the second category. And I'm sure most people on this
> list do.

As do I ofcourse. An operating system kernel development list might provide 
for a fairly non-average balanced population of "am / am not interested in 
the inner workings of computers". Given that most everyone these days uses a 
computer, it's still a really small percentage though -- and as evidenced by 
the bootsplash thing, even of Linux users (and I've in fact heard real-life 
people say they disliked the noisy Linux bootup due to "all those errors").

> I would be miserably sad if I couldn't get my boot messages anymore. It
> already irritates me a lot to loose the ones displayed before switching
> to frame-buffer when a hang happens just afterwards...

Oh quite. I use VGA console myself. But not being able to get to the bootup 
messages anymore even for people who do care is not the issue. It's about 
finding it a bit hard to get excited about colourization when the "obvious" 
way forward is so much more graphically oriented.

As also commented in another reply just now, ways forward also tend to have 
their problems but this kind of "innovation" takes me back to the time when 
our favorite bulletins board adopted ANSI colours. Today, that seems just a 
tad pathetic...

Again, it might not hurt any either, but sheesh.

Rene.
