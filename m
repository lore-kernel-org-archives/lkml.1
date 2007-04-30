Return-Path: <linux-kernel-owner+w=401wt.eu-S1423179AbXD3JNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423179AbXD3JNp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 05:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423187AbXD3JNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 05:13:45 -0400
Received: from host67-238-dynamic.19-87-r.retail.telecomitalia.it ([87.19.238.67]:58425
	"EHLO srv01.nuovanetmore.it" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1423179AbXD3JNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 05:13:44 -0400
Message-ID: <26114.212.141.48.2.1177924343.squirrel@riccitrk.ath.cx>
In-Reply-To: <6bffcb0e0704300157g5bd58565pd1f1a61d63296593@mail.gmail.com>
References: <55875.172.20.1.1.1177699628.squirrel@srv01.nuovanetmore.it>
    <1177765306.7646.152.camel@localhost.localdomain>
    <6bffcb0e0704300157g5bd58565pd1f1a61d63296593@mail.gmail.com>
Date: Mon, 30 Apr 2007 11:12:23 +0200 (CEST)
Subject: Re: Problem: 2.6.21 won't boot
From: "Riccardo Ricci" <rricci@nuovanetmore.it>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Cc: tglx@linutronix.de, "Riccardo Ricci" <rricci@nuovanetmore.it>,
       linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.9a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'll try...

> On 28/04/07, Thomas Gleixner <tglx@linutronix.de> wrote:
>> On Fri, 2007-04-27 at 20:47 +0200, Riccardo Ricci wrote:
>> > Hi to everyone,
>> > i've compiled kernel 2.6.21 on my debian PIII 650 / 256MB / Dell
>> Latitude
>> > J650GT. With 2.6.20.8 all works very good, with 2.6.21 don't boot...
>> While
>> > booting it stops after ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6
>> 7 9
>> > 10 11 12 14 15).
>>
>> Can you capture the 2.6.21 boot log via serial console ?
>
> Or netconsole? Please read chapter 3
> http://www.stardust.webpages.pl/files/handbook/handbook-en.pdf
>
> Regards,
> Michal
>
> --
> Michal K. K. Piotrowski
> Kernel Monkeys
> (http://kernel.wikidot.com/start)
>


-- 
Riccardo Ricci

