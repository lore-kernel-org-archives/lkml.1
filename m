Return-Path: <linux-kernel-owner+w=401wt.eu-S1752672AbYKNKKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbYKNKKj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 05:10:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751289AbYKNKKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 05:10:30 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:11882 "EHLO
	SG2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbYKNKK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 05:10:29 -0500
X-BigFish: VPS-64(z21eW971Jz1432R62a3L98dR936eQ4015M1805M936fOzzzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KABIX1-02-1UI-01
Date: Fri, 14 Nov 2008 11:09:38 +0100
From: Robert Richter <robert.richter@amd.com>
To: Jiri Kosina <jkosina@suse.cz>
CC: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       oprofile-list@lists.sf.net, Jiri Benc <jbenc@suse.cz>,
       Vilem Marsik <vmarsik@suse.cz>, Eric Dumazet <dada1@cosmosbay.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: Oprofile [still] doesn't work on 2.6.28-rc4 on certain CPU
Message-ID: <20081114100938.GA1664@erda.amd.com>
References: <alpine.LNX.1.10.0811132147030.19853@jikos.suse.cz> <20081113212446.GA5694@elte.hu> <alpine.LNX.1.10.0811132226140.19853@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0811132226140.19853@jikos.suse.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 14 Nov 2008 10:10:06.0771 (UTC) FILETIME=[2B293830:01C94641]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.11.08 22:27:52, Jiri Kosina wrote:
> On Thu, 13 Nov 2008, Ingo Molnar wrote:
> 
> > > I haven't yet found a time to start bisecting this.
> > Would be nice to identify a commit to revert - in case we run out of 
> > time fixing it.
> 
> Yup, I first wanted to make this known to the public in hope that it will 
> ring a bell somewhere.
> 
> If noone sees an obvous reason for this, I will do my best to bisect this 
> tomorrow.

Could you at least test with v2.6.27? I could not reproduce it on the
hardware I am using.

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

