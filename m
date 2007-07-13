Return-Path: <linux-kernel-owner+w=401wt.eu-S1763452AbXGMUoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763452AbXGMUoW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 16:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757759AbXGMUoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 16:44:13 -0400
Received: from brick.kernel.dk ([80.160.20.94]:4953 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756419AbXGMUoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 16:44:12 -0400
Date: Fri, 13 Jul 2007 22:43:54 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Patrick McHardy <kaber@trash.net>
Cc: Chuck Ebbert <cebbert@redhat.com>, neilb@suse.de,
       nfs@lists.sourceforge.net,
       Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: nfsd oops in current -git
Message-ID: <20070713204353.GB5328@kernel.dk>
References: <469780BB.3070206@trash.net> <4697A7EC.6050006@redhat.com> <20070713163337.GT5328@kernel.dk> <20070713165001.GV5328@kernel.dk> <4697DF7F.3030400@trash.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4697DF7F.3030400@trash.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13 2007, Patrick McHardy wrote:
> Jens Axboe wrote:
> >>>On 07/13/2007 09:40 AM, Patrick McHardy wrote:
> >>>
> >>>>I get this oops with current -git:
> >>>>
> >>>>[ 3437.018923] Pid: 4432, comm: nfsd Not tainted 2.6.22 #5
> >>>>[ 3437.018926] RIP: 0010:[<ffffffff81054eff>]  [<ffffffff81054eff>]
> >>>>put_page+0x4/0xb3
> 
> > Patrick, does this work?
> 
> 
> Seems to work fine, thanks Jens.

Wonderful, thanks for testing!

-- 
Jens Axboe

