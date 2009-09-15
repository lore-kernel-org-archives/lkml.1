Return-Path: <linux-kernel-owner+w=401wt.eu-S1758129AbZIOG5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129AbZIOG5X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 02:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756898AbZIOG5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 02:57:19 -0400
Received: from brick.kernel.dk ([93.163.65.50]:43014 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756890AbZIOG5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 02:57:18 -0400
Date: Tue, 15 Sep 2009 08:57:21 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Philipp Reisner <philipp.reisner@linbit.com>, drbd-dev@linbit.com,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Nikanth Karthikesan <knikanth@suse.de>
Subject: Re: linux-next: drbd tree build failure
Message-ID: <20090915065721.GQ14984@kernel.dk>
References: <20090915160739.86e85ab3.sfr@canb.auug.org.au> <20090915062306.GP14984@kernel.dk> <20090915165309.f07381ec.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090915165309.f07381ec.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15 2009, Stephen Rothwell wrote:
> Hi Jens,
> 
> On Tue, 15 Sep 2009 08:23:06 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:
> >
> > Fix looks correct.
> 
> Thanks for the confirmation.  So hopefully one of these trees will be
> merged by Linus soon an this can be fixed up in the other.

The block one is already merged, so drbd just needs to get fixed up.

-- 
Jens Axboe

