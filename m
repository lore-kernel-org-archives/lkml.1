Return-Path: <linux-kernel-owner+w=401wt.eu-S1754038AbZLEJU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbZLEJU5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 04:20:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753826AbZLEJUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 04:20:55 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:39959 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753843AbZLEJUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 04:20:52 -0500
Date: Sat, 5 Dec 2009 10:20:57 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Vivek Goyal <vgoyal@redhat.com>
Subject: Re: linux-next: block tree build failure
Message-ID: <20091205092057.GE8742@kernel.dk>
References: <20091204143612.f30db275.sfr@canb.auug.org.au> <20091204074341.GH8742@kernel.dk> <20091204135422.GZ8742@kernel.dk> <20091205094934.eefdddf4.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091205094934.eefdddf4.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 05 2009, Stephen Rothwell wrote:
> Hi Jens,
> 
> On Fri, 4 Dec 2009 14:54:22 +0100 Jens Axboe <jens.axboe@oracle.com> wrote:
> >
> > I pushed out the quick fix, just disallowing cfq=m and blk cgroup in
> > Kconfig. So it should work now.
> 
> Great, thanks.

And later on a proper solution was also implemented, that is what is
currently in the tree since last night.

-- 
Jens Axboe

