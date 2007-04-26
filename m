Return-Path: <linux-kernel-owner+w=401wt.eu-S1031404AbXDZSR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031404AbXDZSR3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 14:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031419AbXDZSR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 14:17:28 -0400
Received: from main.gmane.org ([80.91.229.2]:56778 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031404AbXDZSR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 14:17:26 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
   hang in atomic copy)
Date: Thu, 26 Apr 2007 14:18:28 -0400
Message-ID: <4630ECF4.6040702@tmr.com>
References: <200704182245.24156.mail@earthworm.de>	 <20070418211632.GA7610@elte.hu> <200704182357.28107.mail@earthworm.de>	 <20070418220228.GA14536@elte.hu>	 <1176947576.5906.21.camel@nigel.suspend2.net>	 <20070419070437.GA25211@elte.hu> <20070424202336.GC16503@elf.ucw.cz>	 <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org>	 <20070424212408.GD16457@elf.ucw.cz>	 <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org>	 <20070425072350.GA6866@ucw.cz>	 <1177490913.30284.38.camel@frg-rhel40-em64t-04>	 <1177491047.3857.32.camel@nigel.suspend2.net> <1177492072.30284.48.camel@frg-rhel40-em64t-04>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: mail.tmr.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
In-Reply-To: <1177492072.30284.48.camel@frg-rhel40-em64t-04>
Cc: suspend2-devel@lists.suspend2.net
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Xavier Bestel wrote:
> On Wed, 2007-04-25 at 18:50 +1000, Nigel Cunningham wrote:
>>> (And guess what, it uses APM and suspend is really faster and way more
>>> reliable than each kernel implementation I could try).
>> If you tried Suspend2 and had problems with reliability, please send me
>> logs. I'll do all I can to help. (I have to qualify it a bit, because
>> I'm not able to fix drivers, but if it's a Suspend2 issue, tell me and
>> I'll fix it).
> 
> Does suspend2 work with APM ? After much trying, I think now the ACPI
> implementation of my laptop (a vintage Compaq Armada 1700) is busted,
> only APM works.
> 
> AFAIR the problem with suspend2 was that it didn't poweroff some parts
> of the laptop (the led of the wifi pcmcia card was on, and the lcd light
> was on too), but that was last year. Kernel's suspend kind of worked but
> didn't resume (no reaction on button press). As I tried all this last
> year, I may have forgotten some things.
> Honestly, I like this laptop when it works flawlessly, so I don't see
> many reasons to try *susp* again. I'll do it when I'm bored, just not
> today.
> 
Actually on some old laptops I just use the apm command, with -s (or -S, 
I forget by now), and that works.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

