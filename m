Return-Path: <linux-kernel-owner+w=401wt.eu-S1759429AbXGVGJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759429AbXGVGJg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 02:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbXGVGJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 02:09:30 -0400
Received: from aug.linbit.com ([212.69.162.22]:41659 "EHLO mail.linbit.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751603AbXGVGJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 02:09:29 -0400
Date: Sun, 22 Jul 2007 08:09:25 +0200
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@osdl.org>,
       lkml <linux-kernel@vger.kernel.org>, drbd-user@linbit.com
Subject: Re: [DRIVER SUBMISSION] DRBD wants to go mainline
Message-ID: <20070722060925.GD18326@mail.linbit.com>
Mail-Followup-To: Andi Kleen <andi@firstfloor.org>,
	Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@osdl.org>,
	lkml <linux-kernel@vger.kernel.org>, drbd-user@lists.linbit.com
References: <20070721203819.GA10706@mail.linbit.com> <p73hcnxuxji.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73hcnxuxji.fsf@bingen.suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 22, 2007 at 01:50:09AM +0200, Andi Kleen wrote:
> Lars Ellenberg <lars@linbit.com> writes:
> > 
> > Jens, Andrew, anyone: please review,
> > and give me advice how to proceed from here.
> 
> The standard procedure would be to post all the source code in logical
> pieces on the list for review. Then iterate until all comments are addressed.
> 
> -Andi

well.
there is just one logical piece, the drbd module...
it is all in its own subdirectory.
it does not really touch anything else.
I don't think it is feasible to split it further.

	Lars
