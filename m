Return-Path: <linux-kernel-owner+w=401wt.eu-S1754955AbZGISvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955AbZGISvO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 14:51:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752573AbZGISvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 14:51:03 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:49802 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752324AbZGISvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 14:51:02 -0400
Message-ID: <4A563B83.4010803@simtec.co.uk>
Date: Thu, 09 Jul 2009 19:48:35 +0100
From: Ben Dooks <ben@simtec.co.uk>
Organization: Simtec Electronics, UK
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Russell King <rmk+lkml@arm.linux.org.uk>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       davinci <davinci-linux-open-source@linux.davincidsp.com>,
       Hugo Villeneuve <hugo.villeneuve@lyrtech.com>, philip@opensdr.com,
       Sascha Hauer <s.hauer@pengutronix.de>,
       Eduardo Valentin <eduardo.valentin@indt.org.br>,
       Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
       Ben Dooks <ben-linux@fluff.org>,
       dmitry pervushin <dpervushin@embeddedalley.com>,
       Vladislav Buzov <vbuzov@embeddedalley.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       arm <linux-arm@lists.arm.linux.org.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/44] includecheck: fix multiple includes
References: <1247063308.4382.12.camel@ht.satnam>	 <1247076059.4382.127.camel@ht.satnam>	 <20090708211321.GA15928@flint.arm.linux.org.uk> <1247113711.2453.27.camel@ht.satnam>
In-Reply-To: <1247113711.2453.27.camel@ht.satnam>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput wrote:
> On Wed, 2009-07-08 at 22:13 +0100, Russell King wrote:
>> On Wed, Jul 08, 2009 at 11:30:59PM +0530, Jaswinder Singh Rajput wrote:
>>> I am still waiting ACK/NAK for :
>>>
>>>       includecheck fix: arm, misc.c
>>>       includecheck fix: arm, atomic.h
>>>       includecheck fix: arm, board-dm355-evm.c
>>>       includecheck fix: arm, board-dm355-leopard.c
>>>       includecheck fix: arm, board-dm644x-evm.c
>>>       includecheck fix: arm, board-dm646x-evm.c
>>>       includecheck fix: arm, board-sffsdr.c
>>>       includecheck fix: arm, mach-mx3/devices.c
>>>       includecheck fix: arm, mach-omap1/mcbsp.c
>>>       includecheck fix: arm, mach-omap2/mcbsp.c
>>>       includecheck fix: arm, plat-s3c64xx/pm.c
>>>       includecheck fix: arm, plat-stmp3xxx/pinmux.c
>> You're still waiting because apparantly you never sent this set anywhere
>> near any ARM people before.
>>
>> For the first two, I'll ack them:
>>
>> Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
>>
>> The remainder look sane to me, but you'll have to seek acks from the
>> individual platform maintainer(s).
>>

Ack for plat-s3c64xx/pm.c:
Acked-by: Ben Dooks <ben-linux@fluff.org>

-- 
Ben Dooks, Software Engineer, Simtec Electronics

http://www.simtec.co.uk/
