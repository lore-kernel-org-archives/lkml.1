Return-Path: <linux-kernel-owner+w=401wt.eu-S932866AbXHAOBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932866AbXHAOBZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 10:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932083AbXHAOBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 10:01:17 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:52565 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932256AbXHAOBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 10:01:16 -0400
Message-ID: <46B09190.1070201@gmail.com>
Date: Wed, 01 Aug 2007 15:58:40 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070716)
MIME-Version: 1.0
To: "<:::.. TeresaII ..:::>" <teresa@kvitka.net>
CC: Indan Zupancic <indan@nul.nu>, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@elte.hu>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       CK Mailinglist <ck@vds.kolivas.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux Kernel cfs scheduler and xorg kbd
References: <1185827130.26459.16.camel@xtower.fri>    <6bffcb0e0707301549t6be3cd97y27726f5421bb7680@mail.gmail.com>    <20070801064816.GC10134@elte.hu> <p73abtbpk2s.fsf@bingen.suse.de>    <46B06815.10200@gmail.com>    <46470.81.207.0.53.1185971693.squirrel@secure.samage.net>    <46B0818F.10204@gmail.com> <49653.81.207.0.53.1185973640.squirrel@secure.samage.net> <46B08B95.2010405@kvitka.net>
In-Reply-To: <46B08B95.2010405@kvitka.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2007 03:33 PM, <:::.. TeresaII ..:::> wrote:

> Problem is, that i can't reproduce it after last reboot.
> Can this be different on each reboot ? Any idea ?
> 
> About another kernel: i only had -ck kernels since last year or more, i 
> can remember i had same behavier atleast 6 month ago, or maybe more. But 
> it wasn't that hard and it dissapiered self after some time.

Hmm.

> Now on first run of 2.6.22.1-cfs-v19.1 i got it again. And realy bad. It 
> was even very hard to write report mail.

I notice by the way that you are also using Thunderbird 2.0 -- that was my 
own suspect; I had just switched from Thunderbird 1.5.

> I did reboot, day after that it was back, but not that hard. And now
> rebooted yesterday and cant reproduce it at all.

I believe that at least for now we can safely remove this from any list of 
possible CFS regresssions. I'll sit on it and see what I can find out 
when/if my stuck delete happens again.

Indan -- under what circumstances/programs did you experience what?

Rene.
