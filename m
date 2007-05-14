Return-Path: <linux-kernel-owner+w=401wt.eu-S1760391AbXENW3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760391AbXENW3W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 18:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755232AbXENW3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 18:29:15 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48797 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755155AbXENW3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 18:29:15 -0400
Date: Mon, 14 May 2007 15:29:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <ak@suse.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [VOYAGER] fix build broken by shift to smp_ops
Message-Id: <20070514152905.3604fa20.akpm@linux-foundation.org>
In-Reply-To: <200705142358.09529.ak@suse.de>
References: <1179158912.3703.47.camel@mulgrave.il.steeleye.com>
	<20070514140530.8e0491cf.akpm@linux-foundation.org>
	<4648D03F.4090407@goop.org>
	<200705142358.09529.ak@suse.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2007 23:58:09 +0200
Andi Kleen <ak@suse.de> wrote:

> 
> > OK, but only if you don't want to put "i386: move common parts of smp
> > into their own file" in front of it, and remove the duplicated code.  I
> > could send you a third copy if you like.
> 
> Using Jeremy's patch is better than James'
> 

This is getting comical.

According to my records, the patch
voyager-fix-build-broken-by-shift-to-smp_ops.patch _is_ Jeremy's patch. 
James forwarded it.

I take it from your statement that we should merge some Jeremy-patch other
than this Jeremy-patch?

If "yes", than could Jeremy please resend the other patch(es) (I believe there
are multiple patches involved) and then can James please test them?

If "no" then I think I'll just go shopping.

