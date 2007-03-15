Return-Path: <linux-kernel-owner+w=401wt.eu-S933078AbXCOTau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933078AbXCOTau (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 15:30:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933024AbXCOTat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 15:30:49 -0400
Received: from smtp.osdl.org ([65.172.181.24]:37714 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933078AbXCOTas (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 15:30:48 -0400
Date: Thu, 15 Mar 2007 11:25:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-stable <stable@kernel.org>, Adrian Bunk <bunk@stusta.de>
Subject: Re: Three critical patches still aren't merged in 2.6.21
Message-Id: <20070315112532.7d6a6521.akpm@linux-foundation.org>
In-Reply-To: <45F9757F.2020900@redhat.com>
References: <45F9757F.2020900@redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2007 12:34:07 -0400 Chuck Ebbert <cebbert@redhat.com> wrote:

> I've been holding off sending these in for -stable until they're
> merged, but now I wonder when that will happen.

We'll get there.  I just got off the plane.

> http://lkml.org/lkml/2007/3/14/99
> [PATCH] hrtimer: prevent overrun DoS in hrtimer_forward()
> From: Thomas Gleixner <tglx@linutronix,de> 
> 
> http://lkml.org/lkml/2007/3/12/268
> NFS: nfs_getattr() can't call nfs_sync_mapping_range() for non-regular files
> From: Trond Myklebust <Trond.Myklebust@netapp.com>
> 
> http://lkml.org/lkml/2007/3/12/60
> [patch] futex: PI state locking fix
> From: Ingo Molnar <mingo@elte.hu>

I have all three in various stages of queuedness, but I am presently
expecting Trond to merge the NFS one.  I can send it if he wants?
