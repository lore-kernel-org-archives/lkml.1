Return-Path: <linux-kernel-owner+w=401wt.eu-S1755442AbYHJONr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbYHJONr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 10:13:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753781AbYHJONj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 10:13:39 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:55240 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753226AbYHJONj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 10:13:39 -0400
Date: Sun, 10 Aug 2008 17:11:59 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Grant Grundler <grundler@parisc-linux.org>
Cc: kyle@mcmartin.ca, matthew@wil.cx, linux-parisc@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       bdale@hp.com
Subject: Re: [2.6 patch] binfmt_som.c: add MODULE_LICENSE
Message-ID: <20080810141159.GA13105@cs181140183.pp.htv.fi>
References: <20080806211155.GV1702@cs181140183.pp.htv.fi> <20080810005511.GB2617@colo.lackof.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080810005511.GB2617@colo.lackof.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 09, 2008 at 06:55:11PM -0600, Grant Grundler wrote:
> +bdale@hp.com
> 
> On Thu, Aug 07, 2008 at 12:11:55AM +0300, Adrian Bunk wrote:
> > This patch adds the missing MODULE_LICENSE("GPL").
> > 
> > Reported-by: Adrian Bunk <bunk@kernel.org>
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> > 
> > ---
> > 
> > This patch has been sent on:
> > - 15 Jun 2008
> > 
> > 4cec562181f818f16f072b9a14ca7a0ce6c66417 diff --git a/fs/binfmt_som.c b/fs/binfmt_som.c
> > index fdc36bf..6d3bebb 100644
> > --- a/fs/binfmt_som.c
> > +++ b/fs/binfmt_som.c
> > @@ -308,3 +308,5 @@ static void __exit exit_som_binfmt(void)
> >  
> >  core_initcall(init_som_binfmt);
> >  module_exit(exit_som_binfmt);
> > +
> > +MODULE_LICENSE("GPL");
> 
> Someone from HP needs to ACK this patch since I believe HP funded the code
> changes made during the parisc-linux port. This should be a no-brainer
> and I expect Bdale Garbee can quickly take care of this.

Either the file is available since the beginning under the terms of the 
GPLv2 (or a compatible license that can be reduced to GPLv2) or it's 
addition to the kernel was a huge mistake.

> thanks,
> grant

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

