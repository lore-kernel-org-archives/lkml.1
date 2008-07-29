Return-Path: <linux-kernel-owner+w=401wt.eu-S1759360AbYG2Ul2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759360AbYG2Ul2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 16:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752555AbYG2UlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 16:41:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50001 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752383AbYG2UlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 16:41:19 -0400
Date: Tue, 29 Jul 2008 13:40:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Liam Girdwood <lg@opensource.wolfsonmicro.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       broonie@opensource.wolfsonmicro.com, sfr@canb.auug.org.au,
       linux-next@vger.kernel.org
Subject: Re: [PATCH 0/13] Updated V4  - Regulator Framework
Message-Id: <20080729134043.d677323b.akpm@linux-foundation.org>
In-Reply-To: <1217363626.7498.47.camel@odin>
References: <1209742841.12502.40.camel@odin>
	<20080710020848.066cfc8c.akpm@linux-foundation.org>
	<1217363626.7498.47.camel@odin>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jul 2008 21:33:46 +0100
Liam Girdwood <lg@opensource.wolfsonmicro.com> wrote:

> On Thu, 2008-07-10 at 02:08 -0700, Andrew Morton wrote:
> > On Fri, 02 May 2008 16:40:41 +0100 Liam Girdwood <lg@opensource.wolfsonmicro.com> wrote:
> > 
> > > This is an updated version of the kernel voltage & current regulator
> > > framework based on comments received from version 3 of the patch series.
> > 
> > git-regulator.patch has been in -mm for two months without incident.  I'd
> > forgotten about it.   This is bad - we should have put it into linux-next.
> > 
> > If you hope to get this into 2.6.27 then please send the git URL to Stephen
> > and the linux-next list asap.  Please also resend the patches to this list
> > for re-review.  Then, if it doesn't get shot down, send Linux a pull
> > request during the 2.6.27 merge window.  ie: about one week from today.
> 
> Would there be any chance of this going in for rc2 ? (2 pull requests
> sent recently prior to rc1) or would it be better now waiting for the
> 2.6.28 merge window ?
> 

Oh, I'd assumed that it had been merged already.

Linus was probably wondering "who is this Liam person and why is he
sending me stuff".  It should be OK for 2.6.27-rc1 unless Linus had
some specific reason for skipping it?  Please retry.
