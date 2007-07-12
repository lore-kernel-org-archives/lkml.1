Return-Path: <linux-kernel-owner+w=401wt.eu-S932352AbXGLUiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932352AbXGLUiv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 16:38:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756440AbXGLUin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 16:38:43 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39004 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756165AbXGLUim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 16:38:42 -0400
Date: Thu, 12 Jul 2007 22:38:40 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, jeremy@goop.org, Tim Hockin <thockin@google.com>,
       jesse.barnes@intel.com
Subject: Re: x86 status was Re: -mm merge plans for 2.6.23
Message-ID: <20070712203840.GA1011@one.firstfloor.org>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org> <p734pkbyuu4.fsf@bingen.suse.de> <Pine.LNX.4.64.0707121230370.11653@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707121230370.11653@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2007 at 12:33:43PM -0700, Christoph Lameter wrote:
> On Wed, 11 Jul 2007, Andi Kleen wrote:
> 
> > These all need re-review:
> > 
> > > i386-add-support-for-picopower-irq-router.patch
> > > make-arch-i386-kernel-setupcremapped_pgdat_init-static.patch
> > > arch-i386-kernel-i8253c-should-include-asm-timerh.patch
> > > make-arch-i386-kernel-io_apicctimer_irq_works-static-again.patch
> 
> 
> > > quicklist-support-for-x86_64.patch
> 
> ^^^ That patch was supposed to be merged for 2.6.22 (you told me you 
> forgot to merge it) and has been for a long time in mm. Does it now 
> need to be rereviewed for 2.6.23? The other pieces of the quicklist patch 
> for core and other arches were merged for 2.6.22.

It's just on the normal re-review list. But it'll likely go in.

-Andi
