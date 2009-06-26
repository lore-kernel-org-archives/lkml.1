Return-Path: <linux-kernel-owner+w=401wt.eu-S1761342AbZFZTUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761342AbZFZTUQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 15:20:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761179AbZFZTTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 15:19:40 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:54054 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760579AbZFZTTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 15:19:37 -0400
Date: Fri, 26 Jun 2009 21:18:24 +0200 (CEST)
From: Jesper Dangaard Brouer <hawk@diku.dk>
To: David Miller <davem@davemloft.net>
Cc: Jesper Dangaard Brouer <jdb@comx.dk>, paulmck@linux.vnet.ibm.com,
       netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
       Patrick McHardy <kaber@trash.net>, yoshfuji@linux-ipv6.org,
       linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org,
       catalin.marinas@gmail.com
Subject: Re: [PATCH 07/10] decnet: Use rcu_barrier() on module unload.
In-Reply-To: <20090625.161046.19938291.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0906262100210.14848@ask.diku.dk>
References: <1245845367.24921.3.camel@localhost.localdomain>
 <5A680E0A-EFEB-44EA-9F06-F338E6CBD6D1@googlemail.com>
 <1245930729.24921.67.camel@localhost.localdomain> <20090625.161046.19938291.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jun 2009, David Miller wrote:

> However, could you formally resubmit just the networking bits
> as that would make life a lot easier for me.

As maintainer of now three kernel subsystems, you are allowed to push work 
my way... And thanks to StGit (http://www.procode.org/stgit/) picking the 
patchset a part is easy :-) (kudos to Catalin Marinas)

I'll resubmit the patches to you and netdev, to limit the spam effect...

Thus, you are getting 5 of the patches 02, 03, 04, 06 and 07.  And I have 
added the Acked-by's.  And Patrick has already picked up the netfilter 
patch.

> Thanks a lot Jesper!
You are welcome :-)

Cheers,
   Jesper Brouer

--
-------------------------------------------------------------------
MSc. Master of Computer Science
Dept. of Computer Science, University of Copenhagen
Author of http://www.adsl-optimizer.dk
-------------------------------------------------------------------
