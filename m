Return-Path: <linux-kernel-owner+w=401wt.eu-S1752489AbYHKKsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489AbYHKKsf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 06:48:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751492AbYHKKsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 06:48:25 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:32778 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458AbYHKKsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 06:48:24 -0400
Date: Mon, 11 Aug 2008 13:46:43 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Grant Grundler <grundler@parisc-linux.org>
Cc: kyle@mcmartin.ca, matthew@wil.cx, linux-parisc@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       bdale@hp.com
Subject: Re: [2.6 patch] binfmt_som.c: add MODULE_LICENSE
Message-ID: <20080811104643.GA3338@cs181140183.pp.htv.fi>
References: <20080806211155.GV1702@cs181140183.pp.htv.fi> <20080810005511.GB2617@colo.lackof.org> <20080810141159.GA13105@cs181140183.pp.htv.fi> <20080811001015.GC14163@colo.lackof.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080811001015.GC14163@colo.lackof.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 10, 2008 at 06:10:15PM -0600, Grant Grundler wrote:
> On Sun, Aug 10, 2008 at 05:11:59PM +0300, Adrian Bunk wrote:
> > On Sat, Aug 09, 2008 at 06:55:11PM -0600, Grant Grundler wrote:
> ...
> > > Someone from HP needs to ACK this patch since I believe HP funded the code
> > > changes made during the parisc-linux port. This should be a no-brainer
> > > and I expect Bdale Garbee can quickly take care of this.
> > 
> > Either the file is available since the beginning under the terms of the 
> > GPLv2 (or a compatible license that can be reduced to GPLv2) or it's 
> > addition to the kernel was a huge mistake.
> 
> As a former HP employee who was one of the several parisc-linux developers,
> I'm certain the intent was to release this as GPL. That's why I said
> "this should be a no-brainer".
> 
> However, it's still HP's (and not my) right to assert that.

If it wasn't already 100% clear that the file was released under
the terms of the GPLv2 (or a compatible license that can be reduced
to GPLv2) at the day when it was included into the kernel something
went horribly wrong back then.

Otherwise HP would have the situation SCO was desperately searching for...

> thanks,
> grant

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

