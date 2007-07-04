Return-Path: <linux-kernel-owner+w=401wt.eu-S1761370AbXGDMEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761370AbXGDMEI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 08:04:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759565AbXGDMDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 08:03:54 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:48858 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757152AbXGDMDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 08:03:53 -0400
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
Date: Wed, 4 Jul 2007 17:55:15 +0530 (IST)
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: Keiichi KII <k-keiichi@bx.jp.nec.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Netdev <netdev@vger.kernel.org>, Joel Becker <joel.becker@oracle.com>,
       Matt Mackall <mpm@selenic.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [RFC][PATCH -mm 0/9] netconsole: Multiple targets and dynamic
 reconfigurability
In-Reply-To: <468B8952.9030205@bx.jp.nec.com>
Message-ID: <Pine.LNX.4.64.0707041752210.29756@cselinux1.cse.iitk.ac.in>
References: <20070704110739.28520.5036.sendpatchset@cselinux1.cse.iitk.ac.in>
 <468B8952.9030205@bx.jp.nec.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Keiichi,

On Wed, 4 Jul 2007, Keiichi KII wrote:
> [...]
> At first, thank you for your helping.
> I'm going to try/review your patches.
> 
> >[ I had initially thought about only modifying Keiichi's patches to
> >incorporate the suggested stuff, sysfs+ioctl->configfs conversion, etc,
> >but the changes became too much and I ultimately ended up rewriting the
> >patchset. This also gave the flexibility to make other changes possible.
> >Keiichi, Takayoshi, kindly review this, and if OK, please give your
> >Signed-off-by:'s to the patches herein. ]
> 
> By the way, how can I add Signed-off-by:'s to your patches?
> Should I add it to each patch and submit them to this list again?
> 
> Anybody could give me an advice?

I think you could just individually reply to all the mails and replace
the "Cc:" in front of your name + email ID with "Signed-off-by:" --
after reviewing & testing this, of course!

Thanks,
Satyam
