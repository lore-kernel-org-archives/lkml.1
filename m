Return-Path: <linux-kernel-owner+w=401wt.eu-S1753403AbXC2MZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403AbXC2MZk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 08:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753400AbXC2MZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 08:25:40 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52514 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753395AbXC2MZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 08:25:39 -0400
Message-ID: <460BB03F.6040003@garzik.org>
Date: Thu, 29 Mar 2007 08:25:35 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] net driver fixes
References: <20070323065742.GA17613@havoc.gtf.org> <Pine.LNX.4.60.0703232254170.5971@poirot.grange>
In-Reply-To: <Pine.LNX.4.60.0703232254170.5971@poirot.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Guennadi Liakhovetski wrote:
> Jeff, might be worth getting the sk_buff leak fix in ppp from 
> http://www.spinics.net/lists/netdev/msg27706.html in 2.6.21 too?
> 
> Don't know how important it is for stable. It was present in 2.6.18 too.

Can you resend the patch to me, please?

Easier for the system to apply than the URL...

	Jeff


