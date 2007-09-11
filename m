Return-Path: <linux-kernel-owner+w=401wt.eu-S1758084AbXIKEYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084AbXIKEYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 00:24:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750820AbXIKEYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 00:24:01 -0400
Received: from smtpoutm.mac.com ([17.148.16.78]:49486 "EHLO smtpoutm.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818AbXIKEYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 00:24:00 -0400
In-Reply-To: <20070910153953.GG3563@stusta.de>
References: <20070905102230.10b0bdcf@oldman> <782111.42803.qm@web90413.mail.mud.yahoo.com> <46E2DF74.7040307@tmr.com> <20070908191132.GD3563@stusta.de> <46E5558D.3030402@tmr.com> <20070910153953.GG3563@stusta.de>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <A5211C44-E353-46B1-9868-CE17B5489289@mac.com>
Cc: Bill Davidsen <davidsen@tmr.com>, James Corey <ploversegg@yahoo.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Rob Sims <lkml-z@robsims.com>, Kyle Rose <krose@akamai.com>,
       linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: sk98lin for 2.6.23-rc1
Date: Tue, 11 Sep 2007 00:23:28 -0400
To: Adrian Bunk <bunk@kernel.org>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 10, 2007, at 11:39:53, Adrian Bunk wrote:
> No, it is obsolete because we have more than one driver for this  
> hardware, and the people responsible for network drivers in the  
> kernel decided some time ago that sk98lin is the one that is obsolete.

I would like to happily report that the sky2 driver works great in  
the NIC on my tablet where the sk98lin and skge drivers both fail  
utterly and hang the kernel.  On another system the sk98lin and skge  
drivers don't recognize the chipset at all (missing PCI ID?) while  
the sky2 driver works perfectly for large quantities of data  
transferred.

Cheers,
Kyle Moffett

