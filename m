Return-Path: <linux-kernel-owner+w=401wt.eu-S1751818AbXCDQre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818AbXCDQre (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 11:47:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751809AbXCDQre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 11:47:34 -0500
Received: from wr-out-0506.google.com ([64.233.184.226]:50350 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbXCDQrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 11:47:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZqIFWHBfB7QC+vGnveuquPaWCrLGNzSyFb5XQhH6d1x6ywKccabu8HAoDe6m5ryjpE7OzfpFoRGc77x9jRRORTdtr2byMDUHeM+1D1Qj/dSrv3/MPefyl998saXOCGTdQ0KpVdDeXLBpOviT5F6EcXuraUeTlX4bAaTwr0T3Q7w=
Message-ID: <6bffcb0e0703040847g1c04940bm4c22895ec2540bd1@mail.gmail.com>
Date: Sun, 4 Mar 2007 17:47:32 +0100
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: tglx@linutronix.de
Subject: Re: 2.6.21-rc2-git3 soft lockup detected on CPU#0 (crash dump kernel)
Cc: "Ingo Molnar" <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1173026442.24738.143.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6bffcb0e0703031531h3f0a86c6sda2522c0ca504765@mail.gmail.com>
	 <1173018209.24738.135.camel@localhost.localdomain>
	 <6bffcb0e0703040636q5a4ed3ekf5a0461052e8e018@mail.gmail.com>
	 <1173022668.24738.141.camel@localhost.localdomain>
	 <6bffcb0e0703040828j46a339c2ofabf7c0e20f6ae09@mail.gmail.com>
	 <1173026442.24738.143.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/07, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Sun, 2007-03-04 at 17:28 +0100, Michal Piotrowski wrote:
> > > Can you please add "initcall_debug" and "ignore_loglevel" to the kernel
> > > command line ?
> >
> > Here is a full serial console log
> > http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc2-git3-kdump/log.txt
>
> sk98lin: driver has been replaced by the skge driver and is scheduled for removal
>
> Can you try without that one or with the skge driver instead ?
>

Unfortunately the bug still appears.

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
