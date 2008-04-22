Return-Path: <linux-kernel-owner+w=401wt.eu-S1762276AbYDVOft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762276AbYDVOft (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 10:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754748AbYDVOfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 10:35:38 -0400
Received: from rtr.ca ([76.10.145.34]:2895 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154AbYDVOfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 10:35:37 -0400
Message-ID: <480DF7B7.9030000@rtr.ca>
Date: Tue, 22 Apr 2008 10:35:35 -0400
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>, Jeff Garzik <jeff@garzik.org>,
       Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [2.6 patch] select ATA_SFF
References: <20080421213147.GH2633@cs181133002.pp.htv.fi> <480DE3C4.5@ru.mvista.com> <480DE6F5.8060403@gmail.com> <480DE9E8.2070809@ru.mvista.com> <480DEB1F.5060500@gmail.com>
In-Reply-To: <480DEB1F.5060500@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Sergei Shtylyov wrote:
>>>>    Jeff, Tejun, what "sff" in the file name actually means? Isn't it 
>>>> strange that the drivers lacking DMA support or not really compliant 
>>>> with SFF-8038i have to link with this file?
>>
>>> Maybe it should be libata-tf and libata-bmdma, but sff (sans bmdma)
>>> and bmdma is acceptable, hopefully, right?
>>
>>    What's sff sans bmdma?
> 
> Supposed to be TF interface.  IIRC, the SFF term was first from Alan 
> although it's entirely possible that I misunderstood it and used it in 
> the wrong way.  Alan, can you please clear up the confusion?
..

SFF stands for "Small Form Factor", as in the "SFF Committee Information
Specification for Bus Master Programming Interface for IDE ATA Controllers Rev 1.0"
from May 16, 1994.

That document is basically a committee rubber-stamp of the earlier Intel
"PCI IDE Controller Specification Revision 1.0" dated 3/4/94.

Would anyone like copies ?

Cheers

 

