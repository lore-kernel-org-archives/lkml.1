Return-Path: <linux-kernel-owner+w=401wt.eu-S1760357AbYEMNhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760357AbYEMNhW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 09:37:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756213AbYEMNhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 09:37:10 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:60883 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755986AbYEMNhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 09:37:09 -0400
Date: Tue, 13 May 2008 16:35:37 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Parag Warudkar <parag.warudkar@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Frans Pop <elendil@planet.nl>
Subject: Re: [Bug #10616] Horrendous Audio Stutter - current git
Message-ID: <20080513133537.GA30361@cs181133002.pp.htv.fi>
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera> <88YBFoyd1CN.A.K6.1w1JIB@chimera> <82e4877d0805111428j3f73f436w1c6094c779f6110d@mail.gmail.com> <20080511214131.GM1645@cs181133002.pp.htv.fi> <82e4877d0805111459jf4891fbpff5a91b08e32db01@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <82e4877d0805111459jf4891fbpff5a91b08e32db01@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 11, 2008 at 05:59:21PM -0400, Parag Warudkar wrote:
> On Sun, May 11, 2008 at 5:41 PM, Adrian Bunk <bunk@kernel.org> wrote:
>...
> > Is this commit 018d6db4cb5bbdcd65424a16f2dcca692ed32ae4
> > (sched: re-do "sched: fix fair sleepers") that had already been reverted
> > in 2.6.25 for causing such regressions or is this caused by a different
> > commit?
> 
> Both current -git and sched-devel have this problem - that means it's
> unrelated to the commit you refer to unless it was reintroduced in a
> different form but same effect.

It was changed, not reverted.

But most likely I was simply thinking in the wrong direction.

> Parag

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

