Return-Path: <linux-kernel-owner+w=401wt.eu-S932314AbXGLTd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314AbXGLTd4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 15:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764009AbXGLTdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 15:33:47 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50052 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763825AbXGLTdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 15:33:46 -0400
Date: Thu, 12 Jul 2007 12:33:43 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <andi@firstfloor.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, jeremy@goop.org, Tim Hockin <thockin@google.com>,
       jesse.barnes@intel.com
Subject: Re: x86 status was Re: -mm merge plans for 2.6.23
In-Reply-To: <p734pkbyuu4.fsf@bingen.suse.de>
Message-ID: <Pine.LNX.4.64.0707121230370.11653@schroedinger.engr.sgi.com>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
 <p734pkbyuu4.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2007, Andi Kleen wrote:

> These all need re-review:
> 
> > i386-add-support-for-picopower-irq-router.patch
> > make-arch-i386-kernel-setupcremapped_pgdat_init-static.patch
> > arch-i386-kernel-i8253c-should-include-asm-timerh.patch
> > make-arch-i386-kernel-io_apicctimer_irq_works-static-again.patch


> > quicklist-support-for-x86_64.patch

^^^ That patch was supposed to be merged for 2.6.22 (you told me you 
forgot to merge it) and has been for a long time in mm. Does it now 
need to be rereviewed for 2.6.23? The other pieces of the quicklist patch 
for core and other arches were merged for 2.6.22.
