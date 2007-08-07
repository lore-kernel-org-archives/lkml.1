Return-Path: <linux-kernel-owner+w=401wt.eu-S934422AbXHGNS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934422AbXHGNS4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 09:18:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933566AbXHGNSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 09:18:44 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:48000 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934320AbXHGNSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 09:18:41 -0400
Message-ID: <46B87069.50204@gmail.com>
Date: Tue, 07 Aug 2007 15:15:21 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Kyle Moffett <mrmacman_g4@mac.com>, Indan Zupancic <indan@nul.nu>,
       teresa@kvitka.net, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@elte.hu>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       CK Mailinglist <ck@vds.kolivas.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux Kernel cfs scheduler and xorg kbd
References: <1185827130.26459.16.camel@xtower.fri>	 <6bffcb0e0707301549t6be3cd97y27726f5421bb7680@mail.gmail.com>	 <20070801064816.GC10134@elte.hu> <p73abtbpk2s.fsf@bingen.suse.de>	 <46B06815.10200@gmail.com>	 <46470.81.207.0.53.1185971693.squirrel@secure.samage.net>	 <46B0818F.10204@gmail.com>	 <49653.81.207.0.53.1185973640.squirrel@secure.samage.net>	 <46B08B95.2010405@kvitka.net> <46B09190.1070201@gmail.com>	 <46850.81.207.0.53.1185980760.squirrel@secure.samage.net>	 <F4037195-194E-4265-9653-ED964CBA41E0@mac.com> <1186466758.2700.2.camel@laptopd505.fenrus.org>
In-Reply-To: <1186466758.2700.2.camel@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2007 08:05 AM, Arjan van de Ven wrote:

[ stuck keys ]

> the last time I saw something like this it was a BIOS that kept doing 
> USB->PS/2 emulation even when the kernel was running.. that caused great 
> havoc somehow...
> 
> those who are seeing this... is it all on a USB keyboard? If so, is the 
> bios set to do PS/2 emulation (sometimes called USB legacy emulation) ??

No, as far as reported into this thread, it's all been PS/2. We can leave 
this thread be though. It's nothing to do with CFS and is a non-debuggable 
problem sofar unfortunately. Although very present at the start of this 
thread, I haven't experienced my stuck delete key since. Teresa and Indan 
have the same problem (well, "non-problem" that is). If it's still lurking 
somewhere, we'll see it resurface at some point.

Rene.
