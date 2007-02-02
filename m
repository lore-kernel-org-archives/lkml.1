Return-Path: <linux-kernel-owner+w=401wt.eu-S1423123AbXBBGCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423123AbXBBGCc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 01:02:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423114AbXBBGCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 01:02:32 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:45744 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423112AbXBBGCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 01:02:31 -0500
Message-ID: <45C2D3F0.9050907@garzik.org>
Date: Fri, 02 Feb 2007 01:02:24 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: NeilBrown <neilb@suse.de>, Andrew Morton <akpm@osdl.org>,
       nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 000 of 14] knfsd: Preparation for IPv6 support in NFS
 server.
References: <20070202153531.18622.patches@notabene> <adahcu55fiu.fsf@cisco.com>
In-Reply-To: <adahcu55fiu.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
>  > They are mostly from Chuck Level and make preparating for IPv6 support
>  > in the NFS server.
>  > They are *not* for 2.6.20, but should be ok for .21.
> 
> Out of curiousity, does this patch series reduce the delta between the
> NFS/RDMA tree and mainline Linux?  In other words does this bring
> NFS/RDMA closer to merging?

NFS/RDMA is IMO more than a little bit questionable, and the likely 
userbase is also quite small.  I'm not sure its worth a mainline merge 
at this point.

	Jeff



