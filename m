Return-Path: <linux-kernel-owner+w=401wt.eu-S1759025AbXGVFwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759025AbXGVFwo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 01:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751013AbXGVFwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 01:52:36 -0400
Received: from brick.kernel.dk ([80.160.20.94]:5777 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021AbXGVFwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 01:52:35 -0400
Date: Sun, 22 Jul 2007 07:52:36 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Lars Ellenberg <lars@linbit.com>, Andrew Morton <akpm@osdl.org>,
       lkml <linux-kernel@vger.kernel.org>, drbd-user@linbit.com
Subject: Re: [DRIVER SUBMISSION] DRBD wants to go mainline
Message-ID: <20070722055235.GQ11657@kernel.dk>
References: <20070721203819.GA10706@mail.linbit.com> <p73hcnxuxji.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73hcnxuxji.fsf@bingen.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 22 2007, Andi Kleen wrote:
> Lars Ellenberg <lars@linbit.com> writes:
> > 
> > Jens, Andrew, anyone: please review,
> > and give me advice how to proceed from here.
> 
> The standard procedure would be to post all the source code in logical
> pieces on the list for review. Then iterate until all comments are
> addressed.

Yep, cleanup the style issues (that make sense) from checkpatch and then
psot as a series of patches that can be reviewed. Linking to a git tree
wont get you very far.

-- 
Jens Axboe

