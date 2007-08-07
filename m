Return-Path: <linux-kernel-owner+w=401wt.eu-S1762149AbXHGEkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762149AbXHGEkf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 00:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753428AbXHGEk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 00:40:27 -0400
Received: from smtpout.mac.com ([17.250.248.175]:62433 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753292AbXHGEk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 00:40:26 -0400
In-Reply-To: <46850.81.207.0.53.1185980760.squirrel@secure.samage.net>
References: <1185827130.26459.16.camel@xtower.fri> <6bffcb0e0707301549t6be3cd97y27726f5421bb7680@mail.gmail.com> <20070801064816.GC10134@elte.hu> <p73abtbpk2s.fsf@bingen.suse.de> <46B06815.10200@gmail.com> <46470.81.207.0.53.1185971693.squirrel@secure.samage.net> <46B0818F.10204@gmail.com> <49653.81.207.0.53.1185973640.squirrel@secure.samage.net> <46B08B95.2010405@kvitka.net> <46B09190.1070201@gmail.com> <46850.81.207.0.53.1185980760.squirrel@secure.samage.net>
Mime-Version: 1.0 (Apple Message framework v752.2)
X-Priority: 3 (Normal)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <F4037195-194E-4265-9653-ED964CBA41E0@mac.com>
Cc: Rene Herman <rene.herman@gmail.com>, teresa@kvitka.net,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       CK Mailinglist <ck@vds.kolivas.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: Linux Kernel cfs scheduler and xorg kbd
Date: Tue, 7 Aug 2007 00:40:21 -0400
To: Indan Zupancic <indan@nul.nu>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 01, 2007, at 11:06:00, Indan Zupancic wrote:
> Different programs, different keys "stuck", so hard to tell. The  
> amount the pressed key is repeated differs too, from double to  
> hundreds.
>
> As an apparently separate problem my mouse warps once in a while  
> too, and that's not totally fixed yet, neither with that locking  
> patch. Throw in that two of my USB ports stopped working after a  
> rare power outage, I didn't totally trust my hardware any more,  
> hence my initial reluctance to report these problems.
>
> We could have independent problems with more or less the same  
> symptoms, at least Teresa's problem seems much worse than ours, and  
> if you and Ingo only experience a stuck delete key, it might be  
> something else.

Well I've just seen an FC box (6? 7?) running a 2.6.18-ish which  
reliably experiences the same problem (randomly stuck keys), so I  
doubt very much it's CFS.  Basically keys will somewhat randomly  
repeat 6-7 times, mainly depending on how fast you're typing (the  
intern using the box typed somewhat slowly and didn't trigger it  
much, but when I borrowed his keyboard I could reliably trigger it  
once every 5 sec or so.  Unfortunately I don't have access to that  
box anymore, so I can't really debug the problem.

Cheers,
Kyle Moffett

