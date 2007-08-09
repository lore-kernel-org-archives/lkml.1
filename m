Return-Path: <linux-kernel-owner+w=401wt.eu-S1763135AbXHIVO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763135AbXHIVO4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 17:14:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754729AbXHIVOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 17:14:48 -0400
Received: from rtr.ca ([64.26.128.89]:1752 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753224AbXHIVOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 17:14:46 -0400
Message-ID: <46BB83C5.5040100@rtr.ca>
Date: Thu, 09 Aug 2007 17:14:45 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Rene Herman <rene.herman@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>, Kyle Moffett <mrmacman_g4@mac.com>,
       Indan Zupancic <indan@nul.nu>, teresa@kvitka.net,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       CK Mailinglist <ck@vds.kolivas.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux Kernel cfs scheduler and xorg kbd
References: <1185827130.26459.16.camel@xtower.fri>	 <6bffcb0e0707301549t6be3cd97y27726f5421bb7680@mail.gmail.com>	 <20070801064816.GC10134@elte.hu> <p73abtbpk2s.fsf@bingen.suse.de>	 <46B06815.10200@gmail.com>	 <46470.81.207.0.53.1185971693.squirrel@secure.samage.net>	 <46B0818F.10204@gmail.com>	 <49653.81.207.0.53.1185973640.squirrel@secure.samage.net>	 <46B08B95.2010405@kvitka.net> <46B09190.1070201@gmail.com>	 <46850.81.207.0.53.1185980760.squirrel@secure.samage.net>	 <F4037195-194E-4265-9653-ED964CBA41E0@mac.com> <1186466758.2700.2.camel@laptopd505.fenrus.org> <46B87069.50204@gmail.com>
In-Reply-To: <46B87069.50204@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> ..
> No, as far as reported into this thread, it's all been PS/2. We can 
> leave this thread be though. It's nothing to do with CFS and is a 
> non-debuggable problem sofar unfortunately. Although very present at the 
> start of this thread, I haven't experienced my stuck delete key since. 
> Teresa and Indan have the same problem (well, "non-problem" that is). If 
> it's still lurking somewhere, we'll see it resurface at some point.

My Dell X1 notebook has long suffered from this type of problem,
but disabling the "keyboard accessibility" features in KDE seems
to have greatly lessened the occurances.
