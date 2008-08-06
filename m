Return-Path: <linux-kernel-owner+w=401wt.eu-S1762282AbYHFKdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762282AbYHFKdZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 06:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754576AbYHFKdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 06:33:13 -0400
Received: from brick.kernel.dk ([87.55.233.238]:8326 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753438AbYHFKdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 06:33:11 -0400
Date: Wed, 6 Aug 2008 12:33:08 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, mike.miller@hp.com,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 6/6] cciss: fix bug if scsi tape support is disabled
Message-ID: <20080806103308.GM20055@kernel.dk>
References: <20080730211842.GF1758@roadking.ldev.net> <20080804095633.GA20055@kernel.dk> <20080805153012.0076396e.akpm@linux-foundation.org> <20080806130825.1567d882.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080806130825.1567d882.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06 2008, Stephen Rothwell wrote:
> On Tue, 5 Aug 2008 15:30:12 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > I'm not seeing these changes in linux-next nor in
> > master.kernel.org/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git#for-next
> > nor in #for-akpm.
> 
> Well linux-next gets its block tree from
> git://git.kernel.dk/linux-2.6-block.git#for-next (which appears to be
> very similar - if not identical to - the above).
> 
> > Also, #for-next is empty, but #for-akpm has the single commit
> 
> The for-linus branch seems to have a few commits, though ...
> Jens, would you like that in linux-next as block-current (merged early -
> meant for bug fixes destined for the current release)?

Thanks, but just keep pulling linux-next and I'll try and get them
uptodate more frequently :-)

-- 
Jens Axboe

