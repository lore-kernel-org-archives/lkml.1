Return-Path: <linux-kernel-owner+w=401wt.eu-S1759876AbXKAKHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759876AbXKAKHf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 06:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756306AbXKAKHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 06:07:25 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:38720 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753753AbXKAKHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 06:07:23 -0400
Date: Thu, 1 Nov 2007 13:05:39 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Li Yang-r58472 <LeoLi@freescale.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] ucc_geth: add support for netpoll
Message-ID: <20071101100539.GA24088@localhost.localdomain>
Reply-To: avorontsov@ru.mvista.com
References: <20071011124842.GB13963@localhost.localdomain> <4723389F.7010109@ru.mvista.com> <20071027143731.GA2616@zarina> <989B956029373F45A0B8AF0297081890019B61BF@zch01exm26.fsl.freescale.net> <20071029121744.GA20372@localhost.localdomain> <20071031215903.GA1287@zarina> <989B956029373F45A0B8AF0297081890019B642A@zch01exm26.fsl.freescale.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <989B956029373F45A0B8AF0297081890019B642A@zch01exm26.fsl.freescale.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2007 at 10:33:24AM +0800, Li Yang-r58472 wrote:
> > -----Original Message-----
> > From: Anton Vorontsov [mailto:cbou@mail.ru] 
> > Sent: Thursday, November 01, 2007 5:59 AM
> > To: Li Yang-r58472
> > Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; 
> > linuxppc-dev@ozlabs.org
> > Subject: Re: [PATCH] ucc_geth: add support for netpoll
> > 
> > On Mon, Oct 29, 2007 at 03:17:44PM +0300, Anton Vorontsov wrote:
> > [...]
> > > > Oops.  The original patch happened to hit the Junk mail box. :(
> > > 
> > > That one as well? http://lkml.org/lkml/2007/10/11/128
> > > 
> > > > I think
> > > > the patch is good to merge after the cosmetic change.  I 
> > can do it 
> > > > in next pull request to Jeff.
> > > 
> > > Ok, great. Thanks.
> > 
> > I'm wondering if you missed that email again. Maybe your mail 
> > client/server doing weird things with emails from @ru.mvista.com?
> 
> No.  I have explicitly add you to the whitelist. :)

Hehe, thanks. ;-)

> Please be patient,
> isn't this patch a new feature which can only be integrated in the merge
> window?

Sure it is. I didn't mean to "hurry up" you, of course not.

Just wondered if you've solved issues with getting my emails. Such
wonders are quite normal if there was a precedent lately. ;-)


Sorry for troubling you,

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.net/bd2
