Return-Path: <linux-kernel-owner+w=401wt.eu-S1752771AbZIAFiH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbZIAFiH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 01:38:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbZIAFiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 01:38:06 -0400
Received: from brick.kernel.dk ([93.163.65.50]:47120 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536AbZIAFiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 01:38:05 -0400
Date: Tue, 1 Sep 2009 07:38:07 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Alasdair G Kergon <agk@redhat.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: block tree build failure
Message-ID: <20090901053807.GJ12579@kernel.dk>
References: <20090901145949.58610c23.sfr@canb.auug.org.au> <20090901153038.807f5586.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090901153038.807f5586.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 01 2009, Stephen Rothwell wrote:
> Hi Alasdair,
> 
> On Tue, 1 Sep 2009 14:59:49 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > I have used the version of the block tree from next-20090831 for today.
> 
> Which means that I have had to use yesterday's version of the
> device-mapper tree as well (since it is based on the block tree).

Ah darn, sorry about that. I'll get that updated in about an hours time
and do a full compile.

-- 
Jens Axboe

