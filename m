Return-Path: <linux-kernel-owner+w=401wt.eu-S1754160AbZDWGJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160AbZDWGJg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 02:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752534AbZDWGJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 02:09:26 -0400
Received: from brick.kernel.dk ([93.163.65.50]:50216 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406AbZDWGJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 02:09:26 -0400
Date: Thu, 23 Apr 2009 08:09:17 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, bzolnier@gmail.com
Subject: Re: [GIT PATCH linux-2.6-block] block: cleanup patches, take#3
Message-ID: <20090423060917.GJ4593@kernel.dk>
References: <1240331881-28218-1-git-send-email-tj@kernel.org> <20090422101038.GA4593@kernel.dk> <49EFCE29.7050903@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49EFCE29.7050903@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23 2009, Tejun Heo wrote:
> Hello,
> 
> Jens Axboe wrote:
> >> linux-2.6-block#for-next(a95320f3ede3f028837a621715cd352e83ffe7c2)
> >> + linux-2.6-ide#for-next(2ecf0a57c60dcb588f310d94412118e15c510532)
> > 
> > Looks nice, the only real quibble I have is the one that hch also brings
> > up. Using a 'locked' argument is always ugly. Otherwise, overall the
> > patchset is really nice and does good cleanups. Getting rid of ->data is
> > great as well.
> > 
> > Once we get that settled, pulling into for-2.6.31 will be done.
> 
> Tree updated.  In addition to the @locked removal, Acked-by:'s are
> added to 0012 and 0013 got a proper arm-omap prefix.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git block-cleanup

Thanks, pulled!

-- 
Jens Axboe

