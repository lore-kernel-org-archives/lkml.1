Return-Path: <linux-kernel-owner+w=401wt.eu-S1763425AbXJZCTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763425AbXJZCTU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 22:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759629AbXJZCTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 22:19:08 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:39827 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758795AbXJZCTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 22:19:06 -0400
Message-ID: <47214E98.6070402@garzik.org>
Date: Thu, 25 Oct 2007 22:19:04 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
       akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Remove #warnings for longstanding conditions.
References: <a576b5944eb04a18d4df3dd27cd32e7f13601470.1193299380.git.jeff@garzik.org> <03231528cf69b4194111178db23a7a387a573cb7.1193299380.git.jeff@garzik.org> <20071025112231.GL27248@parisc-linux.org> <47214BD5.4020106@garzik.org> <20071026021437.GQ27248@parisc-linux.org>
In-Reply-To: <20071026021437.GQ27248@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Thu, Oct 25, 2007 at 10:07:17PM -0400, Jeff Garzik wrote:
>> Is this warning of value to anybody but you?
> 
> Yup.  It signals this driver isn't production quality yet.
> 
>> Is this information worth printing out on everyone else's kernel build?
> 
> I thnk that's worth noting to anyone who's enabled it.

OK, thanks!

	Jeff



