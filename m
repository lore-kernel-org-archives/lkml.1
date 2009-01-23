Return-Path: <linux-kernel-owner+w=401wt.eu-S1755570AbZAWOrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570AbZAWOrw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 09:47:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753085AbZAWOrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 09:47:45 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:12128 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723AbZAWOro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 09:47:44 -0500
X-BigFish: VPS4(zzzzzzz32i6bh6di43j66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0KDXIF5-02-FAH-01
Date: Fri, 23 Jan 2009 15:47:23 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: Mark Hounschell <dmarkh@cfl.rr.com>
CC: Andreas Herrmann <andreas.herrmann3@amd.com>, markh@compro.net,
       john stultz <johnstul@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: PROBLEM: Can't boot a (HZ = 1000) kernel using an AMD
	Phenom-II processor
Message-ID: <20090123144723.GA12790@aftab>
References: <497322CC.7050900@cfl.rr.com> <1f1b08da0901191625i6ac12312g9ae9ab599958a818@mail.gmail.com> <49759499.4050708@cfl.rr.com> <20090120093732.GC3764@alberich.amd.com> <49763D49.7050907@compro.net> <49798F33.8070906@cfl.rr.com> <20090123130416.GA27616@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090123130416.GA27616@alberich.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 23 Jan 2009 14:47:26.0942 (UTC) FILETIME=[82644FE0:01C97D69]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[.. ]

> Can you please try to boot with idle=poll, or idle=mwait, or nolapic_timer
> when using 2.6.26.X?
> Can you also try to boot .27 or .28?

Also, can you send me the output of dmidecode please?

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices, Inc.
Operating System Research Center

