Return-Path: <linux-kernel-owner+w=401wt.eu-S1759310AbZGHGzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759310AbZGHGzR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 02:55:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758598AbZGHGzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 02:55:04 -0400
Received: from brick.kernel.dk ([93.163.65.50]:48397 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089AbZGHGzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 02:55:03 -0400
Date: Wed, 8 Jul 2009 08:55:02 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: linux-next: block tree build failure
Message-ID: <20090708065502.GR23611@kernel.dk>
References: <20090707134908.e81b1556.sfr@canb.auug.org.au> <20090707063846.GY23611@kernel.dk> <20090708131713.61d9ea7b.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090708131713.61d9ea7b.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 08 2009, Stephen Rothwell wrote:
> Hi Jens,
> 
> On Tue, 7 Jul 2009 08:38:46 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:
> >
> > That is correct! I have just now updated for-next as well, so your next
> > pull should lose this fixup.
> 
> Except you left the call to wakeup_pdflush(0) in there ...  I will fix
> that up while Christoph's concerns are addressed.

Oops, belt and suspenders and all that... Sorry, fixing it up now.

-- 
Jens Axboe

